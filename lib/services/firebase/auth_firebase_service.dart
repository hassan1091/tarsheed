import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tarsheed/core/constants/custom_exceptions.dart';
import 'package:tarsheed/models/profile.dart';
import 'package:tarsheed/services/firebase/firebase_service.dart';

class AuthFirebaseService {
  final db = FirebaseFirestore.instance;

  Future<UserCredential> signup(username, emailAddress, password) async {
    try {
      final query = await db
          .collection("users")
          .where("name", isEqualTo: username)
          .count()
          .get();
      if ((query.count ?? 0) != 0) {
        throw const UsernameAlreadyInUseException(
            message: 'The account already exists for that username.');
      }
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      await credential.user?.updateDisplayName(username);
      await FirebaseService().createUser(Profile(
        uid: credential.user!.uid,
        name: username,
      ));
      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw const WeakPasswordException(
            message: 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        throw const EmailAlreadyInUseException(
            message: 'The account already exists for that email.');
      } else {
        throw FirebaseAuthException;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<UserCredential> login(emailAddress, password) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      await FirebaseService().getUser();
      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw const UserNotFoundException(
            message: 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        throw const WrongPasswordException(
            message: 'Wrong password provided for that user.');
      } else {
        throw FirebaseAuthException;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } on FirebaseAuthException catch (e) {
      throw PublicException(e.code);
    } catch (e) {
      rethrow;
    }
  }
}
