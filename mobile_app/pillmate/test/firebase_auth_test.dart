import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pillmate/services/auth.dart';

import 'firebase_auth_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Auth>()])
void main() {

  test('description', () async {
    final auth = MockFirebaseAuth();
    final user = auth.createUserWithEmailAndPassword(email: 'bob@somedomain.com', password: 'bob123');


    final result = await auth.signInWithEmailAndPassword(email: 'bob@somedomain.com', password: 'bob123', );
    final email = await result.user?.email;
    expect(email, 'bob@somedomain.com');
  });

  test('test code sent pass', () async {
    String phoneNumber = '0812345678';
    final user = MockUser(
      isAnonymous: false,
      uid: 'someuid',
      email: 'bob@somedomain.com',
      displayName: 'Bob',
      phoneNumber: '0812345678'
    );
    final auth = MockFirebaseAuth(mockUser: user);
    final authService = Auth();
    authService.auth = auth;
    final verificationId = await authService.signInWithPhoneNumber(phoneNumber);-
    expect(verificationId, isNotEmpty);
    // PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId!, smsCode: '123456');
    // final result = await auth.signInWithCredential(credential);
    // expect(result.user?.phoneNumber, phoneNumber);
    // print(auth.currentUser);
  });

  test('test code sent failed', () async {
    final user = MockUser(
        isAnonymous: false,
        uid: 'someuid',
        email: 'bob@somedomain.com',
        displayName: 'Bob',
        phoneNumber: '0812345678'
    );
    final auth = MockFirebaseAuth(mockUser: user);
    final authService = MockAuth();
    authService.auth = auth;
    when(authService.signInWithPhoneNumber('xxxxxxx')).thenAnswer((_) async => 'The provided phone number is not valid.');
    final verificationId = await authService.signInWithPhoneNumber('xxxxxxx');
    expect(verificationId, 'The provided phone number is not valid.');
  });
}