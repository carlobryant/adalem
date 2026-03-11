import 'package:adalem/features/notebook_content/domain/content_entity.dart';

class NotebookContentDataModel extends NotebookContent {
  const NotebookContentDataModel({
    required super.id,
    required super.title,
    required super.chapterTotal,
    required super.notebookId,
    required super.chapters,
    required super.items,
    required super.scenarios,
  });

  factory NotebookContentDataModel.fromMap(Map<String, dynamic> map) {
    return NotebookContentDataModel(
      id: map['id'] as String? ?? '',
      title: map['title'] as String? ?? '',
      chapterTotal: map['chapterTotal']?.toInt() ?? 0,
      notebookId: map['notebook'] as String? ?? '',
      chapters: _parseMapToList(map['chapters'], ChapterDataModel.fromMap),
      items: _parseMapToList(map['items'], QuizItemDataModel.fromMap),
      scenarios: _parseMapToList(map['scenarios'], ScenarioDataModel.fromMap),
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

class ChapterDataModel extends Chapter {
  const ChapterDataModel({required super.header, required super.body});

  factory ChapterDataModel.fromMap(Map<String, dynamic> map) {
    return ChapterDataModel(
      header: map['header'] as String? ?? '',
      body: (map['body'] as String? ?? '').replaceAll('\\n', '\n'),
    );
  }
}

class QuizItemDataModel extends QuizItem {
  const QuizItemDataModel({
    required super.text,
    required super.answer,
    required super.difficulty,
  });

  factory QuizItemDataModel.fromMap(Map<String, dynamic> map) {
    return QuizItemDataModel(
      text: map['text'] as String? ?? '',
      answer: map['answer'] as String? ?? '',
      difficulty: map['difficulty']?.toInt() ?? 1,
    );
  }
}

class ScenarioDataModel extends Scenario {
  const ScenarioDataModel({
    required super.text,
    required super.options,
    required super.answer,
    required super.difficulty,
  });

  factory ScenarioDataModel.fromMap(Map<String, dynamic> map) {
    return ScenarioDataModel(
      text: map['text'] as String? ?? '',
      options: List<String>.from(map['options'] ?? []),
      answer: map['answer'] as String? ?? '',
      difficulty: map['difficulty']?.toInt() ?? 1,
    );
  }
}