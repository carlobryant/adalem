import 'package:adalem/features/notebooks/domain/notebook_entity.dart';
import 'package:intl/intl.dart';

class NotebookModel {
  final String id;
  final String owner;
  final Map<String, NotebookUserModel> users;
  final String createdAt;
  final String updatedAt;
  final String title;
  final String course;
  final String image;
  final String contentId; 
  final String available; 

  const NotebookModel({
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

  factory NotebookModel.fromEntity(Notebook notebook) {
    String formattedUpdated = "";
    
    if (notebook.updatedAt.content != null) {
      formattedUpdated = DateFormat("MMM d, yyyy-HH:mm").format(notebook.updatedAt.content!);
    } else if (notebook.updatedAt.flashcard != null) {
      formattedUpdated = DateFormat("MMM d, yyyy-HH:mm").format(notebook.updatedAt.flashcard!);
    } else if (notebook.updatedAt.quiz != null) {
      formattedUpdated = DateFormat("MMM d, yyyy-HH:mm").format(notebook.updatedAt.quiz!);
    }

    return NotebookModel(
      id: notebook.id,
      owner: notebook.owner,
      users: notebook.users.map(
        (key, value) => MapEntry(key, NotebookUserModel.fromEntity(value)),
      ),
      createdAt: DateFormat("MMM d, yyyy-HH:mm").format(notebook.createdAt),
      updatedAt: formattedUpdated, 
      title: notebook.title,
      course: notebook.course,
      image: notebook.image,
      contentId: notebook.contentId,
      available: notebook.available,
    );
  }

  factory NotebookModel.empty() {
    return const NotebookModel(
      id: '',
      owner: '',
      users: {},
      createdAt: '',
      updatedAt: '',
      title: '',
      course: '',
      image: '',
      contentId: '',
      available: '',
    );
  }
}

class NotebookUserModel {
  final int mastery;
  final int? streak;
  final DateTime? quizSession;
  final DateTime? flashcardSession;
  final List<NotebookFlashcardModel> flashcards;

  const NotebookUserModel({
    required this.mastery,
    required this.streak,
    required this.quizSession,
    required this.flashcardSession,
    required this.flashcards,
  });

  factory NotebookUserModel.fromEntity(NotebookUser user) {
    return NotebookUserModel(
      mastery: user.mastery,
      streak: user.streak,
      quizSession: user.quizSession,
      flashcardSession: user.flashcardSession,
      flashcards: user.flashcards
          .map((e) => NotebookFlashcardModel.fromEntity(e))
          .toList(),
    );
  }

  factory NotebookUserModel.empty() {
    return const NotebookUserModel(
      mastery: 0,
      streak: 0,
      quizSession: null,
      flashcardSession: null,
      flashcards: [],
    );
  }
}

class NotebookFlashcardModel {
  final int? cardId;
  final int? quality;
  final int? repetitions;
  final double? easeFactor;
  final int? interval;
  final DateTime? dueAt;
  final bool isDue;

  const NotebookFlashcardModel({
    this.cardId,
    this.quality,
    this.repetitions,
    this.easeFactor,
    this.interval,
    this.dueAt,
    this.isDue = false,
  });

  factory NotebookFlashcardModel.fromEntity(NotebookFlashcard flashcard) {
    return NotebookFlashcardModel(
      cardId: flashcard.cardId,
      quality: flashcard.quality,
      repetitions: flashcard.repetitions,
      easeFactor: flashcard.easeFactor,
      interval: flashcard.interval,
      dueAt: flashcard.dueAt,
      isDue: flashcard.dueAt != null
          ? !flashcard.dueAt!.isAfter(DateTime.now())
          : true,
    );
  }

  factory NotebookFlashcardModel.empty() {
    return NotebookFlashcardModel(
      cardId: null,
      quality: null,
      repetitions: 0,
      easeFactor: 2.5,
      interval: 0,
      dueAt: DateTime.now(),
      isDue: true,
    );
  }

}