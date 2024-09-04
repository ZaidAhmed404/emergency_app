

abstract class AuthRepository {
  Future<bool> signUpWithEmail(String email, String password);

  Future<bool> signInWithEmail(String email, String password);

  Future<void> signOut();
}
