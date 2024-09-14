import 'package:emergency_app/data/models/user_model.dart';
import 'package:emergency_app/domain/services/email_services.dart';
import 'package:emergency_app/presentation/screens/complete_profile/complete_profile.dart';
import 'package:emergency_app/presentation/screens/login/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

import '../../core/messages.dart';
import '../../data/repositories/storage_repository.dart';
import '../../data/repositories/user_repository.dart';
import '../../main.dart';
import '../provider/user_provider.dart';
import '../screens/email_verification/email_verification.dart';
import '../screens/home/home.dart';
import '../widgets/toast.dart';

class UserController {
  final UserRepository userRepository;
  final StorageRepository storageRepository;
  final EmailServices emailServices;

  final Messages _messages = Messages();

  UserController(
      {required this.userRepository,
      required this.storageRepository,
      required this.emailServices});

  Future completeProfile(
      {required String userName,
      required String firstName,
      required String lastName,
      required String phoneNumber,
      required String url}) async {
    try {
      bool isSuccess = await userRepository.saveUserProfile(
          userName: userName,
          photoUrl: url,
          firstName: firstName,
          lastName: lastName,
          phoneNumber: phoneNumber);
      if (isSuccess == true) {
        toastWidget(isError: false, message: _messages.successfulLogin);
        navigatorKey.currentState?.pushReplacementNamed(HomeScreen.routeName);
      }
    } catch (error) {
      toastWidget(isError: true, message: error.toString());
      return null;
    }
  }

  Future editProfile(
      {required String userName,
      required String firstName,
      required String lastName,
      required String phoneNumber,
      required String url}) async {
    try {
      bool isSuccess = await userRepository.saveUserProfile(
          userName: userName,
          photoUrl: url,
          firstName: firstName,
          lastName: lastName,
          phoneNumber: phoneNumber);
      if (isSuccess == true) {
        toastWidget(
            isError: false, message: _messages.successfullyEditProfileMessage);
      }
    } catch (error) {
      toastWidget(isError: true, message: error.toString());
      return null;
    }
  }

  Future handleSendVerificationEmail() async {
    try {
      await emailServices.sendVerificationEmail();

      toastWidget(isError: false, message: _messages.emailSentMessage);
    } catch (error) {
      toastWidget(isError: true, message: error.toString());
    }
  }

  Future initializeSetting(WidgetRef ref) async {
    UserModel? userModel = await userRepository.getUserData();
    if (FirebaseAuth.instance.currentUser?.uid == null) {
      navigatorKey.currentState?.pushReplacementNamed(LoginScreen.routeName);
    } else if (userModel == null) {
      navigatorKey.currentState
          ?.pushReplacementNamed(CompleteProfileScreen.routeName);
    } else {
      final userNotifier = ref.watch(userNotifierProvider.notifier);
      userNotifier.updateUserModel(userModel: userModel);

      if (FirebaseAuth.instance.currentUser != null &&
          !FirebaseAuth.instance.currentUser!.emailVerified) {
        toastWidget(
            isError: false, message: _messages.emailVerificationMessage);
        navigatorKey.currentState
            ?.pushReplacementNamed(EmailVerificationScreen.routeName);
      } else {
        ZegoUIKitPrebuiltCallInvitationService().init(
          appID: 501718067,
          appSign:
              "d1dba58d9d0b63c472c182d25338a850fa32a61a47e23807de8f0e6179692c36",
          userID: FirebaseAuth.instance.currentUser!.uid,
          userName: ref.watch(userNotifierProvider).userName,
          plugins: [ZegoUIKitSignalingPlugin()],
        );
        toastWidget(isError: false, message: _messages.successfulLogin);

        navigatorKey.currentState?.pushReplacementNamed(HomeScreen.routeName);
      }
    }
  }

  Future<String?> handleUploadingNewProfileImage(
      {required String filePath, required String oldFilePath}) async {
    try {
      final isSuccess =
          await storageRepository.deleteImage(imageUrl: oldFilePath);
      if (isSuccess) {
        final url = await storageRepository.saveImage(filePath);
        return url;
      }
      return null;
    } catch (error) {
      toastWidget(isError: true, message: error.toString());
      return null;
    }
  }
}
