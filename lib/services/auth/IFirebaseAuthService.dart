import 'package:firebase_auth/firebase_auth.dart';

abstract class IFirebaseAuthService {
  User? get currentUser;
  Future<bool> signIn({required String email, required String password});
  Future<bool> signUp({required String email, required String password, required String username});
  Future<bool> resetPassword({required String email});
  Future<void> signOut();
}
