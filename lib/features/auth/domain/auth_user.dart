class AuthUser {
  final String uid;
  final String name;
  final String email;
  final String photoURL;
  final String provider;

  const AuthUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.photoURL,
    required this.provider,
  });
}