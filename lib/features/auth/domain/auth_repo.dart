import 'package:adalem/features/auth/domain/auth_user.dart';

abstract class AuthRepo {
  Future<AuthUser?> signInWithGoogle();
  Future<void> signOut();
  AuthUser? getCurrentUser();
  Future<AuthUser?> getUserById(String uid);
  Stream<AuthUser?> get authStateChanges;
}