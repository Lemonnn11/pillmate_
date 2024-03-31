import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

class Auth{
  late FirebaseAuth auth;

  Future<String?> signInWithPhoneNumber(String phoneNumber) async {
    Completer<String?> completer = Completer<String?>();

    String res = '';

    await auth.verifyPhoneNumber(
      phoneNumber: '+66 ' + phoneNumber,
      timeout: const Duration(seconds: 120),
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          res = 'The provided phone number is not valid.';
        }
        completer.complete(res);
      },
      codeSent: (String verificationId, [int? forceResendingToken]) {
        res = verificationId;
        completer.complete(res);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        completer.complete(verificationId);
      },
    );

    return completer.future;
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