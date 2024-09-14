import 'package:emergency_app/data/models/request_model.dart';
import 'package:emergency_app/presentation/controllers/contacts_controller.dart';
import 'package:emergency_app/presentation/provider/screen_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:lottie/lottie.dart';

import '../../../provider/user_provider.dart';
import '../../../widgets/icon_button.dart';

class Requests extends ConsumerWidget {
  Requests({super.key});

  final ContactsController _contactsController = GetIt.I<ContactsController>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenNotifier = ref.watch(screenNotifierProvider.notifier);

    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.33,
        child: StreamBuilder<List<RequestModel>>(
            stream: _contactsController
                .handleGetRequests(FirebaseAuth.instance.currentUser!.uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: SizedBox(
                        width: 50,
                        height: 50,
                        child: Lottie.asset('assets/lottie/loading.json')),
                  ),
                );
              }

              final requests = snapshot.data!;

              return SizedBox(
                  child: requests.isEmpty
                      ? const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "No Requests",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 18),
                            ),
                          ],
                        )
                      : ListView.builder(
                          itemCount: requests.length,
                          itemBuilder: (context, index) {
                            RequestModel req = requests[index];
                            return Container(
                              margin: const EdgeInsets.only(top: 10),
                              child: Row(
                                children: [
                                  ClipOval(
                                      child: SizedBox.fromSize(
                                    size: const Size.fromRadius(25),
                                    child: Image.network(req.senderPhotoUrl,
                                        fit: BoxFit.fill,
                                        loadingBuilder: (BuildContext context,
                                            Widget child,
                                            ImageChunkEvent? loadingProgress) {
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
                                        req.senderUserName,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(req.senderPhoneNumber),
                                    ],
                                  ),
                                  const Spacer(),
                                  IconButtonWidget(
                                    icon: Icons.check,
                                    isFilled: false,
                                    onPressedFunction: () async {
                                      screenNotifier.updateLoading(
                                          isLoading: true);

                                      await _contactsController
                                          .handleAcceptRequestContactRequest(
                                              docId: req.docId,
                                              userId: req.senderId,
                                              userName: req.senderUserName,
                                              photoUrl: req.senderPhotoUrl,
                                              phoneNumber:
                                                  req.senderPhoneNumber,
                                              uUserName: ref
                                                  .watch(userNotifierProvider)
                                                  .userName,
                                              uPhotoUrl: ref
                                                  .watch(userNotifierProvider)
                                                  .photoUrl,
                                              uPhotoNumber: ref
                                                  .watch(userNotifierProvider)
                                                  .phoneNumber);
                                      screenNotifier.updateLoading(
                                          isLoading: false);
                                    },
                                    iconSize: 15,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  IconButtonWidget(
                                    icon: Icons.close,
                                    isFilled: true,
                                    onPressedFunction: () async {
                                      screenNotifier.updateLoading(
                                          isLoading: true);

                                      await _contactsController
                                          .handleRejectContactRequest(
                                              docId: req.docId);
                                      screenNotifier.updateLoading(
                                          isLoading: false);
                                    },
                                    iconSize: 15,
                                  ),
                                ],
                              ),
                            );
                          }));
            }));
  }
}
