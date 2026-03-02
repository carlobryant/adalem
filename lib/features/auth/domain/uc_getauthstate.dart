import 'package:adalem/features/auth/domain/auth_repo.dart';
import 'package:adalem/features/auth/domain/auth_user.dart';

class GetAuthState {
  final AuthRepo _authRepo;

  GetAuthState(this._authRepo);

  Stream<AuthUser?> call() {
    return _authRepo.authStateChanges;
  }
}