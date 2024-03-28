import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pillmate/services/auth.dart';

main() {
  // Mock sign in with Google.
  // Sign in.

  test('description', () async {
    final auth = MockFirebaseAuth();
    final user = auth.createUserWithEmailAndPassword(email: 'bob@somedomain.com', password: 'bob123');


    final result = await auth.signInWithEmailAndPassword(email: 'bob@somedomain.com', password: 'bob123', );
    final email = await result.user?.email;
    expect(email, 'bob@somedomain.com');
  });

  test('description', () async {
    final auth = MockFirebaseAuth();
    auth.createUserWithEmailAndPassword(email: 'bob@somedomain.com', password: 'bob123');
    final authService = Auth(auth: auth);
    expect(await authService.signIn(email: 'bob@somedomain.com', password: 'bob123'), "Success");
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
    PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId!, smsCode: '123456');
    final result = await auth.signInWithCredential(credential);
    expect(result.user?.phoneNumber, phoneNumber);
    print(auth.currentUser);
  });
}