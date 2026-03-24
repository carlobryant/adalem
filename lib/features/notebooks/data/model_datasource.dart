import 'package:adalem/features/notebooks/domain/notebook_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotebookDataModel extends Notebook {
  const NotebookDataModel({
    required super.id,
    required super.owner,
    required super.users,
    required super.createdAt,
    required super.updatedAt,
    required super.title,
    required super.course,
    required super.image,
    required super.contentId,
    required super.available,
  });

  factory NotebookDataModel.fromMap(Map<String, dynamic> map) {
    return NotebookDataModel(
      id: map['id'] as String,
      owner: map['owner'] as String? ?? '',
      users: (map['users'] as Map<String, dynamic>? ?? {}).map(
        (key, value) => MapEntry(key, NotebookUserDataModel.fromMap(value)),
      ),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: NotebookUpdatedAtDataModel.fromMap(
        map['updatedAt'] as Map<String, dynamic>? ?? {},
      ),
      title: map['title'] as String? ?? '',
      course: map['course'] as String? ?? '',
      image: map['image'] as String? ?? '',
      contentId: map['contentId'] as String? ?? '',
      available: map['available'] as String? ?? '',
    );
  }
}

class NotebookUpdatedAtDataModel extends NotebookUpdatedAt {
  const NotebookUpdatedAtDataModel({
    super.content,
    super.flashcard,
    super.quiz,
  });

  factory NotebookUpdatedAtDataModel.fromMap(Map<String, dynamic> map) {
    return NotebookUpdatedAtDataModel(
      content: (map['content'] as Timestamp?)?.toDate(),
      flashcard: (map['flashcard'] as Timestamp?)?.toDate(),
      quiz: (map['quiz'] as Timestamp?)?.toDate(),
    );
  }
}

class NotebookUserDataModel extends NotebookUser {
  const NotebookUserDataModel({
    required super.mastery,
    required super.quizStreak,
    required super.flashcardStreak,
    required super.quizSession,
    required super.flashcardSession,
    required super.flashcards,
  });

  factory NotebookUserDataModel.fromMap(Map<String, dynamic> map) {
    return NotebookUserDataModel(
      mastery: map['mastery'] as int? ?? 0,
      quizStreak: map['quizStreak'] as int? ?? 0,
      flashcardStreak: map['flashcardStreak'] as int? ?? 0,
      quizSession: (map['quizSession'] as Timestamp?)?.toDate(),
      flashcardSession: (map['flashcardSession'] as Timestamp?)?.toDate(),
      flashcards: (map['flashcards'] as List<dynamic>? ?? [])
          .map((e) => NotebookFlashcardDataModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class NotebookFlashcardDataModel extends NotebookFlashcard {
  const NotebookFlashcardDataModel({
    super.cardId,
    super.quality,
    super.repetitions,
    super.easeFactor,
    super.interval,
    super.dueAt,
  });

  factory NotebookFlashcardDataModel.fromMap(Map<String, dynamic> map) {
    return NotebookFlashcardDataModel(
      cardId: map['cardId'] as int?,
      quality: map['quality'] as int?,
      repetitions: map['repetitions'] as int?,
      easeFactor: map['easeFactor'] as double?,
      interval: map['interval'] as int?,
      dueAt: map['dueAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['dueAt'] as int)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'cardId': cardId,
      'quality': quality,
      'repetitions': repetitions,
      'easeFactor': easeFactor,
      'interval': interval,
      'dueAt': dueAt?.millisecondsSinceEpoch,
    };
  }
}

class NotebookHistoryDataModel extends NotebookHistory {
  const NotebookHistoryDataModel({
    required super.id,
    required super.notebookId,
    required super.uid,
    required super.score,
    required super.aveDifficulty,
    required super.accuracy,
    required super.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'notebookId': notebookId,
      'uid': uid,
      'score': score,
      'aveDifficulty': aveDifficulty,
      'accuracy': accuracy,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory NotebookHistoryDataModel.fromMap(String id, Map<String, dynamic> map) {
    return NotebookHistoryDataModel(
      id: id,
      notebookId: map['notebookId'] as String,
      uid: map['uid'] as String,
      score: map['score'] as int,
      aveDifficulty: (map['aveDifficulty'] as num).toDouble(),
      accuracy: (map['accuracy'] as num).toDouble(),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
    );
  }
}