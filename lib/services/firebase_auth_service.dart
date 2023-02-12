import 'dart:developer';
import 'package:dota2_invoker/enums/local_storage_keys.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../utils/user_records.dart';
import 'app_services.dart';

class FirebaseAuthService {
  FirebaseAuthService._();

  static FirebaseAuthService? _instance;
  static FirebaseAuthService get instance => _instance ??= FirebaseAuthService._();

  final _firebaseAuth = FirebaseAuth.instance;
  
  User? get getCurrentUser => _firebaseAuth.currentUser;
  
  Future<void> signIn({required String email, required String password}) async {
    await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signUp({required String email, required String password, required String username}) async {
    try {
      var user = UserRecords.userModel;
      if (user == null) throw Exception("User could not be created!");

      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        user.uid = userCredential.user!.uid;
        user.nickname = username;
        await AppServices.instance.localStorageService.setStringValue(LocalStorageKey.UserRecords, user.toJson());
        await AppServices.instance.databaseService.createUser(user);
      }
    } on FirebaseAuthException catch (error) {
      log(getErrorMessage(error.code));
    } catch (error) {
      log(getErrorMessage(error.toString()));
    }
  }

  Future<void> resetPassword({required String email}) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }  
  
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  String getErrorMessage(String errorCode){
    switch (errorCode) {
      case 'invalid-email':
        return 'Invalid e-mail address.';
      case 'user-not-found':
        return 'Account not found';
      case 'wrong-password':
        return 'Password is invalid';
      case 'weak-password':
        return 'Password should be at least 6 characters.';
      case 'email-already-in-use':
        return 'The email address is already in use by another account.';
      case 'unknown':
        return 'Given values is empty';
      default: return 'Something went wrong, try again!';
    }
  }

}
