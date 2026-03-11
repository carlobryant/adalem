import 'dart:convert';
import 'package:adalem/features/notebook_content/data/model_datasource.dart';
import 'package:adalem/features/notebook_content/domain/content_entity.dart';
import 'package:adalem/features/notebook_content/domain/uc_createnotebook.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

abstract class FirestoreContentDataSource {
  Future<NotebookContent?> fetchContent(String notebookId);
  Future<NotebookContent> parseContent();
  ({String notebookId, String contentId}) generateIds();
  Future<void> batchCreateNotebookAndContent({
    required CreateNotebookParams params,
    required NotebookContent content,
    required String notebookId,
    required String contentId,
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
  Future<NotebookContent> parseContent() async {
    final jsonString = await rootBundle.loadString('assets/dummy.json');
    final map = json.decode(jsonString) as Map<String, dynamic>;
    return NotebookContentDataModel.fromMap({'id': '', ...map});
  }

  @override
  ({String notebookId, String contentId}) generateIds() {
    final notebookRef = _firestore.collection('notebooks').doc();
    final contentRef = _firestore.collection('content').doc();
    return (notebookId: notebookRef.id, contentId: contentRef.id);
  }

  @override
  Future<void> batchCreateNotebookAndContent({
    required CreateNotebookParams params,
    required NotebookContent content,
    required String notebookId,
    required String contentId,
  }) async {
    final batch = _firestore.batch();

    batch.set(_firestore.collection('notebooks').doc(notebookId), {
      'owner': params.owner,
      'users': {
        params.owner: {'mastery': 0, 'flashcards': []},
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
      'available': true,
    });

    batch.set(_firestore.collection('content').doc(contentId), {
      'title': content.title,
      'chapterTotal': content.chapterTotal,
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