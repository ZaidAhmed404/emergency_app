import 'package:firebase_auth/firebase_auth.dart';

import '../../Domain/Repositories/auth_repository.dart';
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
      toastWidget(isError: true, message: "Something Went Wrong");

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
      toastWidget(isError: true, message: "Something Went Wrong");
      return false;
    }
  }

  @override
  Future<void> signOut() async {
    await firebaseAuth.signOut();

    toastWidget(isError: false, message: "User logout Successfully");
  }
}
