import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/messages.dart';
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
    try {
      userCollectionReference.doc(firebaseAuth.currentUser!.uid).set({
        "uid": firebaseAuth.currentUser!.uid,
        'userName': userName,
        "firstName": firstName,
        "lastName": lastName,
        'photoUrl': photoUrl,
        "phoneNumber": phoneNumber,
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
  Future<bool> updateUserProfile({
    required String userName,
    required String? photoUrl,
    required String email,
    required String firstName,
    required String lastName,
    required String phoneNumber,
  }) async {
    try {
      userCollectionReference.doc(firebaseAuth.currentUser!.uid).set({
        'userName': userName,
        "firstName": firstName,
        "lastName": lastName,
        'photoUrl': photoUrl,
        "phoneNumber": phoneNumber,
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
}
