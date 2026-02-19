import 'package:adalem/core/config/config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthRemoteDataSource {
  Future<UserCredential> signInWithGoogle();
  Future<void> signOut();
  User? getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  bool _isInitialized = false;

  Future<void> _initSignIn() async {
    if (!_isInitialized) {
      await _googleSignIn.initialize(
        serverClientId: AppConfig.googleClientId,
      );
      _isInitialized = true;
    }
  }

  //GOOGLE SIGN IN CALL
  @override
  Future<UserCredential> signInWithGoogle() async {
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

    return await _auth.signInWithCredential(credential);
  }

  //SIGN OUT CALL
  @override
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  //GET USER CALL
  @override
  User? getCurrentUser() => _auth.currentUser;
}