import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Future<User?> signUpWithEmail(String email, String password);

  Future<bool> signInWithEmail(String email, String password);

  Future<bool> signInWithGoogle();

  Future<bool> forgetPassword(String email);

  Future<void> signOut();
}
