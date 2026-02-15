/// API-related constants
class ApiConstants {
  ApiConstants._();

  // Supabase Endpoints (to be configured via environment)
  static const String supabaseAuthEndpoint = '/auth/v1';
  static const String supabaseRestEndpoint = '/rest/v1';
  static const String supabaseStorageEndpoint = '/storage/v1';

  // Supabase Tables
  static const String usersTable = 'users';
  static const String userProfilesTable = 'user_profiles';
  static const String workoutsTable = 'workouts';
  static const String exercisesTable = 'exercises';
  static const String workoutExercisesTable = 'workout_exercises';
  static const String setsTable = 'sets';
  static const String bodyMeasurementsTable = 'body_measurements';
  static const String progressPhotosTable = 'progress_photos';
  static const String exerciseLibraryTable = 'exercise_library';
  static const String personalRecordsTable = 'personal_records';
  static const String aiGeneratedPlansTable = 'ai_generated_plans';

  // Supabase Storage Buckets
  static const String progressPhotosBucket = 'progress-photos';
  static const String exerciseImagesBucket = 'exercise-images';
  static const String avatarsBucket = 'avatars';

  // DeepSeek AI API
  static const String deepSeekBaseUrl = 'https://api.deepseek.com';
  static const String deepSeekChatEndpoint = '/v1/chat/completions';
  static const String deepSeekModel = 'deepseek-chat';

  // Request Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 60);
  static const Duration aiRequestTimeout = Duration(seconds: 120);

  // Rate Limiting
  static const int maxRequestsPerMinute = 60;
  static const int aiRequestsPerDay = 50;
}
