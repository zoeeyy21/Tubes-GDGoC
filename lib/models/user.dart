class User {
  final String uid;
  final String? email;
  final String? displayName;

  User({
    required this.uid,
    this.email,
    this.displayName,
  });

  @override
  String toString() {
    return 'User{uid: $uid, email: $email, displayName: $displayName}';
  }
}
