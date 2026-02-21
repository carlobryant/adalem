import 'package:adalem/features/auth/domain/uc_googlesignin.dart';
import 'package:adalem/features/auth/presentation/model_login.dart';
import 'package:flutter/foundation.dart';

class LoginViewModel extends ChangeNotifier {
  final SignInWithGoogle _signInWithGoogle;

  LoginViewModel({required SignInWithGoogle signInWithGoogle})
      : _signInWithGoogle = signInWithGoogle;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  AuthResult? _result;
  AuthResult? get result => _result;

  Future<void> handleGoogleSignIn() async {
    _isLoading = true;
    _result = null;
    notifyListeners();

    try {
      final user = await _signInWithGoogle();

      if (user != null) {
        _result = AuthResult.success(user);
      } else {
        _result = AuthResult.cancelled();
        _isLoading = false;
      }
    } catch (e) {
      _result = AuthResult.failure(e.toString());
      _isLoading = false;
    } finally {
      notifyListeners();
    }
  }
}