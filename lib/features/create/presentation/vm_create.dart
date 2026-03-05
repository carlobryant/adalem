import 'package:adalem/features/auth/domain/uc_getuser.dart';
import 'package:adalem/features/notebooks/domain/uc_createnotebook.dart';
import 'package:flutter/material.dart';

class CreateViewModel extends ChangeNotifier {
  final CreateNotebook _createNotebook;
  final GetCurrentUser _getCurrentUser;

  CreateViewModel({
    required CreateNotebook createNotebook,
    required GetCurrentUser getCurrentUser,
  }) : _createNotebook = createNotebook, _getCurrentUser = getCurrentUser;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController courseController = TextEditingController();

  String _selectedImage = "yellow";
  String get selectedImage => _selectedImage;

  bool _isCreating = false;
  bool get isCreating => _isCreating;

  String? _createError;
  String? get createError => _createError;

  bool _isSuccess = false;
  bool get isSuccess => _isSuccess;

  void selectImage(String image) {
    _selectedImage = image;
    _createError = null;
    notifyListeners();
  }

  bool validateCreate() {
    final title = titleController.text.trim();
    final course = courseController.text.trim();

    if (title.isEmpty || course.isEmpty) {
      _createError = "Please Fill in All Fields.";
      notifyListeners();
      return false;
    }
    return true;
  }

  Future<void> handleCreate() async {
    if (!validateCreate()) return;

    _isCreating = true;
    _createError = null;
    notifyListeners();

    try {
      final currentUser = _getCurrentUser();
      
      if (currentUser == null) {
        _createError = "No User Authenticated.";
        return;
      }

      // await _createNotebook(
      //   owner: currentUser.uid,
      //   uid: [currentUser.uid],
      //   title: titleController.text.trim(),
      //   course: courseController.text.trim(),
      //   image: _selectedImage,
      //   path: '/',
      // );

      final params = CreateNotebookParams(
        owner: currentUser.uid,
        title: titleController.text.trim(),
        course: courseController.text.trim(),
        image: _selectedImage,
      );

      await _createNotebook(params);

      _isSuccess = true;
    } catch (e) {
      _createError = "Failed to Create, Please Try Again Later.";
      //print("$e");
    } finally {
      _isCreating = false;
      notifyListeners();
    }
  }

  void resetCreate() {
    titleController.clear();
    courseController.clear();
    _selectedImage =  "yellow";
    _isSuccess = false;
    _createError = null;
    notifyListeners();
  }

  void clearCreateError() {
    _createError = null;
    notifyListeners();
  }

  @override
  void dispose() {
    titleController.dispose();
    courseController.dispose();
    super.dispose();
  }
}