import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pillmate/services/auth.dart';

import 'firebase_auth_test.mocks.dart';

@GenerateNiceMocks([MockSpec<FirebaseAuth>()])
void main() {
  late MockFirebaseAuth auth;
  late Auth authService;
  // final user = MockUser(
  //     isAnonymous: false,
  //     uid: 'someuid',
  //     email: 'bob@somedomain.com',
  //     displayName: 'Bob',
  //     phoneNumber: '+66812345678'
  // );

  setUpAll(() async {
    // auth = MockFirebaseAuth(mockUser: user);
    authService = Auth();
    // authService.auth = auth;
  });

  // group('test sent code from phoneNumber', () {
  //   test('test code sent pass', () async {
  //     String phoneNumber = '0812345678';
  //     when(authService.signInWithPhoneNumber(phoneNumber)).thenAnswer((_) async => 'AD8T5IsJEjZbC0X3KySGIDX7HXnIrUnWbKVSWqXrlgh32r-lQPWOlZmpQMNmjV2oeTebcywNVACiBXzCs3or7__7nxcGxIC4PjAhxHNuhBBipl9ZhQWu9bFiRLT-gDaYOuzDzcJK6hMOaZJ3CKQFeUfZZnp2ebCZKg');
  //     final verificationId = await authService.signInWithPhoneNumber(phoneNumber);
  //     expect(verificationId, 'AD8T5IsJEjZbC0X3KySGIDX7HXnIrUnWbKVSWqXrlgh32r-lQPWOlZmpQMNmjV2oeTebcywNVACiBXzCs3or7__7nxcGxIC4PjAhxHNuhBBipl9ZhQWu9bFiRLT-gDaYOuzDzcJK6hMOaZJ3CKQFeUfZZnp2ebCZKg');
  //   });
  //
  //   test('test code sent failed', () async {
  //     when(authService.signInWithPhoneNumber('xxxxxxx')).thenAnswer((_) async => 'The provided phone number is not valid.');
  //     final verificationId = await authService.signInWithPhoneNumber('xxxxxxx');
  //     expect(verificationId, 'The provided phone number is not valid.');
  //   });
  // });

  group('test verify OTP', () {
    // test('test verify passed', () async {
    //   when(authService.verifyOTP('AD8T5IsJEjZbC0X3KySGIDX7HXnIrUnWbKVSWqXrlgh32r-lQPWOlZmpQMNmjV2oeTebcywNVACiBXzCs3or7__7nxcGxIC4PjAhxHNuhBBipl9ZhQWu9bFiRLT-gDaYOuzDzcJK6hMOaZJ3CKQFeUfZZnp2ebCZKg', '123456')).thenAnswer((_) async => 'validated');
    //   final res = await authService.verifyOTP('AD8T5IsJEjZbC0X3KySGIDX7HXnIrUnWbKVSWqXrlgh32r-lQPWOlZmpQMNmjV2oeTebcywNVACiBXzCs3or7__7nxcGxIC4PjAhxHNuhBBipl9ZhQWu9bFiRLT-gDaYOuzDzcJK6hMOaZJ3CKQFeUfZZnp2ebCZKg', '123456');
    //   expect(res, 'validated');
    // });

    test('test verify failed', () async {
      // when(auth.signInWithCredential(PhoneAuthProvider.credential(verificationId: 'AD8T5IsJEjZbC0X3KySGIDX7HXnIrUnWbKVSWqXrlgh32r-lQPWOlZmpQMNmjV2oeTebcywNVACiBXzCs3or7__7nxcGxIC4PjAhxHNuhBBipl9ZhQWu9bFiRLT-gDaYOuzDzcJK6hMOaZJ3CKQFeUfZZnp2ebCZKg', smsCode: '111111'))).thenThrow(FirebaseAuthException(code: 'invalid-verification'));
      final res = await authService.verifyOTP('AD8T5IsJEjZbC0X3KySGIDX7HXnIrUnWbKVSWqXrlgh32r-lQPWOlZmpQMNmjV2oeTebcywNVACiBXzCs3or7__7nxcGxIC4PjAhxHNuhBBipl9ZhQWu9bFiRLT-gDaYOuzDzcJK6hMOaZJ3CKQFeUfZZnp2ebCZKg', '111111');
      expect(res, 'invalid-verification');
    });

    // test('test verify unable to create connection', () async {
    //   when(authService.verifyOTP('AD8T5IsJEjZbC0X3KySGIDX7HXnIrUnWbKVSWqXrlgh32r-lQPWOlZmpQMNmjV2oeTebcywNVACiBXzCs3or7__7nxcGxIC4PjAhxHNuhBBipl9ZhQWu9bFiRLT-gDaYOuzDzcJK6hMOaZJ3CKQFeUfZZnp2ebCZKg', '')).thenAnswer((_) async => 'Unable to establish connection');
    //   final res = await authService.verifyOTP('AD8T5IsJEjZbC0X3KySGIDX7HXnIrUnWbKVSWqXrlgh32r-lQPWOlZmpQMNmjV2oeTebcywNVACiBXzCs3or7__7nxcGxIC4PjAhxHNuhBBipl9ZhQWu9bFiRLT-gDaYOuzDzcJK6hMOaZJ3CKQFeUfZZnp2ebCZKg', '');
    //   expect(res, 'Unable to establish connection');
    // });
  });

}