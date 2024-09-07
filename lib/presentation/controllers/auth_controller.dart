
import 'package:emergency_app/domain/repositories/user_repository.dart';
import 'package:emergency_app/presentation/screens/home/home.dart';

import '../../domain/repositories/auth_repository.dart';
import '../../main.dart';
import '../screens/login/login.dart';
import '../widgets/toast.dart';

class AuthController {
  final AuthRepository authRepository;
  final UserRepository userRepository;

  AuthController({required this.authRepository, required this.userRepository});

  Future handleSignUp(
      {required String email,
      required String password,
      required String userName,
      required String url}) async {
    final user = await authRepository.signUpWithEmail(email, password);
    if (user != null) {
      bool isSuccess =
          await userRepository.saveUserProfile(user, userName, url);
      if (isSuccess == true) {
        toastWidget(
            isError: false,
            message: "User Registered Successfully. Please Login");
        navigatorKey.currentState?.pushReplacementNamed(LoginScreen.routeName);
      }
    }
  }

  Future handleSignInWithEmail(String email, String password) async {
    final isSuccess = await authRepository.signInWithEmail(email, password);
    if (isSuccess) {
      navigatorKey.currentState?.pushReplacementNamed(HomeScreen.routeName);
    }
  }

  Future handleSignOut() async {
    final isSuccess = await authRepository.signOut();
    if (isSuccess == true) {
      navigatorKey.currentState?.pushReplacementNamed(LoginScreen.routeName);
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
