import 'package:adalem/features/auth/domain/auth_repo.dart';

class SignOut {
  final AuthRepo _authRepo;

  SignOut(this._authRepo);

  Future<void> call() async {
    await _authRepo.signOut();
  }
}