import 'package:adalem/features/notebooks/domain/notebook_entity.dart';

abstract class NotebookRepo {
  Stream<List<Notebook>> fetchNotebooks(String uid);
  Future<int> getNotebookCount(String uid);
  Future<void> syncFlashcards({
  required String notebookId,
  required String uid,
  required List<NotebookFlashcard> progress,
  });
}