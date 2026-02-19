import 'package:adalem/features/notebooks/domain/uc_createnotebook.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CreateViewModel extends ChangeNotifier {
  final CreateNotebook _createNotebook;

  CreateViewModel({required CreateNotebook createNotebook})
      : _createNotebook = createNotebook;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController courseController = TextEditingController();

  String _selectedImage = "yellow"; 
  String get selectedImage => _selectedImage;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isSuccess = false;
  bool get isSuccess => _isSuccess;

  void selectImage(String image) {
    _selectedImage = image;
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

    _isLoading = true;
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
    } catch (e) {
      _errorMessage = 'Failed to create notebook. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void reset() {
    titleController.clear();
    courseController.clear();
    _selectedImage = 'default';
    _isSuccess = false;
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    titleController.dispose();
    courseController.dispose();
    super.dispose();
  }
}