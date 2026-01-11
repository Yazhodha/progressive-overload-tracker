# Contributing to Progressive Overload Fitness Tracker

First off, thank you for considering contributing to Progressive Overload Fitness Tracker! It's people like you that make this app better for everyone.

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Coding Standards](#coding-standards)
- [Commit Guidelines](#commit-guidelines)
- [Pull Request Process](#pull-request-process)
- [Testing](#testing)
- [Documentation](#documentation)

---

## Code of Conduct

This project and everyone participating in it is governed by our commitment to creating a welcoming and inclusive environment. By participating, you are expected to uphold this standard.

### Our Standards

- **Be respectful**: Treat everyone with respect and professionalism
- **Be collaborative**: Work together towards common goals
- **Be constructive**: Provide helpful feedback and criticism
- **Be inclusive**: Welcome and support people of all backgrounds

---

## Getting Started

### Prerequisites

Before you begin, ensure you have the following installed:

- **Flutter SDK** (3.0 or higher): [Installation Guide](https://docs.flutter.dev/get-started/install)
- **Dart SDK** (3.0 or higher): Comes bundled with Flutter
- **Git**: [Installation Guide](https://git-scm.com/downloads)
- **VS Code** or **Android Studio**: Recommended IDEs
- **Xcode** (for iOS development on macOS)
- **Android Studio** (for Android development)

### Setting Up Your Development Environment

1. **Fork the Repository**
   ```bash
   # Click the "Fork" button on GitHub, then clone your fork
   git clone https://github.com/[your-username]/progressive-overload-tracker.git
   cd progressive-overload-tracker
   ```

2. **Add Upstream Remote**
   ```bash
   git remote add upstream https://github.com/Yazhodha/progressive-overload-tracker.git
   ```

3. **Install Dependencies**
   ```bash
   flutter pub get
   ```

4. **Set Up Environment Variables**
   ```bash
   cp .env.example .env
   # Edit .env with your API keys (see .env.example for required values)
   ```

5. **Run the App**
   ```bash
   flutter run
   ```

---

## Development Workflow

### Branching Strategy

We follow a modified Git Flow workflow:

- **`main`**: Production-ready code only
- **`develop`**: Integration branch for features
- **`feature/[issue-number]-[feature-name]`**: Feature branches
- **`bugfix/[issue-number]-[bug-description]`**: Bug fix branches
- **`hotfix/[description]`**: Critical production fixes

### Workflow Steps

1. **Create an Issue**
   - Before starting work, create or find an existing issue
   - Discuss the proposed changes in the issue
   - Get approval from maintainers for significant changes

2. **Create a Feature Branch**
   ```bash
   git checkout develop
   git pull upstream develop
   git checkout -b feature/123-add-workout-timer
   ```

3. **Make Your Changes**
   - Write clean, readable code following our [Coding Standards](#coding-standards)
   - Write tests for your changes
   - Update documentation as needed

4. **Commit Your Changes**
   - Follow our [Commit Guidelines](#commit-guidelines)
   - Make small, focused commits
   ```bash
   git add .
   git commit -m "feat: add workout timer functionality"
   ```

5. **Keep Your Branch Updated**
   ```bash
   git fetch upstream
   git rebase upstream/develop
   ```

6. **Push to Your Fork**
   ```bash
   git push origin feature/123-add-workout-timer
   ```

7. **Create a Pull Request**
   - Go to GitHub and create a pull request from your fork
   - Fill out the pull request template
   - Link the related issue(s)
   - Request review from maintainers

---

## Coding Standards

### Dart/Flutter Style Guide

We follow the official [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style) and [Flutter Style Guide](https://github.com/flutter/flutter/wiki/Style-guide-for-Flutter-repo).

**Key Points:**

- **Use `dart format`**: Format all code before committing
  ```bash
  dart format lib/
  ```

- **Use `dart analyze`**: Ensure no linting errors
  ```bash
  dart analyze
  ```

- **Naming Conventions**:
  - Classes: `PascalCase` (e.g., `WorkoutRepository`)
  - Variables/Functions: `camelCase` (e.g., `getUserProfile`)
  - Constants: `lowerCamelCase` (e.g., `defaultTimeout`)
  - Files: `snake_case` (e.g., `workout_repository.dart`)

- **Import Order**:
  ```dart
  // 1. Dart SDK imports
  import 'dart:async';
  import 'dart:io';

  // 2. Flutter imports
  import 'package:flutter/material.dart';

  // 3. Package imports (alphabetically)
  import 'package:riverpod/riverpod.dart';
  import 'package:supabase_flutter/supabase_flutter.dart';

  // 4. Relative imports (alphabetically)
  import '../domain/entities/workout.dart';
  import '../domain/repositories/workout_repository.dart';
  ```

### Architecture Guidelines

**Follow Clean Architecture Principles:**

```
lib/
├── core/               # Core utilities, constants, themes
│   ├── constants/
│   ├── themes/
│   ├── utils/
│   └── errors/
├── data/              # Data layer (repositories, data sources, models)
│   ├── models/        # Data models (DTOs)
│   ├── data_sources/  # Local (SQLite) and Remote (Supabase)
│   └── repositories/  # Repository implementations
├── domain/            # Business logic (entities, use cases, repository interfaces)
│   ├── entities/      # Core business models
│   ├── repositories/  # Repository interfaces (abstract)
│   └── usecases/      # Business logic use cases
├── presentation/      # UI layer (screens, widgets, state management)
│   ├── providers/     # Riverpod providers
│   ├── screens/       # Full screen widgets
│   ├── widgets/       # Reusable UI components
│   └── controllers/   # View controllers
└── main.dart         # App entry point
```

**Dependency Rule**: Dependencies should only point inward
- Presentation → Domain ← Data
- Domain should have NO dependencies on Presentation or Data layers

### Code Quality Checklist

Before submitting a PR, ensure:

- [ ] Code is formatted with `dart format`
- [ ] No errors from `dart analyze`
- [ ] All tests pass
- [ ] New features have unit tests
- [ ] UI changes have widget tests
- [ ] Documentation is updated
- [ ] No console.log or debug print statements
- [ ] No hardcoded strings (use localization)
- [ ] No API keys or secrets in code

---

## Commit Guidelines

We follow [Conventional Commits](https://www.conventionalcommits.org/) for commit messages.

### Commit Message Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types

- **feat**: A new feature
- **fix**: A bug fix
- **docs**: Documentation only changes
- **style**: Code style changes (formatting, missing semi-colons, etc.)
- **refactor**: Code changes that neither fix a bug nor add a feature
- **perf**: Performance improvements
- **test**: Adding or updating tests
- **chore**: Changes to build process or auxiliary tools
- **ci**: CI/CD configuration changes

### Examples

```bash
# Feature
git commit -m "feat(workout): add rest timer between sets"

# Bug fix
git commit -m "fix(auth): resolve Google OAuth token refresh issue"

# Documentation
git commit -m "docs(readme): update installation instructions"

# Refactor
git commit -m "refactor(database): migrate to repository pattern"

# Test
git commit -m "test(workout): add unit tests for set logging"
```

### Commit Message Guidelines

- Use the imperative mood ("add feature" not "added feature")
- Keep the subject line under 72 characters
- Reference issues in the footer (e.g., "Closes #123")
- Provide context in the body for complex changes

---

## Pull Request Process

### Before Creating a PR

1. **Rebase on Latest `develop`**
   ```bash
   git fetch upstream
   git rebase upstream/develop
   ```

2. **Run All Tests**
   ```bash
   flutter test
   ```

3. **Format and Analyze Code**
   ```bash
   dart format lib/
   dart analyze
   ```

### PR Title Format

Follow the same format as commit messages:
```
feat(workout): add rest timer functionality
```

### PR Description Template

When creating a PR, use this template:

```markdown
## Description
[Brief description of the changes]

## Related Issue
Closes #[issue number]

## Type of Change
- [ ] Bug fix (non-breaking change which fixes an issue)
- [ ] New feature (non-breaking change which adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] Documentation update

## How Has This Been Tested?
- [ ] Unit tests
- [ ] Widget tests
- [ ] Integration tests
- [ ] Manual testing

**Test Configuration**:
- Device: [e.g., iPhone 14 Pro Simulator]
- OS: [e.g., iOS 16.0]

## Screenshots (if applicable)
[Add screenshots for UI changes]

## Checklist
- [ ] My code follows the project's style guidelines
- [ ] I have performed a self-review of my code
- [ ] I have commented my code, particularly in hard-to-understand areas
- [ ] I have updated the documentation accordingly
- [ ] My changes generate no new warnings
- [ ] I have added tests that prove my fix is effective or that my feature works
- [ ] New and existing unit tests pass locally with my changes
- [ ] Any dependent changes have been merged and published
```

### PR Review Process

1. **Automated Checks**: CI/CD will run automated tests and linting
2. **Code Review**: At least one maintainer must approve
3. **Feedback**: Address all review comments
4. **Approval**: Once approved, a maintainer will merge

---

## Testing

### Writing Tests

All new features and bug fixes should include tests.

**Test Types**:

1. **Unit Tests** (lib/domain and lib/data logic)
   ```dart
   // test/domain/usecases/log_workout_test.dart
   void main() {
     group('LogWorkoutUseCase', () {
       test('should successfully log a workout', () async {
         // Arrange
         final repository = MockWorkoutRepository();
         final useCase = LogWorkoutUseCase(repository);

         // Act
         final result = await useCase.execute(mockWorkout);

         // Assert
         expect(result, isA<Success>());
       });
     });
   }
   ```

2. **Widget Tests** (UI components)
   ```dart
   // test/presentation/widgets/workout_card_test.dart
   void main() {
     testWidgets('WorkoutCard displays workout name', (tester) async {
       await tester.pumpWidget(
         MaterialApp(
           home: WorkoutCard(workout: mockWorkout),
         ),
       );

       expect(find.text('Test Workout'), findsOneWidget);
     });
   }
   ```

3. **Integration Tests** (End-to-end flows)
   ```dart
   // integration_test/workout_logging_test.dart
   void main() {
     testWidgets('User can log a complete workout', (tester) async {
       // Test full workout logging flow
     });
   }
   ```

### Running Tests

```bash
# Run all unit and widget tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run integration tests
flutter test integration_test/

# Run specific test file
flutter test test/domain/usecases/log_workout_test.dart
```

### Test Coverage

- **Minimum coverage**: 70% for new code
- **Target coverage**: 80%+ for critical features (authentication, data sync, workout logging)

---

## Documentation

### Code Documentation

- Add doc comments to all public APIs
- Use `///` for documentation comments (supports markdown)
- Include examples in complex functions

```dart
/// Logs a workout to the local database and queues for sync.
///
/// Returns [Success] with the workout ID on successful save,
/// or [Failure] with error details if the operation fails.
///
/// Example:
/// ```dart
/// final result = await logWorkout(workout);
/// result.fold(
///   (error) => print('Error: $error'),
///   (workoutId) => print('Saved with ID: $workoutId'),
/// );
/// ```
Future<Either<Failure, String>> logWorkout(Workout workout) async {
  // Implementation
}
```

### Updating Documentation

When making changes, update the relevant documentation:

- **README.md**: For user-facing features
- **docs/HLD.md**: For architectural changes
- **docs/FEATURES.md**: For new features or feature changes
- **docs/TECH_STACK.md**: For new dependencies or technology changes
- **docs/PROGRESS.md**: Update after each significant milestone

---

## Questions or Need Help?

- **Create an issue**: [GitHub Issues](https://github.com/Yazhodha/progressive-overload-tracker/issues)
- **Email**: yazhodha@live.com
- **Discussions**: [GitHub Discussions](https://github.com/Yazhodha/progressive-overload-tracker/discussions)

---

## Recognition

Contributors will be recognized in:
- README.md contributors section
- GitHub contributors graph
- Release notes for significant contributions

---

Thank you for contributing to Progressive Overload Fitness Tracker! Your efforts help make fitness tracking better for everyone. 💪
