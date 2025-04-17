import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import '../models/user.dart';

class AuthService {
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

  User? _mapFirebaseUser(auth.User? firebaseUser) {
    if (firebaseUser == null) return null;
    return User(
      uid: firebaseUser.uid,
      email: firebaseUser.email,
      displayName: firebaseUser.displayName,
    );
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      auth.UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _mapFirebaseUser(userCredential.user);
    } catch (e) {
      print("Error signing in: $e");
      return null;
    }
  }

  Future<User?> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      auth.UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _mapFirebaseUser(userCredential.user);
    } catch (e) {
      print("Error signing up: $e");
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      // Kirim event null ke stream sebelum sign out
      _authStateController.add(null);
      
      // Tunggu hingga Firebase selesai sign out
      await _auth.signOut();
      
      print("Logout service call successful.");
    } catch (e) {
      print("Error during signOut: $e");
      throw e;
    }
  }

  User? getCurrentUser() {
    return _mapFirebaseUser(_auth.currentUser);
  }

  // Stream to notify about authentication state changes
  final _authStateController = StreamController<User?>.broadcast();

  // Expose the stream as a getter
  Stream<User?> get authStateChanges => _authStateController.stream;

  Future<void> updateUserProfile(String displayName) async {
    try {
      // Dapatkan user saat ini
      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        // Update displayName
        await currentUser.updateDisplayName(displayName);

        print("Profile updated with displayName: $displayName");
      } else {
        throw Exception('No user is currently signed in');
      }
    } catch (e) {
      print("Error updating profile: $e");
      throw Exception('Failed to update profile: $e');
    }
  }
}
