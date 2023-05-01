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

  void _errorSnackbar(String error) => AppSnackBar.showSnackBarMessage(
    text: error, 
    snackBartype: SnackBarType.error,
  );

  String _getErrorMessage(String errorCode){
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

  Future<bool> _handleAsyncAuthOperation({required Future<void> Function() operation}) async {
    try {
      await operation.call();
      return true;
    } on FirebaseAuthException catch (error) {
      log(_getErrorMessage(error.code));
      _errorSnackbar(_getErrorMessage(error.code));
      return false;
    } catch (error) {
      log(_getErrorMessage(error.toString()));
      _errorSnackbar(_getErrorMessage(error.toString()));
      return false;
    }
  }

  Future<bool> signIn({required String email, required String password}) async {
    final bool isSuccess = await _handleAsyncAuthOperation(
      operation: () async {
        final userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
        if (userCredential.user != null) {
          //fetch records from firebase
          final user = await UserManager.instance.getUserFromDb(userCredential.user!.uid);
          //set locale
          await UserManager.instance.setAndSaveUserToLocale(user!);
        }
      },
    );
    return isSuccess;
  }

  Future<bool> signUp({required String email, required String password, required String username}) async {
    final bool isSuccess = await _handleAsyncAuthOperation(
      operation: () async {
        final user = UserManager.instance.user;
        final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
        if (userCredential.user != null) {
          user.uid = userCredential.user!.uid; //set uid
          user.username = username; //set username
          //set locale
          await UserManager.instance.setAndSaveUserToLocale(user);
          //set firebase
          await AppServices.instance.databaseService.createOrUpdateUser(user);
        }
      },
    );
    return isSuccess;
  }

  Future<void> resetPassword({required String email}) async {
    await _handleAsyncAuthOperation(
      operation: () async => _firebaseAuth.sendPasswordResetEmail(email: email),
    );
  }  
  
  Future<void> signOut() async {
    await _handleAsyncAuthOperation(
      operation: () async {
        await _firebaseAuth.signOut();
        //delete locale records
        await AppServices.instance.localStorageService.deleteAllValues();
        //create new guest user
        final newGuestUser = UserManager.instance.createUser();
        //create new guest user and set locale
        await UserManager.instance.setAndSaveUserToLocale(newGuestUser);
      },
    );
  }

}
