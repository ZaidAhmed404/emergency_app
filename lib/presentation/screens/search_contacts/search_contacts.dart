import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emergency_app/data/models/user_model.dart';
import 'package:emergency_app/presentation/controllers/contacts_controller.dart';
import 'package:emergency_app/presentation/provider/screen_provider.dart';
import 'package:emergency_app/presentation/provider/user_provider.dart';
import 'package:emergency_app/presentation/widgets/text_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:lottie/lottie.dart';

import '../../widgets/heading_text.dart';
import '../../widgets/icon_button.dart';
import '../../widgets/overlay_loading.dart';
import '../../widgets/text_field.dart';

class SearchContactsScreen extends ConsumerStatefulWidget {
  SearchContactsScreen({super.key});

  static const routeName = "/Search-Contacts-Screen";

  @override
  ConsumerState<SearchContactsScreen> createState() =>
      _SearchContactsScreenState();
}

class _SearchContactsScreenState extends ConsumerState<SearchContactsScreen> {
  final TextEditingController _searchController = TextEditingController();

  List<UserModel> users = [];

  final ContactsController _contactsController = GetIt.I<ContactsController>();

  @override
  Widget build(BuildContext context) {
    final screenNotifier = ref.watch(screenNotifierProvider.notifier);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: OverlayLoadingWidget(
          isLoading: ref.watch(screenNotifierProvider),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButtonWidget(
                      icon: Icons.arrow_back_ios_outlined,
                      isFilled: true,
                      onPressedFunction: () {
                        Navigator.pop(context);
                      },
                      iconSize: 20,
                    ),
                    const Spacer(),
                    HeadingTextWidget(
                      heading: "Search Contacts",
                      fontSize: 25,
                    ),
                    const Spacer(),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFieldWidget(
                  hintText: "Search Name",
                  controller: _searchController,
                  isPassword: false,
                  isEnabled: true,
                  validationFunction: (value) {
                    return null;
                  },
                  textInputType: TextInputType.emailAddress,
                  textFieldWidth: MediaQuery.of(context).size.width,
                  onValueChange: (value) {
                    setState(() {});
                  },
                  maxLines: 1,
                  borderCircular: 10,
                ),
                const SizedBox(
                  height: 20,
                ),
                HeadingTextWidget(
                  heading: "Results",
                  fontSize: 25,
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.65,
                    child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .snapshots(),
                        builder:
                            (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: SizedBox(
                                width: 50,
                                height: 50,
                                child: SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: Lottie.asset(
                                        'assets/lottie/loading.json')),
                              ),
                            );
                          }

                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }
                          if (_searchController.text.isNotEmpty) {
                            users = snapshot.data!.docs
                                .map((doc) {
                                  Map<String, dynamic> data =
                                      doc.data() as Map<String, dynamic>;
                                  return UserModel.fromJson(data);
                                })
                                .where((user) => user.userName
                                    .contains(_searchController.text.trim()))
                                .where((user) =>
                                    user.uid !=
                                    FirebaseAuth.instance.currentUser?.uid)
                                .toList();
                          }

                          return SizedBox(
                              child: users.isEmpty
                                  ? const Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "No Users Found",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 18),
                                        ),
                                      ],
                                    )
                                  : ListView.builder(
                                      itemCount: users.length,
                                      itemBuilder: (context, index) {
                                        UserModel user = users[index];
                                        return Container(
                                          margin:
                                              const EdgeInsets.only(top: 10),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  ClipOval(
                                                      child: SizedBox.fromSize(
                                                    size: const Size.fromRadius(
                                                        25),
                                                    child: Image.network(
                                                        user.photoUrl,
                                                        fit: BoxFit.fill,
                                                        loadingBuilder:
                                                            (BuildContext
                                                                    context,
                                                                Widget child,
                                                                ImageChunkEvent?
                                                                    loadingProgress) {
                                                      if (loadingProgress ==
                                                          null) {
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
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        user.userName,
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(user.phoneNumber),
                                                    ],
                                                  ),
                                                  const Spacer(),
                                                  TextButtonWidget(
                                                      text: "Send Request",
                                                      function: () async {
                                                        FocusScope.of(context)
                                                            .unfocus();

                                                        screenNotifier
                                                            .updateLoading(
                                                                isLoading:
                                                                    true);
                                                        await _contactsController.handleSendingRequestContacts(
                                                            senderPhotoUrl: ref
                                                                .watch(
                                                                    userNotifierProvider)
                                                                .photoUrl,
                                                            senderUserName: ref
                                                                .watch(
                                                                    userNotifierProvider)
                                                                .userName,
                                                            senderPhoneNumber: ref
                                                                .watch(
                                                                    userNotifierProvider)
                                                                .phoneNumber,
                                                            receiverId:
                                                                user.uid);
                                                        screenNotifier
                                                            .updateLoading(
                                                                isLoading:
                                                                    false);
                                                      },
                                                      isSelected: false,
                                                      buttonWidth:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.3)
                                                ],
                                              ),
                                              const Divider(
                                                height: 20,
                                              )
                                            ],
                                          ),
                                        );
                                      }));
                        }))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
