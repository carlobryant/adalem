import 'package:adalem/features/auth/domain/uc_getuser.dart';
import 'package:adalem/features/notebook_content/domain/uc_createnotebook.dart';
import 'package:adalem/features/notebooks/domain/uc_getnotebookcount.dart';
import 'package:flutter/material.dart';

class CreateViewModel extends ChangeNotifier {
  final CreateNotebook _createNotebook;
  final GetCurrentUser _getCurrentUser;
  final GetNotebookCount _getNotebookCount;

  CreateViewModel({
    required CreateNotebook createNotebook,
    required GetCurrentUser getCurrentUser,
    required GetNotebookCount getNotebookCount,
  }) :  _createNotebook = createNotebook,
        _getCurrentUser = getCurrentUser,
        _getNotebookCount = getNotebookCount;


  final TextEditingController titleController = TextEditingController();
  final TextEditingController courseController = TextEditingController();

  String _selectedImage = "yellow";
  String get selectedImage => _selectedImage;

  bool _isCreating = false;
  bool get isCreating => _isCreating;

  List<String>? _createError;
  List<String>? get createError => _createError;

  bool _isSuccess = false;
  bool get isSuccess => _isSuccess;

  void selectImage(String image) {
    _selectedImage = image;
    _createError = null;
    notifyListeners();
  }
  
  Future<void> handleCreate() async {
    try {
      final title = titleController.text.trim();
      final course = courseController.text.trim();

      if (title.isEmpty || course.isEmpty) {
        _createError = ["Missing Details", "Please fill in all fields."];
        notifyListeners();
        return;
      }

      final currentUser = _getCurrentUser();
      if (currentUser == null) {
        _createError = ["Unexpected Error", "No user is authenticated."];
        notifyListeners();
        return;
      }

      final currentCount = await _getNotebookCount(currentUser.uid);
      if (currentCount >= 10) {
        _createError =  ["Limit Reached!", "Notebook creation is limited for now."];
        notifyListeners();
        return; 
      }

      _isCreating = true;
      _createError = null;
      notifyListeners();

      final params = CreateNotebookParams(
        owner: currentUser.uid,
        title: titleController.text.trim(),
        course: courseController.text.trim(),
        image: _selectedImage,
      );

      await _createNotebook(params);

      _isSuccess = true;
    } catch (e) {
      _createError = ["Failed to Create", "Please try again later."];
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