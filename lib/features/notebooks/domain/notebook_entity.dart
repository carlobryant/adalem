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
  final String? streakAt;
  final DateTime? quizSession;
  final DateTime? flashcardSession;
  final DateTime? lastDecayApplied;
  final List<NotebookFlashcard> flashcards;

  const NotebookUser({
    required this.mastery,
    required this.streak,
    required this.streakAt,
    required this.quizSession,
    required this.flashcardSession,
    required this.lastDecayApplied,
    required this.flashcards,
  });

  factory NotebookUser.empty() {
    return const NotebookUser(
      mastery: 0,
      streak: 0,
      streakAt: "",
      quizSession: null,
      flashcardSession: null,
      lastDecayApplied: null,
      flashcards: [],
    );
  }
  
  String timestampToStreakAt() {
    DateTime dt = DateTime.now();
    final yyyy = dt.year.toString().padLeft(4, '0');
    final mm = dt.month.toString().padLeft(2, '0');
    final dd = dt.day.toString().padLeft(2, '0');
    return '$yyyy-$mm-$dd';
    
  }

  int calculateNewStreak({DateTime? currentDate}) {
    if (streakAt == null || streakAt!.isEmpty) return 1;
    final parts = streakAt!.split('-');
    if (parts.length != 3) return 1;
    final lastDate = DateTime(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
    final now = currentDate ?? DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
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