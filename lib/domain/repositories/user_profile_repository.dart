import '../entities/user.dart';
import '../../core/utils/result.dart';

/// User profile repository interface
abstract class UserProfileRepository {
  /// Get user profile by user ID
  Future<Result<UserProfile?>> getProfile(String userId);

  /// Create user profile
  Future<Result<UserProfile>> createProfile(UserProfile profile);

  /// Update user profile
  Future<Result<UserProfile>> updateProfile(UserProfile profile);

  /// Delete user profile
  Future<Result<void>> deleteProfile(String userId);

  /// Check if profile exists
  Future<Result<bool>> profileExists(String userId);

  /// Update profile field
  Future<Result<UserProfile>> updateProfileField({
    required String userId,
    required String field,
    required dynamic value,
  });

  /// Get available equipment
  Future<Result<List<String>>> getAvailableEquipment(String userId);

  /// Update available equipment
  Future<Result<void>> updateAvailableEquipment({
    required String userId,
    required List<String> equipment,
  });

  /// Get dietary preferences
  Future<Result<List<String>>> getDietaryPreferences(String userId);

  /// Update dietary preferences
  Future<Result<void>> updateDietaryPreferences({
    required String userId,
    required List<String> preferences,
  });
}
