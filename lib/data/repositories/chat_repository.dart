import '../models/chat_message_model.dart';

abstract class ChatRepository {
  Future<void> createOrJoinChatRoom(
      String chatRoomId, List<String> participants);

  Future<void> sendMessage(String chatRoomId, ChatMessageModel message);

  Stream<List<ChatMessageModel>> getMessages(String chatRoomId);
}
