# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Progressive Overload Fitness Tracker — a Flutter mobile app for tracking progressive overload, body measurements, and AI-powered workout recommendations. Uses Supabase backend, Riverpod state management, and DeepSeek AI integration. Targets iOS (12.0+) and Android (API 21+).

## Build & Development Commands

```bash
flutter pub get                # Install dependencies
flutter run                    # Run on default device
flutter run -d ios             # Run on iOS simulator
flutter run -d android         # Run on Android emulator
flutter test                   # Run all tests
flutter test test/specific_test.dart  # Run a single test
flutter test --coverage        # Run tests with coverage
dart analyze                   # Static analysis (uses package:flutter_lints/flutter.yaml)
dart format lib/               # Format code
flutter clean                  # Clean build artifacts
flutter build ios              # Build iOS release
flutter build apk              # Build Android APK
dart run build_runner build --delete-conflicting-outputs  # Code generation
```

## Architecture

Clean Architecture with three layers. Dependency flow: Presentation → Domain ← Data.

- **`lib/domain/`** — Business logic layer (no dependencies on outer layers). Contains entities (`User`, `UserProfile`), repository interfaces, and use cases.
- **`lib/data/`** — Data layer. Repository implementations, data models (extend domain entities with JSON serialization), and data sources (Supabase client).
- **`lib/presentation/`** — UI layer. Screens, Riverpod providers/controllers, and reusable widgets.
- **`lib/core/`** — Shared code: constants, themes (Material 3 light/dark), error handling, utilities.

### State Management — Riverpod

Uses `StateNotifierProvider` with sealed class state pattern:
```dart
sealed class AuthState {}
class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthAuthenticated extends AuthState { final User user; }
```
Pattern matching via `switch` expressions in `ConsumerWidget.build()`.

### Error Handling — Result Type

Custom `Result<T>` sealed class (`lib/core/utils/result.dart`) for functional error handling. All repository methods return `Result<T>`. Use `.fold(onSuccess:, onFailure:)` for handling.

Failure hierarchy in `lib/core/errors/failures.dart`: `ServerFailure`, `NetworkFailure`, `AuthFailure`, `ValidationFailure`, etc.

### Entity-Model Pattern

Domain entities live in `lib/domain/entities/`. Data models in `lib/data/models/` extend domain entities and add `fromJson()`/`toJson()`/`fromSupabaseUser()` factory methods. No code generation (freezed/json_serializable) — manual serialization.

## Environment Setup

Requires a `.env` file in project root:
```
SUPABASE_URL=your_url
SUPABASE_ANON_KEY=your_key
DEEPSEEK_API_KEY=your_key
ENABLE_MOCK_AUTH=true
```
When `ENABLE_MOCK_AUTH=true` or Supabase is not configured, the app uses built-in mock authentication with simulated delays and demo users.

## Database

Supabase backend with local SQLite (sqflite) for offline-first. Database migrations are in `supabase/migrations/`. Local Supabase config in `supabase/config.toml`.

## Key Conventions

- Sealed classes for state representation with exhaustive pattern matching
- Repository pattern: abstract interfaces in domain, implementations in data
- Providers declared at file level (not inside widgets)
- Material 3 theming via `AppTheme`, `AppColors`, `AppTypography` in `lib/core/themes/`
- Package name: `progressive_overload_tracker`
- Do NOT include `Co-Authored-By` lines in commit messages
