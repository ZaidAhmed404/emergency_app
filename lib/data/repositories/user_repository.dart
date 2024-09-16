import 'package:emergency_app/data/models/user_model.dart';

import '../models/contact_model.dart';

abstract class UserRepository {
  Future<bool> saveUserProfile({
    required String userName,
    required String? photoUrl,
    required String firstName,
    required String lastName,
    required String phoneNumber,
  });

  Future<UserModel?> getUserData();

  Future updateToken();

  Future<List<String>> getEmergencyContactsTokens(
      {required List<ContactModel> contacts});
}
