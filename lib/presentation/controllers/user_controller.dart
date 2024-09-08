import 'package:emergency_app/domain/repositories/storage_repository.dart';
import 'package:emergency_app/domain/repositories/user_repository.dart';

import '../widgets/toast.dart';

class UserController {
  final UserRepository userRepository;
  final StorageRepository storageRepository;

  UserController(
      {required this.userRepository, required this.storageRepository});

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

    final isSuccess =
        await userRepository.updateUserProfile(userName, photoUrl, email);
    if (isSuccess) {
      toastWidget(isError: false, message: "User Profile Updated Successfully");
    }
  }
}
