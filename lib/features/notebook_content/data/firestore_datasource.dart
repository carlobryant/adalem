import 'package:adalem/features/notebook_content/domain/content_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class FirestoreContentDataSource {
  Future<NotebookContent?> fetchContent(String notebookId);
}

class ContentDataSourceImpl implements FirestoreContentDataSource {
  final FirebaseFirestore _firestore;

  ContentDataSourceImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<NotebookContent?> fetchContent(String notebookId) async {
    try {
      final snapshot = await _firestore
          .collection('content')
          .where('notebook', isEqualTo: notebookId)
          .limit(1)
          .get(const GetOptions(source: Source.serverAndCache));

      if (snapshot.docs.isEmpty) return null;
      final doc = snapshot.docs.first;
      return _fromMap({'id': doc.id, ...doc.data()});
    } catch (_) {
      final snapshot = await _firestore
          .collection('content')
          .where('notebook', isEqualTo: notebookId)
          .limit(1)
          .get(const GetOptions(source: Source.cache));

      if (snapshot.docs.isEmpty) return null;
      final doc = snapshot.docs.first;
      return _fromMap({'id': doc.id, ...doc.data()});
    }
  }

  NotebookContent _fromMap(Map<String, dynamic> map) {
    return NotebookContent(
      id: map['id'] as String? ?? '',
      title: map['title'] as String? ?? '',
      chapterTotal: map['chapterTotal']?.toInt() ?? 0,
      notebookId: map['notebook'] as String? ?? '',
      chapters: _parseMapToList(map['chapters'], _chapterFromMap),
      items: _parseMapToList(map['items'], _quizItemFromMap),
      scenarios: _parseMapToList(map['scenarios'], _scenarioFromMap),
    );
  }

  Chapter _chapterFromMap(Map<String, dynamic> map) {
    return Chapter(
      header: map['header'] as String? ?? '',
      body: map['body'] as String? ?? '',
    );
  }

  QuizItem _quizItemFromMap(Map<String, dynamic> map) {
    return QuizItem(
      text: map['text'] as String? ?? '',
      answer: map['answer'] as String? ?? '',
      difficulty: map['difficulty']?.toInt() ?? 1,
    );
  }

  Scenario _scenarioFromMap(Map<String, dynamic> map) {
    return Scenario(
      text: map['text'] as String? ?? '',
      options: List<String>.from(map['options'] ?? []),
      answer: map['answer'] as String? ?? '',
      difficulty: map['difficulty']?.toInt() ?? 1,
    );
  }

  static List<T> _parseMapToList<T>(
    dynamic mapData,
    T Function(Map<String, dynamic>) fromMap,
  ) {
    if (mapData == null || mapData is! Map) return [];
    final keys = mapData.keys.toList()
      ..sort((a, b) => int.parse(a).compareTo(int.parse(b)));
    return keys.map((key) {
      return fromMap(Map<String, dynamic>.from(mapData[key]));
    }).toList();
  }
}