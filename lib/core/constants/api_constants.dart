class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://api.bidndrive.in';
  static const String _authBasePath = '/api/auth';

  static const String registerPath = '$_authBasePath/register';
  static const String loginPath = '$_authBasePath/login';
  static const String refreshTokenPath = '$_authBasePath/refresh-token';
  static const String updateProfilePath = '$_authBasePath/update-profile';
  static const String changePasswordPath = '$_authBasePath/change-password';
  static const String updateFcmPath = '$_authBasePath/updatefcm';

  static Uri uri(String path) => Uri.parse('$baseUrl$path');
}
