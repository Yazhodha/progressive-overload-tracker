import 'package:flutter/foundation.dart';

/// User entity - represents the core user domain object
@immutable
class User {
  final String id;
  final String email;
  final String? displayName;
  final String? avatarUrl;
  final DateTime createdAt;
  final DateTime? lastSignInAt;
  final bool isOnboardingComplete;
  final UserProfile? profile;

  const User({
    required this.id,
    required this.email,
    this.displayName,
    this.avatarUrl,
    required this.createdAt,
    this.lastSignInAt,
    this.isOnboardingComplete = false,
    this.profile,
  });

  /// Create a copy with updated fields
  User copyWith({
    String? id,
    String? email,
    String? displayName,
    String? avatarUrl,
    DateTime? createdAt,
    DateTime? lastSignInAt,
    bool? isOnboardingComplete,
    UserProfile? profile,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
      lastSignInAt: lastSignInAt ?? this.lastSignInAt,
      isOnboardingComplete: isOnboardingComplete ?? this.isOnboardingComplete,
      profile: profile ?? this.profile,
    );
  }

  /// Get display name or email username
  String get name => displayName ?? email.split('@').first;

  /// Get initials for avatar
  String get initials {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : 'U';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'User(id: $id, email: $email, displayName: $displayName)';
}

/// User profile - extended user information
@immutable
class UserProfile {
  final String userId;
  final String? firstName;
  final String? lastName;
  final DateTime? dateOfBirth;
  final Gender? gender;
  final double? heightCm;
  final double? weightKg;
  final FitnessGoal? primaryGoal;
  final ExperienceLevel? experienceLevel;
  final List<String> availableEquipment;
  final List<String> dietaryPreferences;
  final int? workoutsPerWeek;
  final int? preferredWorkoutDuration; // in minutes
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserProfile({
    required this.userId,
    this.firstName,
    this.lastName,
    this.dateOfBirth,
    this.gender,
    this.heightCm,
    this.weightKg,
    this.primaryGoal,
    this.experienceLevel,
    this.availableEquipment = const [],
    this.dietaryPreferences = const [],
    this.workoutsPerWeek,
    this.preferredWorkoutDuration,
    this.createdAt,
    this.updatedAt,
  });

  /// Get full name
  String get fullName {
    if (firstName != null && lastName != null) {
      return '$firstName $lastName';
    }
    return firstName ?? lastName ?? '';
  }

  /// Calculate age from date of birth
  int? get age {
    if (dateOfBirth == null) return null;
    final today = DateTime.now();
    int age = today.year - dateOfBirth!.year;
    if (today.month < dateOfBirth!.month ||
        (today.month == dateOfBirth!.month && today.day < dateOfBirth!.day)) {
      age--;
    }
    return age;
  }

  /// Calculate BMI
  double? get bmi {
    if (heightCm == null || weightKg == null) return null;
    final heightM = heightCm! / 100;
    return weightKg! / (heightM * heightM);
  }

  /// Get BMI category
  String? get bmiCategory {
    final bmiValue = bmi;
    if (bmiValue == null) return null;
    if (bmiValue < 18.5) return 'Underweight';
    if (bmiValue < 25) return 'Normal';
    if (bmiValue < 30) return 'Overweight';
    return 'Obese';
  }

  /// Check if profile is complete
  bool get isComplete {
    return firstName != null &&
        lastName != null &&
        dateOfBirth != null &&
        gender != null &&
        heightCm != null &&
        weightKg != null &&
        primaryGoal != null &&
        experienceLevel != null;
  }

  UserProfile copyWith({
    String? userId,
    String? firstName,
    String? lastName,
    DateTime? dateOfBirth,
    Gender? gender,
    double? heightCm,
    double? weightKg,
    FitnessGoal? primaryGoal,
    ExperienceLevel? experienceLevel,
    List<String>? availableEquipment,
    List<String>? dietaryPreferences,
    int? workoutsPerWeek,
    int? preferredWorkoutDuration,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      userId: userId ?? this.userId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      primaryGoal: primaryGoal ?? this.primaryGoal,
      experienceLevel: experienceLevel ?? this.experienceLevel,
      availableEquipment: availableEquipment ?? this.availableEquipment,
      dietaryPreferences: dietaryPreferences ?? this.dietaryPreferences,
      workoutsPerWeek: workoutsPerWeek ?? this.workoutsPerWeek,
      preferredWorkoutDuration:
          preferredWorkoutDuration ?? this.preferredWorkoutDuration,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfile &&
          runtimeType == other.runtimeType &&
          userId == other.userId;

  @override
  int get hashCode => userId.hashCode;
}

/// Gender enumeration
enum Gender {
  male('Male'),
  female('Female'),
  other('Other'),
  preferNotToSay('Prefer not to say');

  final String displayName;
  const Gender(this.displayName);
}

/// Fitness goal enumeration
enum FitnessGoal {
  buildMuscle('Build Muscle', 'Focus on hypertrophy and strength gains'),
  loseWeight('Lose Weight', 'Burn fat while maintaining muscle'),
  gainStrength('Gain Strength', 'Maximize strength on compound lifts'),
  improveEndurance('Improve Endurance', 'Build cardiovascular fitness'),
  maintainFitness('Maintain Fitness', 'Stay in shape with regular workouts'),
  generalHealth('General Health', 'Overall health and wellness');

  final String displayName;
  final String description;
  const FitnessGoal(this.displayName, this.description);
}

/// Experience level enumeration
enum ExperienceLevel {
  beginner('Beginner', 'Less than 6 months of training'),
  intermediate('Intermediate', '6 months to 2 years of training'),
  advanced('Advanced', '2+ years of consistent training'),
  expert('Expert', '5+ years with deep knowledge');

  final String displayName;
  final String description;
  const ExperienceLevel(this.displayName, this.description);
}
