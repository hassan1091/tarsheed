import 'package:cloud_firestore/cloud_firestore.dart';

class Device {
  final String id;
  final String description;
  final Map<String, dynamic> history;
  final int usage;
  final String name;
  final String status;
  final String type;

  Device({
    required this.id,
    required this.description,
    required this.history,
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
      history: data['history'] ?? {},
      usage: int.parse(data['usage'] ?? "0"),
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
