import '../../domain/entities/user.dart';

/// User data model - maps between JSON/database and User entity
class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    super.displayName,
    super.avatarUrl,
    required super.createdAt,
    super.lastSignInAt,
    super.isOnboardingComplete,
    super.profile,
  });

  /// Create from JSON (Supabase response)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['display_name'] as String? ?? json['full_name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      lastSignInAt: json['last_sign_in_at'] != null
          ? DateTime.parse(json['last_sign_in_at'] as String)
          : null,
      isOnboardingComplete: json['is_onboarding_complete'] as bool? ?? false,
      profile: json['profile'] != null
          ? UserProfileModel.fromJson(json['profile'] as Map<String, dynamic>)
          : null,
    );
  }

  /// Create from Supabase auth user
  factory UserModel.fromSupabaseUser(Map<String, dynamic> authUser) {
    final userMetadata = authUser['user_metadata'] as Map<String, dynamic>? ?? {};
    return UserModel(
      id: authUser['id'] as String,
      email: authUser['email'] as String,
      displayName: userMetadata['full_name'] as String? ??
          userMetadata['name'] as String?,
      avatarUrl: userMetadata['avatar_url'] as String? ??
          userMetadata['picture'] as String?,
      createdAt: DateTime.parse(authUser['created_at'] as String),
      lastSignInAt: authUser['last_sign_in_at'] != null
          ? DateTime.parse(authUser['last_sign_in_at'] as String)
          : null,
      isOnboardingComplete: false,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'display_name': displayName,
      'avatar_url': avatarUrl,
      'created_at': createdAt.toIso8601String(),
      'last_sign_in_at': lastSignInAt?.toIso8601String(),
      'is_onboarding_complete': isOnboardingComplete,
    };
  }

  /// Create from entity
  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      displayName: user.displayName,
      avatarUrl: user.avatarUrl,
      createdAt: user.createdAt,
      lastSignInAt: user.lastSignInAt,
      isOnboardingComplete: user.isOnboardingComplete,
      profile: user.profile != null
          ? UserProfileModel.fromEntity(user.profile!)
          : null,
    );
  }

  /// Convert to entity
  User toEntity() {
    return User(
      id: id,
      email: email,
      displayName: displayName,
      avatarUrl: avatarUrl,
      createdAt: createdAt,
      lastSignInAt: lastSignInAt,
      isOnboardingComplete: isOnboardingComplete,
      profile: profile,
    );
  }
}

/// User profile data model
class UserProfileModel extends UserProfile {
  const UserProfileModel({
    required super.userId,
    super.firstName,
    super.lastName,
    super.dateOfBirth,
    super.gender,
    super.heightCm,
    super.weightKg,
    super.primaryGoal,
    super.experienceLevel,
    super.availableEquipment,
    super.dietaryPreferences,
    super.workoutsPerWeek,
    super.preferredWorkoutDuration,
    super.createdAt,
    super.updatedAt,
  });

  /// Create from JSON
  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      userId: json['user_id'] as String,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      dateOfBirth: json['date_of_birth'] != null
          ? DateTime.parse(json['date_of_birth'] as String)
          : null,
      gender: json['gender'] != null
          ? Gender.values.firstWhere(
              (g) => g.name == json['gender'],
              orElse: () => Gender.preferNotToSay,
            )
          : null,
      heightCm: (json['height_cm'] as num?)?.toDouble(),
      weightKg: (json['weight_kg'] as num?)?.toDouble(),
      primaryGoal: json['primary_goal'] != null
          ? FitnessGoal.values.firstWhere(
              (g) => g.name == json['primary_goal'],
              orElse: () => FitnessGoal.generalHealth,
            )
          : null,
      experienceLevel: json['experience_level'] != null
          ? ExperienceLevel.values.firstWhere(
              (l) => l.name == json['experience_level'],
              orElse: () => ExperienceLevel.beginner,
            )
          : null,
      availableEquipment: (json['available_equipment'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      dietaryPreferences: (json['dietary_preferences'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      workoutsPerWeek: json['workouts_per_week'] as int?,
      preferredWorkoutDuration: json['preferred_workout_duration'] as int?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'first_name': firstName,
      'last_name': lastName,
      'date_of_birth': dateOfBirth?.toIso8601String().split('T').first,
      'gender': gender?.name,
      'height_cm': heightCm,
      'weight_kg': weightKg,
      'primary_goal': primaryGoal?.name,
      'experience_level': experienceLevel?.name,
      'available_equipment': availableEquipment,
      'dietary_preferences': dietaryPreferences,
      'workouts_per_week': workoutsPerWeek,
      'preferred_workout_duration': preferredWorkoutDuration,
      'updated_at': DateTime.now().toIso8601String(),
    };
  }

  /// Create from entity
  factory UserProfileModel.fromEntity(UserProfile profile) {
    return UserProfileModel(
      userId: profile.userId,
      firstName: profile.firstName,
      lastName: profile.lastName,
      dateOfBirth: profile.dateOfBirth,
      gender: profile.gender,
      heightCm: profile.heightCm,
      weightKg: profile.weightKg,
      primaryGoal: profile.primaryGoal,
      experienceLevel: profile.experienceLevel,
      availableEquipment: profile.availableEquipment,
      dietaryPreferences: profile.dietaryPreferences,
      workoutsPerWeek: profile.workoutsPerWeek,
      preferredWorkoutDuration: profile.preferredWorkoutDuration,
      createdAt: profile.createdAt,
      updatedAt: profile.updatedAt,
    );
  }

  /// Convert to entity
  UserProfile toEntity() {
    return UserProfile(
      userId: userId,
      firstName: firstName,
      lastName: lastName,
      dateOfBirth: dateOfBirth,
      gender: gender,
      heightCm: heightCm,
      weightKg: weightKg,
      primaryGoal: primaryGoal,
      experienceLevel: experienceLevel,
      availableEquipment: availableEquipment,
      dietaryPreferences: dietaryPreferences,
      workoutsPerWeek: workoutsPerWeek,
      preferredWorkoutDuration: preferredWorkoutDuration,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
