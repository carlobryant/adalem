import 'package:adalem/features/auth/domain/auth_user.dart';
import 'package:adalem/features/auth/domain/auth_repo.dart';

class GetCurrentUser {
  final AuthRepo _authRepo;

  GetCurrentUser(this._authRepo);

  AuthUser? call() {
    return _authRepo.getCurrentUser();
  }
}