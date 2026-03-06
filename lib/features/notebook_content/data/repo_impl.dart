import 'package:adalem/features/notebook_content/data/firestore_datasource.dart';
import 'package:adalem/features/notebook_content/domain/content_entity.dart';
import 'package:adalem/features/notebook_content/domain/content_repo.dart';
import 'package:adalem/features/notebook_content/domain/uc_createnotebook.dart';

class ContentRepositoryImpl implements ContentRepo {
  final FirestoreContentDataSource _dataSource;

  ContentRepositoryImpl({required FirestoreContentDataSource dataSource})
      : _dataSource = dataSource;

  @override
  Future<NotebookContent?> fetchContent(String notebookId) async {
    return await _dataSource.fetchContent(notebookId);
  }

  @override
  ({String notebookId, String contentId}) generateIds() {
    return _dataSource.generateIds();
  }

  @override
  Future<NotebookContent> parseContent() async {
    return await _dataSource.parseContent();
  }

  @override
  Future<void> batchCreateNotebookAndContent({
    required CreateNotebookParams params,
    required NotebookContent content,
    required String notebookId,
    required String contentId,
  }) async {
    await _dataSource.batchCreateNotebookAndContent(
      params: params,
      content: content,
      notebookId: notebookId,
      contentId: contentId,
    );
  }
}