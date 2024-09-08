import 'package:emergency_app/data/models/user_model.dart';

abstract class UserRepository {
  Future<bool> saveUserProfile({
    required String userName,
    required String? photoUrl,
    required String firstName,
    required String lastName,
    required String phoneNumber,
  });

  Future<bool> updateUserProfile({
    required String userName,
    required String? photoUrl,
    required String email,
    required String firstName,
    required String lastName,
    required String phoneNumber,
  });

  Future<UserModel?> getUserData();
}
