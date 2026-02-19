import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class FirestoreDataSource {
  Future<List<Map<String, dynamic>>> fetchNotebooks();
}

class FirestoreDataSourceImpl implements FirestoreDataSource {
  final FirebaseFirestore _firestore;

  FirestoreDataSourceImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<Map<String, dynamic>>> fetchNotebooks() async {
  final currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser == null) return [];

  final snapshot = await _firestore
      .collection('notebooks')
      .where('uid', arrayContains: currentUser.uid)
      .get();

  return snapshot.docs
      .map((doc) => {'id': doc.id, ...doc.data()})
      .toList();
}
}