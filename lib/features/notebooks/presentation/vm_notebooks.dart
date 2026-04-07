import 'dart:async';

import 'package:adalem/core/components/model_error.dart';
import 'package:adalem/features/auth/domain/auth_user.dart';
import 'package:adalem/features/auth/domain/uc_getuser.dart';
import 'package:adalem/features/notebooks/domain/notebook_entity.dart';
import 'package:adalem/features/notebooks/domain/uc_getnotebooks.dart';
import 'package:adalem/features/notebooks/presentation/model_notebooks.dart';
import 'package:flutter/material.dart';

enum SortOption {latest, oldest, alphabetical}

class NotebookViewModel extends ChangeNotifier {
  StreamSubscription<List<Notebook>>? _subscription;
  final GetNotebooks _getNotebooks;
  final GetCurrentUser _getCurrentUser;
  final GetUserProfile _getUserProfile;

  NotebookViewModel({
    required GetNotebooks getNotebooks,
    required GetCurrentUser getCurrentUser,
    required GetUserProfile getUserProfile,
  })  : _getNotebooks = getNotebooks,
        _getCurrentUser = getCurrentUser,
        _getUserProfile = getUserProfile;

  String get currentUserId => _getCurrentUser()?.uid ?? "";

  // NOTEBOOK SORT & SEARCH
  String _searchQuery = "";
  String get searchQuery => _searchQuery;

  ErrorModel? _error;
  ErrorModel? get error => _error;

  SortOption _currentSort = SortOption.latest;
  SortOption get currentSort => _currentSort;

    void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSortOption(SortOption option) async {
    _isLoading = true;
    _currentSort = option;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 550));
    _isLoading = false;
    notifyListeners();
  }

  // LIST NOTEBOOKS
  List<NotebookModel> _notebooks = [];
  List<NotebookModel> get filteredNotebooks {
    var list = List<NotebookModel>.from(_notebooks);
    
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      list = _notebooks.where((notebook) {
        return notebook.title.toLowerCase().contains(query) ||
        notebook.course.toLowerCase().contains(query);
      }).toList();
    }

    switch (_currentSort) {
      case SortOption.latest: list.sort((b, a) => a.updatedAt.compareTo(b.updatedAt));
      break;
      case SortOption.oldest: list.sort((a, b) => a.updatedAt.compareTo(b.updatedAt));
      break;
      case SortOption.alphabetical: list.sort((a, b) => a.title.toLowerCase()
        .compareTo(b.title.toLowerCase()));
      break;
    }
    return list;
  }

  List<NotebookModel> get rankedNotebooks {
    final uid = _getCurrentUser()?.uid;
    final readyNotebooks = _notebooks.where((n) => n.available == "ready").toList();
    if (uid == null) return readyNotebooks;

    readyNotebooks.sort((a, b) {
      final masteryA = a.users[uid]?.mastery ?? 0;
      final masteryB = b.users[uid]?.mastery ?? 0;
      return masteryB.compareTo(masteryA); 
    });
    return readyNotebooks;
  }

  List<NotebookModel> get toDoNotebooks {
    final uid = _getCurrentUser()?.uid;
    final readyNotebooks = _notebooks.where((n) => n.available == "ready" 
    && (flashcardAvailable(n.id) || _isNotToday(n.users[uid]!.quizSession))).toList();
    if (uid == null) return readyNotebooks;

    readyNotebooks.sort((a, b) {
      final sessionA = a.users[uid]?.flashcardSession;
      final sessionB = b.users[uid]?.flashcardSession;

      // IGNORE IF BOTH ARE NULL
      if (sessionA == null && sessionB == null) return 0;
      
      // IF A VALUE IS NULL
      if (sessionA == null) return -1;
      if (sessionB == null) return 1;

      return sessionA.compareTo(sessionB);
    });
    
    return readyNotebooks;
  }

  bool _isNotToday(DateTime? date) {
    if (date == null) return true;
    final now = DateTime.now();
    return !(date.year == now.year && date.month == now.month && date.day == now.day);
  }

  // LOAD NOTEBOOKS
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _backendLoding = false;
  bool get backendLoading => _backendLoding;

  void loadNotebooks() {
  _subscription?.cancel();
  _isLoading = true;
  notifyListeners();

    final currentUser = _getCurrentUser();

    if (currentUser == null) {
      _error = const ErrorModel(
        header: "No User Found", 
        description: "Unexpected error, no user signed in."
      );
      _backendLoding = false;
      _isLoading = false;
      notifyListeners();
      return;
    }

  _subscription = _getNotebooks(currentUser.uid).listen(
    (notebooks) {
      _notebooks = notebooks.map(NotebookModel.fromEntity).toList();
      _isLoading = false;
      _backendLoding = false;
      _error = null;
      notifyListeners();
    },
    onError: (e) {
        _backendLoding = true;
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  // NOTEBOOK COUNT
  int get notebookCount => _notebooks.length;

  int get sharedNotebookCount => _notebooks.where(
    (n) => n.owner == _getCurrentUser()?.uid && n.users.length > 1
    ).length;

  int get receivedNotebookCount => _notebooks.where(
    (n) => n.owner != _getCurrentUser()?.uid
  ).length;

   // FETCH AVAILABLE
  bool isNotebookCreating() => _notebooks.any((n) => n.available == "generating");

  // FETCH USER ENTITY
  NotebookUser getUserEntityFor(String notebookId, String uid) {
    final notebook = _notebooks.firstWhere(
      (n) => n.id == notebookId,
      orElse: () => NotebookModel.empty(),
    );

    final userModel = notebook.users[uid];
    final flashcards = getProgressFor(notebookId, uid);
    if (userModel == null) {
      return NotebookUser.empty();
    }
    return NotebookUser(
      mastery: userModel.mastery,
      streak: userModel.streak,
      quizSession: userModel.quizSession,
      flashcardSession: userModel.flashcardSession,
      lastDecayApplied: userModel.lastDecayApplied,
      flashcards: flashcards,
    );
  }
  
  // FETCH OWNER
  AuthUser? _ownerData;
  AuthUser? get ownerData => _ownerData;

  bool _isLoadingOwner = true;
  bool get isLoadingOwner => _isLoadingOwner;

  Future<void> fetchOwnerDetails(String ownerId) async {
    _isLoadingOwner = true;
    notifyListeners();

    _ownerData = await _getUserProfile(ownerId);

    _isLoadingOwner = false;
    notifyListeners();
  }

  // FETCH PROGRESS
  List<NotebookFlashcard> getProgressFor(String notebookId, String uid) {
    final notebook = _notebooks.firstWhere(
      (n) => n.id == notebookId,
      orElse: () => NotebookModel.empty(),
    );

    final userModel = notebook.users[uid];
    if (userModel == null) return [];

    return userModel.flashcards.map((model) => NotebookFlashcard(
      cardId: model.cardId,
      quality: model.quality,
      repetitions: model.repetitions,
      easeFactor: model.easeFactor,
      interval: model.interval,
      dueAt: model.dueAt,
    )).toList();
  }

  // FETCH MASTERY
  int getMasteryFor(String notebookId, String uid) {
    final notebook = _notebooks.firstWhere(
      (n) => n.id == notebookId,
      orElse: () => NotebookModel.empty(),
    );

    final userModel = notebook.users[uid];
    if (userModel == null) return 0;
    return userModel.mastery;
  }

  // FLASHCARD SESSION AVAILABILITY
  bool flashcardAvailable(String notebookId) {
    final uid = _getCurrentUser()?.uid;
    if (uid == null) return false;

    final progress = getProgressFor(notebookId, uid);
    
    if (progress.isEmpty) return true;

    final now = DateTime.now();
    return progress.where((card) {
      if (card.dueAt == null) return true;
      return !card.dueAt!.isAfter(now);
    }).length > 4;
  }
  
  // CLEARING NOTEBOOKS
  void clearError() {
    _error = null;
    notifyListeners();
  }
  
    @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void clearData() {
    _notebooks =[];
    _searchQuery = "";
    _error = null;
    _subscription?.cancel();
    notifyListeners();
  }
}