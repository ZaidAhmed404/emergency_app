import 'package:firebase_auth/firebase_auth.dart';

abstract class UserRepository {
  Future<bool> saveUserProfile(User? user, String userName, String photoUrl);
}
