import 'package:firebase_auth/firebase_auth.dart';

class Auth{
  final FirebaseAuth auth;

  Auth({required this.auth});

  Future<String?> signIn({required String email, required String password}) async {
    try {
      await auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return "Success";
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> signInWithPhoneNumber(String phoneNumber) async {
    String id = '';
    await auth.verifyPhoneNumber(
      phoneNumber: '+66 ' + phoneNumber,
      timeout: const Duration(seconds: 120),
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        }
      },
      codeSent: (verificationId, [forceResendingToken]) {
        id = verificationId;
      },
      codeAutoRetrievalTimeout: (verificationId) {},
    );
    return id;
  }
}