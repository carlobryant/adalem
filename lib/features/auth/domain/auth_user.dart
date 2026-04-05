class AuthUser {
  final String uid;
  final String name;
  final String email;
  final String photoURL;
  final String provider;
  final Map<String, ActivityEntry> activity;

  const AuthUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.photoURL,
    required this.provider,
    this.activity = const {},
  });
}

class ActivityEntry {
  final int created;
  final int quiz;
  final int flashcard;

  const ActivityEntry({
    required this.created,
    required this.quiz,
    required this.flashcard,
  });

  factory ActivityEntry.fromMap(Map<String, dynamic> map) {
    return ActivityEntry(
      created: map['Created'] as int? ?? 0,
      quiz: map['Quiz'] as int? ?? 0,
      flashcard: map['Flashcard'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Created': created,
      'Quiz': quiz,
      'Flashcard': flashcard,
    };
  }
}