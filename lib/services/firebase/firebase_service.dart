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

      final querySnapshot = await db
          .collection("users_has_devices")
          .where("user_id", isEqualTo: uid)
          .get();

      // Check if there are any device IDs to query
      if (querySnapshot.docs.isEmpty) return [];

      final deviceIds =
          querySnapshot.docs.map((doc) => doc.data()["device_id"].id);

      List<Device> devices = [];
      for (var deviceId in deviceIds) {
        final deviceDoc = await db
            .collection("devices")
            .doc(deviceId)
            .withConverter(
              fromFirestore: Device.fromFirestore,
              toFirestore: Device.toFirestore,
            )
            .get();

        if (deviceDoc.exists) {
          final device = deviceDoc.data()!;

          final historySnapshot = await db
              .collection("devices")
              .doc(deviceId)
              .collection("device_usage")
              .orderBy("created_at", descending: true)
              .withConverter(
                fromFirestore: DeviceHistory.fromFirestore,
                toFirestore: DeviceHistory.toFirestore,
              )
              .get();

          // Convert the history documents to DeviceHistory
          device.history = historySnapshot.docs.map((e) => e.data()).toList();
          devices.add(device);
        }
      }
      return devices;
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
