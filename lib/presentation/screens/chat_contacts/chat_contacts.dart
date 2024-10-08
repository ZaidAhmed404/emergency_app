import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:lottie/lottie.dart';

import '../../../data/models/contact_model.dart';
import '../../../routes/custom_page_route.dart';
import '../../controllers/chat_message_controller.dart';
import '../../controllers/contacts_controller.dart';
import '../../provider/user_provider.dart';
import '../../widgets/heading_text.dart';
import '../../widgets/icon_button.dart';
import '../chat/chat.dart';

class ChatContactsScreen extends ConsumerWidget {
  ChatContactsScreen({super.key});

  final ChatMessageController _chatMessageController =
      GetIt.I<ChatMessageController>();

  final ContactsController _contactsController = GetIt.I<ContactsController>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeadingTextWidget(
              heading: "Chats Contacts",
              fontSize: 25,
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.75,
                child: StreamBuilder(
                    stream: _contactsController.handleGetContacts(
                        FirebaseAuth.instance.currentUser!.uid),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: SizedBox(
                            width: 50,
                            height: 50,
                            child: SizedBox(
                                width: 50,
                                height: 50,
                                child:
                                    Lottie.asset('assets/lottie/loading.json')),
                          ),
                        );
                      }

                      if (snapshot.hasError) {
                        return const Center(
                            child: Text('Something Went Wrong!!!'));
                      }
                      final contacts = snapshot.data!;

                      return SizedBox(
                          child: contacts.isEmpty
                              ? const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "No Contacts",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18),
                                    ),
                                  ],
                                )
                              : ListView.builder(
                                  itemCount: contacts.length,
                                  itemBuilder: (context, index) {
                                    ContactModel cont = contacts[index];
                                    return Container(
                                      margin: const EdgeInsets.only(top: 10),
                                      child: Row(
                                        children: [
                                          ClipOval(
                                              child: SizedBox.fromSize(
                                            size: const Size.fromRadius(25),
                                            child: Image.network(cont.photoUrl,
                                                fit: BoxFit.fill,
                                                loadingBuilder:
                                                    (BuildContext context,
                                                        Widget child,
                                                        ImageChunkEvent?
                                                            loadingProgress) {
                                              if (loadingProgress == null) {
                                                return child;
                                              }
                                              return SizedBox(
                                                  width: 50,
                                                  height: 50,
                                                  child: Lottie.asset(
                                                      'assets/lottie/loading.json'));
                                            }),
                                          )),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                cont.userName,
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(cont.phoneNumber),
                                            ],
                                          ),
                                          const Spacer(),
                                          IconButtonWidget(
                                            icon: Icons.message,
                                            isFilled: false,
                                            onPressedFunction: () {
                                              _chatMessageController
                                                  .handleCreatingChatRoom(
                                                      otherUserId: cont.userId);
                                              String chatRoomId =
                                                  _chatMessageController
                                                      .getChatRoomId(
                                                          otherUserId:
                                                              cont.userId);
                                              Navigator.push(
                                                context,
                                                CustomPageRoute(
                                                  child: ChatScreen(
                                                    chatRoomId: chatRoomId,
                                                    senderName: ref
                                                        .watch(
                                                            userNotifierProvider)
                                                        .userName,
                                                    senderPhotoUrl: ref
                                                        .watch(
                                                            userNotifierProvider)
                                                        .photoUrl,
                                                  ),
                                                ),
                                              );
                                            },
                                            iconSize: 15,
                                          ),
                                        ],
                                      ),
                                    );
                                  }));
                    })),
          ],
        ),
      ),
    );
  }
}
