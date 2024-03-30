import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:pillmate/services/auth.dart';

@GenerateNiceMocks([MockSpec<Auth>()])
void main() {
  // Mock sign in with Google.
  // Sign in.

  test('description', () async {
    final auth = MockFirebaseAuth();
    final user = auth.createUserWithEmailAndPassword(email: 'bob@somedomain.com', password: 'bob123');


    final result = await auth.signInWithEmailAndPassword(email: 'bob@somedomain.com', password: 'bob123', );
    final email = await result.user?.email;
    expect(email, 'bob@somedomain.com');
  });

  test('test', () async {
    String phoneNumber = '0812345678';
    final user = MockUser(
      isAnonymous: false,
      uid: 'someuid',
      email: 'bob@somedomain.com',
      displayName: 'Bob',
      phoneNumber: '0812345678'
    );
    final auth = MockFirebaseAuth(mockUser: user);
    final authService = Auth(auth: auth);
    final verificationId = await authService.signInWithPhoneNumber(phoneNumber);
    expect(verificationId, isNotEmpty);
    // PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId!, smsCode: '123456');
    // final result = await auth.signInWithCredential(credential);
    // expect(result.user?.phoneNumber, phoneNumber);
    // print(auth.currentUser);
  });

  test('test', () async {
    String phoneNumber = 'xxxxxxx';
    final user = MockUser(
        isAnonymous: false,
        uid: 'someuid',
        email: 'bob@somedomain.com',
        displayName: 'Bob',
        phoneNumber: '0812345678'
    );
    final auth = MockFirebaseAuth(mockUser: user);
    final authService = Auth(auth: auth);
    final verificationId = await authService.signInWithPhoneNumber(phoneNumber);
    expect(verificationId, 'The provided phone number is not valid.');
  });
}