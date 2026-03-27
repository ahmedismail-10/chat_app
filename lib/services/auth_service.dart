import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/helper/functions.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  static Future<void> signIn(
    BuildContext context, {
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      showSnackBar(context, 'Signed in successfully.', Colors.green);
    } on FirebaseAuthException catch (e) {
      if (e.code == "wrong-password") {
        showSnackBar(
          context,
          "Wrong password provided for that user.",
          Colors.red,
        );
      } else if (e.code == "user-not-found") {
        showSnackBar(
          context,
          "No user found for that email.",
          Colors.red,
        );
      }
    } catch (e) {
      showSnackBar(context, e.toString(), Colors.red);
    }
  }

  static Future<void> signUp(
    BuildContext context, {
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await addUser(
        UserModel(
          uid: _firebaseAuth.currentUser!.uid,
          email: email,
        ),
      );
      showSnackBar(context, 'Signed up successfully.', Colors.green);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        showSnackBar(
          context,
          'Email already exists, try login instead',
          Colors.red,
        );
      }
    } catch (e) {
      showSnackBar(context, e.toString(), Colors.red);
    }
  }

  static Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  static Future<void> addUser(UserModel user) async {
    await FirebaseFirestore.instance
        .collection(kUsersCollections)
        .doc(user.uid)
        .set(user.toMap());
  }
}
