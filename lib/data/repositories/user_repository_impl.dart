import 'dart:developer';

import 'package:emergency_app/domain/repositories/user_repository.dart';
import 'package:emergency_app/presentation/widgets/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepositoryImpl extends UserRepository {
  final firebaseAuth = FirebaseAuth.instance;

  @override
  Future<bool> saveUserProfile(
      User? user, String userName, String photoUrl) async {
    // TODO: implement saveUserProfile
    try {
      await user?.updateDisplayName(userName);
      await user?.updatePhotoURL(photoUrl);
      return true;
    } catch (error) {
      await user?.delete();
      toastWidget(isError: true, message: "Some thing went wrong");
      return false;
    }
  }

  @override
  Future<bool> updateUserProfile(
      String userName, String? photoUrl, String email) async {
    try {
      await firebaseAuth.currentUser?.updateDisplayName(userName);
      await firebaseAuth.currentUser?.updateEmail(email);
      if (photoUrl != null) {
        await firebaseAuth.currentUser?.updatePhotoURL(photoUrl);
      }

      return true;
    } on FirebaseAuthException catch (e) {
      toastWidget(isError: true, message: e.message.toString());
      return false;
    } catch (error) {
      log("${error.toString()}");
      toastWidget(isError: true, message: "Some thing went wrong");

      return false;
    }
  }
}
