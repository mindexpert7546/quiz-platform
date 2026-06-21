class AppConfig {
  AppConfig._();

  // Change this one constant when the backend host or API path changes.
  static const baseUrl = 'http://10.54.208.25:8080/api';
  static const authTokenKey = 'student_auth_token';
  static const connectTimeoutSeconds = 12;
}
