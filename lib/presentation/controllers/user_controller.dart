import 'package:emergency_app/domain/services/email_services.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/messages.dart';
import '../../data/repositories/storage_repository.dart';
import '../../data/repositories/user_repository.dart';
import '../../main.dart';
import '../screens/email_verification/email_verification.dart';
import '../screens/home/home.dart';
import '../widgets/toast.dart';

class UserController {
  final UserRepository userRepository;
  final StorageRepository storageRepository;
  final EmailServices emailServices;

  final Messages _messages = Messages();

  User? user = FirebaseAuth.instance.currentUser;

  UserController(
      {required this.userRepository,
      required this.storageRepository,
      required this.emailServices});

  Future handleUpdatingUserProfile(
      {required String email,
      String? imagePath,
      required String userName}) async {
    String? photoUrl;
    if (imagePath != null) {
      final isSuccess = await storageRepository.deleteImage();
      if (isSuccess) {
        photoUrl = await storageRepository.saveImage(imagePath);
      }
    }
  }

  Future handleSendVerificationEmail() async {
    try {
      await emailServices.sendVerificationEmail();
    } catch (error) {
      toastWidget(isError: true, message: error.toString());
    }
  }

  void initializeSetting() {
    if (user != null && !user!.emailVerified) {
      toastWidget(isError: false, message: _messages.emailVerificationMessage);
      navigatorKey.currentState
          ?.pushReplacementNamed(EmailVerificationScreen.routeName);
    } else {
      toastWidget(isError: false, message: _messages.successfulLogin);

      navigatorKey.currentState?.pushReplacementNamed(HomeScreen.routeName);
    }
  }
}
