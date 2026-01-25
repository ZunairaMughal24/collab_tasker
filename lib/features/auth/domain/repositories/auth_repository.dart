import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Future<UserCredential?> signInWithEmailAndPassword(
    String email,
    String password,
  );
  Future<UserCredential?> signUpWithEmailAndPassword(
    String email,
    String password,
  );
  Future<void> signOut();
  User? get currentUser;
  Stream<User?> get authStateChanges;
}
