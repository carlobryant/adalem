import 'package:adalem/features/notebooks/domain/notebook_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class FirestoreDataSource {
  Stream<List<Map<String, dynamic>>> fetchNotebooks(String uid);
  Future<void> createNotebook(Map<String, dynamic> data);
  Future<int> getNotebookCount(String uid);
  Future<void> syncFlashcards({
    required String notebookId,
    required String uid,
    required List<NotebookFlashcard> progress,
  });
}

class FirestoreDataSourceImpl implements FirestoreDataSource {
  final FirebaseFirestore _firestore;

  FirestoreDataSourceImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;
  
  @override
  Future<void> createNotebook(Map<String, dynamic> data) async {
    await _firestore.collection('notebooks').add(data);
  }

  @override
  Stream<List<Map<String, dynamic>>> fetchNotebooks(String uid) {
      return _firestore
      .collection('notebooks')
      .where('users.$uid', isNull: false)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data()})
          .toList());
  }

  @override
  Future<int> getNotebookCount(String uid) async {
    final query = _firestore
        .collection('notebooks')
        .where('users.$uid', isNull: false);
        
    final aggregateQuery = await query.count().get();
    return aggregateQuery.count ?? 0;
  }


  @override
  Future<void> syncFlashcards({
    required String notebookId,
    required String uid,
    required List<NotebookFlashcard> progress,
  }) async {
    final flashcards = progress.map((card) => {
      'cardId': card.cardId,
      'quality': card.quality,
      'repetitions': card.repetitions,
      'easeFactor': card.easeFactor,
      'interval': card.interval,
      'dueAt': card.dueAt?.millisecondsSinceEpoch,
    }).toList();

    await _firestore.collection('notebooks').doc(notebookId).update({
      'users.$uid.flashcards': flashcards,
    });
  }
}