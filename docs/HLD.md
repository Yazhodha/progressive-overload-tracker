# High-Level Design (HLD)
# Progressive Overload Fitness Tracker

**Version**: 1.0
**Last Updated**: 2026-01-11
**Author**: Yazhodha

---

## 1. System Overview

The Progressive Overload Fitness Tracker is a mobile-first application designed to help users systematically track strength gains through progressive overload, monitor body measurements, and receive AI-powered workout and nutrition recommendations.

### 1.1 Key Objectives
- Provide an intuitive offline-first workout logging experience
- Visualize progressive overload with comprehensive charts and analytics
- Deliver personalized AI-powered workout and meal recommendations using DeepSeek API
- Enable seamless cross-device synchronization via cloud backend
- Maintain high performance and responsiveness on mobile devices

### 1.2 Target Platforms
- iOS 12.0+
- Android API 21+ (Android 5.0+)
- Future: Web platform

---

## 2. System Architecture

### 2.1 Architecture Pattern

The application follows **Clean Architecture** principles with three distinct layers:

```
┌─────────────────────────────────────────────────────────────┐
│                    Presentation Layer                        │
│  (UI, Widgets, State Management, ViewModels)                │
│  - Riverpod Providers                                        │
│  - Flutter Widgets & Screens                                 │
│  - State Notifiers                                           │
└────────────────────┬────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────┐
│                     Domain Layer                             │
│  (Business Logic, Entities, Use Cases)                      │
│  - Core business rules                                       │
│  - Repository interfaces                                     │
│  - Entity models                                             │
└────────────────────┬────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────┐
│                      Data Layer                              │
│  (Repositories, Data Sources, Models)                       │
│  - Repository implementations                                │
│  - Local data source (SQLite)                               │
│  - Remote data source (Supabase)                            │
│  - Data models & DTOs                                        │
└─────────────────────────────────────────────────────────────┘
```

### 2.2 Layer Responsibilities

#### Presentation Layer
- **Responsibilities**: UI rendering, user interactions, state management
- **Key Components**:
  - Screens (Home, Workout, Progress, Profile, AI Assistant)
  - Widgets (reusable UI components)
  - Riverpod providers for state management
  - ViewModels/Controllers

#### Domain Layer
- **Responsibilities**: Business logic, use cases, core entities
- **Key Components**:
  - Use cases (e.g., LogWorkout, CalculateProgressiveOverload, GenerateWorkoutPlan)
  - Entity models (User, Workout, Exercise, BodyMeasurement)
  - Repository interfaces (abstract contracts)

#### Data Layer
- **Responsibilities**: Data persistence, API communication, data transformation
- **Key Components**:
  - Repository implementations
  - Local data source (SQLite via sqflite)
  - Remote data source (Supabase client)
  - DTOs (Data Transfer Objects)
  - Sync manager for offline-first functionality

---

## 3. Data Architecture

### 3.1 Database Schema (PostgreSQL - Supabase)

#### Users Table
```sql
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  email TEXT UNIQUE NOT NULL,
  google_id TEXT UNIQUE, -- Google OAuth ID
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

  -- Profile information
  full_name TEXT,
  profile_photo_url TEXT,
  date_of_birth DATE,
  gender TEXT CHECK (gender IN ('male', 'female', 'other')),
  height_cm DECIMAL(5,2),
  fitness_level TEXT CHECK (fitness_level IN ('beginner', 'intermediate', 'advanced')),

  -- Goals
  primary_goal TEXT CHECK (primary_goal IN ('strength', 'hypertrophy', 'endurance', 'weight_loss', 'general_fitness')),
  target_weight_kg DECIMAL(5,2),

  -- Preferences
  available_equipment JSONB,
  dietary_preferences JSONB,
  dietary_restrictions JSONB
);
```

#### Exercises Table
```sql
CREATE TABLE exercises (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  category TEXT NOT NULL, -- 'chest', 'back', 'legs', 'shoulders', 'arms', 'core', 'cardio'
  equipment_needed TEXT[], -- ['barbell', 'dumbbell', 'bodyweight']
  muscle_groups TEXT[], -- ['pectoralis', 'deltoids', 'triceps']
  difficulty_level TEXT CHECK (difficulty_level IN ('beginner', 'intermediate', 'advanced')),
  description TEXT,
  form_tips TEXT[],
  video_url TEXT,
  image_url TEXT,
  is_custom BOOLEAN DEFAULT FALSE,
  user_id UUID REFERENCES users(id),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

#### Workouts Table
```sql
CREATE TABLE workouts (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) NOT NULL,
  name TEXT,
  notes TEXT,
  started_at TIMESTAMP WITH TIME ZONE NOT NULL,
  completed_at TIMESTAMP WITH TIME ZONE,
  duration_seconds INTEGER,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  synced BOOLEAN DEFAULT FALSE
);
```

#### Workout Exercises Table
```sql
CREATE TABLE workout_exercises (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  workout_id UUID REFERENCES workouts(id) ON DELETE CASCADE NOT NULL,
  exercise_id UUID REFERENCES exercises(id) NOT NULL,
  order_index INTEGER NOT NULL,
  notes TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

#### Sets Table
```sql
CREATE TABLE sets (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  workout_exercise_id UUID REFERENCES workout_exercises(id) ON DELETE CASCADE NOT NULL,
  set_number INTEGER NOT NULL,
  reps INTEGER NOT NULL,
  weight_kg DECIMAL(6,2),
  rest_seconds INTEGER,
  is_warmup BOOLEAN DEFAULT FALSE,
  is_failure BOOLEAN DEFAULT FALSE,
  rpe INTEGER CHECK (rpe >= 1 AND rpe <= 10), -- Rate of Perceived Exertion
  notes TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

#### Body Measurements Table
```sql
CREATE TABLE body_measurements (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) NOT NULL,
  measured_at TIMESTAMP WITH TIME ZONE NOT NULL,

  -- Weight and composition
  weight_kg DECIMAL(5,2),
  body_fat_percentage DECIMAL(4,2),
  muscle_mass_kg DECIMAL(5,2),

  -- Body measurements (in cm)
  neck_cm DECIMAL(5,2),
  chest_cm DECIMAL(5,2),
  shoulders_cm DECIMAL(5,2),
  left_bicep_cm DECIMAL(5,2),
  right_bicep_cm DECIMAL(5,2),
  left_forearm_cm DECIMAL(5,2),
  right_forearm_cm DECIMAL(5,2),
  waist_cm DECIMAL(5,2),
  hips_cm DECIMAL(5,2),
  left_thigh_cm DECIMAL(5,2),
  right_thigh_cm DECIMAL(5,2),
  left_calf_cm DECIMAL(5,2),
  right_calf_cm DECIMAL(5,2),

  notes TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  synced BOOLEAN DEFAULT FALSE
);
```

#### Progress Photos Table
```sql
CREATE TABLE progress_photos (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) NOT NULL,
  photo_url TEXT NOT NULL,
  photo_type TEXT CHECK (photo_type IN ('front', 'back', 'side', 'other')),
  taken_at TIMESTAMP WITH TIME ZONE NOT NULL,
  weight_kg DECIMAL(5,2),
  notes TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  synced BOOLEAN DEFAULT FALSE
);
```

#### Personal Records Table
```sql
CREATE TABLE personal_records (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) NOT NULL,
  exercise_id UUID REFERENCES exercises(id) NOT NULL,
  record_type TEXT CHECK (record_type IN ('max_weight', 'max_reps', 'max_volume')),
  value DECIMAL(10,2) NOT NULL,
  workout_id UUID REFERENCES workouts(id),
  achieved_at TIMESTAMP WITH TIME ZONE NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

  UNIQUE(user_id, exercise_id, record_type)
);
```

### 3.2 Local Database (SQLite)

The local SQLite database mirrors the Supabase schema with additional sync metadata:
- `sync_status` column (pending, synced, conflict)
- `local_updated_at` timestamp
- `remote_updated_at` timestamp

### 3.3 Data Flow

```
User Action → Presentation Layer → Domain Layer → Data Layer
                                                       ↓
                                              1. Write to SQLite (Immediate)
                                              2. Queue for sync
                                              3. Background sync to Supabase
                                              4. Update sync status
```

---

## 4. API Design

### 4.1 Authentication - OAuth 2.0 with Google

#### Authentication Flow
```
1. User clicks "Sign in with Google"
2. App redirects to Google OAuth consent screen
3. User authorizes the app
4. Google returns authorization code
5. App exchanges code for access token + ID token
6. App verifies ID token and extracts user info
7. Create/update user in Supabase with google_id
8. Store access token securely for session management
```

#### Implementation Details
- **Package**: `google_sign_in` for Flutter
- **Scopes**: email, profile
- **Token Storage**: flutter_secure_storage for secure persistence
- **Session Management**: Auto-refresh tokens before expiry
- **Backend Verification**: Verify Google ID token on Supabase side

#### User Session Management
```dart
// Session structure
{
  "access_token": "google_access_token",
  "id_token": "google_id_token",
  "user": {
    "id": "uuid",
    "email": "user@gmail.com",
    "name": "User Name",
    "photo_url": "https://...",
    "google_id": "google_user_id"
  },
  "expires_at": "timestamp"
}
```

### 4.2 Supabase Integration

#### Data API
- RESTful API for CRUD operations on all tables
- Row-Level Security (RLS) policies based on user_id
- Real-time subscriptions for multi-device sync

#### Storage
- Progress photos stored in Supabase Storage
- Organized by user_id/YYYY-MM/photo_id.jpg
- Automatic image optimization and thumbnail generation
- RLS policies ensure users can only access their own photos

### 4.3 DeepSeek API Integration

#### Workout Generation Endpoint
```dart
POST https://api.deepseek.com/v1/chat/completions
Headers:
  Authorization: Bearer YOUR_DEEPSEEK_API_KEY
  Content-Type: application/json

Request:
{
  "model": "deepseek-chat",
  "messages": [
    {
      "role": "system",
      "content": "You are a professional fitness trainer and workout plan designer..."
    },
    {
      "role": "user",
      "content": "Generate a 4-day workout plan for: [user profile + history]"
    }
  ],
  "temperature": 0.7,
  "max_tokens": 2000
}

Response:
{
  "choices": [
    {
      "message": {
        "content": "Structured workout plan in JSON format..."
      }
    }
  ]
}
```

#### Meal Plan Generation
```dart
POST https://api.deepseek.com/v1/chat/completions

System Prompt: "You are a certified nutritionist specializing in meal planning for athletes..."

User Input: User profile, dietary preferences, restrictions, calorie targets

Output: Structured meal plan with macros, recipes, and shopping list
```

#### Workout Suggestions (Real-time)
```dart
// Context-aware suggestions based on:
// - Current workout progress
// - Historical performance
// - Fatigue levels
// - Available time

POST https://api.deepseek.com/v1/chat/completions
Context: "Based on the user's last 5 workouts and current fatigue, suggest next exercise..."
```

#### API Implementation Strategy
- **Caching**: Cache AI responses for similar queries (reduce costs)
- **Rate Limiting**: Implement request throttling (max 10 requests/minute)
- **Error Handling**: Fallback to default plans if API fails
- **Cost Management**:
  - Use lower token limits for simple queries
  - Implement prompt optimization
  - Cache frequently requested plans

---

## 5. State Management

### 5.1 Riverpod Architecture

```dart
// Provider hierarchy
StateNotifierProvider (App-level state)
  ├── AuthStateProvider (Google OAuth session)
  ├── UserProfileProvider
  ├── ThemeProvider
  └── SyncStatusProvider

StateNotifierProvider (Feature-level state)
  ├── WorkoutStateProvider
  ├── ExerciseLibraryProvider
  ├── BodyMeasurementsProvider
  └── ProgressPhotoProvider

FutureProvider / StreamProvider (Data fetching)
  ├── WorkoutHistoryProvider
  ├── PersonalRecordsProvider
  └── ProgressChartsProvider
```

### 5.2 State Persistence
- User preferences: SharedPreferences
- OAuth tokens: flutter_secure_storage
- App state: Riverpod with persistence interceptors

---

## 6. Offline-First Strategy

### 6.1 Sync Architecture

```
┌─────────────────────────────────────────────────────────┐
│  User performs action (log workout, add measurement)     │
└────────────────────┬────────────────────────────────────┘
                     ▼
┌─────────────────────────────────────────────────────────┐
│  Write immediately to SQLite with sync_status='pending' │
└────────────────────┬────────────────────────────────────┘
                     ▼
┌─────────────────────────────────────────────────────────┐
│  Add to sync queue (WorkManager for background sync)    │
└────────────────────┬────────────────────────────────────┘
                     ▼
┌─────────────────────────────────────────────────────────┐
│  When online: Sync pending records to Supabase          │
│  Conflict resolution: Last-write-wins or merge strategy │
└────────────────────┬────────────────────────────────────┘
                     ▼
┌─────────────────────────────────────────────────────────┐
│  Update sync_status='synced' and remote_updated_at      │
└─────────────────────────────────────────────────────────┘
```

### 6.2 Conflict Resolution
- **Strategy**: Last-write-wins for most entities
- **Exception**: For critical data (PRs, body measurements), merge conflicts with user prompt
- **Sync metadata**: Track local and remote timestamps

---

## 7. Security Considerations

### 7.1 Authentication & Authorization
- OAuth 2.0 with Google for secure authentication
- Row-Level Security (RLS) policies on all Supabase tables
- Users can only access their own data
- API keys stored in environment variables (never hardcoded)
- Verify Google ID token server-side before creating sessions

### 7.2 Data Protection
- HTTPS for all network communication
- Encrypted local storage for sensitive data (OAuth tokens)
- Secure token storage using flutter_secure_storage
- Google access tokens never exposed in logs or error messages

### 7.3 Input Validation
- Client-side validation for all user inputs
- Server-side validation via Supabase PostgreSQL constraints
- Sanitization of user-generated content
- Rate limiting on API endpoints

### 7.4 API Security
- DeepSeek API key stored securely in backend/environment
- API calls proxied through secure backend endpoint (optional)
- Request signing and validation
- Token rotation for OAuth 2.0

---

## 8. Performance Optimization

### 8.1 Strategies
- **Lazy Loading**: Load workout history and charts on-demand
- **Pagination**: Fetch workouts in batches (20-50 per page)
- **Image Optimization**: Compress progress photos before upload
- **Caching**:
  - Cache exercise library locally
  - Cache AI responses for common queries
  - Cache user profile in memory
- **Debouncing**: Debounce search inputs and filters
- **Background Sync**: Use WorkManager for efficient background data sync

### 8.2 Monitoring
- Track app performance metrics (startup time, frame rendering)
- Monitor API response times (DeepSeek, Supabase)
- Log sync errors and failures
- OAuth token refresh failures

---

## 9. Scalability Approach

### 9.1 Database Scalability
- Supabase PostgreSQL handles up to millions of rows efficiently
- Indexes on frequently queried columns (user_id, created_at, exercise_id)
- Partitioning strategy for large tables if needed (future consideration)

### 9.2 Storage Scalability
- Supabase Storage with CDN for global photo delivery
- Automatic image resizing and optimization
- Implement storage quotas per user (e.g., 500 MB free tier)

### 9.3 API Rate Limiting
- Implement exponential backoff for API failures
- Queue and batch sync operations
- Rate limiting on DeepSeek API calls (cache results aggressively)
- OAuth token refresh with retry logic

---

## 10. Deployment Architecture

### 10.1 Mobile App Deployment
- **iOS**: App Store via Xcode and Apple Developer account
- **Android**: Google Play Store via Gradle build
- **CI/CD**: GitHub Actions for automated builds and testing

### 10.2 Backend Infrastructure
- **Hosting**: Supabase (managed PostgreSQL, Storage)
- **Authentication**: Google OAuth 2.0
- **AI API**: DeepSeek API (direct integration or proxied)
- **Monitoring**: Supabase Dashboard + Sentry for error tracking

---

## 11. Future Considerations

### 11.1 Phase 2 Enhancements
- Social features (friend workouts, leaderboards)
- Wearable integration (Apple Watch, Garmin)
- Advanced analytics (1RM calculators, strength standards)
- Workout templates marketplace
- Multi-language support

### 11.2 Technical Improvements
- GraphQL API for more efficient data fetching
- Redis caching layer for frequently accessed data
- Machine learning models for form checking via camera
- Voice commands for hands-free logging
- Apple Sign In as additional OAuth provider

---

## 12. Appendix

### 12.1 Technology Versions
- Flutter: 3.x (latest stable)
- Dart: 3.x
- Supabase: Latest
- Riverpod: 2.x

### 12.2 Key Dependencies
- `supabase_flutter`: Supabase client
- `sqflite`: SQLite database
- `riverpod`: State management
- `fl_chart`: Charts and graphs
- `image_picker`: Photo capture
- `google_sign_in`: Google OAuth authentication
- `flutter_secure_storage`: Secure token storage
- `shared_preferences`: Local preferences
- `http`: API calls to DeepSeek
- `workmanager`: Background sync

### 12.3 External Services
- **Supabase**: Backend infrastructure (database, storage)
- **Google OAuth 2.0**: User authentication
- **DeepSeek API**: AI-powered workout and meal plan generation
- **Google Cloud Console**: OAuth 2.0 client configuration
