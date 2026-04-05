import 'package:adalem/config/config.dart';
import 'package:adalem/core/app_constraints.dart';
import 'package:adalem/features/auth/domain/auth_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthRemoteDataSource {
  Future<AuthUser?> signInWithGoogle();
  Future<void> signOut();
  AuthUser? getCurrentUser();
  Future<AuthUser?> getUserById(String uid);
  Stream<AuthUser?> get authStateChanges;
  Stream<AuthUser?> fetchActivity();
  Future<void> updateActivity(String uid, 
    String dateKey, {int created = 0, int quiz = 0, int flashcard = 0,});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;
  final FirebaseFirestore _firestore;
  bool _isInitialized = false;

  AuthRemoteDataSourceImpl({
    FirebaseAuth? auth,
    GoogleSignIn? googleSignIn,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  AuthUser _mapFirebaseUser(User user, {String provider = 'google'}) {
    return AuthUser(
      uid: user.uid,
      name: user.displayName ?? '',
      email: user.email ?? '',
      photoURL: user.photoURL ?? '',
      provider: provider,
    );
  }

    Future<void> _initSignIn() async {
    if (!_isInitialized) {
      await _googleSignIn.initialize(
        serverClientId: AppConfig.googleClientId,
      );
      _isInitialized = true;
    }
  }

  // SIGN IN WITH GOOGLE
  @override
  Future<AuthUser?> signInWithGoogle() async {
    await _initSignIn();

    final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();
    final idToken = googleUser.authentication.idToken;
    final authorizationClient = googleUser.authorizationClient;

    GoogleSignInClientAuthorization? authorization =
        await authorizationClient.authorizationForScopes(['email', 'profile']);

    if (authorization?.accessToken == null) {
      authorization = await authorizationClient.authorizationForScopes(
        ['email', 'profile'],
      );
      if (authorization?.accessToken == null) {
        throw FirebaseAuthException(
          code: 'missing-access-token',
          message: 'Failed to retrieve access token.',
        );
      }
    }

    final credential = GoogleAuthProvider.credential(
      accessToken: authorization!.accessToken,
      idToken: idToken,
    );

    final userCredential = await _auth.signInWithCredential(credential);
    final user = userCredential.user;

    if (user == null) return null;
    await _saveUserToFirestore(user); 
    return _mapFirebaseUser(user);
  }

  // NEW USER TO DATABASE
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
        'activity': {},
      });
    }
  }

  // GET USER
  @override
  AuthUser? getCurrentUser() {
    final user = _auth.currentUser;
    return user != null ? _mapFirebaseUser(user) : null;
  }

  // STREAM
  @override
  Stream<AuthUser?> get authStateChanges {
    return _auth.authStateChanges().map((user) {
      return user != null ? _mapFirebaseUser(user) : null;
    });
  }

  @override
  Stream<AuthUser?> fetchActivity() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return Stream.value(null);

    return _firestore.collection('users').doc(uid).snapshots().map((snapshot) {
      if (!snapshot.exists || snapshot.data() == null) return null;

      final data = snapshot.data()!;

      final parsedActivity = <String, ActivityEntry>{};
      if (data['activity'] is Map<String, dynamic>) {
        (data['activity'] as Map<String, dynamic>).forEach((key, value) {
          if (value is Map<String, dynamic>) {
            parsedActivity[key] = ActivityEntry.fromMap(value); 
          }
        });
      }

      return AuthUser(
        uid: uid,
        name: data['name'] ?? data['displayName'] ?? 'Unknown User',
        email: data['email'] ?? '',
        photoURL: data['photoURL'] ?? '',
        provider: data['provider'] ?? 'unknown',
        activity: parsedActivity,
      );
    });
  }

  // UPDATE ACTIVITY
  @override
  Future<void> updateActivity(
    String uid, 
    String dateKey, {
    int created = 0, 
    int quiz = 0, 
    int flashcard = 0,
  }) async {
    final docRef = _firestore.collection('users').doc(uid);

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) return;

      final data = snapshot.data() ?? {};
      final activityMap = (data['activity'] as Map<String, dynamic>?) ?? {};

      final Map<String, dynamic> updates = {};

      if (created > 0) updates['activity.$dateKey.Created'] = FieldValue.increment(created);
      if (quiz > 0) updates['activity.$dateKey.Quiz'] = FieldValue.increment(quiz);
      if (flashcard > 0) updates['activity.$dateKey.Flashcard'] = FieldValue.increment(flashcard);
      if (updates.isEmpty) return;

      if (!activityMap.containsKey(dateKey) && activityMap.length >= Constraint.maxActivity) {
        final sortedKeys = activityMap.keys.toList()..sort();
        final oldestKey = sortedKeys.first;
        updates['activity.$oldestKey'] = FieldValue.delete();
      }

      transaction.update(docRef, updates);
    });
  }
    
  // GET USER BY USER ID
  @override
  Future<AuthUser?> getUserById(String uid) async {
    final docSnapshot = await _firestore.collection('users').doc(uid).get();
    if (!docSnapshot.exists || docSnapshot.data() == null) return null;

    final data = docSnapshot.data()!;
    return AuthUser(
      uid: uid,
      name: data['name'] ?? data['displayName'] ?? 'Unknown User',
      email: data['email'] ?? '',
      photoURL: data['photoURL'] ?? '',
      provider: data['provider'] ?? 'unknown',
    );
  }

  //SIGN OUT 
  @override
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}