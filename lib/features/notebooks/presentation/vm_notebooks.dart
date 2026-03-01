import 'dart:async';

import 'package:adalem/features/auth/domain/uc_getuser.dart';
import 'package:adalem/features/notebooks/domain/notebook.dart';
import 'package:adalem/features/notebooks/domain/uc_createnotebook.dart';
import 'package:adalem/features/notebooks/domain/uc_getnotebooks.dart';
import 'package:adalem/features/notebooks/presentation/model_notebooks.dart';
import 'package:flutter/material.dart';

enum SortOption {latest, oldest, alphabetical}

class NotebookViewModel extends ChangeNotifier {
  StreamSubscription<List<Notebook>>? _subscription;
  final GetNotebooks _getNotebooks;
  final CreateNotebook _createNotebook;
  final GetCurrentUser _getCurrentUser;

  NotebookViewModel({
    required GetNotebooks getNotebooks,
    required CreateNotebook createNotebook,
    required GetCurrentUser getCurrentUser,
  })  : _getNotebooks = getNotebooks,
        _createNotebook = createNotebook,
        _getCurrentUser = getCurrentUser;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController courseController = TextEditingController();

  // CREATE VARIABLES
  bool _isCreating = false;
  bool get isCreating => _isCreating;

  bool _isSuccess = false;
  bool get isSuccess => _isSuccess;

  String? _createError;
  String? get createError => _createError;

  String _selectedImage = "yellow";
  String get selectedImage => _selectedImage;

  // RETRIEVE VARIABLES
  String? _streamError;
  String? get streamError => _streamError;

  String _searchQuery = "";
  String get searchQuery => _searchQuery;

  SortOption _currentSort = SortOption.latest;
  SortOption get currentSort => _currentSort;

  void setSortOption(SortOption option) async {
    _isLoading = true;
    _currentSort = option;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 550));
    _isLoading = false;
    notifyListeners();
  }

  List<NotebookModel> _notebooks = [];
  //List<NotebookModel> get notebooks => _notebooks;
  
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


  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  DateTime? _lastValidationError;

  void loadNotebooks() {
  _isLoading = true;
  notifyListeners();

  _subscription = _getNotebooks().listen(
    (notebooks) {
      _notebooks = notebooks.map(NotebookModel.fromEntity).toList();
      _isLoading = false;
      _streamError = null;
      notifyListeners();
    },
    onError: (e) {
        _streamError = 'Service unavailable. Please check your connection or try again later.';
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void selectImage(String image) {
    _selectedImage = image;
    _errorMessage = null;
    notifyListeners();
  }

  bool validateCreate() {
    final title = titleController.text.trim();
    final course = courseController.text.trim();

    if (title.isEmpty || course.isEmpty) {
      final now = DateTime.now();
      if (_lastValidationError == null ||
          now.difference(_lastValidationError!) > const Duration(seconds: 6)) {
        _lastValidationError = now;
        _createError = "Please Fill In All Fields.";
        notifyListeners();
      }
      return false;
    }
    return true;
  }

  Future<void> handleCreate() async {
    _isCreating = true;
    notifyListeners();

    final title = titleController.text.trim();
    final course = courseController.text.trim();
    
    _lastValidationError = null;
    _createError = null;
    notifyListeners();

    try {
      final currentUser = _getCurrentUser();
      if(currentUser == null) {
        _errorMessage = "Authentication Error.";
        return;
      }

      await _createNotebook(
        owner: currentUser.uid,
        uid: [currentUser.uid],
        title: title,
        course: course,
        image: _selectedImage,
        path: '/',
      );

      _isSuccess = true;
      loadNotebooks(); // REFRESH AFTER CREATION
    } catch (e) {
      _createError = 'Failed to create notebook. Please try again.';
    } finally {
      _isCreating = false;
      notifyListeners();
    }
  }

  void resetCreate() {
    titleController.clear();
    courseController.clear();
    _selectedImage = "yellow";
    _isSuccess = false;
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    titleController.dispose();
    courseController.dispose();
    super.dispose();
  }

  void clearCreateError() {
    _createError = null;
    notifyListeners();
  }

  void clearStreamError() {
    _streamError = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}