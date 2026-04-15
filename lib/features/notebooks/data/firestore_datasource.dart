import 'package:adalem/core/app_constraints.dart';
import 'package:adalem/core/components/model_mastery.dart';
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
    required int newStreak,
    required String newStreakAt,
  });
  Future<void> syncQuizHistory({
    required String notebookId,
    required String uid,
    required NotebookHistory history,
    required int newStreak,
    required String newStreakAt,
  });
}

class FirestoreDataSourceImpl implements FirestoreDataSource {
  List<Map<String, dynamic>> _cachedNotebooks = [];
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
      .map((snapshot) {
        if (snapshot.metadata.hasPendingWrites && _cachedNotebooks.isNotEmpty) {
          return _cachedNotebooks;
        }
        final batch = _firestore.batch();
        bool hasUpdates = false;

        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final todayString = "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

        final processedNotebooks = snapshot.docs.map((doc) {
          final data = doc.data();
          final users = data['users'] as Map<String, dynamic>? ?? {};
          final userData = Map<String, dynamic>.from(users[uid] as Map<String, dynamic>? ?? {});
          final streakAt = userData['streakAt'] as String?;
          final decayAt = userData['decayAt'] as String?;
          int currentStreak = userData['streak'] as int? ?? 0;
          int currentMastery = userData['mastery'] as int? ?? 0;
    
          DateTime? lastSessionDay;
          if (streakAt != null && streakAt.isNotEmpty) {
            lastSessionDay = DateTime.tryParse(streakAt);
          }
          if (lastSessionDay != null) {
            final daysSinceSession = today.difference(lastSessionDay).inDays;
            if (daysSinceSession >= 2) {
              Map<String, dynamic> updates = {};
              bool docNeedsUpdate = false;
              if (currentStreak > 0) {
                updates['users.$uid.streak'] = 0;
                userData['streak'] = 0;
                docNeedsUpdate = true;
              }
              if (currentMastery > MasteryLevel.level3.minXp) {
                DateTime? lastDecayDay;
                if (decayAt != null && decayAt.isNotEmpty) {
                  lastDecayDay = DateTime.tryParse(decayAt);
                }

                final baselineDate = lastDecayDay ?? lastSessionDay;
                final daysToPenalize = today.difference(baselineDate).inDays;
                if (daysToPenalize > 0) {
                  final penalty = daysToPenalize * Constraint.mcItemPts;
                  int newMastery = currentMastery - penalty;
                  if (newMastery < MasteryLevel.level3.minXp) newMastery = MasteryLevel.level3.minXp;

                  updates['users.$uid.mastery'] = newMastery;
                  updates['users.$uid.decayAt'] = todayString; 
                  userData['mastery'] = newMastery;
                  userData['decayAt'] = todayString;
                  docNeedsUpdate = true;
                }
              }
              if (docNeedsUpdate) {
                batch.update(doc.reference, updates);
                hasUpdates = true;
              }
            }
          }
          users[uid] = userData;
          data['users'] = users;
          return {'id': doc.id, ...data};
        }).toList();

        if (hasUpdates) { 
          batch.commit(); 
        }
        
        _cachedNotebooks = processedNotebooks;
        return processedNotebooks;
      });
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
    required int newStreak,
    required String newStreakAt,
  }) async {
    final docRef = _firestore.collection('notebooks').doc(notebookId);
    final batch = _firestore.batch();

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
      'users.$uid.streakAt': newStreakAt,
    };

    if (!isEarly) {
      updateData['users.$uid.mastery'] = FieldValue.increment(Constraint.flashcardPts);
    }

    batch.update(docRef, updateData);
    batch.commit();
  }

  @override
  Future<void> syncQuizHistory({
    required String notebookId,
    required String uid,
    required NotebookHistory history,
    required int newStreak,
    required String newStreakAt,
  }) async {
    final notebookRef = _firestore.collection('notebooks').doc(notebookId);
    final historyRef = _firestore.collection('history').doc();
    final batch = _firestore.batch();

    batch.update(notebookRef, {
      'users.$uid.mastery': FieldValue.increment(history.score),
      'users.$uid.quizSession': FieldValue.serverTimestamp(),
      'users.$uid.streak': newStreak,
      'users.$uid.streakAt': newStreakAt,
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

    batch.commit();
  }
}