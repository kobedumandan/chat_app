import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  // auth
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  User? getCurentUser() {
    return _auth.currentUser;
  }

  // signin
  Future<UserCredential?> signInWithEmailPassword(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential;
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'user-not-found') {
        message = 'No user found with that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Incorrect password. Please try again.';
      } else if (e.code == 'invalid-email') {
        message = 'The email address is invalid.';
      } else if (e.code == 'user-disabled') {
        message = 'This account has been disabled.';
      } else if (e.code == 'too-many-requests') {
        message = 'Too many login attempts. Try again later.';
      } else {
        message = 'Sign-in failed. (${e.code})';
      }
      showErrorDialog(context, message);
      return null;
    } catch (e) {
      showErrorDialog(context, 'Something went wrong: $e');
      return null;
    }
  }

  // signup
  Future<UserCredential?> signUpWithEmailPassword(
    BuildContext context,
    String email,
    String password,
    String f_name,
    String l_name,
  ) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      await _firebaseFirestore
          .collection("Users")
          .doc(userCredential.user!.uid)
          .set({
            'uid': userCredential.user!.uid,
            'f_name': f_name,
            'l_name': l_name,
            'email': email,
            'color': getRandomMaterialColor().toARGB32(),
          });

      return userCredential;
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'email-already-in-use') {
        message = 'The email address is already in use.';
      } else if (e.code == 'invalid-email') {
        message = 'The email address is invalid.';
      } else if (e.code == 'weak-password') {
        message = 'The password is too weak.';
      } else {
        message = 'Registration failed. (${e.code})';
      }
      showErrorDialog(context, message);
      return null;
    } catch (e) {
      showErrorDialog(context, 'Something went wrong: $e');
      return null;
    }
  }

  // sign out
  Future<void> signOut() async {
    return await _auth.signOut();
  }

  void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Color getRandomMaterialColor() {
    final List<Color> colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
      Colors.amber,
    ];

    final random = Random();
    return colors[random.nextInt(colors.length)];
  }
}
