import 'dart:async';

import 'package:adalem/features/notebooks/domain/notebook.dart';
import 'package:adalem/features/notebooks/domain/uc_createnotebook.dart';
import 'package:adalem/features/notebooks/domain/uc_getnotebooks.dart';
import 'package:adalem/features/notebooks/presentation/model_notebooks.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NotebookViewModel extends ChangeNotifier {
  StreamSubscription<List<Notebook>>? _subscription;
  final GetNotebooks _getNotebooks;
  final CreateNotebook _createNotebook;

  NotebookViewModel({
    required GetNotebooks getNotebooks,
    required CreateNotebook createNotebook,
  })  : _getNotebooks = getNotebooks,
        _createNotebook = createNotebook;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController courseController = TextEditingController();

  String _selectedImage = "yellow";
  String get selectedImage => _selectedImage;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isCreating = false;
  bool get isCreating => _isCreating;

  List<NotebookModel> _notebooks = [];
  List<NotebookModel> get notebooks => _notebooks;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isSuccess = false;
  bool get isSuccess => _isSuccess;

  void loadNotebooks() {
  _isLoading = true;
  notifyListeners();

  _subscription = _getNotebooks().listen(
    (notebooks) {
      _notebooks = notebooks.map(NotebookModel.fromEntity).toList();
      _isLoading = false;
      _errorMessage = null;
      notifyListeners();
    },
    onError: (e) {
        _errorMessage = 'Service unavailable. Please check your connection or try again later.';
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  void selectImage(String image) {
    _selectedImage = image;
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> handleCreate() async {
    final title = titleController.text.trim();
    final course = courseController.text.trim();

    if (title.isEmpty || course.isEmpty) {
      _errorMessage = 'Please fill in all fields.';
      notifyListeners();
      return;
    }

    _isCreating = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        _errorMessage = 'No user logged in.';
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
      _errorMessage = 'Failed to create notebook. Please try again.';
    } finally {
      _isCreating = false;
      notifyListeners();
    }
  }

  void resetCreate() {
    titleController.clear();
    courseController.clear();
    _selectedImage = 'default';
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

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}