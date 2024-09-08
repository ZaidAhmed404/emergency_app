import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../core/messages.dart';
import '../repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth firebaseAuth;
  final Messages _messages = Messages();

  AuthRepositoryImpl({
    required this.firebaseAuth,
  });

  @override
  Future<User?> signUpWithEmail(String email, String password) async {
    try {
      final UserCredential userCredential =
          await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      log("$e", name: "error");
      throw ("${e.message}");
    } catch (e) {
      log("$e", name: "error");
      throw (_messages.tryAgainMessage);
    }
  }

  @override
  Future<bool> signInWithEmail(String email, String password) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return true;
    } on FirebaseAuthException catch (e) {
      log("$e", name: "error");
      throw ("${e.message}");
    } catch (e) {
      log("$e", name: "error");
      throw (_messages.tryAgainMessage);
    }
  }

  @override
  Future<bool> forgetPassword(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);

      return true;
    } on FirebaseAuthException catch (e) {
      log("$e", name: "error");
      throw ("${e.message}");
    } catch (error) {
      log("$error", name: "error");
      throw (_messages.tryAgainMessage);
    }
  }

  @override
  Future<bool> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);

      return true;
    } on FirebaseAuthException catch (e) {
      log("$e", name: "error");
      throw ("${e.message}");
    } catch (error) {
      log("$error", name: "error");
      throw (_messages.tryAgainMessage);
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      await firebaseAuth.signOut();
      return true;
    } on FirebaseAuthException catch (e) {
      log("$e", name: "error");
      throw ("${e.message}");
    } catch (error) {
      log("$error", name: "error");
      throw (_messages.tryAgainMessage);
    }
  }
}
