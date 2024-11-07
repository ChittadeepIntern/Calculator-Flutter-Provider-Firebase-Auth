import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;

  Future<User?> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return cred.user;
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  Future<User?> signInUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return cred.user;
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  Future<void> signout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> _reAuthenticateUser(String? password) async {
    try {
      // Get the currently signed-in user
      User? user = FirebaseAuth.instance.currentUser;

      // Set up the user's credentials again (e.g., using email and password)
      AuthCredential credential = EmailAuthProvider.credential(
        email: user?.email ?? '',
        password: password??'', // Replace with the actual user password
      );

      // Re-authenticate the user
      await user?.reauthenticateWithCredential(credential);
      print('User re-authenticated successfully');
    } catch (e) {
      print('Failed to re-authenticate user: $e');
    }
  }


  Future<void> deleteUserAccount(String? password) async {
    await _reAuthenticateUser(password);//First reauthenticate the user
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.delete();
        log('User account deleted successfully');
      }
    } catch (e) {
      log('Failed to delete user: ${e.toString()}');
    }
  }

}
