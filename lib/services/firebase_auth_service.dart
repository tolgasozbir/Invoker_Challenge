import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

import '../providers/user_manager.dart';
import '../widgets/app_snackbar.dart';
import 'app_services.dart';

class FirebaseAuthService {
  FirebaseAuthService._();

  static FirebaseAuthService? _instance;
  static FirebaseAuthService get instance => _instance ??= FirebaseAuthService._();

  final _firebaseAuth = FirebaseAuth.instance;
  
  User? get getCurrentUser => _firebaseAuth.currentUser;

  void errorSnackbar(String error) => AppSnackBar.showSnackBarMessage(
    text: error, 
    snackBartype: SnackBarType.error,
  );
  
  Future<bool> signIn({required String email, required String password}) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        //fetch records from firebase
        final user = await UserManager.instance.getUserFromDb(userCredential.user!.uid);
        //set locale
        await UserManager.instance.setAndSaveUserToLocale(user!);
        return true;
      }
      return false;
    } on FirebaseAuthException catch (error) {
      log(getErrorMessage(error.code));
      errorSnackbar(getErrorMessage(error.code));
      return false;
    } catch (error) {
      log(getErrorMessage(error.toString()));
      errorSnackbar(getErrorMessage(error.toString()));
      return false;
    }
  }

  Future<bool> signUp({required String email, required String password, required String username}) async {
    try {
      final user = UserManager.instance.user;
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        user.uid = userCredential.user!.uid; //set uid
        user.username = username; //set username
        //set locale
        await UserManager.instance.setAndSaveUserToLocale(user);
        //set firebase
        await AppServices.instance.databaseService.createOrUpdateUser(user);
        return true;
      }
      return false;
    } on FirebaseAuthException catch (error) {
      log(getErrorMessage(error.code));
      errorSnackbar(getErrorMessage(error.code));
      return false;
    } catch (error) {
      log(getErrorMessage(error.toString()));
      errorSnackbar(getErrorMessage(error.toString()));
      return false;
    }
  }

  Future<void> resetPassword({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (error) {
      log(getErrorMessage(error.code));
      errorSnackbar(getErrorMessage(error.code));
    } catch (error) {
      log(getErrorMessage(error.toString()));
      errorSnackbar(getErrorMessage(error.toString()));
    }
  }  
  
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
      //delete locale records
      await AppServices.instance.localStorageService.deleteAllValues();
      //create new guest user
      final newGuestUser = UserManager.instance.createUser();
      //create new guest user and set locale
      await UserManager.instance.setAndSaveUserToLocale(newGuestUser);
    } on FirebaseAuthException catch (error) {
      log(getErrorMessage(error.code));
      errorSnackbar(getErrorMessage(error.code));
    } catch (error) {
      log(getErrorMessage(error.toString()));
      errorSnackbar(getErrorMessage(error.toString()));
    }
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
