/// Local SQLite database constants
class DatabaseConstants {
  DatabaseConstants._();

  // Database Configuration
  static const String databaseName = 'progressive_overload.db';
  static const int databaseVersion = 1;

  // Table Names (Local SQLite)
  static const String usersTable = 'users';
  static const String workoutsTable = 'workouts';
  static const String exercisesTable = 'exercises';
  static const String workoutExercisesTable = 'workout_exercises';
  static const String setsTable = 'sets';
  static const String bodyMeasurementsTable = 'body_measurements';
  static const String progressPhotosTable = 'progress_photos';
  static const String exerciseLibraryTable = 'exercise_library';
  static const String personalRecordsTable = 'personal_records';
  static const String syncQueueTable = 'sync_queue';
  static const String cacheMetadataTable = 'cache_metadata';

  // Column Names - Common
  static const String columnId = 'id';
  static const String columnUserId = 'user_id';
  static const String columnCreatedAt = 'created_at';
  static const String columnUpdatedAt = 'updated_at';
  static const String columnSyncStatus = 'sync_status';
  static const String columnDeletedAt = 'deleted_at';

  // Sync Status Values
  static const String syncStatusPending = 'pending';
  static const String syncStatusSynced = 'synced';
  static const String syncStatusFailed = 'failed';
  static const String syncStatusConflict = 'conflict';
}
