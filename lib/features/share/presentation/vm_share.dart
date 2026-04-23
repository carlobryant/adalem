
import 'package:adalem/core/components/model_error.dart';
import 'package:adalem/features/auth/domain/auth_user.dart';
import 'package:adalem/features/auth/domain/uc_getuser.dart';
import 'package:adalem/features/notebooks/domain/uc_sharenotebooks.dart';
import 'package:flutter/material.dart';

class ShareViewModel extends ChangeNotifier {
  final GetCurrentUser _getCurrentUser;
  final GetUserProfile _getUserProfile;
  final ShareNotebooks _shareNotebooks;

  ShareViewModel({
    required GetCurrentUser getCurrentUser,
    required GetUserProfile getUserProfile,
    required ShareNotebooks shareNotebooks,
  }) :  _getCurrentUser = getCurrentUser,
        _getUserProfile = getUserProfile,
        _shareNotebooks = shareNotebooks;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  ErrorModel? _error;
  ErrorModel? get error => _error;

  AuthUser? _foundUser;
  AuthUser? get foundUser => _foundUser;

  final List<AuthUser> _recipients = [];
  List<AuthUser> get recipients => List.unmodifiable(_recipients);

  // FETCH USERS TO SHARE
  Future<AuthUser?> searchUserByEmail(String email) async {
    final currentUserEmail = _getCurrentUser()?.email;
    if (email.trim().isEmpty) return null;
    if (email.trim() == currentUserEmail) {
      _error = const ErrorModel(
        header: "Invalid Email", 
        description: "You cannot share a notebook with yourself."
      );
      notifyListeners();
      return null;
    }

    _error = null;
    _isLoading = true;
    notifyListeners();

    try {
      final searchedUser = await _getUserProfile.call(email: email.trim());
      
      if (searchedUser == null) {
        _foundUser = null;
        _error = const ErrorModel(
          header: "User Not Found",
          description: "No account exists with that email address.",
        );
      } else {
        _foundUser = searchedUser;
        addRecipient();
      }
      return searchedUser; 
      
    } catch (e) {
      _error = ErrorModel(
        header: "Search Failed",
        description: e.toString(),
      );
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void addRecipient() {
    if (_foundUser == null) return;
    if (_recipients.any((u) => u.uid == _foundUser!.uid)) return;
    _recipients.add(_foundUser!);
    _foundUser = null;
    notifyListeners();
  }

  void removeRecipient(String uid) {
    _recipients.removeWhere((u) => u.uid == uid);
    notifyListeners();
  }

  // SHARE
  bool _isSharing = false;
  bool get isSharing => _isSharing;

  Future<void> shareNotebooks(List<String> notebookIds) async {
    if (_recipients.isEmpty || notebookIds.isEmpty) return;

    _isSharing = true;
    notifyListeners();

    try {
      await _shareNotebooks(
        notebookIds: notebookIds,
        targetUserIds: _recipients.map((u) => u.uid).toList(),
      );
      _recipients.clear();
      _foundUser = null;
      _error = null;
    } catch (e) {
      _error = ErrorModel(
        header: "Share Failed",
        description: e.toString(),
      );
    } finally {
      _isSharing = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
  }
}