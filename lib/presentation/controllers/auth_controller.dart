import 'package:emergency_app/Domain/Repositories/auth_repository.dart';
import 'package:emergency_app/domain/repositories/user_repository.dart';

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
    try {
      final user = await authRepository.signUpWithEmail(email, password);
      if (user != null) {
        bool isSuccess =
            await userRepository.saveUserProfile(user, userName, url);
        if (isSuccess == true) {
          toastWidget(
              isError: false,
              message: "User Registered Successfully. Please Login");
          navigatorKey.currentState
              ?.pushReplacementNamed(LoginScreen.routeName);
        }
      }
    } catch (error) {
      toastWidget(isError: false, message: "User Registered Failed");
    }
  }

  Future<void> handleSignIn(String email, String password) async {
    await authRepository.signInWithEmail(email, password);
  }

  Future<void> handleSignOut() async {
    await authRepository.signOut();
  }
}
