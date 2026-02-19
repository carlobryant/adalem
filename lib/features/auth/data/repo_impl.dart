import 'package:adalem/features/auth/data/google_datasource.dart';
import 'package:adalem/features/auth/domain/auth_user.dart';
import 'package:adalem/features/auth/domain/auth_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepositoryImpl implements AuthRepo {
  final AuthRemoteDataSource _dataSource;
  final FirebaseFirestore _firestore;

  AuthRepositoryImpl({
    required AuthRemoteDataSource dataSource,
    FirebaseFirestore? firestore,
  })  : _dataSource = dataSource,
        _firestore = firestore ?? FirebaseFirestore.instance;
  
  //GOOGLE SIGN IN ENTRY
  @override
  Future<AuthUser?> signInWithGoogle() async {
    try {
      final userCredential = await _dataSource.signInWithGoogle();
      final user = userCredential.user;

      if (user == null) return null;

      await _saveUserToFirestore(user);

      return AuthUser(
        uid: user.uid,
        name: user.displayName ?? '',
        email: user.email ?? '',
        photoURL: user.photoURL ?? '',
        provider: 'google',
      );
    } catch (e) {
      rethrow;
    }
  }

  //SIGN OUT
  @override
  Future<void> signOut() async {
    await _dataSource.signOut();
  }
  
  //GET CURRENT USER
  @override
  AuthUser? getCurrentUser() {
    final user = _dataSource.getCurrentUser();
    if (user == null) return null;

    return AuthUser(
      uid: user.uid,
      name: user.displayName ?? '',
      email: user.email ?? '',
      photoURL: user.photoURL ?? '',
      provider: 'google',
    );
  }

  //CREATE FIRESTORE DOCUMENT
  Future<void> _saveUserToFirestore(User user) async {
    final userDoc = _firestore.collection('users').doc(user.uid);
    final docSnapshot = await userDoc.get();

    if (!docSnapshot.exists) {
      await userDoc.set({
        'name': user.displayName ?? '',
        'email': user.email ?? '',
        'photoURL': user.photoURL ?? '',
        'provider': 'google',
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }
}