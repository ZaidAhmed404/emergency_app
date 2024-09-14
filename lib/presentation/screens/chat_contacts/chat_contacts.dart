import 'package:flutter/material.dart';

import '../../widgets/heading_text.dart';

class ChatContactsScreen extends StatelessWidget {
  const ChatContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            HeadingTextWidget(
              heading: "Chats Contacts",
              fontSize: 25,
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
