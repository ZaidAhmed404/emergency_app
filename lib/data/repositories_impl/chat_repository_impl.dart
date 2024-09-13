import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/chat_message_model.dart';
import '../repositories/chat_repository.dart';

class ChatRepositoryImpl extends ChatRepository {
  CollectionReference chatMessageCollectionReference =
      FirebaseFirestore.instance.collection('chats');

  @override
  Future<void> createOrJoinChatRoom(
      String chatRoomId, List<String> participants) async {
    final chatRoom = chatMessageCollectionReference.doc(chatRoomId);

    final doc = await chatRoom.get();
    if (!doc.exists) {
      await chatRoom.set({
        'participants': participants,
        'createdAt': DateTime.now(),
      });
    }
  }

  @override
  Future<void> sendMessage(String chatRoomId, ChatMessageModel message) async {
    await chatMessageCollectionReference
        .doc(chatRoomId)
        .collection('messages')
        .add(message.toMap());
  }

  @override
  Stream<List<ChatMessageModel>> getMessages(String chatRoomId) {
    return chatMessageCollectionReference
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChatMessageModel.fromMap(doc.data()))
            .toList());
  }
}
