import 'package:adalem/features/auth/domain/auth_user.dart';
import 'package:adalem/features/auth/domain/uc_getuser.dart';
import 'package:adalem/features/auth/domain/uc_signout.dart';
import 'package:flutter/material.dart';

class ProfileViewModel extends ChangeNotifier {
  final SignOut _signOut;
  final GetCurrentUser _getCurrentUser;

  ProfileViewModel({
    required SignOut signOut,
    required GetCurrentUser getCurrentUser,
  })  : _signOut = signOut,
        _getCurrentUser = getCurrentUser;

  AuthUser? _user;
  AuthUser? get user => _user;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void init() {
    _user = _getCurrentUser();
  }

  Future<void> handleSignOut() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _signOut();
    } catch (e) {
      _errorMessage = 'Failed to sign out. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}