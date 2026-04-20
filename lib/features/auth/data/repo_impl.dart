import 'package:adalem/features/auth/data/google_datasource.dart';
import 'package:adalem/features/auth/domain/auth_user.dart';
import 'package:adalem/features/auth/domain/auth_repo.dart';

class AuthRepositoryImpl implements AuthRepo {
  final AuthRemoteDataSource _dataSource;

  AuthRepositoryImpl({required AuthRemoteDataSource dataSource}) 
      : _dataSource = dataSource;
  
  @override
  Future<AuthUser?> signInWithGoogle() async {
    return await _dataSource.signInWithGoogle();
  }

  @override
  Future<void> signOut() async {
    await _dataSource.signOut();
  }
  
  @override
  AuthUser? getCurrentUser() {
    return _dataSource.getCurrentUser();
  }

  @override
  Future<AuthUser?> getUserById(String uid) async {
    return await _dataSource.getUserById(uid);
  }

  @override
  Future<AuthUser?> getUserByEmail(String email) async {
    return await _dataSource.getUserById(email);
  }

  @override
  Stream<AuthUser?> get authStateChanges {
    return _dataSource.authStateChanges;
  }
  @override
  Stream<AuthUser?> fetchActivity() {
    return _dataSource.fetchActivity();
  }

  @override
  Future<void> updateActivity(
    String uid, 
    String dateKey, {
    bool isMaxReached = false,
    String? oldestDateKey,
    int created = 0, 
    int quiz = 0, 
    int flashcard = 0,
  }) async {
    await _dataSource.updateActivity(
      uid, 
      dateKey, 
      isMaxReached: isMaxReached,
      oldestDateKey: oldestDateKey,
      created: created, 
      quiz: quiz, 
      flashcard: flashcard,
    );
  }
}

