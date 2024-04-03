import 'dart:async';

import 'package:flutter_test/flutter_test.dart';

void main(){
  group('test start timer', () {
    test('start timer', () async {
      int secondss = 3;
      Duration duration = VerifyOTPTest.startTimer(secondss);
      await Future.delayed(Duration(seconds: secondss));
      expect(duration, Duration());
    });
  });
}

class VerifyOTPTest{
  static Duration startTimer(int secondss){
    Timer? timer;
    Duration duration = Duration();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      secondss--;
      if(secondss == 0){
        timer?.cancel();
      }
      duration = Duration(seconds: secondss);
    });
    return duration;
  }
}