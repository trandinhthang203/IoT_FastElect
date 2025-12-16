class ApiConstants {
  static const String baseUrl = 'http://103.249.200.211:3000/api';
  static const String loginEndpoint = '/v1/auth/login/mobile-app';
  static const String logoutEndpoint = '/v1/auth/logout';
  static const String monthlyConsumptionEndpoint = '/v1/consumptions/monthly';
  static const String latestConsumptionEndpoint = '/v1/consumptions/monthly/latest';
  static const String dailyConsumptionEndpoint = '/v1/consumptions/daily';
  static const String notificationsEndpoint = '/v1/notifications';
  
  static const String tokenKey = 'access_token';
}