import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tarsheed/models/profile.dart';

class FirebaseService {
  final db = FirebaseFirestore.instance;

  Future<void> createUser(Profile profile) async {
    try {
      await db.collection("users").doc(profile.uid).set(profile.toJson());
    } catch (e) {
      rethrow;
    }
  }
}
