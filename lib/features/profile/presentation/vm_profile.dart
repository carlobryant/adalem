import 'dart:async';
import 'package:adalem/core/app_constraints.dart';
import 'package:adalem/core/components/model_error.dart';
import 'package:adalem/features/auth/domain/auth_user.dart';
import 'package:adalem/features/auth/domain/uc_getuser.dart';
import 'package:adalem/features/auth/domain/uc_signout.dart';
import 'package:adalem/features/home/domain/uc_getupdates.dart';
import 'package:adalem/features/home/domain/updates_entity.dart';
import 'package:adalem/features/profile/domain/uc_fetchactivity.dart';
import 'package:adalem/features/profile/domain/uc_updateactivity.dart';
import 'package:flutter/material.dart';

class ProfileViewModel extends ChangeNotifier {
  final SignOut _signOut;
  final GetCurrentUser _getCurrentUser;
  final FetchActivity _fetchActivity;
  final UpdateActivity _updateActivity;
  final GetUpdates _getUpdates;

  StreamSubscription<AuthUser?>? _activitySubscription;
  StreamSubscription<Updates>? _updatesSubscription;

  ProfileViewModel({
    required SignOut signOut,
    required GetCurrentUser getCurrentUser,
    required FetchActivity fetchActivity,
    required UpdateActivity updateActivity,
    required GetUpdates getUpdates,
  })  : _signOut = signOut,
        _getCurrentUser = getCurrentUser,
        _fetchActivity = fetchActivity,
        _updateActivity = updateActivity,
        _getUpdates = getUpdates;

  AuthUser? _user;
  AuthUser? get user => _user;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  ErrorModel? _error;
  ErrorModel? get error => _error;

  void init() {
    _activitySubscription?.cancel(); 
    _user = _getCurrentUser();
    fetchUpdates();
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

  // USER UPDATES
  Updates? _updates;
  List<Update> get updates => (_updates?.updates ?? [])
    ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  void fetchUpdates() {
    if (_user?.email == null) return;

    _updatesSubscription?.cancel();
    _updatesSubscription = _getUpdates.call(email: _user!.email).listen(
      (updates) {
        _updates = updates;
        notifyListeners();
      },
      onError: (error) {
        _error = ErrorModel(
          header: "Failed to Load Updates",
          description: error.toString(),
        );
        notifyListeners();
      },
    );
  }

  // ACTIVITY HEATMAP DATA
  Map<DateTime, ({int total, String summary})> get detailedActivityMap {
    final activityMap = _user?.activity;
    if (activityMap == null) return {};

    final Map<DateTime, ({int total, String summary})> dataset = {};
    activityMap.forEach((dateString, stats) {
      try {
        final parts = dateString.split('-');
        if (parts.length != 3) return; 
        
        final DateTime date = DateTime(
          int.parse(parts[0]), 
          int.parse(parts[1]), 
          int.parse(parts[2]),
        );

        final int totalDailyActivity = stats.created + stats.quiz + stats.flashcard;
        if (totalDailyActivity > 0) {
          final List<String> summaryParts = [];
          if (stats.flashcard > 0) {
            summaryParts.add("${stats.flashcard} Flashcard${stats.flashcard > 1 ? 's' : ''}");
          }
          if (stats.quiz > 0) {
            summaryParts.add("${stats.quiz} Quiz${stats.quiz > 1 ? 'zes' : ''}");
          }
          if (stats.created > 0) {
            summaryParts.add("${stats.created} Created");
          }

          final String summaryString = summaryParts.join(', ');
          dataset[date] = (total: totalDailyActivity, summary: summaryString);
        }
      } catch (e) {
        _error = const ErrorModel(header: "Unexpected Error", description: "Data was not saved to profile.");
      }
    });
    
    return dataset;
  }
  
  Map<DateTime, int> get heatmapData {
    return detailedActivityMap.map((date, record) => MapEntry(date, record.total));
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
      _updateActivity.call(
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

  // CREATE DAILY LIMIT
  bool isLimitReached() => (
    _user?.activity[
      DateTime.now().toIso8601String().split('T').first
    ]?.created ?? 0
  ) >= Constraint.maxDailyCr;

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
    _updatesSubscription?.cancel();
    super.dispose();
  }
}