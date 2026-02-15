/// Application-wide constants
class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'Progressive Overload Tracker';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';

  // Default Values
  static const int defaultRestTimerSeconds = 90;
  static const int maxSetsPerExercise = 20;
  static const int maxExercisesPerWorkout = 30;
  static const double defaultWeightIncrement = 2.5; // kg

  // Pagination
  static const int defaultPageSize = 20;
  static const int exerciseSearchLimit = 50;

  // Image Configuration
  static const int maxImageWidth = 1080;
  static const int maxImageHeight = 1920;
  static const int imageQuality = 85;
  static const int maxProgressPhotos = 100;

  // Cache Configuration
  static const Duration cacheValidDuration = Duration(hours: 24);
  static const int maxCachedWorkouts = 100;

  // Sync Configuration
  static const Duration syncInterval = Duration(minutes: 15);
  static const int maxRetryAttempts = 3;
  static const Duration retryDelay = Duration(seconds: 5);

  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 350);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);

  // Validation
  static const int minPasswordLength = 8;
  static const int maxNameLength = 50;
  static const int maxNotesLength = 500;
  static const double minWeight = 0.5; // kg
  static const double maxWeight = 1000.0; // kg
  static const int minReps = 1;
  static const int maxReps = 999;
}
