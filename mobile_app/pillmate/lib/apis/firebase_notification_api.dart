import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationApi{
  static final _firebaseMessaging = FirebaseMessaging.instance;

  static Future init() async {
    NotificationSettings settings =  await _firebaseMessaging.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
      await _requestNotificationPermission();
    }
    final token = await _firebaseMessaging.getToken();
    print(token);
  }

  static Future<void> _requestNotificationPermission() async {
    PermissionStatus status = await Permission.notification.request();

    if (status.isGranted) {
      print('Notification permission granted');
    } else {
      print('Notification permission denied');
      // Handle the case where permission is denied.
      // You may want to show a dialog explaining why the permission is necessary.
    }
  }
}