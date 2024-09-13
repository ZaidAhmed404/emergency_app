import 'package:emergency_app/data/repositories/chat_repository.dart';
import 'package:emergency_app/domain/services/chat_services.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../data/models/chat_message_model.dart';

class ChatMessageController {
  final ChatServices chatServices;
  final ChatRepository chatRepository;

  ChatMessageController(
      {required this.chatRepository, required this.chatServices});

  Future handleCreatingChatRoom({required String otherUserId}) async {
    String chatRoomId = chatServices.getChatRoomId(
        FirebaseAuth.instance.currentUser!.uid, otherUserId);
    await chatRepository.createOrJoinChatRoom(
        chatRoomId, [FirebaseAuth.instance.currentUser!.uid, otherUserId]);
  }

  String getChatRoomId({required String otherUserId}) {
    String chatRoomId = chatServices.getChatRoomId(
        FirebaseAuth.instance.currentUser!.uid, otherUserId);
    return chatRoomId;
  }

  Stream<List<ChatMessageModel>> handleGetMessages(String chatRoomId) {
    return chatRepository.getMessages(chatRoomId);
  }

  Future<void> handleSendMessage(
      String chatRoomId, ChatMessageModel message) async {
    await chatRepository.sendMessage(chatRoomId, message);
  }
}
