import 'package:adalem/features/notebooks/data/firestore_datasource.dart';
import 'package:adalem/features/notebooks/domain/notebook_entity.dart';
import 'package:adalem/features/notebooks/domain/notebook_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotebookRepositoryImpl implements NotebookRepo {
  final FirestoreDataSource _dataSource;

  NotebookRepositoryImpl({required FirestoreDataSource dataSource})
      : _dataSource = dataSource;

  // @override
  // Future<void> createNotebook(CreateNotebookParams params) async {
  //   await _dataSource.createNotebook({
  //     'owner': params.owner,
  //     'users': {
  //       params.owner: {       
  //         'mastery': 0,
  //         'flashcards': []
  //       }
  //     },
  //     'title': params.title,
  //     'course': params.course,
  //     'image': params.image,
  //     'contentId': "",
  //     'createdAt': FieldValue.serverTimestamp(),
  //     'updatedAt': FieldValue.serverTimestamp(),
  //     'available': false
  //   });
  // }

  @override
Stream<List<Notebook>> fetchNotebooks() {
  final currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser == null) return const Stream.empty();

  return _dataSource.fetchNotebooks(currentUser.uid).map((list) =>
      list.map((map) => Notebook.fromMap(map)).toList());
}
}