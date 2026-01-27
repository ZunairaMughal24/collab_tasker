import 'package:firebase_auth/firebase_auth.dart';
import 'package:collab_tasker/features/auth/domain/repositories/auth_repository.dart';
import 'package:collab_tasker/core/utils/app_snackbar.dart';

/// Auth repository implementation - directly uses Firebase, no datasource layer.
class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<UserCredential?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      return await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
      return null;
    } catch (e) {
      AppSnackbar.showError('An unexpected error occurred: ${e.toString()}');
      return null;
    }
  }

  @override
  Future<UserCredential?> signUpWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      return await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
      return null;
    } catch (e) {
      AppSnackbar.showError('An unexpected error occurred: ${e.toString()}');
      return null;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      AppSnackbar.showError('Error signing out: ${e.toString()}');
    }
  }

  @override
  User? get currentUser => _firebaseAuth.currentUser;

  @override
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  void _handleAuthError(FirebaseAuthException e) {
    String message = 'Authentication failed';
    switch (e.code) {
      case 'user-not-found':
        message = 'No user found for that email.';
        break;
      case 'wrong-password':
        message = 'Wrong password provided.';
        break;
      case 'email-already-in-use':
        message = 'The account already exists for that email.';
        break;
      case 'invalid-email':
        message = 'The email address is badly formatted.';
        break;
      case 'weak-password':
        message = 'The password provided is too weak.';
        break;
      case 'invalid-credential':
        message = 'Invalid email or password.';
        break;
      default:
        message = e.message ?? message;
    }
    AppSnackbar.showError(message);
  }
}
