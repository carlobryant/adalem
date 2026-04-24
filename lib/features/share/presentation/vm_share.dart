
import 'package:adalem/core/app_constraints.dart';
import 'package:adalem/core/components/model_error.dart';
import 'package:adalem/features/auth/domain/auth_user.dart';
import 'package:adalem/features/auth/domain/uc_getuser.dart';
import 'package:adalem/features/notebooks/domain/uc_getnotebooks.dart';
import 'package:adalem/features/notebooks/domain/uc_sharenotebooks.dart';
import 'package:adalem/features/notebooks/presentation/model_notebooks.dart';
import 'package:flutter/material.dart';

class ShareViewModel extends ChangeNotifier {
  final GetNotebookCount _getNotebookCount;
  final GetCurrentUser _getCurrentUser;
  final GetUserProfile _getUserProfile;
  final ShareNotebooks _shareNotebooks;

  ShareViewModel({
    required GetNotebookCount getNotebookCount,
    required GetCurrentUser getCurrentUser,
    required GetUserProfile getUserProfile,
    required ShareNotebooks shareNotebooks,
  }) :  _getNotebookCount = getNotebookCount,
        _getCurrentUser = getCurrentUser,
        _getUserProfile = getUserProfile,
        _shareNotebooks = shareNotebooks;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  ErrorModel? _error;
  ErrorModel? get error => _error;

  String? _success;
  String? get success => _success;

  AuthUser? _foundUser;
  AuthUser? get foundUser => _foundUser;

  final List<AuthUser> _recipients = [];
  List<AuthUser> get recipients => List.unmodifiable(_recipients);

  // FETCH USERS TO SHARE
  Future<AuthUser?> searchUserByEmail(String email, int share) async {
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
        if(await _getNotebookCount(searchedUser.uid) + share > Constraint.maxCreate) {
          _error = ErrorModel(
            header: "Limit Reached for ${searchedUser.name}",
            description: "Ask ${searchedUser.name} to delete notebooks, or remove from your selection."
          );
        } else {
          _foundUser = searchedUser;
          if (!_recipients.any((u) => u.uid == searchedUser.uid)) {
            _recipients.add(searchedUser);
            _success = "Added ${searchedUser.name}"; 
            _foundUser = null;
          } else {
            _error = ErrorModel(
              header: "Already Added",
              description: "${searchedUser.name} is already included.",
            );
          }
        }
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

  Future<bool> validateRecipients(int share) async {
    if(recipients.isEmpty) return true;
    
    for(final recipient in _recipients) {
      final count = await _getNotebookCount(recipient.uid);
      if (count + share > Constraint.maxCreate) {
        _error = ErrorModel(
          header: "Limit Reached for ${recipient.name}",
          description: "Ask ${recipient.name} to delete notebooks, or remove them from your selection.",
        );
        notifyListeners();
        return false;
      }
    }
    return true;
  }

  // SHARE
  bool _isShared = false;
  bool get isShared => _isShared;

  bool _isSharing = false;
  bool get isSharing => _isSharing;

  Future<void> shareNotebooks(List<NotebookModel> notebooks) async {
    if (_recipients.isEmpty || notebooks.isEmpty) return;

    _isSharing = true;
    notifyListeners();

    for (final recipient in _recipients) {
      for (final notebook in notebooks) {
        if (notebook.users.containsKey(recipient.uid)) {
          _error = ErrorModel(
            header: "Already Shared to ${recipient.name}",
            description: "${notebook.title} was shared to ${recipient.name}.",
          );
          _isSharing = false;
          notifyListeners();
          return;
        }
      }

      final count = await _getNotebookCount(recipient.uid);
      if (count + notebooks.length > Constraint.maxCreate) {
        _error = ErrorModel(
          header: "Limit Reached for ${recipient.name}",
          description: "Ask ${recipient.name} to delete notebooks, or remove them from your selection.",
        );
        _isSharing = false;
        notifyListeners();
        return;
      }
    }

    try {
      await _shareNotebooks(
        notebookIds: notebooks.map((n) => n.id).toList(),
        targetUserIds: _recipients.map((u) => u.uid).toList(),
      );
      _recipients.clear();
      _isShared = true;
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

  void returnToShare() {
    _isShared = false;
    notifyListeners();
  }

  void clearSuccess() {
    _success = null;
  }

  void clearError() {
    _error = null;
  }
}