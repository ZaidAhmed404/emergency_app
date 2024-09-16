import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../core/messages.dart';
import '../models/contact_model.dart';
import '../models/user_model.dart';
import '../repositories/user_repository.dart';

class UserRepositoryImpl extends UserRepository {
  final firebaseAuth = FirebaseAuth.instance;
  CollectionReference userCollectionReference =
      FirebaseFirestore.instance.collection('users');

  final Messages _messages = Messages();

  @override
  Future<bool> saveUserProfile({
    required String userName,
    required String? photoUrl,
    required String firstName,
    required String lastName,
    required String phoneNumber,
  }) async {
    // TODO: implement saveUserProfile
    String? token = await FirebaseMessaging.instance.getToken();
    try {
      await userCollectionReference.doc(firebaseAuth.currentUser!.uid).set({
        "uid": firebaseAuth.currentUser!.uid,
        'userName': userName,
        "firstName": firstName,
        "lastName": lastName,
        'photoUrl': photoUrl,
        "phoneNumber": phoneNumber,
        "token": token
      });
      return true;
    } on FirebaseAuthException catch (e) {
      log("${e.message}", name: "error");
      throw ("${e.message}");
    } catch (error) {
      log("$error", name: "error");
      throw (_messages.tryAgainMessage);
    }
  }

  @override
  Future updateToken() async {
    try {
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      messaging.onTokenRefresh.listen((newToken) async {
        await userCollectionReference
            .doc(firebaseAuth.currentUser!.uid)
            .set({"token": newToken});
      });
    } catch (error) {
      log("$error", name: "error");
      throw (_messages.tryAgainMessage);
    }
  }

  @override
  Future<UserModel?> getUserData() async {
    try {
      DocumentSnapshot documentSnapshot = await userCollectionReference
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .get();
      if (documentSnapshot.exists) {
        UserModel user = UserModel.fromJson(
            (documentSnapshot.data() as Map<String, dynamic>));

        return user;
      } else {
        return null;
      }
    } catch (error) {
      log("$error", name: "error");
      throw (_messages.tryAgainMessage);
    }
  }

  @override
  Future<List<String>> getEmergencyContactsTokens(
      {required List<ContactModel> contacts}) async {
    List<String> tokens = [];

    for (int index = 0; index < contacts.length; index++) {
      DocumentSnapshot documentSnapshot =
          await userCollectionReference.doc(contacts[index].userId).get();
      if (documentSnapshot.exists) {
        UserModel user = UserModel.fromJson(
            (documentSnapshot.data() as Map<String, dynamic>));
        tokens.add(user.token);
      }
    }

    return tokens;
  }
}
