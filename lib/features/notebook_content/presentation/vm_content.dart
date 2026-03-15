import 'package:adalem/features/notebook_content/domain/uc_getcontent.dart';
import 'package:adalem/features/notebook_content/presentation/model_content.dart';
import 'package:adalem/features/flashcards/presentation/model_quiz.dart';
import 'package:flutter/material.dart';

enum ContentType { chapters, flashcards, quiz }

class ContentViewModel extends ChangeNotifier {
  final GetContent _getContent;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<ChapterModel> _chapterModels = [];
  List<ChapterModel> get chapterModels => _chapterModels;

  List<QuizItemModel> _quizItemModels = [];
  List<QuizItemModel> get quizItemModels => _quizItemModels;

  List<ScenarioModel> _scenarioModels = [];
  List<ScenarioModel> get scenarioModels => _scenarioModels;

  ContentViewModel({required GetContent getContent}) : _getContent = getContent;

  Future<void> loadNotebookContent(String notebookId, {Set<ContentType> load = const {ContentType.chapters}}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final content = await _getContent(notebookId);

      if (content != null) {

        if (load.contains(ContentType.chapters)) {
        _chapterModels = content.chapters
            .map((chapter) => ChapterModel(chapter: chapter))
            .toList();
        await Future.delayed(Duration(milliseconds: 150));
      }

      if (load.contains(ContentType.flashcards)) {
        _quizItemModels = content.items
            .map((item) => QuizItemModel(
                  quizItem: item,
                  mode: QuizMode.flashcard,
                ))
            .toList();
      }

      if (load.contains(ContentType.quiz)) {
        _quizItemModels = content.items
            .map((item) => QuizItemModel(
                  quizItem: item,
                  mode: QuizMode.multipleChoice,
                  //mode: QuizMode.identification,
                ))
            .toList();
        _scenarioModels = content.scenarios
            .map((scenario) => ScenarioModel(scenario: scenario))
            .toList();
      }
      
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

  void updateQuizItem(int index, QuizItemModel updated) {
    _quizItemModels[index] = updated;
    notifyListeners();
  }
}