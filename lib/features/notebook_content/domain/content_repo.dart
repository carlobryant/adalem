import 'package:adalem/features/notebook_content/domain/content_entity.dart';
import 'package:adalem/features/notebook_content/domain/uc_createnotebook.dart';

abstract class ContentRepo {
  Future<NotebookContent?> fetchContent(String notebookId);
  ({String notebookId, String contentId}) generateIds();
  Future<void> createNotebook({
    required CreateNotebookParams params,
    required String notebookId,
    required String contentId,
  });
  Future<void> generateContent({
    required NotebookContent content,
    required String title,
    required String notebookId,
    required String contentId,
  });
  Future<void> generateFailed({required String notebookId});
  Future<void> deleteOrLeaveNotebook({
    required String notebookId,
    required String contentId,
    required String userId,
  });
}