import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:collab_tasker/features/auth/domain/repositories/auth_repository.dart';
import 'package:collab_tasker/core/utils/app_snackbar.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

  @override
  Future<void> saveUserData(String uid, String email, String name) async {
    try {
      String? fcmToken;
      try {
        fcmToken = await _firebaseMessaging.getToken();
      } catch (_) {}

      await _firestore.collection('users').doc(uid).set({
        'uid': uid,
        'email': email.toLowerCase(),
        'name': name,
        'fcmToken': fcmToken,
        'lastActive': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // Process pending invites
      final pendingWorkspaces = await _firestore
          .collection('workspaces')
          .where('pendingMembers', arrayContains: email.toLowerCase())
          .get();

      final batch = _firestore.batch();
      for (final doc in pendingWorkspaces.docs) {
        batch.update(doc.reference, {
          'members': FieldValue.arrayUnion([uid]),
          'pendingMembers': FieldValue.arrayRemove([email.toLowerCase()]),
        });
      }
      await batch.commit();
    } catch (e) {
      AppSnackbar.showError('Error saving user data: ${e.toString()}');
    }
  }

  @override
  Future<void> updateFcmToken() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) return;

      final token = await _firebaseMessaging.getToken();
      if (token != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'fcmToken': token,
          'lastActive': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }
    } catch (e) {
      debugPrint('Error updating FCM token: $e');
    }
  }

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  Future<String?> getUIDByEmail(String email) async {
    try {
      final normalizedEmail = email.trim().toLowerCase();

      // First try exact match with lowercase email
      var snapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: normalizedEmail)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first.id;
      }

      // If no match found, log for debugging
      debugPrint('User not found for email: $normalizedEmail');
      return null;
    } catch (e) {
      debugPrint('Error looking up user by email: $e');
      return null;
    }
  }

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
