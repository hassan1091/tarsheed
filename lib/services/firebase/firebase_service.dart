import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tarsheed/core/constants/custom_exceptions.dart';
import 'package:tarsheed/models/device.dart';
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

  Future<List<Device>> getUserDevices() async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      // Query devices based on user ID
      final querySnapshot = await db
          .collection("users_has_devices")
          .where("user_id", isEqualTo: uid)
          .get();

      // Check if there are any device IDs to query
      if (querySnapshot.docs.isEmpty) return [];

      final deviceIds =
          querySnapshot.docs.map((doc) => doc.data()["device_id"].id);

      final devices = await db
          .collection("devices")
          .where(FieldPath.documentId, whereIn: deviceIds)
          .withConverter(
            fromFirestore: (snapshot, _) => Device.fromFirestore(snapshot, _),
            toFirestore: (value, _) => Device.toFirestore(value, _),
          )
          .get();
      return devices.docs.map((e) => e.data()).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Device>> addDeviceLink(String deviceId) async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      final deviceRef = db.collection("devices").doc(deviceId);

      final querySnapshot = await db
          .collection("users_has_devices")
          .where("user_id", isEqualTo: uid)
          .where("device_id", isEqualTo: deviceRef)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        throw const DeviceLinkExistsException();
      }

      await db.collection("users_has_devices").add({
        "device_id": deviceRef,
        "user_id": uid,
      });

      return await getUserDevices();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Device>> toggleDeviceStatus(Device device, bool value) async {
    try {
      await db
          .collection("devices")
          .doc(device.id)
          .update({"status": value ? "on" : "off"});
      return await getUserDevices();
    } catch (e) {
      rethrow;
    }
  }
}
