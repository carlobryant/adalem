import 'package:adalem/features/notebook_content/domain/content_entity.dart';
import 'package:adalem/features/notebook_content/domain/uc_createnotebook.dart';

abstract class ContentRepo {
  Future<NotebookContent?> fetchContent(String notebookId);
  Future<NotebookContent> parseContent();
  ({String notebookId, String contentId}) generateIds();
  Future<void> batchCreateNotebookAndContent({
    required CreateNotebookParams params,
    required NotebookContent content,
    required String notebookId,
    required String contentId,
  });
  Future<void> deleteOrLeaveNotebook({
    required String notebookId,
    required String contentId,
    required String userId,
  });
}