import 'package:emergency_app/presentation/controllers/chat_message_controller.dart';
import 'package:emergency_app/presentation/screens/chat/widgets/message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:lottie/lottie.dart';

import '../../../data/models/chat_message_model.dart';
import '../../widgets/heading_text.dart';
import '../../widgets/icon_button.dart';
import '../../widgets/text_field.dart';

class ChatScreen extends StatefulWidget {
  final String chatRoomId;
  final String senderName;
  final String senderPhotoUrl;

  ChatScreen(
      {required this.chatRoomId,
      required this.senderName,
      required this.senderPhotoUrl});

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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButtonWidget(
                    icon: Icons.arrow_back,
                    isFilled: true,
                    onPressedFunction: () {
                      Navigator.pop(context);
                    },
                    iconSize: 20,
                  ),
                  const Spacer(),
                  HeadingTextWidget(
                    heading: "Chat",
                    fontSize: 25,
                  ),
                  const Spacer()
                ],
              ),
              Expanded(child: buildChatMessages(widget.chatRoomId)),
              buildMessageInput(widget.chatRoomId),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildChatMessages(String chatRoomId) {
    return StreamBuilder<List<ChatMessageModel>>(
      stream: _chatMessageController.handleGetMessages(chatRoomId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
              child: SizedBox(
                  width: 50,
                  height: 50,
                  child: Lottie.asset('assets/lottie/loading.json')));
        }

        final messages = snapshot.data!;
        return ListView.builder(
          reverse: true,
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final message = messages[index];
            return Message(
              message: message.message,
              name: message.senderName,
              condition:
                  message.senderId == FirebaseAuth.instance.currentUser!.uid,
              imageUrl: message.senderPhotoUrl,
            );
            return ListTile(
              title: Text(message.message),
              subtitle: Text(message.senderName),
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
            child: TextFieldWidget(
              hintText: "Enter your message",
              controller: _controller,
              isPassword: false,
              isEnabled: true,
              validationFunction: (value) {
                return null;
              },
              textInputType: TextInputType.text,
              textFieldWidth: MediaQuery.of(context).size.width,
              onValueChange: (value) {},
              maxLines: 1,
              borderCircular: 10,
            ),
          ),
          IconButtonWidget(
            icon: Icons.send,
            isFilled: false,
            onPressedFunction: () {
              final message = ChatMessageModel(
                  senderId: FirebaseAuth.instance.currentUser!.uid,
                  message: _controller.text,
                  timestamp: DateTime.now(),
                  senderName: widget.senderName,
                  senderPhotoUrl: widget.senderPhotoUrl);
              _chatMessageController.handleSendMessage(chatRoomId, message);
              _controller.clear();
            },
            iconSize: 20,
          ),
        ],
      ),
    );
  }
}
