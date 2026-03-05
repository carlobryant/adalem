import 'package:adalem/features/notebook_content/domain/uc_getcontent.dart';
import 'package:adalem/features/notebook_content/presentation/model_content.dart';
import 'package:flutter/material.dart';

class ContentViewModel extends ChangeNotifier {
  final GetContent _getContent;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

List<ChapterModel> _chapterModels = [];
List<ChapterModel> get chapterModels => _chapterModels;

  ContentViewModel({required GetContent getContent}) : _getContent = getContent;

  Future<void> loadNotebookContent(String notebookId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final content = await _getContent(notebookId);

      if (content != null) {
        _chapterModels = content.chapters
            .map((chapter) => ChapterModel(chapter: chapter))
            .toList();
      } else {
        _errorMessage = "Notebook content not found.";
      }
    } catch (e) {
      _errorMessage = "Failed to load content: ${e.toString()}";
    } finally {
      _isLoading = false;
      notifyListeners(); 
    }
  }
}