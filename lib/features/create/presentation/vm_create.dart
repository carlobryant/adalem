import 'dart:io';

import 'package:adalem/core/components/model_error.dart';
import 'package:adalem/features/auth/domain/uc_getuser.dart';
import 'package:adalem/features/create/data/repo_impl.dart';
import 'package:adalem/features/notebook_content/domain/uc_createnotebook.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class CreateViewModel extends ChangeNotifier {
  final CreateNotebook _createNotebook;
  final GetCurrentUser _getCurrentUser;

  CreateViewModel({
    required CreateNotebook createNotebook,
    required GetCurrentUser getCurrentUser,
  }) : _createNotebook = createNotebook,
    _getCurrentUser = getCurrentUser{
      titleController.addListener(notifyListeners);
    }


  final TextEditingController titleController = TextEditingController();
  final TextEditingController courseController = TextEditingController();

  String _selectedImage = "yellow";
  String get selectedImage => _selectedImage;

  bool _isCreating = false;
  bool get isCreating => _isCreating;

  ErrorModel? _error;
  ErrorModel? get error => _error;

  bool _isSuccess = false;
  bool get isSuccess => _isSuccess;

  void selectImage(String image) {
    _selectedImage = image;
    _error = null;
    notifyListeners();
  }
  
  Future<void> handleCreate(
    int currentCount, 
    bool isCreating, 
    List<PlatformFile> files,
  ) async {
    try {
      final title = titleController.text.trim();
      final course = courseController.text.trim();

      if (title.isEmpty || course.isEmpty) {
        _error = const ErrorModel(
          header: "Missing Details", 
          description: "Please fill in all fields.",
        );
        notifyListeners();
        return;
      }

      if (files.isEmpty) {
        _error = const ErrorModel(
          header: "No Files Uploaded", 
          description: "You can't create a notebook without notes!",
        );
        notifyListeners();
        return;
      }

      final currentUser = _getCurrentUser();
      if (currentUser == null) {
        _error = const ErrorModel(
          header: "Unexpected Error", 
          description: "No user is authenticated.",
        );
        notifyListeners();
        return;
      }

      if (currentCount >= 10) {
        _error = const ErrorModel(
          header: "Limit Reached!", 
          description: "Notebook creation is limited for now.",
        );
        notifyListeners();
        return; 
      }
      if (isCreating) {
        _error = const ErrorModel(
          header: "A Notebook is Processing", 
          description: "A notebook is still being created, check back later.",
        );
        notifyListeners();
        return; 
      }

      _isCreating = true;
      _error = null;
      notifyListeners();

      final fileData = await Future.wait(
        files.map((f) async {
          final bytes = await File(f.path!).readAsBytes();
          final mimeType = _mimeTypeFromExtension(f.extension ?? '');
          return (bytes: bytes, mimeType: mimeType);
        })
      );

      final params = CreateNotebookParams(
        owner: currentUser.uid,
        title: title,
        course: course,
        image: _selectedImage,
        files: fileData,
        description: "",
      );

      await _createNotebook(params);
      _isSuccess = true;
    } on AIException catch (e) {
      String errorHeader;
      switch (e) {
        case AIQuotaExceededException():
          errorHeader = "Daily Limit Reached";
        case AINetworkException():
          errorHeader = "Connection Failed";
        case AIInvalidResponseException():
          errorHeader = "Generation Failed";
        case AIUnknownException():
          errorHeader = "Unexpected AI Error";
      }
      _isSuccess = false;
      _error = ErrorModel(header: errorHeader, description: e.message);
    } catch (e) {
      _isSuccess = false;
      _error = const ErrorModel(
          header: "Failed to Create", 
          description: "An unexpected error occurred. Please try again later.",
        );
    } finally {
      _isCreating = false;
      notifyListeners();
    }
  }

  void resetCreate() {
    _isSuccess = false;
    _error = null;
    _selectedImage = "yellow";
    titleController.clear();
    courseController.clear();
    notifyListeners();
  }

  void clearCreateError() {
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    titleController.removeListener(notifyListeners);
    titleController.dispose();
    courseController.dispose();
    super.dispose();
  }
}

String _mimeTypeFromExtension(String ext) {
  switch (ext.toLowerCase()) {
    case 'jpg': case 'jpeg': return 'image/jpeg';
    case 'png':             return 'image/png';
    case 'pdf':             return 'application/pdf';
    case 'mp3':             return 'audio/mpeg';
    case 'mp4':             return 'video/mp4';
    case 'txt': case 'md':  return 'text/plain';
    case 'doc': case 'docx': return 'application/msword';
    case 'ppt': case 'pptx': return 'application/vnd.ms-powerpoint';
    default:                return 'application/octet-stream';
  }
}