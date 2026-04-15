
import 'package:adalem/features/notebook_content/data/firestore_datasource.dart';
import 'package:adalem/features/notebook_content/domain/content_entity.dart';
import 'package:adalem/features/notebook_content/domain/content_repo.dart';
import 'package:adalem/features/notebook_content/domain/uc_createnotebook.dart';

class ContentRepositoryImpl implements ContentRepo {
  final FirestoreContentDataSource _dataSource;
  ContentRepositoryImpl({
    required FirestoreContentDataSource dataSource
  }) : _dataSource = dataSource;

  @override
  Future<NotebookContent?> fetchContent(String notebookId) {
    return _dataSource.fetchContent(notebookId);
  }

  @override
  ({String notebookId, String contentId}) generateIds() {
    return _dataSource.generateIds();
  }

  @override
  Future<void> createNotebook({
    required CreateNotebookParams params,
    required String notebookId,
    required String contentId,
  }) {
    return _dataSource.createNotebook(
      params: params,
      notebookId: notebookId,
      contentId: contentId,
      
    );
  }

  @override
  Future<void> generateContent({
    required NotebookContent content,
    required String title,
    required String notebookId,
    required String contentId,
  }) {
    return _dataSource.generateContent(
      content: content,
      title: title,
      notebookId: notebookId,
      contentId: contentId,
    );
  }

  @override
  Future<void> generateFailed({
    required String notebookId,
    required String error,
  }) {
    return _dataSource.generateFailed(
      notebookId: notebookId,
      error: error,
    );
  }

  @override
  Future<void> deleteOrLeaveNotebook({
    required String notebookId,
    required String contentId,
    required String userId,
  }) async {
    await _dataSource.deleteOrLeaveNotebook(
      notebookId: notebookId,
      contentId: contentId,
      userId: userId,
    );
  }
}