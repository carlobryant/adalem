import 'package:adalem/features/notebooks/data/model_datasource.dart';
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
    required bool isEarly,
  });
  Future<void> syncQuizHistory({
    required String notebookId,
    required String uid,
    required NotebookHistory history,
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
    required bool isEarly,
  }) async {
    final flashcards = progress.map((card) => {
      'cardId': card.cardId,
      'quality': card.quality,
      'repetitions': card.repetitions,
      'easeFactor': card.easeFactor,
      'interval': card.interval,
      'dueAt': card.dueAt?.millisecondsSinceEpoch,
    }).toList();

    final Map<String, dynamic> updateData = {
      'users.$uid.flashcards': flashcards,
      'updatedAt.flashcard': FieldValue.serverTimestamp(),
    };

    if (!isEarly) {
      updateData['users.$uid.mastery'] = FieldValue.increment(30);
    }
    await _firestore.collection('notebooks').doc(notebookId).update(updateData);
  }

  @override
  Future<void> syncQuizHistory({
    required String notebookId,
    required String uid,
    required NotebookHistory history,
  }) async {
    final notebookRef = _firestore.collection('notebooks').doc(notebookId);
    final historyRef = _firestore.collection('history').doc();
    
    final batch = _firestore.batch();
    batch.update(notebookRef, {
      'users.$uid.mastery': FieldValue.increment(history.score),
      'updatedAt.quiz': FieldValue.serverTimestamp(),
    });

    batch.set(historyRef, NotebookHistoryDataModel(
      id: historyRef.id,
      notebookId: history.notebookId,
      uid: history.uid,
      score: history.score,
      aveDifficulty: history.aveDifficulty,
      accuracy: history.accuracy,
      createdAt: history.createdAt,
    ).toMap());
    await batch.commit();
  }
}