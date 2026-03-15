import 'package:adalem/features/notebook_content/domain/content_entity.dart';
import 'package:adalem/features/notebooks/domain/notebook_entity.dart';

class SM2Algorithm {
  const SM2Algorithm();

  NotebookFlashcard calculate(NotebookFlashcard card, int quality) {
    if (quality < 0 || quality > 5) {
      throw ArgumentError("SM2 quality must be between 0 and 5, got: $quality");
    }
    
    final prevEaseFactor = card.easeFactor ?? 2.5;
    final prevRepetitions = card.repetitions ?? 0;
    final prevInterval = card.interval ?? 0;

    final newEaseFactor = (prevEaseFactor +
            (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02)))
        .clamp(1.3, double.infinity);

    if (quality < 3) {
      return NotebookFlashcard(
        cardId: card.cardId,
        quality: quality,
        repetitions: 0, 
        easeFactor: newEaseFactor, 
        interval: 0, 
        dueAt: DateTime.now(), 
      );
    }

    final newRepetitions = prevRepetitions + 1;
    final newInterval = switch (prevRepetitions) {
      0 => 1,
      1 => 6,
      _ => (prevInterval * newEaseFactor).round(),
    };

    return NotebookFlashcard(
      cardId: card.cardId,
      quality: quality,
      repetitions: newRepetitions,
      easeFactor: newEaseFactor,
      interval: newInterval,
      dueAt: DateTime.now().add(Duration(days: newInterval)),
    );
  }
}

class FlashcardSession {
  const FlashcardSession();

  static const int firstSessionSize = 10;
  static const int newCardsPerSession = 5;

  List<int> buildSession({
    required List<QuizItem> allItems,  
    required List<NotebookFlashcard> progress,
  }) {
    final reviewedIds = progress.map((f) => f.cardId).toSet();
    final dueCards = progress.where(_isDue).toList();

    final newCards = allItems
        .where((item) => !reviewedIds.contains(item.id))
        .toList();

    // FIRST SESSION
    if (progress.isEmpty) {
      return newCards.take(firstSessionSize).map((i) => i.id).toList();
    }

    // SUCCEEDING SESSIONS
    final newCardIds = newCards.take(newCardsPerSession).map((i) => i.id);
    final dueCardIds = dueCards.map((f) => f.cardId!);

    return [...dueCardIds, ...newCardIds].toList();
  }

  bool _isDue(NotebookFlashcard card) {
    if (card.dueAt == null) return true;
    return !card.dueAt!.isAfter(DateTime.now());
  }
}