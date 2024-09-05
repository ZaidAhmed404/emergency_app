import 'package:emergency_app/domain/repositories/user_repository.dart';
import 'package:emergency_app/presentation/widgets/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepositoryImpl extends UserRepository {
  @override
  Future<bool> saveUserProfile(
      User? user, String userName, String photoUrl) async {
    // TODO: implement saveUserProfile
    try {
      await user?.updateDisplayName(userName);
      await user?.updatePhotoURL(photoUrl);
      return true;
    } catch (error) {
      await user?.delete();
      toastWidget(isError: true, message: "Some thing went wrong");
      return false;
    }
  }
}
