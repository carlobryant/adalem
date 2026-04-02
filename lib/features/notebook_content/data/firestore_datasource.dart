import 'package:adalem/features/notebook_content/data/model_datasource.dart';
import 'package:adalem/features/notebook_content/domain/content_entity.dart';
import 'package:adalem/features/notebook_content/domain/uc_createnotebook.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class FirestoreContentDataSource {
  Future<NotebookContent?> fetchContent(String notebookId);
  ({String notebookId, String contentId}) generateIds();
  Future<void> createNotebook({
    required CreateNotebookParams params,
    required String notebookId,
    required String contentId,
  });
  Future<void> generateContent({
    required NotebookContent content,
    required String notebookId,
    required String contentId,
  });
  Future<void> generateFailed({required String notebookId});
  Future<void> deleteOrLeaveNotebook({
    required String notebookId,
    required String contentId,
    required String userId,
  });
}

class ContentDataSourceImpl implements FirestoreContentDataSource {
  final FirebaseFirestore _firestore;

  ContentDataSourceImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<NotebookContent?> fetchContent(String notebookId) async {
    try {
      final snapshot = await _firestore
          .collection('content')
          .where('notebook', isEqualTo: notebookId)
          .limit(1)
          .get(const GetOptions(source: Source.serverAndCache));

      if (snapshot.docs.isEmpty) return null;
      final doc = snapshot.docs.first;
      return NotebookContentDataModel.fromMap({'id': doc.id, ...doc.data()});
    } catch (_) {
      final snapshot = await _firestore
          .collection('content')
          .where('notebook', isEqualTo: notebookId)
          .limit(1)
          .get(const GetOptions(source: Source.cache));

      if (snapshot.docs.isEmpty) return null;
      final doc = snapshot.docs.first;
      return NotebookContentDataModel.fromMap({'id': doc.id, ...doc.data()});
    }
  }

  @override
  ({String notebookId, String contentId}) generateIds() {
    final notebookRef = _firestore.collection('notebooks').doc();
    final contentRef = _firestore.collection('content').doc();
    return (notebookId: notebookRef.id, contentId: contentRef.id);
  }

  @override
  Future<void> createNotebook({
    required CreateNotebookParams params,
    required String notebookId,
    required String contentId,
  }) async {
    await _firestore.collection('notebooks').doc(notebookId).set({
      'owner': params.owner,
      'users': {
        params.owner: {'mastery': 0, 'flashcards': [], 'lastDecayApplied': FieldValue.serverTimestamp(), },
      },
      'title': params.title,
      'course': params.course,
      'image': params.image,
      'contentId': contentId,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': {
        'content': FieldValue.serverTimestamp(),
        'flashcard': FieldValue.serverTimestamp(),
        'quiz': FieldValue.serverTimestamp(),
      },
      'available': "generating",
    });
  }

  @override
  Future<void> generateContent({
    required NotebookContent content,
    required String notebookId,
    required String contentId,
  }) async {
    final batch = _firestore.batch();
    batch.set(_firestore.collection('content').doc(contentId), {
      'title': content.title,
      'notebook': notebookId,
      'chapters': _listToNumberedMap(
        content.chapters.map((c) => {'header': c.header, 'body': c.body}).toList(),
      ),
      'items': _listToNumberedMap(
        content.items.map((i) => {
          'text': i.text,
          'answer': i.answer,
          'difficulty': i.difficulty,
        }).toList(),
      ),
      'scenarios': _listToNumberedMap(
        content.scenarios.map((s) => {
          'text': s.text,
          'options': s.options,
          'answer': s.answer,
          'difficulty': s.difficulty,
        }).toList(),
      ),
    });

    batch.update(_firestore.collection('notebooks').doc(notebookId), {
      'available': "ready",
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': {
        'content': FieldValue.serverTimestamp(),
        'flashcard': FieldValue.serverTimestamp(),
        'quiz': FieldValue.serverTimestamp(),
      },
    });
    
    await batch.commit();
  }

  @override
  Future<void> generateFailed({
    required String notebookId,
  }) async {
    await _firestore.collection('notebooks').doc(notebookId).update({
      'available': "failed",
    });
  }

  @override
  Future<void> deleteOrLeaveNotebook({
    required String notebookId,
    required String contentId,
    required String userId,
  }) async {
    final notebookRef = _firestore.collection('notebooks').doc(notebookId);
    DocumentSnapshot<Map<String, dynamic>> snapshot;
    try {
      snapshot = await notebookRef.get(const GetOptions(source: Source.serverAndCache));
    } catch (_) {
      snapshot = await notebookRef.get(const GetOptions(source: Source.cache));
    }

    if (!snapshot.exists || snapshot.data() == null) return;

    final data = snapshot.data()!;
    final usersMap = data['users'] as Map<String, dynamic>? ?? {};

    final historySnapshot = await _firestore
      .collection('history')
      .where('notebookId', isEqualTo: notebookId)
      .where('uid', isEqualTo: userId)
      .get(const GetOptions(source: Source.serverAndCache));
    
    final batch = _firestore.batch();
    for (final doc in historySnapshot.docs) {batch.delete(doc.reference);}
    
    if (usersMap.length > 1) {
      batch.update(notebookRef, {'users.$userId': FieldValue.delete()});
    } else {
      batch.delete(notebookRef);
      batch.delete(_firestore.collection('content').doc(contentId));
    }
      await batch.commit();
  }
  
  Map<String, dynamic> _listToNumberedMap(List<Map<String, dynamic>> list) {
    final map = <String, dynamic>{};
    for (int i = 0; i < list.length; i++) {
      map[i.toString()] = list[i];
    }
    return map;
  }
}