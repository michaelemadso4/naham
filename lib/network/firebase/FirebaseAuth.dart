import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService{
  BuildContext context;
  AuthService({required this.context});
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to sign in: $e. Please check your credentials.'),
      ));
      return null;
    }
  }

  // Sign out
  Future signOut() async {
    try {
      return await auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}