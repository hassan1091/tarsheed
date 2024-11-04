import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:tarsheed/core/constants/custom_exceptions.dart';

class AuthFirebaseService {
  Future<UserCredential> signup(username, emailAddress, password) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      await credential.user?.updateDisplayName(username);
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
}
