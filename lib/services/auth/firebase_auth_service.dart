import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

import '../../constants/locale_keys.g.dart';
import '../../extensions/string_extension.dart';
import '../../widgets/app_snackbar.dart';
import 'IFirebaseAuthService.dart';

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

  String _getErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'invalid-email':
        return LocaleKeys.authErrorMessages_AuthInvalidMail.locale;
      case 'user-not-found':
        return LocaleKeys.authErrorMessages_AuthUserNotFound.locale;
      case 'wrong-password':
        return LocaleKeys.authErrorMessages_AuthWrongPassword.locale;
      case 'weak-password':
        return LocaleKeys.authErrorMessages_AuthWeakPassword.locale;
      case 'email-already-in-use':
        return LocaleKeys.authErrorMessages_AuthEmailAlreadyInUse.locale;
      case 'unknown':
        return LocaleKeys.authErrorMessages_AuthUnknown.locale;
      case 'too-many-requests':
        return LocaleKeys.authErrorMessages_AuthToManyRequests.locale;
      default:
        return LocaleKeys.authErrorMessages_AuthDefaultError.locale;
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
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      if (userCredential.user == null) throw Exception(LocaleKeys.authErrorMessages_AuthDefaultError.locale);
    });
    return isSuccess;
  }

  @override
  Future<bool> signUp({required String email, required String password, required String username}) async {
    final bool isSuccess = await _handleAsyncAuthOperation(() async {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential.user == null) throw Exception(LocaleKeys.authErrorMessages_AuthDefaultError.locale);
    });
    return isSuccess;
  }

  @override
  Future<bool> resetPassword({required String email}) async {
    return _handleAsyncAuthOperation(() async => _firebaseAuth.sendPasswordResetEmail(email: email));
  }

  @override
  Future<void> signOut() async {
    await _handleAsyncAuthOperation(() async => _firebaseAuth.signOut());
  }

}
