import 'dart:io';

class AppConfig {
  AppConfig._();

  // GOOGLE OAUTH CLIENT IDs
  static String get googleClientId {
    if (Platform.isAndroid) {
      return const String.fromEnvironment('GOOGLE_CLIENT_ID_ANDROID');
    } else if (Platform.isIOS) {
      return const String.fromEnvironment('GOOGLE_CLIENT_ID_IOS');
    } else {
      return const String.fromEnvironment('GOOGLE_CLIENT_ID_WEB');
    }
  }

  /* API BASE URL
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    //defaultValue: 'https://api.adalem.com',
  );*/

  // ENVIRONMENT
  static const String environment = String.fromEnvironment(
    'APP_ENVIRONMENT',
    defaultValue: 'development',
  );

  // HELPER METHODS
  static bool get isDevelopment => environment == 'development';
  static bool get isProduction => environment == 'production';
}