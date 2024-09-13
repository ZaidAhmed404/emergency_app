import '../services/chat_services.dart';

class ChatServicesImpl extends ChatServices {
  @override
  String getChatRoomId(String user1, String user2) {
    if (user1.hashCode <= user2.hashCode) {
      return "$user1\_$user2";
    } else {
      return "$user2\_$user1";
    }
  }
}
