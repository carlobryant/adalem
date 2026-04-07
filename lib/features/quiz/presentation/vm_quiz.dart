import 'package:adalem/core/components/model_error.dart';
import 'package:adalem/features/notebook_content/domain/content_entity.dart';
import 'package:adalem/features/notebook_content/presentation/model_quizitem.dart';
import 'package:adalem/features/notebooks/domain/notebook_entity.dart';
import 'package:adalem/features/quiz/domain/quiz_algo.dart';
import 'package:adalem/features/quiz/domain/uc_syncquiz.dart';
import 'package:flutter/foundation.dart';

enum QuizSessionStatus { idle, active, complete, syncError, error }

class QuizViewModel extends ChangeNotifier {
  final SyncQuizHistory _syncQuizHistory;
  NotebookUser? _currentUser;

  StaircaseAlgorithm? _algorithm;

  dynamic _currentQuestion;
  dynamic get currentQuestion => _currentQuestion;

  QuizItemModel? _currentQuizItemModel;
  QuizItemModel? get currentQuizItemModel => _currentQuizItemModel;

  ScenarioModel? _currentScenarioModel;
  ScenarioModel? get currentScenarioModel => _currentScenarioModel;

  bool get isScenario => _currentQuestion is Scenario;

  QuizSessionStatus _status = QuizSessionStatus.idle;
  QuizSessionStatus get status => _status;

  int _prevMastery = 0;
  int get prevMastery => _prevMastery;

  ErrorModel? _error;
  ErrorModel? get error => _error;

  bool _isProcessing = false;
  bool get isProcessing => _isProcessing;

  int get itemsServed => _algorithm?.itemsServedThisSession ?? 0;
  int get sessionScore => _algorithm?.sessionScore ?? 0; 
  double get sessionAccuracy => _algorithm?.sessionAccuracy ?? 0.0; 
  double get sessionAveDifficulty => _algorithm?.sessionAveDifficulty ?? 1.0; 
  Map<String, dynamic> get diagnostics => _algorithm?.diagnostics ?? {};

  String get difficultyLabel {
    final diff = sessionAveDifficulty;
    if (diff < 1.4) {
      return "Very Easy";
    } 
    else if (diff < 1.8) {
      return "Easy";
    } 
    else if (diff < 2.2) {
      return "Moderate";
    } 
    else if (diff < 2.6) {
      return "Hard";
    } 
    else {
      return "Very Hard";
    }
  }

  QuizViewModel({required SyncQuizHistory syncQuizHistory})
      : _syncQuizHistory = syncQuizHistory;

  void initSession(NotebookContent content, NotebookUser currentUser, {
    double initialDifficulty = 1.0,
    int currentMastery = 0,
    }) {
    if (content.items.isEmpty && content.scenarios.isEmpty) {
      _status = QuizSessionStatus.error;
      _error = const ErrorModel(
        header: "No Content",
        description: "No quiz content available for this notebook.",
      );
      notifyListeners();
      return;
    }

    _prevMastery = currentMastery;
    _currentUser = currentUser;

    _algorithm = StaircaseAlgorithm(
      content: content, 
      initialDifficulty: initialDifficulty,
    );
    _status = QuizSessionStatus.active;
    _loadNextQuestion();
    notifyListeners();
  }

  // ANSWER SUBMISSION
  Future<void> submitAnswer({
    required String notebookId,
    required String uid,
    required bool isCorrect,
  }) async {
    if (_status != QuizSessionStatus.active || _algorithm == null) return;
    _isProcessing = true;
    notifyListeners();

    try {
      final contentLevel = _algorithm!.targetContent;
      final formatLevel = _algorithm!.targetFormat;

      _algorithm!.recordResult(
        isCorrect,
        contentLevel: contentLevel,
        formatLevel: formatLevel,
      );

      if (_algorithm!.shouldEndSession) {
        _status = QuizSessionStatus.complete;
        await _saveQuizHistory(notebookId: notebookId, uid: uid);
      } else {
        _loadNextQuestion();
      }
    } catch (e) {
      _status = QuizSessionStatus.error;
      _error = ErrorModel(
        header: "Something went wrong",
        description: e.toString(),
      );
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }

  // SUDDEN EXIT
  Future<void> endSessionEarly() async {
    if (_algorithm == null || _algorithm!.itemsServedThisSession == 0) return;
    if (_status != QuizSessionStatus.active) return;

    _algorithm?.resetSession();
    _status = QuizSessionStatus.idle;
    notifyListeners();
  }

  void resetSession() {
    _algorithm?.resetSession();
    _status = QuizSessionStatus.idle;
    _currentQuestion = null;
    _currentQuizItemModel = null;
    _currentScenarioModel = null;
    _error = null;
    _isProcessing = false;
    notifyListeners();
  }

  void _loadNextQuestion() {
    if (_algorithm == null) return;

    _currentQuestion = _algorithm!.getNextQuestion();

    if (_currentQuestion is QuizItem) {
      final item = _currentQuestion as QuizItem;
      final formatLevel = _algorithm!.targetFormat;

      // 1 - MULTIPLE CHOICE
      // 3 - IDENTIFICATION
      final mode = formatLevel == 3 ? QuizMode.identification : QuizMode.multipleChoice;

      // GENERATE MULTIPLE CHOICES
      List<String>? options;
      if (mode == QuizMode.multipleChoice) {
        final content = _algorithm!.content;
        final distractors = content.items
            .where((i) => i.id != item.id && i.answer.toLowerCase().trim() != item.answer.toLowerCase().trim())
            .toList()
          ..shuffle();
        options = [item.answer, ...distractors.take(3).map((i) => i.answer)]
          ..shuffle();
      }

      _currentQuizItemModel = QuizItemModel(
        quizItem: item,
        mode: mode,
        generatedOptions: options,
      );
      _currentScenarioModel = null;

    } else if (_currentQuestion is Scenario) {
      final scenario = _currentQuestion as Scenario;
      final shuffledOptions = List<String>.from(scenario.options)..shuffle();

      _currentScenarioModel = ScenarioModel(
        scenario: Scenario(
          text: scenario.text,
          options: shuffledOptions,
          answer: scenario.answer,
          difficulty: scenario.difficulty,
        ),
      );
      _currentQuizItemModel = null;
    }
  }

  Future<void> _saveQuizHistory({
    required String notebookId,
    required String uid,
  }) async {
    try {
      await _syncQuizHistory(
        notebookId: notebookId,
        uid: uid,
        score: sessionScore, 
        aveDifficulty: sessionAveDifficulty,
        accuracy: sessionAccuracy,
        currentUser: _currentUser!,
      );
    } catch (e) {
      _status = QuizSessionStatus.syncError;
      _error = const ErrorModel(
        header: "Sync Failed",
        description: "Your quiz results may not have been saved.",
      );
      notifyListeners();
    }
  }
}