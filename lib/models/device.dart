import 'package:cloud_firestore/cloud_firestore.dart';

class Device {
  final String id;
  final String description;
  List<DeviceHistory>? history;
  String? room;
  final int usage;
  final String name;
  final String status;
  final String type;

  Device({
    required this.id,
    required this.description,
    this.history,
    this.room,
    required this.usage,
    required this.name,
    required this.status,
    required this.type,
  });

  bool isOn() => status == "on";

  // Factory constructor to create a Device instance from Firestore data
  factory Device.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc, SnapshotOptions? options) {
    final data = doc.data()!;
    return Device(
      id: doc.id,
      description: data['description'] ?? '',
      usage: data['usage'] ?? 0,
      name: data['name'] ?? '',
      status: data['status'] ?? '',
      type: data['type'] ?? '',
    );
  }

  // Convert a Device instance to Firestore data
  static Map<String, dynamic> toFirestore(Device device, SetOptions? options) {
    return {
      'description': device.description,
      'history': device.history,
      'usage': device.usage,
      'name': device.name,
      'status': device.status,
      'type': device.type,
    };
  }
}

class DeviceHistory {
  final String id;
  final int usage;
  final DateTime createdAt;

  DeviceHistory({
    required this.id,
    required this.usage,
    required this.createdAt,
  });

  factory DeviceHistory.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc, SnapshotOptions? options) {
    final data = doc.data()!;
    return DeviceHistory(
      id: doc.id,
      usage: data['usage'] ?? 0,
      createdAt: data['created_at'] != null
          ? (data['created_at'] as Timestamp).toDate()
          : DateTime(0),
    );
  }

  // Convert a Device instance to Firestore data
  static Map<String, dynamic> toFirestore(
      DeviceHistory deviceHistory, SetOptions? options) {
    return {
      'usage': deviceHistory.usage,
      'created_at': deviceHistory.createdAt,
    };
  }
}
