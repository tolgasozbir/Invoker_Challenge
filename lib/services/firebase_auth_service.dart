import 'dart:developer';
import 'package:dota2_invoker/services/user_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'app_services.dart';

class FirebaseAuthService {
  FirebaseAuthService._();

  static FirebaseAuthService? _instance;
  static FirebaseAuthService get instance => _instance ??= FirebaseAuthService._();

  final _firebaseAuth = FirebaseAuth.instance;
  
  User? get getCurrentUser => _firebaseAuth.currentUser;
  
  Future<void> signIn({required String email, required String password}) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        //fetch records from firebase
        var user = await UserManager.instance.getUserFromDb(userCredential.user!.uid);
        //set locale
        await UserManager.instance.setAndSaveUserToLocale(user!);
      }
    } on FirebaseAuthException catch (error) {
      log(getErrorMessage(error.code));
    } catch (error) {
      log(getErrorMessage(error.toString()));
    }
  }

  Future<void> signUp({required String email, required String password, required String username}) async {
    try {
      var user = UserManager.instance.user;
      if (user == null) throw Exception("User could not be created!");

      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        user.uid = userCredential.user!.uid; //set uid
        user.nickname = username; //set username
        //set locale
        await UserManager.instance.setAndSaveUserToLocale(user);
        //set firebase
        await AppServices.instance.databaseService.createOrUpdateUser(user);
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
    //create new guest user
    var newGuestUser = UserManager.instance.createUser();
    //create new guest user and set locale
    await UserManager.instance.setAndSaveUserToLocale(newGuestUser);
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
