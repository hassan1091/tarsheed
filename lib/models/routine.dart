import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tarsheed/models/device.dart';

class Routine {
  final String id;
  final String name;
  final String description;
  final DocumentReference deviceId;
  final Device? device;
  final String userId;
  final String action;
  final String condition;
  final String sensor;
  final int value;

  Routine({
    required this.id,
    required this.name,
    required this.description,
    required this.deviceId,
    this.device,
    required this.userId,
    required this.action,
    required this.condition,
    required this.sensor,
    required this.value,
  });

  Routine copyWith({
    String? id,
    String? name,
    String? description,
    DocumentReference? deviceId,
    Device? device,
    String? userId,
    String? action,
    String? condition,
    String? sensor,
    int? value,
  }) {
    return Routine(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      deviceId: deviceId ?? this.deviceId,
      device: device ?? this.device,
      userId: userId ?? this.userId,
      action: action ?? this.action,
      condition: condition ?? this.condition,
      sensor: sensor ?? this.sensor,
      value: value ?? this.value,
    );
  }

  factory Routine.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc, SnapshotOptions? options) {
    final data = doc.data()!;
    return Routine(
      id: doc.id,
      action: data['action'] ?? '',
      condition: data['condition'] ?? '',
      sensor: data['sensor'] ?? '',
      value: data['value'] ?? 0,
      description: data['description'] ?? '',
      deviceId: data['device_id'] ?? '',
      name: data['name'] ?? '',
      userId: data['user_id'] ?? '',
    );
  }

  static Map<String, dynamic> toFirestore(
      Routine routine, SetOptions? options) {
    return {
      'action': routine.action,
      'condition': routine.condition,
      'sensor': routine.sensor,
      'value': routine.value,
      'description': routine.description,
      'device_id': routine.deviceId,
      'name': routine.name,
      'user_id': routine.userId,
    };
  }
}
