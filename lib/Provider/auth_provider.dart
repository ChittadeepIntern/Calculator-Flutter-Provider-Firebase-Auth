import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  AuthProvider() {
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  // Getter for user
  User? get user => _user;

  // Check if user is authenticated
  bool get isAuthenticated => _user != null;

  // Create user with email and password
  Future<String?> createUserWithEmailAndPassword(String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      _user = cred.user;
      notifyListeners();
      return null; // Success
    } catch (e) {
      log(e.toString());
      return 'Failed to create user: ${e.toString()}'; // Error message
    }
  }

  // Sign in user with email and password
  Future<String?> signInUserWithEmailAndPassword(String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      _user = cred.user;
      notifyListeners();
      return null; // Success
    } catch (e) {
      log(e.toString());
      return 'Error signing in: ${e.toString()}'; // Error message
    }
  }

  // Sign out user
  Future<void> signout() async {
    try {
      await _auth.signOut();
      _user = null;
      notifyListeners();
    } catch (e) {
      log(e.toString());
    }
  }

  // Re-authenticate user with password
  Future<void> _reAuthenticateUser(String? password) async {
    try {
      // Use _user instead of querying FirebaseAuth instance
      User? user = _user;
      if (user == null) throw Exception('No user is currently signed in.');

      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email ?? '',
        password: password ?? '',
      );
      await user.reauthenticateWithCredential(credential);
      log('User re-authenticated successfully');
    } catch (e) {
      log('Failed to re-authenticate user: $e');
    }
  }

  // Delete user account after re-authentication
  Future<String?> deleteUserAccount(String? password) async {
    await _reAuthenticateUser(password); // First re-authenticate the user
    try {
      User? user = _user;
      if (user != null) {
        await user.delete();
        _user = null;
        notifyListeners();
        log('User account deleted successfully');
        return null; // Success
      } else {
        return 'User not authenticated';
      }
    } catch (e) {
      log('Failed to delete user: ${e.toString()}');
      return 'Error deleting account: ${e.toString()}'; // Error message
    }
  }
}
