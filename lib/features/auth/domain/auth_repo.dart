import 'package:adalem/features/auth/domain/auth_user.dart';

abstract class AuthRepo {
  Future<AuthUser?> signInWithGoogle();
  Future<void> signOut();
  AuthUser? getCurrentUser();
  Future<AuthUser?> getUserById(String uid);
  Stream<AuthUser?> get authStateChanges;
  Stream<AuthUser?> fetchActivity();
  Future<void> updateActivity(
    String uid, 
    String dateKey, {
    bool isMaxReached = false,
    String? oldestDateKey,
    int created = 0, 
    int quiz = 0, 
    int flashcard = 0,
  });
}