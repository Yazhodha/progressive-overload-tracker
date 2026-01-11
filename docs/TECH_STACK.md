# Technology Stack

**Project**: Progressive Overload Fitness Tracker
**Last Updated**: 2026-01-11

---

## Overview

This document outlines all technologies, packages, and tools used in the Progressive Overload Fitness Tracker, along with the rationale behind each choice.

---

## Core Technologies

### Frontend Framework

**Flutter 3.x**
- **Why**: Cross-platform development (iOS & Android) with a single codebase
- **Benefits**:
  - Hot reload for rapid development
  - Rich widget library for beautiful UIs
  - Excellent performance (compiled to native code)
  - Strong community and ecosystem
  - Mature offline-first capabilities

**Dart 3.x**
- **Why**: Official language for Flutter
- **Benefits**:
  - Null safety for fewer runtime errors
  - Strong typing for better code quality
  - Excellent async/await support
  - Fast compilation

---

## Backend & Database

### Supabase (PostgreSQL)

**Why Supabase?**
- **Open-source Firebase alternative** with full PostgreSQL power
- **Real-time subscriptions** for multi-device sync
- **Row-Level Security (RLS)** for data protection
- **Built-in storage** for progress photos
- **Free tier** sufficient for MVP and early users
- **Scalability** - can handle millions of users
- **RESTful API** auto-generated from database schema

**Key Features Used**:
- PostgreSQL database with complex queries
- Real-time data sync
- Storage buckets for images
- Database functions for complex calculations

### Local Database - SQLite

**Package**: `sqflite: ^2.3.0`

**Why SQLite?**
- **Offline-first requirement**: Users can log workouts without internet
- **Fast local queries**: Instant UI updates
- **Proven reliability**: Battle-tested on mobile platforms
- **Low overhead**: Minimal battery and storage impact

**Use Case**:
- Primary data store for all user-generated content
- Sync queue for pending uploads to Supabase
- Cache for frequently accessed data

---

## Authentication

### Google OAuth 2.0

**Package**: `google_sign_in: ^6.1.5`

**Why OAuth 2.0 with Google?**
- **User convenience**: Most users have Google accounts
- **Security**: No password management on our end
- **Trusted provider**: Users trust Google's authentication
- **Profile data**: Automatic access to name, email, profile photo

**Implementation**:
- Google Sign-In SDK for Flutter
- Secure token storage with `flutter_secure_storage`
- Automatic token refresh
- Backend verification of ID tokens

**Alternative Considered**:
- Email/password (rejected: more friction, security responsibility)
- Apple Sign In (future addition for iOS)

---

## AI Integration

### DeepSeek API

**API**: `https://api.deepseek.com/v1/chat/completions`
**Model**: `deepseek-chat`

**Why DeepSeek?**
- **Cost-effective**: Competitive pricing for API calls
- **High-quality outputs**: Excellent for workout and meal plan generation
- **Fast inference**: Low latency for real-time suggestions
- **Large context window**: Can process extensive workout history

**Package**: `http: ^1.1.0` for API calls

**Use Cases**:
1. **Workout Plan Generation**: Create personalized training programs
2. **Meal Plan Generation**: Custom nutrition plans based on goals
3. **Exercise Suggestions**: Real-time recommendations during workouts
4. **Form Tips**: Detailed exercise form guidance

**Cost Management Strategy**:
- Cache AI responses for similar queries
- Use lower max_tokens for simple queries
- Implement rate limiting (10 requests/minute per user)
- Optimize prompts for token efficiency

**Alternative Considered**:
- Anthropic Claude (rejected: higher cost)
- OpenAI GPT-4 (rejected: higher cost)
- Local models (rejected: insufficient mobile hardware)

---

## State Management

### Riverpod 2.x

**Package**: `flutter_riverpod: ^2.4.9`

**Why Riverpod?**
- **Compile-time safety**: Catch errors before runtime
- **No BuildContext needed**: More flexible provider access
- **Better testability**: Easy to mock providers
- **Improved performance**: Automatic optimization
- **Clear dependencies**: Explicit provider relationships

**Architecture**:
```dart
// App-level state
- AuthStateProvider (OAuth session)
- UserProfileProvider
- ThemeProvider
- SyncStatusProvider

// Feature-level state
- WorkoutStateProvider
- ExerciseLibraryProvider
- BodyMeasurementsProvider
- ProgressPhotoProvider

// Data providers
- FutureProvider for async data
- StreamProvider for real-time updates
- StateNotifierProvider for complex state
```

**Alternatives Considered**:
- Provider (rejected: Riverpod is improved successor)
- Bloc (rejected: more boilerplate, steeper learning curve)
- GetX (rejected: too much magic, harder to debug)

---

## Data Visualization

### FL Chart

**Package**: `fl_chart: ^0.65.0`

**Why FL Chart?**
- **Beautiful charts**: Highly customizable and modern design
- **Performance**: Smooth animations even with large datasets
- **Rich features**: Line, bar, pie charts all supported
- **Active maintenance**: Regular updates and bug fixes
- **Theming support**: Easy dark/light mode integration

**Chart Types Used**:
- **Line Charts**: Progressive overload trends over time
- **Bar Charts**: Volume comparison week-over-week
- **Pie Charts**: Muscle group distribution

**Alternatives Considered**:
- Syncfusion Charts (rejected: not free for commercial use)
- Charts Flutter (rejected: less maintained)

---

## Storage & Persistence

### Secure Storage

**Package**: `flutter_secure_storage: ^9.0.0`

**Why Secure Storage?**
- **Encryption**: Stores OAuth tokens encrypted
- **Platform-specific**: Uses Keychain (iOS) and KeyStore (Android)
- **Biometric protection**: Optional fingerprint/Face ID unlock

**Use Case**:
- OAuth access tokens
- OAuth refresh tokens
- API keys (DeepSeek)

### Shared Preferences

**Package**: `shared_preferences: ^2.2.2`

**Why Shared Preferences?**
- **Simple key-value storage**: Perfect for user settings
- **Fast access**: In-memory cache
- **Cross-platform**: Works consistently on iOS/Android

**Use Case**:
- Theme preference (dark/light)
- Unit preferences (kg/lbs)
- Notification settings
- Onboarding completion flag

---

## Media & Images

### Image Picker

**Package**: `image_picker: ^1.0.5`

**Why Image Picker?**
- **Cross-platform**: Consistent API for iOS/Android
- **Gallery & Camera**: Support for both sources
- **Permissions handling**: Built-in permission requests

**Use Case**:
- Progress photos capture
- Profile photo upload

### Image Compression

**Package**: `flutter_image_compress: ^2.1.0`

**Why Compression?**
- **Reduce storage costs**: Smaller files on Supabase
- **Faster uploads**: Especially on slow connections
- **Better UX**: Quick photo processing

**Strategy**:
- Compress to 80% quality
- Max dimensions: 1920x1080
- Convert to JPEG for photos

---

## Background Tasks

### WorkManager

**Package**: `workmanager: ^0.5.1`

**Why WorkManager?**
- **Reliable background sync**: OS-managed background tasks
- **Battery efficient**: Runs during optimal conditions
- **Constraint support**: WiFi-only, charging requirements
- **Cross-platform**: iOS and Android support

**Use Case**:
- Sync pending workouts to Supabase
- Upload progress photos in background
- Periodic data sync every 6 hours

---

## UI/UX Packages

### Additional Packages

```yaml
dependencies:
  # Animations
  animations: ^2.0.8
  # Smooth page transitions

  # Date/Time
  intl: ^0.18.1
  # Internationalization and date formatting

  # Icons
  cupertino_icons: ^1.0.6
  # iOS-style icons

  # URL Launcher
  url_launcher: ^6.2.1
  # Open external links (exercise videos)

  # Device Info
  device_info_plus: ^9.1.1
  # Platform-specific features

  # Connectivity
  connectivity_plus: ^5.0.2
  # Monitor network status for sync
```

---

## Development Tools

### Code Quality

**flutter_lints: ^3.0.0**
- Official Flutter linting rules
- Enforce code style consistency
- Catch common mistakes

### Testing

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  mockito: ^5.4.4
  # Mocking for unit tests

  integration_test:
    sdk: flutter
  # End-to-end testing
```

### CI/CD

**GitHub Actions**
- Automated testing on push
- Build verification for iOS/Android
- Automated APK/IPA generation

---

## External Services

### 1. Supabase

**Tier**: Free (starting), Pro ($25/month when scaling)

**Features Used**:
- PostgreSQL database (500 MB free)
- Authentication helpers
- Storage (1 GB free)
- Real-time subscriptions
- Edge Functions (future)

### 2. Google Cloud Console

**Purpose**: OAuth 2.0 configuration

**Setup**:
- OAuth 2.0 client ID for Android
- OAuth 2.0 client ID for iOS
- API key for Google Sign-In

**Cost**: Free

### 3. DeepSeek API

**Pricing**: Pay-per-token
- Input: ~$0.14 per million tokens
- Output: ~$0.28 per million tokens

**Estimated Cost** (per 1000 users/month):
- Workout generation: ~$5-10
- Meal plans: ~$5-10
- Suggestions: ~$2-5
- **Total**: ~$15-25/month

**Budget Strategy**:
- Cache aggressive ly
- Rate limit users
- Use optimized prompts

### 4. Firebase (Optional - Future)

**Use Case**: Push notifications, analytics

**Why Optional**:
- Not required for MVP
- Add when user base grows
- Free tier sufficient for notifications

---

## Platform-Specific Considerations

### iOS Requirements

```yaml
# ios/Podfile
platform :ios, '12.0'

# Required permissions (Info.plist)
- NSPhotoLibraryUsageDescription
- NSCameraUsageDescription
- NSPhotoLibraryAddUsageDescription
```

### Android Requirements

```gradle
// android/app/build.gradle
minSdkVersion 21
targetSdkVersion 34

// Required permissions (AndroidManifest.xml)
- INTERNET
- ACCESS_NETWORK_STATE
- READ_EXTERNAL_STORAGE
- WRITE_EXTERNAL_STORAGE
- CAMERA
```

---

## Development Environment

### Required Tools

1. **Flutter SDK**: 3.x latest stable
2. **Dart SDK**: 3.x (bundled with Flutter)
3. **IDE**: VS Code or Android Studio
4. **iOS**: Xcode 14+ (Mac required)
5. **Android**: Android Studio with SDK
6. **Version Control**: Git 2.x+

### Recommended VS Code Extensions

- Flutter
- Dart
- Flutter Riverpod Snippets
- GitLens
- Error Lens
- Pubspec Assist

---

## Dependency Management Strategy

### Version Pinning
- Use `^` for minor version updates
- Test thoroughly before major version upgrades
- Lock versions in production builds

### Update Schedule
- Monthly dependency review
- Security patches immediately
- Major updates in dedicated sprint

---

## Performance Monitoring

### Sentry (Future Addition)

**Package**: `sentry_flutter: ^7.13.2`

**Why Sentry?**
- Real-time error tracking
- Performance monitoring
- Release health tracking
- Breadcrumb trail for debugging

**When to Add**: After MVP launch

---

## Summary

This tech stack balances:
- **Performance**: Native compilation, efficient sync
- **Developer Experience**: Hot reload, strong typing, great tooling
- **Cost**: Free tiers for MVP, reasonable scaling costs
- **Scalability**: Proven technologies for millions of users
- **Security**: OAuth 2.0, encrypted storage, RLS policies
- **User Experience**: Offline-first, smooth animations, fast UI

All technology choices prioritize the core goal: helping users track progressive overload effectively while maintaining a delightful user experience.
