abstract class AuthInterface {
  Future<Map<String,dynamic>?> createAccount(String name, String email, String password);
  Future<Map<String,dynamic>?> signIn(String email, String password);
  Future<void> signOut();
  Future<Map<String,dynamic>?> getCurrentUser();
}
