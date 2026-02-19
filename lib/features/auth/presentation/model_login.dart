import 'package:adalem/features/auth/domain/auth_user.dart';

class AuthResult {
  final AuthUser? user;
  final bool success;
  final String? errorMessage;

  const AuthResult({
    required this.success,
    this.user,
    this.errorMessage,
  });

  factory AuthResult.success(AuthUser user) {
    return AuthResult(
      success: true,
      user: user,
    );
  }

  factory AuthResult.failure(String message) {
    return AuthResult(
      success: false,
      errorMessage: message,
    );
  }

  factory AuthResult.cancelled() {
    return AuthResult(
      success: false,
      errorMessage: 'Sign in was cancelled.',
    );
  }
}