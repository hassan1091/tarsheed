import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tarsheed/config/app_local_storage.dart';
import 'package:tarsheed/core/constants/custom_exceptions.dart';
import 'package:tarsheed/models/device.dart';
import 'package:tarsheed/models/notification.dart';
import 'package:tarsheed/models/profile.dart';
import 'package:tarsheed/models/routine.dart';

class FirebaseService {
  final db = FirebaseFirestore.instance;
  final dbAuth = FirebaseAuth.instance;

  Future<Profile> getUser() async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final querySnapshot = await db.collection("users").doc(uid).get();
      await AppLocalStorage.setBool(
          AppStorageKey.safeMode, querySnapshot['is_safe_mode'] ?? false);
      return Profile(
        uid: uid,
        name: querySnapshot['name'],
        isSafeMode: querySnapshot['is_safe_mode'] ?? false,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createUser(Profile profile) async {
    try {
      await db.collection("users").doc(profile.uid).set(profile.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateUser(
      {String? username, String? email, bool? isSafeMode}) async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      if (email != null) {
        // ignore: deprecated_member_use
        await dbAuth.currentUser?.updateEmail(email);
      }
      if (username != null) {
        final query = await db
            .collection("users")
            .where("name", isEqualTo: username)
            .count()
            .get();
        if ((query.count ?? 0) != 0) {
          throw const UsernameAlreadyInUseException(
              message: 'The account already exists for that username.');
        }
        await dbAuth.currentUser?.updateDisplayName(username);
        await db.collection("users").doc(uid).update({"name": username});
      }

      if (isSafeMode != null) {
        await db
            .collection("users")
            .doc(uid)
            .update({"is_safe_mode": isSafeMode});
        await AppLocalStorage.setBool(AppStorageKey.safeMode, isSafeMode);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateFcmToken(fcmToken) async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      await db
          .collection("users")
          .doc(uid)
          .set({"fcm_token": fcmToken}, SetOptions(merge: true));
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

      final devicesInfo = querySnapshot.docs.map((doc) {
        return {"id": doc.data()["device_id"].id, "room": doc.data()["room"]};
      });

      List<Device> devices = [];
      for (var deviceInfo in devicesInfo) {
        final deviceDoc = await db
            .collection("devices")
            .doc(deviceInfo["id"])
            .withConverter(
              fromFirestore: Device.fromFirestore,
              toFirestore: Device.toFirestore,
            )
            .get();

        if (deviceDoc.exists) {
          final device = deviceDoc.data()!;

          final historySnapshot = await db
              .collection("devices")
              .doc(deviceInfo["id"])
              .collection("device_usage")
              .orderBy("created_at", descending: true)
              .withConverter(
                fromFirestore: DeviceHistory.fromFirestore,
                toFirestore: DeviceHistory.toFirestore,
              )
              .get();

          // Convert the history documents to DeviceHistory
          device.history = historySnapshot.docs.map((e) => e.data()).toList();
          device.room = deviceInfo["room"];
          devices.add(device);
        }
      }
      return devices;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Notification>> getNotifications() async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      final querySnapshot = await db
          .collection("notifications")
          .where("user_id", isEqualTo: uid)
          .withConverter(
            fromFirestore: Notification.fromFirestore,
            toFirestore: Notification.toFirestore,
          )
          .get();
      return querySnapshot.docs.map((e) => e.data()).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Device>> addDeviceLink(
      String deviceId, String description, String room) async {
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
        "room": room,
      });

      await deviceRef.update({"description": description});

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

  Future<List<Routine>> getUserRoutines() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final querySnapshot = await db
        .collection("routines")
        .where("user_id", isEqualTo: uid)
        .withConverter(
          fromFirestore: Routine.fromFirestore,
          toFirestore: Routine.toFirestore,
        )
        .get();

    if (querySnapshot.docs.isEmpty) return [];

    final routinesWithDeviceRefs =
        querySnapshot.docs.map((doc) => doc.data()).toList();

    final deviceFutures = routinesWithDeviceRefs
        .map((routine) => getDeviceFromDocumentReference(routine.deviceId))
        .toList();

    final devices = await Future.wait(deviceFutures);

    final routines = routinesWithDeviceRefs
        .asMap()
        .entries
        .map((entry) => entry.value.copyWith(device: devices[entry.key]))
        .toList();

    return routines;
  }

  Future<List<Routine>> updateRoutine(Routine routine) async {
    await db
        .collection("routines")
        .doc(routine.id)
        .update(Routine.toFirestore(routine, SetOptions(merge: true)));
    return await getUserRoutines();
  }

  Future<List<Routine>> addRoutine(Routine routine) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    await db.collection("routines").add(Routine.toFirestore(
        routine.copyWith(userId: uid), SetOptions(merge: true)));
    return await getUserRoutines();
  }

  Future<Device?> getDeviceFromDocumentReference(DocumentReference doc) async {
    final querySnapshot = await doc
        .withConverter(
          fromFirestore: Device.fromFirestore,
          toFirestore: Device.toFirestore,
        )
        .get();

    return querySnapshot.data();
  }
}
