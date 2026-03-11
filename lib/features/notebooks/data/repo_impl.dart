import 'package:adalem/features/notebooks/data/firestore_datasource.dart';
import 'package:adalem/features/notebooks/data/model_datasource.dart';
import 'package:adalem/features/notebooks/domain/notebook_repo.dart';

class NotebookRepositoryImpl implements NotebookRepo {
  final FirestoreDataSource _dataSource;

  NotebookRepositoryImpl({required FirestoreDataSource dataSource})
      : _dataSource = dataSource;

  @override
  Stream<List<NotebookDataModel>> fetchNotebooks(String uid) {
    return _dataSource.fetchNotebooks(uid).map((list) =>
        list.map((map) => NotebookDataModel.fromMap(map)).toList());
  }

  @override
  Future<int> getNotebookCount(String uid) {
    return _dataSource.getNotebookCount(uid);
  }
}