import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserAuthServices {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> register({
    required BuildContext context,
    required String username,
    required String phoneno,
    required String email,
    required String password,
  }) async {
    try {
      // Register the user
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get the user ID (UID)
      String userUid = userCredential.user?.uid ?? '';

      // Save the username to Firestore under the user’s UID
      await firestore.collection('users').doc(userUid).set({
        'username': username,
        'phoneno': phoneno,
        'email': email,
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registration Successful for $username'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Registration Unsuccessful for $username: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
