import 'dart:async';
import 'package:adalem/core/app_constraints.dart';
import 'package:adalem/core/components/model_error.dart';
import 'package:adalem/features/auth/domain/auth_user.dart';
import 'package:adalem/features/auth/domain/uc_getuser.dart';
import 'package:adalem/features/auth/domain/uc_signout.dart';
import 'package:adalem/features/profile/domain/uc_fetchactivity.dart';
import 'package:adalem/features/profile/domain/uc_updateactivity.dart';
import 'package:flutter/material.dart';

class ProfileViewModel extends ChangeNotifier {
  final SignOut _signOut;
  final GetCurrentUser _getCurrentUser;
  final FetchActivity _fetchActivity;
  final UpdateActivity _updateActivity;

  StreamSubscription<AuthUser?>? _activitySubscription;

  ProfileViewModel({
    required SignOut signOut,
    required GetCurrentUser getCurrentUser,
    required FetchActivity fetchActivity,
    required UpdateActivity updateActivity,
  })  : _signOut = signOut,
        _getCurrentUser = getCurrentUser,
        _fetchActivity = fetchActivity,
        _updateActivity = updateActivity;

  AuthUser? _user;
  AuthUser? get user => _user;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  ErrorModel? _error;
  ErrorModel? get error => _error;

  void init() {
    _activitySubscription?.cancel(); 
    _user = _getCurrentUser();
    Future.microtask(() {
      notifyListeners(); 
    });

    _activitySubscription = _fetchActivity.call().listen(
      (updatedUser) {
        _user = updatedUser; 
        notifyListeners();
      },
      onError: (error) {
        _error = ErrorModel(
          header: "Failed to Load Activity Data", 
          description: error.toString(),
        );
        notifyListeners();
      },
    );
  }

  Future<void> addActivityStat({
    int created = 0, 
    int quiz = 0, 
    int flashcard = 0,
  }) async {
    if (_user == null) return;
    _error = null;
    notifyListeners();

    try {
      final String todayKey = DateTime.now().toIso8601String().split('T').first;
      final Map<String, dynamic> activityMap = _user!.activity; 
      
      bool isMaxReached = false;
      String? oldestDateKey;
      if (!activityMap.containsKey(todayKey) && activityMap.length >= Constraint.maxActivity) {
        isMaxReached = true;
        final sortedKeys = activityMap.keys.toList()..sort();
        oldestDateKey = sortedKeys.first;
      }
      await _updateActivity.call(
        _user!.uid, 
        todayKey,
        isMaxReached: isMaxReached,
        oldestDateKey: oldestDateKey,
        created: created, 
        quiz: quiz, 
        flashcard: flashcard,
      );
    } catch (e) {
      _error = ErrorModel(
          header: "Failed to Update User Progress", 
          description: e.toString(),
      );
      notifyListeners();
    }
  }

  Future<void> handleSignOut() async {
    _error = null;
    _isLoading = true;
    notifyListeners();

    try {
      await _signOut();
      _user = null;
      _activitySubscription?.cancel();
    } catch (e) {
      _error = ErrorModel(
          header: "Failed to Sign Out", 
          description: e.toString(),
        );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _activitySubscription?.cancel();
    super.dispose();
  }
}