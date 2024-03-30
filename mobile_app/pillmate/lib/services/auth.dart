import 'package:firebase_auth/firebase_auth.dart';

class Auth{
  final FirebaseAuth auth;

  Auth({required this.auth});

  Future<String?> signInWithPhoneNumber(String phoneNumber) async {
    String res = '';
    await auth.verifyPhoneNumber(
      phoneNumber: '+66 ' + phoneNumber,
      timeout: const Duration(seconds: 120),
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          res = 'The provided phone number is not valid.';
        }
      },
      codeSent: (verificationId, [forceResendingToken]) {
        res = verificationId;
      },
      codeAutoRetrievalTimeout: (verificationId) {},
    );
    return res;
  }

  Future<String?> verifyOTP(String verificationId, String code) async {
    try{
      PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: code);
      final user = await auth.signInWithCredential(credential);
      if (user != null) {
        return 'validated';
      }
    }catch (e) {
      if(e.toString().contains('invalid-verification')){
        return 'invalid-verification';
      }
      else if(e.toString().contains('Unable to establish connection')){
        return 'Unable to establish connection';
      }
    }
  }
}