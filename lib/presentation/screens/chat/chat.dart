import 'package:emergency_app/presentation/controllers/chat_message_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../data/models/chat_message_model.dart';

class ChatScreen extends StatefulWidget {
  final String chatRoomId;

  ChatScreen({
    required this.chatRoomId,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();

  final ChatMessageController _chatMessageController =
      GetIt.I<ChatMessageController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chat")),
      body: Column(
        children: [
          Expanded(child: buildChatMessages(widget.chatRoomId)),
          buildMessageInput(widget.chatRoomId),
        ],
      ),
    );
  }

  Widget buildChatMessages(String chatRoomId) {
    return StreamBuilder<List<ChatMessageModel>>(
      stream: _chatMessageController.handleGetMessages(chatRoomId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final messages = snapshot.data!;
        return ListView.builder(
          reverse: true,
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final message = messages[index];
            return ListTile(
              title: Text(message.message),
              subtitle: Text(message.senderId),
            );
          },
        );
      },
    );
  }

  Widget buildMessageInput(String chatRoomId) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(hintText: "Enter your message"),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              final message = ChatMessageModel(
                senderId: FirebaseAuth.instance.currentUser!.uid,
                message: _controller.text,
                timestamp: DateTime.now(),
              );
              _chatMessageController.handleSendMessage(chatRoomId, message);
              _controller.clear();
            },
          ),
        ],
      ),
    );
  }
}
