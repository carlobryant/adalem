import 'package:adalem/core/components/model_error.dart';
import 'package:adalem/features/flashcards/domain/flashcard_algo.dart';
import 'package:adalem/features/flashcards/domain/uc_syncflashcards.dart';
import 'package:adalem/features/notebook_content/domain/content_entity.dart';
import 'package:adalem/features/notebooks/domain/notebook_entity.dart';
import 'package:flutter/foundation.dart';

enum FlashcardSessionStatus { idle, active, complete, caughtUp, syncError, error }

class FlashcardViewModel extends ChangeNotifier {
  final SM2Algorithm _sm2;
  final FlashcardSession _sessionService;
  final SyncFlashcards _syncFlashcards;

  List<QuizItem> _allItems = [];
  List<QuizItem> _sessionItems = [];
  List<QuizItem> get sessionItems => _sessionItems;

  List<NotebookFlashcard> _currentProgress = [];

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  QuizItem? get currentItem =>
      _sessionItems.isEmpty ? null : _sessionItems[_currentIndex];

  bool _isProcessingRating = false;
  bool get isProcessingRating => _isProcessingRating;

  FlashcardSessionStatus _status = FlashcardSessionStatus.idle;
  FlashcardSessionStatus get status => _status;

  ErrorModel? _error;
  ErrorModel? get error => _error;

  FlashcardViewModel({
    required SM2Algorithm sm2,
    required FlashcardSession sessionService,
    required SyncFlashcards syncFlashcardProgress,
  })  : _sm2 = sm2,
        _sessionService = sessionService,
        _syncFlashcards = syncFlashcardProgress;

  void initSession(List<QuizItem> allItems, List<NotebookFlashcard> progress) {
    if (allItems.isEmpty) {
      _status = FlashcardSessionStatus.error;
      _error = const ErrorModel(
        header: "No Content",
        description: "No flashcard content available.",
      );
      notifyListeners();
      return;
    }

    _allItems = allItems;
    _currentProgress = List.from(progress); 
    _currentIndex = 0;

    final sessionCardIds = _sessionService.buildSession(
      allItems: allItems,
      progress: progress,
    );

    _sessionItems = allItems
        .where((item) => sessionCardIds.contains(item.id))
        .toList();

    if (_sessionItems.isEmpty) {
      _status = FlashcardSessionStatus.caughtUp;
      notifyListeners();
      return;
    }

    _status = FlashcardSessionStatus.active;
    notifyListeners();
  }

  void startNextSession() => initSession(_allItems, _currentProgress);

  Future<void> rateCard(String notebookId, String uid, int quality) async {
    if (_sessionItems.isEmpty || _status != FlashcardSessionStatus.active) return;

    _isProcessingRating = true;
    notifyListeners();

    final currentQuizItem = _sessionItems[_currentIndex];
    final currentCard = _currentProgress.firstWhere(
      (f) => f.cardId == currentQuizItem.id,
      orElse: () => NotebookFlashcard(cardId: currentQuizItem.id),
    );

    try {
      final updatedCard = _sm2.calculate(currentCard, quality);

      final index = _currentProgress
          .indexWhere((c) => c.cardId == updatedCard.cardId);
      if (index >= 0) {
        _currentProgress[index] = updatedCard;
      } else {
        _currentProgress.add(updatedCard);
      }

      if (_currentIndex < _sessionItems.length - 1) {
        _currentIndex++;
      } else {
        _status = FlashcardSessionStatus.complete;
        await _saveSessionProgress(notebookId, uid);
      }
    } catch (e) {
      _status = FlashcardSessionStatus.error;
      _error = ErrorModel(
        header: "Something Went Wrong",
        description: e.toString(),
      );

    } finally {
      _isProcessingRating = false;
      notifyListeners();
    }
  }

  bool get hasMoreCardsForToday {
    if (_allItems.isEmpty) return false;
    
    final nextSessionIds = _sessionService.buildSession(
      allItems: _allItems,
      progress: _currentProgress,
    );
    
    return nextSessionIds.isNotEmpty;
  }

  Future<void> _saveSessionProgress(String notebookId, String uid, {bool early = false}) async {
    try {
      await _syncFlashcards(
        notebookId: notebookId,
        uid: uid,
        progress: _currentProgress,
        isEarly: early,
      );
    } catch (e) {
      _status = FlashcardSessionStatus.syncError;
      _error = const ErrorModel(
        header: "Sync Failed",
        description: "Failed to sync progress. Your results may not be saved.",
      );
      notifyListeners();
    }
  }

  Future<void> saveProgressEarly(String notebookId, String uid) async {
    if (_currentIndex > 0 && _status == FlashcardSessionStatus.active) {
      _status = FlashcardSessionStatus.complete;
      await _saveSessionProgress(notebookId, uid, early: true);
    }
  }

  void resetSession() {
    _status = FlashcardSessionStatus.idle;
    _sessionItems = [];
    _currentProgress = [];
    _currentIndex = 0;
    _error = null;
    notifyListeners();
  }
}
