import 'package:adalem/features/notebook_content/data/firestore_datasource.dart';
import 'package:adalem/features/notebook_content/domain/content_entity.dart';
import 'package:adalem/features/notebook_content/domain/content_repo.dart';

class ContentRepositoryImpl implements ContentRepo {
  final FirestoreContentDataSource _dataSource;

  ContentRepositoryImpl({required FirestoreContentDataSource dataSource})
      : _dataSource = dataSource;

  @override
  Future<NotebookContent?> fetchContent(String notebookId) async {
    try {
      return await _dataSource.fetchContent(notebookId);
    } catch (e) {
      rethrow;
    }
  }
}