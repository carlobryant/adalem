import 'package:adalem/features/auth/domain/auth_user.dart';
import 'package:adalem/features/auth/domain/auth_repo.dart';

class SignInWithGoogle {
  final AuthRepo _authRepo;

  SignInWithGoogle(this._authRepo);

  Future<AuthUser?> call() async {
    return await _authRepo.signInWithGoogle();
  }
}