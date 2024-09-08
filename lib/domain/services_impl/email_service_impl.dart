import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

import '../../core/messages.dart';
import '../services/email_services.dart';

class EmailServicesImpl extends EmailServices {
  User? user = FirebaseAuth.instance.currentUser;
  final Messages _messages = Messages();

  @override
  Future sendVerificationEmail() async {
    try {
      if (user != null && !user!.emailVerified) {
        await user?.sendEmailVerification();
        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      log("$e", name: "error");
      throw ("${e.message}");
    } catch (error) {
      log("$error", name: "error");
      throw _messages.tryAgainMessage;
    }
  }
}
