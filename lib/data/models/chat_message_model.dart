import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessageModel {
  final String senderId;
  final String message;
  final String senderPhotoUrl;

  final String senderName;
  final DateTime timestamp;

  ChatMessageModel(
      {required this.senderId,
      required this.message,
      required this.senderName,
      required this.senderPhotoUrl,
      required this.timestamp});

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'message': message,
      'timestamp': timestamp,
      'senderPhotoUrl': senderPhotoUrl,
      'senderName': senderName
    };
  }

  factory ChatMessageModel.fromMap(Map<String, dynamic> map) {
    return ChatMessageModel(
      senderId: map['senderId'] ?? "",
      message: map['message'] ?? "",
      senderName: map['senderName'] ?? "",
      senderPhotoUrl: map['senderPhotoUrl'] ?? "",
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }
}
