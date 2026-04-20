import 'package:adalem/features/auth/domain/auth_user.dart';
import 'package:adalem/features/auth/domain/auth_repo.dart';

class GetCurrentUser {
  final AuthRepo _authRepo;
  GetCurrentUser(this._authRepo);
  AuthUser? call() => _authRepo.getCurrentUser();
}

class GetUserProfile {
  final AuthRepo _authRepo;
  GetUserProfile(this._authRepo);
  Future<AuthUser?> call({String uid = "", String email = ""}) =>
    uid.isNotEmpty ? _authRepo.getUserById(uid) : _authRepo.getUserByEmail(email);
}