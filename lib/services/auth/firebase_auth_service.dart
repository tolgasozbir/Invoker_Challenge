import 'dart:developer';

import 'package:dota2_invoker_game/services/auth/IFirebaseAuthService.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../user_manager.dart';
import '../../widgets/app_snackbar.dart';
import '../app_services.dart';

class FirebaseAuthService implements IFirebaseAuthService {
  FirebaseAuthService._();

  static FirebaseAuthService? _instance;
  static FirebaseAuthService get instance => _instance ??= FirebaseAuthService._();

  final _firebaseAuth = FirebaseAuth.instance;

  @override
  User? get currentUser => _firebaseAuth.currentUser;

  void _errorSnackbar(String error) => AppSnackBar.showSnackBarMessage(
    text: error,
    snackBartype: SnackBarType.error,
  );

  //TODO: ERROR CODES LANG
  String _getErrorMessage(String errorCode) {
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
        return 'Given values are empty';
      case 'too-many-requests':
        return 'We have blocked all requests from this device due to unusual activity. Try again later.';
      default:
        return 'Something went wrong, try again!';
    }
  }

  Future<bool> _handleAsyncAuthOperation(Future<void> Function() operation) async {
    try {
      await operation();
      return true;
    } on FirebaseAuthException catch (error) {
      log(error.code);
      log(_getErrorMessage(error.code));
      _errorSnackbar(_getErrorMessage(error.code));
      return false;
    } catch (error) {
      log(error.toString());
      log(_getErrorMessage(error.toString()));
      _errorSnackbar(_getErrorMessage(error.toString()));
      return false;
    }
  }

  @override
  Future<bool> signIn({required String email, required String password}) async {
    final bool isSuccess = await _handleAsyncAuthOperation(() async {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email,password: password);
      if (userCredential.user != null) {
        final user = await UserManager.instance.getUserFromDb(userCredential.user!.uid);
        await UserManager.instance.setAndSaveUserToLocale(user!);
      }
    });
    return isSuccess;
  }

  @override
  Future<bool> signUp({required String email, required String password, required String username}) async {
    final bool isSuccess = await _handleAsyncAuthOperation(() async {
      final user = UserManager.instance.user;
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email,password: password);
      if (userCredential.user != null) {
        user.uid = userCredential.user!.uid;
        user.username = username;
        await UserManager.instance.setAndSaveUserToLocale(user);
        await AppServices.instance.databaseService.createOrUpdateUser(user);
      }
    });
    return isSuccess;
  }

  @override
  Future<bool> resetPassword({required String email}) async {
    return _handleAsyncAuthOperation(() async => _firebaseAuth.sendPasswordResetEmail(email: email));
  }

  @override
  Future<void> signOut() async {
    await _handleAsyncAuthOperation(() async {
      await _firebaseAuth.signOut();
      await AppServices.instance.localStorageService.deleteAllValues();
      final newGuestUser = UserManager.instance.createUser();
      await UserManager.instance.setAndSaveUserToLocale(newGuestUser);
    });
  }

}
