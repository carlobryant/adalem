import 'package:adalem/features/auth/domain/auth_repo.dart';
import 'package:adalem/features/auth/domain/auth_user.dart';

class FetchActivity {
  final AuthRepo _authRepo;
  
  FetchActivity(this._authRepo);
  
  Stream<AuthUser?> call() => _authRepo.fetchActivity();
}