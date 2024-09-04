import 'package:firebase_auth/firebase_auth.dart';

import '../../Domain/Repositories/auth_repository.dart';
import '../../presentation/widgets/toast.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth firebaseAuth;

  AuthRepositoryImpl(this.firebaseAuth);

  @override
  Future<bool> signUpWithEmail(String email, String password) async {
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      toastWidget(isError: true, message: e.message.toString());
      return false;
    } catch (e) {
      toastWidget(isError: true, message: "Something Went Wrong");

      return false;
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
      toastWidget(isError: true, message: e.message.toString());
      return false;
    } catch (e) {
      toastWidget(isError: true, message: "Something Went Wrong");
      return false;
    }
  }

  @override
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }
}
