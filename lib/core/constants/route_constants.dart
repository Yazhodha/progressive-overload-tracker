/// Navigation route constants
class RouteConstants {
  RouteConstants._();

  // Auth Routes
  static const String splash = '/';
  static const String signIn = '/sign-in';
  static const String signUp = '/sign-up';
  static const String onboarding = '/onboarding';

  // Main Routes
  static const String home = '/home';
  static const String dashboard = '/dashboard';

  // Workout Routes
  static const String workoutList = '/workouts';
  static const String workoutDetail = '/workout/:id';
  static const String startWorkout = '/workout/start';
  static const String activeWorkout = '/workout/active';
  static const String workoutHistory = '/workout/history';

  // Exercise Routes
  static const String exerciseLibrary = '/exercises';
  static const String exerciseDetail = '/exercise/:id';
  static const String exerciseSearch = '/exercises/search';

  // Progress Routes
  static const String progress = '/progress';
  static const String progressCharts = '/progress/charts';
  static const String personalRecords = '/progress/records';

  // Body Measurements Routes
  static const String bodyMeasurements = '/measurements';
  static const String addMeasurement = '/measurements/add';
  static const String progressPhotos = '/measurements/photos';

  // AI Features Routes
  static const String aiWorkoutGenerator = '/ai/workout';
  static const String aiMealPlan = '/ai/meal-plan';
  static const String aiSuggestions = '/ai/suggestions';

  // Profile Routes
  static const String profile = '/profile';
  static const String editProfile = '/profile/edit';
  static const String settings = '/settings';
  static const String equipment = '/profile/equipment';
  static const String goals = '/profile/goals';

  // Helper method to generate dynamic routes
  static String workoutDetailRoute(String id) => '/workout/$id';
  static String exerciseDetailRoute(String id) => '/exercise/$id';
}
