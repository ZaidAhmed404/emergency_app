import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../domain/repositories/auth_repository.dart';
import '../../presentation/widgets/toast.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth firebaseAuth;

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
      toastWidget(isError: true, message: e.message.toString());
      return null;
    } catch (e) {
      toastWidget(
          isError: true, message: "Something Went Wrong. Please try again.");

      return null;
    }
  }

  @override
  Future<bool> signInWithEmail(String email, String password) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      toastWidget(isError: false, message: "User signIn Successfully");
      return true;
    } on FirebaseAuthException catch (e) {
      toastWidget(isError: true, message: e.message.toString());
      return false;
    } catch (e) {
      toastWidget(
          isError: true, message: "Something Went Wrong. Please try again.");
      return false;
    }
  }

  @override
  Future<bool> forgetPassword(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
      toastWidget(
          isError: false,
          message:
              "A password reset link has been sent to your email. Please check your inbox.");
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        toastWidget(isError: true, message: "No account found for this email.");
      } else {
        toastWidget(
            isError: true, message: "Something Went Wrong. Please try again.");
      }
      return false;
    } catch (error) {
      toastWidget(
          isError: true, message: "Something Went Wrong. Please try again.");
      return false;
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
      toastWidget(isError: false, message: "User SignIn successfully");
      return true;
    } catch (error) {
      toastWidget(
          isError: true, message: "Something Went Wrong. Please try again.");
      return false;
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      await firebaseAuth.signOut();

      toastWidget(isError: false, message: "User logout Successfully");
      return true;
    } catch (error) {
      toastWidget(isError: true, message: "User logout Failed");

      return false;
    }
  }
}
