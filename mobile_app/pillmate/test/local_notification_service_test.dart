import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pillmate/services/local_notification_service.dart';

import 'local_notification_service_test.mocks.dart';

@GenerateNiceMocks([MockSpec<LocalNotificationService>()])
void main(){
  late MockLocalNotificationService localNotificationService;
  setUpAll(() {
    localNotificationService = MockLocalNotificationService();
  });
  
  group('test set schedule notification', () {
    test('set schedule notification based on when should it notifying and time', () {

    });
  });
}