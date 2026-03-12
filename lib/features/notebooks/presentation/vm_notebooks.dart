import 'dart:async';

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


  // NOTEBOOK SORT & SEARCH
  String _searchQuery = "";
  String get searchQuery => _searchQuery;

  String? _streamError;
  String? get streamError => _streamError;

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

  // LOAD NOTEBOOKS
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void loadNotebooks() {
  _subscription?.cancel();
  _isLoading = true;
  notifyListeners();

    final currentUser = _getCurrentUser();

    if (currentUser == null) {
      _streamError = "User not logged in";
      _isLoading = false;
      notifyListeners();
      return;
    }

  _subscription = _getNotebooks(currentUser.uid).listen(
    (notebooks) {
      _notebooks = notebooks.map(NotebookModel.fromEntity).toList();
      _isLoading = false;
      _streamError = null;
      notifyListeners();
    },
    onError: (e) {
        _streamError = "Service Unavailable, Please Check Your Connection";
        _isLoading = false;
        notifyListeners();
      },
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

  // CLEARING NOTEBOOKS
  void clearStreamError() {
    _streamError = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
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
    _streamError = null;
    _errorMessage = null;
    _subscription?.cancel();
    notifyListeners();
  }
}