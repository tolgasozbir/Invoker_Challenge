import 'package:firebase_auth/firebase_auth.dart';

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
    await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
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
