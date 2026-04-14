class ApiConfig {
  static const String host = '10.82.70.93';
  static const int port = 8000;
  static const String protocol = 'http';
  static const String apiPrefix = '/api/v1';
  
  static const String baseUrl = '$protocol://$host:$port$apiPrefix';
  
  static const String authRegister = '/auth/register';
  static const String authLogin = '/auth/login';
  static const String authRefresh = '/auth/refresh';
  
  static const String userProfile = '/users/me';
  
  static const String goals = '/goals';
  
  static const String dailyTargets = '/daily-targets';
  
  static const String workoutCategories = '/workouts/categories';
  static const String workouts = '/workouts';
  
  static const String schedules = '/schedules';
  
  static const String records = '/records';
}
