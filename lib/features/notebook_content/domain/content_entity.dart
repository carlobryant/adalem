class NotebookContent {
  final String id;
  final String title;
  final String notebookId;
  final List<Chapter> chapters;
  final List<QuizItem> items;
  final List<Scenario> scenarios;

  const NotebookContent({
    required this.id,
    required this.title,
    required this.notebookId,
    required this.chapters,
    required this.items,
    required this.scenarios,
  });

  NotebookContent copyWith({
    String? id,
    String? title,
    String? notebookId,
    List<Chapter>? chapters,
    List<QuizItem>? items,
    List<Scenario>? scenarios,
  }) {
    return NotebookContent(
      id: id ?? this.id,
      title: title ?? this.title,
      notebookId: notebookId ?? this.notebookId,
      chapters: chapters ?? this.chapters,
      items: items ?? this.items,
      scenarios: scenarios ?? this.scenarios,
    );
  }
}

class Chapter {
  final String header;
  final String body;

  const Chapter({
    required this.header,
    required this.body,
  });
}

class QuizItem {
  final int id;
  final String text;
  final String answer;
  final int difficulty;

  const QuizItem({
    required this.id,
    required this.text,
    required this.answer,
    required this.difficulty,
  });
}

class Scenario {
  final String text;
  final List<String> options;
  final String answer;
  final int difficulty;

  const Scenario({
    required this.text,
    required this.options,
    required this.answer,
    required this.difficulty,
  });
}