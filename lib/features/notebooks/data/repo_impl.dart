import 'package:adalem/features/notebooks/data/firestore_datasource.dart';
import 'package:adalem/features/notebooks/domain/notebook.dart';
import 'package:adalem/features/notebooks/domain/notebook_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotebookRepositoryImpl implements NotebookRepo {
  final FirestoreDataSource _dataSource;

  NotebookRepositoryImpl({required FirestoreDataSource dataSource})
      : _dataSource = dataSource;

  @override
  Future<List<Notebook>> getNotebooks() async {
    final data = await _dataSource.fetchNotebooks();
    return data.map((map) => Notebook(
      id: map['id'] as String,
      owner: map['owner'] as String? ?? '',
      uid: List<String>.from(map['uid'] ?? []),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
      title: map['title'] as String? ?? '',
      course: map['course'] as String? ?? '',
      image: map['image'] as String? ?? '',
      path: map['path'] as String? ?? '',
    )).toList();
  }
}