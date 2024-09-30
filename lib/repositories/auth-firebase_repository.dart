import 'package:daylyse/interfaces/auth_interface.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthFirebaseRepository implements AuthInterface {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<Map<String, dynamic>?> createAccount(
      String name, String email, String password) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      credential.user!.updateDisplayName(name);
      return {
        "id": credential.user!.uid,
        "email": credential.user!.email,
        "name": credential.user!.displayName ?? name
      };
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        throw 'The account already exists for that email.';
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  @override
  Future<Map<String, dynamic>?> getCurrentUser() {
    // TODO: implement getCurrentUser
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>?> signIn(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      return {
        "id": credential.user!.uid,
        "email": credential.user!.email,
        "name": credential.user!.displayName
      };
    } on FirebaseAuthException catch (e) {
      throw e.message!;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> signOut() {
    // TODO: implement signOut
    throw UnimplementedError();
  }
}
