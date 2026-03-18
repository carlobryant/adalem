import 'package:adalem/core/components/model_error.dart';
import 'package:adalem/features/notebook_content/domain/content_entity.dart';
import 'package:adalem/features/notebook_content/domain/uc_getcontent.dart';
import 'package:adalem/features/notebook_content/presentation/model_content.dart';
import 'package:adalem/features/notebook_content/presentation/model_quizitem.dart';
import 'package:flutter/material.dart';

//enum ContentStatus { idle, active, complete, caughtUp, syncError, error }
enum ContentType { chapters, flashcards, quiz }

class ContentViewModel extends ChangeNotifier {
  final GetContent _getContent;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  NotebookContent? _content;
  NotebookContent? get content => _content;

  ErrorModel? _error;
  ErrorModel? get error => _error;

  List<ChapterModel> _chapterModels = [];
  List<ChapterModel> get chapterModels => _chapterModels;

  List<QuizItemModel> _quizItemModels = [];
  List<QuizItemModel> get quizItemModels => _quizItemModels;

  List<QuizItemModel> _identificationModels = [];
  List<QuizItemModel> get identificationModels => _identificationModels;

  List<ScenarioModel> _scenarioModels = [];
  List<ScenarioModel> get scenarioModels => _scenarioModels;

  ContentViewModel({required GetContent getContent}) : _getContent = getContent;

  Future<void> loadNotebookContent(String notebookId, {Set<ContentType> load = const {ContentType.chapters}}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final content = await _getContent(notebookId);

      if (content != null) {
        _content = content; 
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
                ))
            .toList();
        _identificationModels = content.items
            .map((item) => QuizItemModel(
                  quizItem: item,
                  mode: QuizMode.identification,
                ))
            .toList();
        _scenarioModels = content.scenarios
            .map((scenario) => ScenarioModel(scenario: scenario))
            .toList();
      }
      
      } else {
        _error = const ErrorModel(
          header: "No Content",
          description: "Notebook content not found.",
        );
      }
    } catch (e) {
      _error = ErrorModel(
          header: "Failed to Load Content",
          description: e.toString(),
        );
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