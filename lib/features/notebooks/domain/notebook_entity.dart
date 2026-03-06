import 'package:cloud_firestore/cloud_firestore.dart';

class Notebook {
  final String id;
  final String owner;
  final Map<String, NotebookUser> users;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String title;
  final String course;
  final String image;
  final String contentId; 
  final bool available; 

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

  factory Notebook.fromMap(Map<String, dynamic> map) {
    return Notebook(
      id: map['id'] as String,
      owner: map['owner'] as String? ?? '',
      users: (map['users'] as Map<String, dynamic>? ?? {}).map(
        (key, value) => MapEntry(key, NotebookUser.fromMap(value)),
      ),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
      title: map['title'] as String? ?? '',
      course: map['course'] as String? ?? '',
      image: map['image'] as String? ?? '',
      contentId: map['contentId'] as String? ?? '',
      available: map['available'] as bool? ?? false,
    );
  }
}

class NotebookUser {
  final int mastery;
  final List<NotebookFlashcard> flashcards;

  const NotebookUser({
    required this.mastery,
    required this.flashcards,
  });

  factory NotebookUser.fromMap(Map<String, dynamic> map) {
    return NotebookUser(
      mastery: map['mastery'] as int? ?? 0,
      flashcards: (map['flashcards'] as List<dynamic>? ?? [])
          .map((e) => NotebookFlashcard.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class NotebookFlashcard {
  final int cardId;
  final int priority;

  const NotebookFlashcard({
    required this.cardId,
    required this.priority,
  });

  factory NotebookFlashcard.fromMap(Map<String, dynamic> map) {
    return NotebookFlashcard(
      cardId: map['cardId'] as int? ?? 0,
      priority: map['priority'] as int? ?? 0,
    );
  }
}