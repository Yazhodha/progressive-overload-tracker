# Progressive Overload Fitness Tracker 💪

A production-grade mobile fitness application built with Flutter that helps gym-goers systematically track strength gains through progressive overload tracking, body measurements, and AI-powered workout recommendations.

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)](https://flutter.dev)
[![Supabase](https://img.shields.io/badge/Supabase-Backend-3ECF8E?logo=supabase)](https://supabase.com)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

## 🎯 Overview

Progressive Overload Tracker is designed to solve a real problem in fitness tracking: systematically monitoring and improving strength gains over time. The app combines comprehensive workout logging, body measurements tracking, and AI-powered personalized recommendations to help users achieve their fitness goals.

## ✨ Features

### Core Features
- **Progressive Overload Tracking**
  - Log workouts with exercises, sets, reps, and weight
  - Visual progression charts showing strength gains over time
  - Week-over-week and day-over-day comparisons
  - Rest period tracking between sets
  - Personal records (PRs) tracking and celebrations

- **Body Measurements Tracking**
  - Track weight, body fat %, muscle mass
  - Multiple body measurements (chest, arms, waist, thighs, etc.)
  - Progress photos with before/after comparisons
  - Visual charts and trend analysis

- **AI-Powered Features** (Powered by Anthropic Claude)
  - Personalized workout routine generation
  - Custom meal plans based on dietary preferences and goals
  - AI workout suggestions based on past performance
  - Form tips and exercise recommendations

- **User Profile & Analytics**
  - Comprehensive user metrics and goals tracking
  - Equipment availability management
  - Dietary preferences and restrictions
  - Detailed progress analytics and insights

## 🏗️ Architecture

This project follows Clean Architecture principles with proper separation of concerns:

```
lib/
├── core/               # Core utilities, constants, themes
├── data/              # Data layer (repositories, data sources, models)
├── domain/            # Business logic (entities, use cases, repository interfaces)
├── presentation/      # UI layer (screens, widgets, state management)
└── main.dart         # App entry point
```

**Key Architectural Decisions:**
- **Offline-First**: SQLite local storage with Supabase sync
- **State Management**: Riverpod for scalable state management
- **Repository Pattern**: Clean separation between data sources and business logic
- **Responsive Design**: Adapts to various screen sizes and orientations

## 🛠️ Tech Stack

- **Frontend**: Flutter 3.x (Dart)
- **Backend**: Supabase (Authentication, PostgreSQL, Storage)
- **Local Database**: SQLite with `sqflite` package
- **State Management**: Riverpod
- **Charts & Visualization**: fl_chart
- **AI Integration**: Anthropic Claude API
- **Version Control**: Git & GitHub

For detailed technology decisions, see [TECH_STACK.md](docs/TECH_STACK.md)

## 📋 Prerequisites

- Flutter SDK (3.0 or higher)
- Dart SDK (3.0 or higher)
- iOS: Xcode 14+ (for iOS development)
- Android: Android Studio with SDK 21+ (for Android development)
- Supabase account (free tier available)
- Anthropic API key (for AI features)

## 🚀 Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/[your-username]/progressive-overload-tracker.git
cd progressive-overload-tracker
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Environment Configuration

Create a `.env` file in the root directory:

```env
SUPABASE_URL=your_supabase_project_url
SUPABASE_ANON_KEY=your_supabase_anon_key
ANTHROPIC_API_KEY=your_anthropic_api_key
```

### 4. Run the App

```bash
# Run on iOS simulator
flutter run -d ios

# Run on Android emulator
flutter run -d android

# Run on Chrome (for web testing)
flutter run -d chrome
```

## 📱 Platform Support

- ✅ iOS (12.0+)
- ✅ Android (API 21+)
- 🚧 Web (coming soon)

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run integration tests
flutter test integration_test/
```

## 📚 Documentation

- [High-Level Design (HLD)](docs/HLD.md) - System architecture and design decisions
- [Features Specification](docs/FEATURES.md) - Detailed feature requirements
- [Tech Stack Details](docs/TECH_STACK.md) - Technology choices and rationale
- [Development Progress](docs/PROGRESS.md) - Current development status and session notes
- [Contributing Guidelines](CONTRIBUTING.md) - How to contribute to this project

## 🗺️ Roadmap

### Milestone 1: Foundation (MVP)
- [x] Project setup and architecture
- [ ] Supabase integration and authentication
- [ ] User profile creation and management
- [ ] Basic workout logging
- [ ] SQLite offline storage and sync

### Milestone 2: Core Features
- [ ] Progressive overload visualization
- [ ] Exercise library with search
- [ ] Body measurements tracking
- [ ] Progress photos feature
- [ ] Personal records tracking

### Milestone 3: AI Features
- [ ] AI workout routine generator
- [ ] AI meal plan generator
- [ ] AI-powered workout suggestions
- [ ] Exercise form tips integration

### Milestone 4: Polish & Enhancement
- [ ] Dark/light theme
- [ ] Settings and preferences
- [ ] Export data functionality
- [ ] Social sharing features
- [ ] App onboarding flow

See [GitHub Issues](https://github.com/[your-username]/progressive-overload-tracker/issues) for detailed progress.

## 🤝 Contributing

Contributions are welcome! Please read our [Contributing Guidelines](CONTRIBUTING.md) first.

### Development Workflow
1. Create an issue describing the feature/bug
2. Fork the repository
3. Create a feature branch (`git checkout -b feature/amazing-feature`)
4. Commit your changes (`git commit -m 'Add amazing feature'`)
5. Push to the branch (`git push origin feature/amazing-feature`)
6. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👤 Author

**Yazhodha**
- Email: yazhodha@live.com
- GitHub: [@Yazhodha](https://github.com/Yazhodha)

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Supabase for the excellent backend infrastructure
- Anthropic for Claude AI API
- All contributors who help improve this project

## 📞 Support

If you encounter any issues or have questions:
- Open an issue on [GitHub Issues](https://github.com/[your-username]/progressive-overload-tracker/issues)
- Email: yazhodha@live.com

---

**Built with ❤️ using Flutter and Claude Code**
