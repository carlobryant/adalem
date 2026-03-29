import 'package:adalem/features/notebook_content/domain/uc_deletenotebook.dart';
import 'package:flutter/material.dart';

class DeleteViewModel extends ChangeNotifier {
  final DeleteNotebook _deleteNotebook;

  DeleteViewModel({
    required DeleteNotebook deleteNotebook,
  }) : _deleteNotebook = deleteNotebook;

  bool _isDeleting = false;
  bool get isDeleting => _isDeleting;

  List<String>? _deleteError;
  List<String>? get deleteError => _deleteError;

  Future<void> confirmDelete({
    required String notebookId,
    required String contentId,
    required String userId,
    required BuildContext context,
  }) async {
    _isDeleting = true;
    notifyListeners();

    try {
      await _deleteNotebook(
        notebookId: notebookId,
        contentId: contentId,
        userId: userId,
      );

      if (context.mounted) {
         Navigator.pop(context); 
      }
    } catch (e) {
      _deleteError = ["Failed to Delete", "Please try again later."];
      _isDeleting = false;
      notifyListeners();
    } 
  }

  void clearDeleteError() {
    _deleteError = null;
    notifyListeners();
  }
}