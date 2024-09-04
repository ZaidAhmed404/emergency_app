import 'package:emergency_app/Domain/Repositories/auth_repository.dart';

class AuthController {
  final AuthRepository authRepository;

  AuthController({required this.authRepository});

  // Method to handle sign-up logic
  Future<void> handleSignUp(String email, String password) async {
    await authRepository.signUpWithEmail(email, password);
  }

  // Method to handle sign-in logic
  Future<void> handleSignIn(String email, String password) async {
    await authRepository.signInWithEmail(email, password);
  }

  // Method to handle sign-out logic
  Future<void> handleSignOut() async {
    await authRepository.signOut();
  }
}
