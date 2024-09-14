import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emergency_app/data/repositories/contact_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/messages.dart';
import '../models/request_model.dart';

class ContactRepositoryImpl extends ContactRepository {
  final firebaseAuth = FirebaseAuth.instance;
  CollectionReference contactCollectionReference =
      FirebaseFirestore.instance.collection('contacts');

  final Messages _messages = Messages();

  @override
  Future requestContact({
    required String senderPhotoUrl,
    required String senderUserName,
    required String senderPhoneNumber,
    required String receiverId,
  }) async {
    bool found = false;
    try {
      QuerySnapshot<Map<String, dynamic>> requests =
          await contactCollectionReference
              .doc(receiverId)
              .collection('requests')
              .get();
      for (int index = 0; index < requests.docs.length; index++) {
        if (requests.docs[index].data()['senderId'] ==
            FirebaseAuth.instance.currentUser?.uid) {
          found = true;
          throw "";
        }
      }

      await contactCollectionReference
          .doc(receiverId)
          .collection('requests')
          .add({
        "senderId": FirebaseAuth.instance.currentUser?.uid,
        "senderUserName": senderUserName,
        "senderPhotoUrl": senderPhotoUrl,
        "senderPhoneNumber": senderPhoneNumber
      });

      return true;
    } on FirebaseException catch (e) {
      log("${e.message}", name: "error");
      throw ("${e.message}");
    } catch (error) {
      log("$error", name: "error");
      if (found) {
        throw _messages.requestAlreadySentMessage;
      }
      throw (_messages.tryAgainMessage);
    }
  }

  @override
  Stream<List<RequestModel>> getRequests(String docId) {
    return contactCollectionReference
        .doc(docId)
        .collection('requests')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => RequestModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  @override
  Future<bool> rejectContactRequest({required String docId}) async {
    try {
      await contactCollectionReference
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('requests')
          .doc(docId)
          .delete();

      return true;
    } on FirebaseException catch (e) {
      log("${e.message}", name: "error");
      throw ("${e.message}");
    } catch (error) {
      log("$error", name: "error");
      throw (_messages.tryAgainMessage);
    }
  }

  @override
  Future<bool> acceptContact(
      {required String userId,
      required String userName,
      required String photoUrl,
      required String phoneNumber,
      required String uUserName,
      required String uPhotoUrl,
      required String uPhotoNumber}) async {
    try {
      DocumentSnapshot documentSnapshot = await contactCollectionReference
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .get();
      if (!documentSnapshot.exists) {
        await _initializeContacts(
            userId: FirebaseAuth.instance.currentUser!.uid);
      }
      if (documentSnapshot.exists) {
        var data = documentSnapshot.data() as Map<String, dynamic>?;
        List contacts = data?['contacts'] ?? [];
        contacts.add({
          "userId": userId,
          "userName": userName,
          "photoUrl": photoUrl,
          "phoneNumber": phoneNumber,
          "isEmergencyContact": false
        });
        await contactCollectionReference
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .update({"contacts": contacts});

        documentSnapshot = await contactCollectionReference.doc(userId).get();
        if (!documentSnapshot.exists) {
          await _initializeContacts(userId: userId);
        }

        data = documentSnapshot.data() as Map<String, dynamic>?;
        contacts = data?['contacts'] ?? [];
        contacts.add({
          "userId": FirebaseAuth.instance.currentUser!.uid,
          "userName": uUserName,
          "photoUrl": uPhotoUrl,
          "phoneNumber": uPhotoNumber,
          "isEmergencyContact": false
        });
        await contactCollectionReference
            .doc(userId)
            .update({"contacts": contacts});

        return true;
      }
      return false;
    } on FirebaseException catch (e) {
      log("${e.message}", name: "error");
      throw ("${e.message}");
    } catch (error) {
      log("$error", name: "error");

      throw (_messages.tryAgainMessage);
    }
  }

  Future _initializeContacts({required String userId}) async {
    await contactCollectionReference
        .doc(userId)
        .set({"requests": [], "contacts": []});
  }
}
