class Notebook {
  final String id;
  final String owner;
  final Map<String, NotebookUser> users;
  final DateTime createdAt;
  final NotebookUpdatedAt updatedAt; 
  final String title;
  final String course;
  final String image;
  final String contentId; 
  final String available; 

  const Notebook({
    required this.id,
    required this.owner,
    required this.users,
    required this.createdAt,
    required this.updatedAt,
    required this.title,
    required this.course,
    required this.image,
    required this.contentId,
    required this.available,
  });
}

class NotebookUpdatedAt {
  final DateTime? content;
  final DateTime? flashcard;
  final DateTime? quiz;

  const NotebookUpdatedAt({
    this.content,
    this.flashcard,
    this.quiz,
  });
}

class NotebookUser {
  final int mastery;
  final int? streak;
  final DateTime? quizSession;
  final DateTime? flashcardSession;
  final DateTime? lastDecayApplied;
  final List<NotebookFlashcard> flashcards;

  const NotebookUser({
    required this.mastery,
    required this.streak,
    required this.quizSession,
    required this.flashcardSession,
    required this.lastDecayApplied,
    required this.flashcards,
  });

  factory NotebookUser.empty() {
    return const NotebookUser(
      mastery: 0,
      streak: 0,
      quizSession: null,
      flashcardSession: null,
      lastDecayApplied: null,
      flashcards: [],
    );
  }

   DateTime? get latestSession {
    if (quizSession != null && flashcardSession != null) {
      return quizSession!.isAfter(flashcardSession!) ? quizSession : flashcardSession;
    }
    return quizSession ?? flashcardSession;
  }

  int calculateNewStreak({DateTime? currentDate}) {
    if (latestSession == null) return 1;

    final now = currentDate ?? DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    final lastDate = DateTime(latestSession!.year, latestSession!.month, latestSession!.day);
    final difference = today.difference(lastDate).inDays;

    if (difference == 1) return (streak ?? 0) + 1;
    if (difference > 1) return 1;
    
    return streak ?? 0;
  }
}

class NotebookFlashcard {
  final int? cardId;
  final int? quality;
  final int? repetitions;
  final double? easeFactor;
  final int? interval;
  final DateTime? dueAt;    

  const NotebookFlashcard({
    this.cardId,
    this.quality,
    this.repetitions,
    this.easeFactor,
    this.interval,
    this.dueAt,
  });
}

class NotebookHistory {
  final String id;
  final String notebookId;
  final String uid;
  final int score;
  final double aveDifficulty;
  final double accuracy;
  final DateTime createdAt;

  const NotebookHistory({
    required this.id,
    required this.notebookId,
    required this.uid,
    required this.score,
    required this.aveDifficulty,
    required this.accuracy,
    required this.createdAt,
  });
}