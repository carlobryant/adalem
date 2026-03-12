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
  Stream<AuthUser?> get authStateChanges {
    return _dataSource.authStateChanges;
  }
}

