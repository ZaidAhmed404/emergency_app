import 'package:emergency_app/presentation/controllers/user_controller.dart';
import 'package:emergency_app/presentation/screens/home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/messages.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/user_repository.dart';
import '../../domain/services/email_services.dart';
import '../../main.dart';
import '../screens/login/login.dart';
import '../widgets/toast.dart';

class AuthController {
  final AuthRepository authRepository;
  final UserRepository userRepository;
  final EmailServices emailServices;
  final UserController userController;

  final Messages _messages = Messages();
  User? user = FirebaseAuth.instance.currentUser;

  AuthController(
      {required this.authRepository,
      required this.userRepository,
      required this.emailServices,
      required this.userController});

  Future handleSignUp(
      {required String email,
      required String firstName,
      required String lastName,
      required String password,
      required String userName,
      required String phoneNumber,
      required String url}) async {
    try {
      final user = await authRepository.signUpWithEmail(email, password);
      if (user != null) {
        bool isSuccess = await userRepository.saveUserProfile(
            userName: userName,
            photoUrl: url,
            firstName: firstName,
            lastName: lastName,
            phoneNumber: phoneNumber);
        if (isSuccess == true) {
          toastWidget(isError: false, message: _messages.successSignUpMessage);
          navigatorKey.currentState
              ?.pushReplacementNamed(LoginScreen.routeName);
        }
      }
    } catch (error) {
      toastWidget(isError: true, message: error.toString());
    }
  }

  Future handleSignInWithEmail(String email, String password) async {
    try {
      bool isSuccess = await authRepository.signInWithEmail(email, password);
      if (isSuccess) {
        await emailServices.sendVerificationEmail();
        userController.initializeSetting();
      }
    } catch (error) {
      toastWidget(isError: true, message: error.toString());
    }
  }

  Future handleSignOut() async {
    try {
      final isSuccess = await authRepository.signOut();
      if (isSuccess == true) {
        navigatorKey.currentState?.pushReplacementNamed(LoginScreen.routeName);
      }
    } catch (error) {
      toastWidget(isError: true, message: error.toString());
    }
  }

  Future<bool> handleForgetPassword(String email) async {
    final isSuccess = await authRepository.forgetPassword(email);
    return isSuccess;
  }

  Future handleSignInWithGoogle() async {
    final isSuccess = await authRepository.signInWithGoogle();
    if (isSuccess) {
      navigatorKey.currentState?.pushReplacementNamed(HomeScreen.routeName);
    }
  }
}
