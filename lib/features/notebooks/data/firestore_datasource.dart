import 'package:adalem/core/app_constraints.dart';
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
    final docRef = _firestore.collection('notebooks').doc(notebookId);
    final snapshot = await docRef.get();
    if (!snapshot.exists) return;

    final data = snapshot.data()!;
    final users = data['users'] as Map<String, dynamic>? ?? {};
    final userData = users[uid] as Map<String, dynamic>? ?? {};

    final quizTs = userData['quizSession'] as Timestamp?;
    final flashcardTs = userData['flashcardSession'] as Timestamp?;
    final currentStreak = userData['streak'] as int? ?? 0;

    final newStreak = _calculateNewStreak(quizTs, flashcardTs, currentStreak);

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
      'users.$uid.flashcardSession': FieldValue.serverTimestamp(),
      'users.$uid.streak': newStreak,
    };

    if (!isEarly) {
      updateData['users.$uid.mastery'] = FieldValue.increment(Constraint.flashcardPts);
    }
    await docRef.update(updateData);
  }

  @override
  Future<void> syncQuizHistory({
    required String notebookId,
    required String uid,
    required NotebookHistory history,
  }) async {
    final notebookRef = _firestore.collection('notebooks').doc(notebookId);
    final historyRef = _firestore.collection('history').doc();

    final snapshot = await notebookRef.get();
    if (!snapshot.exists) return;

    final data = snapshot.data()!;
    final users = data['users'] as Map<String, dynamic>? ?? {};
    final userData = users[uid] as Map<String, dynamic>? ?? {};

    final quizTs = userData['quizSession'] as Timestamp?;
    final flashcardTs = userData['flashcardSession'] as Timestamp?;
    final currentStreak = userData['streak'] as int? ?? 0;

    final newStreak = _calculateNewStreak(quizTs, flashcardTs, currentStreak);
    final batch = _firestore.batch();

    batch.update(notebookRef, {
      'users.$uid.mastery': FieldValue.increment(history.score),
      'users.$uid.quizSession': FieldValue.serverTimestamp(),
      'users.$uid.streak': newStreak,
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

  int _calculateNewStreak(Timestamp? quizTs, Timestamp? flashcardTs, int currentStreak) {
    Timestamp? lastSessionTs;
    if (quizTs != null && flashcardTs != null) {
      lastSessionTs = quizTs.compareTo(flashcardTs) > 0 ? quizTs : flashcardTs;
    } else {
      lastSessionTs = quizTs ?? flashcardTs;
    }
    if (lastSessionTs == null) return 1;
    final now = DateTime.now();
    final lastSession = lastSessionTs.toDate();
    
    final today = DateTime(now.year, now.month, now.day);
    final lastDate = DateTime(lastSession.year, lastSession.month, lastSession.day);
    
    final difference = today.difference(lastDate).inDays;

    if (difference == 1) {
      return currentStreak + 1; 
    } else if (difference > 1) {
      return 1; 
    }
    
    return currentStreak;
  }
}