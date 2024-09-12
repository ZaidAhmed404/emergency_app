import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../../data/models/contact_model.dart';

class Contacts extends StatelessWidget {
  const Contacts({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.35,
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('contacts')
                .doc(FirebaseAuth.instance.currentUser?.uid)
                .snapshots(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
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

              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              final data = snapshot.data?.data() as Map<String, dynamic>?;
              List requests = data?['contacts'];
              List<ContactModel> contactsModel = [];

              for (int index = 0; index < requests.length; index++) {
                log("${requests[index]}");
                contactsModel.add(ContactModel.fromMap(requests[index], index));
              }

              return SizedBox(
                  child: contactsModel.isEmpty
                      ? const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "No Contacts",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 18),
                            ),
                          ],
                        )
                      : ListView.builder(
                          itemCount: contactsModel.length,
                          itemBuilder: (context, index) {
                            ContactModel cont = contactsModel[index];
                            return Container(
                              margin: const EdgeInsets.only(top: 10),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      ClipOval(
                                          child: SizedBox.fromSize(
                                        size: const Size.fromRadius(25),
                                        child: Image.network(cont.photoUrl,
                                            fit: BoxFit.fill, loadingBuilder:
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
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(cont.phoneNumber),
                                        ],
                                      ),
                                      const Spacer(),
                                    ],
                                  ),
                                  const Divider(
                                    height: 20,
                                  ),
                                ],
                              ),
                            );
                          }));
            }));
  }
}
