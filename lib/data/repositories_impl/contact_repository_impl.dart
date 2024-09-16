import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emergency_app/data/repositories/contact_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/messages.dart';
import '../models/contact_model.dart';
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
  Stream<List<ContactModel>> getContacts(String docId) {
    return contactCollectionReference
        .doc(docId)
        .collection('contacts')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ContactModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future updateEmergencyContact(
      {required String docId, required bool isEmergency}) async {
    await contactCollectionReference
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('contacts')
        .doc(docId)
        .update({"isEmergencyContact": isEmergency});
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
  Future<List<ContactModel>> getEmergencyContacts(String docId) async {
    final snapshot = await contactCollectionReference
        .doc(docId)
        .collection('contacts')
        .get();

    return snapshot.docs
        .map((doc) => ContactModel.fromMap(doc.data(), doc.id))
        .where((contact) => contact.isEmergencyContact)
        .toList();
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
      await contactCollectionReference
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('contacts')
          .add({
        "userId": userId,
        "userName": userName,
        "photoUrl": photoUrl,
        "phoneNumber": phoneNumber,
        "isEmergencyContact": false
      });

      await contactCollectionReference.doc(userId).collection('contacts').add({
        "userId": FirebaseAuth.instance.currentUser!.uid,
        "userName": uUserName,
        "photoUrl": uPhotoUrl,
        "phoneNumber": uPhotoNumber,
        "isEmergencyContact": false
      });

      return true;
    } on FirebaseException catch (e) {
      log("${e.message}", name: "error");
      throw ("${e.message}");
    } catch (error) {
      log("$error", name: "error");

      throw (_messages.tryAgainMessage);
    }
  }
}
