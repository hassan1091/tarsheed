import 'package:cloud_firestore/cloud_firestore.dart';

class Notification {
  String? id;
  String? title;
  String? body;
  DateTime? createdAt;

  Notification({this.id, this.title, this.body, this.createdAt});

  factory Notification.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc, SnapshotOptions? options) {
    final data = doc.data()!;
    return Notification(
      id: doc.id,
      title: data['title'] ?? '',
      body: data['body'] ?? 0,
      createdAt: data['created_at'] != null
          ? (data['created_at'] as Timestamp).toDate()
          : null,
    );
  }

  static Map<String, dynamic> toFirestore(
      Notification notification, SetOptions? options) {
    return {
      'description': notification.title,
      'history': notification.body,
      'created_at': notification.createdAt != null
          ? Timestamp.fromDate(notification.createdAt!)
          : null,
    };
  }
}
