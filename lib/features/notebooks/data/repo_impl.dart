import 'package:adalem/features/notebooks/data/firestore_datasource.dart';
import 'package:adalem/features/notebooks/domain/notebook.dart';
import 'package:adalem/features/notebooks/domain/notebook_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotebookRepositoryImpl implements NotebookRepo {
  final FirestoreDataSource _dataSource;

  NotebookRepositoryImpl({required FirestoreDataSource dataSource})
      : _dataSource = dataSource;

  @override
  Future<void> createNotebook({
    required String owner,
    required List<String> uid,
    required String title,
    required String course,
    required String image,
    required String path,
  }) async {
    await _dataSource.createNotebook({
      'owner': owner,
      'uid': uid,
      'title': title,
      'course': course,
      'image': image,
      'path': path,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  @override
Stream<List<Notebook>> fetchNotebooks() {
  final currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser == null) return const Stream.empty();

  return _dataSource.fetchNotebooks(currentUser.uid).map((list) =>
      list.map((map) => Notebook.fromMap(map)).toList());
}
}