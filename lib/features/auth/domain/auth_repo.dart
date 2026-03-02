import 'package:adalem/features/auth/domain/auth_user.dart';

abstract class AuthRepo {
  Future<AuthUser?> signInWithGoogle();
  Future<void> signOut();
  AuthUser? getCurrentUser();
  Stream<AuthUser?> get authStateChanges;
}