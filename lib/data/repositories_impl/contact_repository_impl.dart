import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emergency_app/data/repositories/contact_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/messages.dart';

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
      DocumentSnapshot documentSnapshot =
          await contactCollectionReference.doc(receiverId).get();
      if (!documentSnapshot.exists) {
        await _initializeContacts(userId: receiverId);
      }

      documentSnapshot = await contactCollectionReference.doc(receiverId).get();

      final data = documentSnapshot.data() as Map<String, dynamic>?;

      List requests = data?['requests'];
      for (int index = 0; index < requests.length; index++) {
        if (requests[index]['senderId'] ==
            FirebaseAuth.instance.currentUser?.uid) {
          found = true;
          break;
        }
      }
      if (found) {
        throw "";
      }
      requests.add({
        "senderId": FirebaseAuth.instance.currentUser?.uid,
        "senderUserName": senderUserName,
        "senderPhotoUrl": senderPhotoUrl,
        "senderPhoneNumber": senderPhoneNumber
      });

      await contactCollectionReference
          .doc(receiverId)
          .update({"requests": requests});

      return true;
    } on FirebaseAuthException catch (e) {
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
  Future<bool> rejectContactRequest({required int index}) async {
    try {
      DocumentSnapshot documentSnapshot = await contactCollectionReference
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .get();
      if (documentSnapshot.exists) {
        final data = documentSnapshot.data() as Map<String, dynamic>?;
        List requests = data?['requests'];
        requests.removeAt(index);
        await contactCollectionReference
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .update({"requests": requests});
        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
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
      required String phoneNumber}) async {
    try {
      DocumentSnapshot documentSnapshot = await contactCollectionReference
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .get();
      if (documentSnapshot.exists) {
        final data = documentSnapshot.data() as Map<String, dynamic>?;
        List contacts = data?['contacts'];
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
        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
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
