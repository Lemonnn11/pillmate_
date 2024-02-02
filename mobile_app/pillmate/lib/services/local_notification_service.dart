

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:pillmate/models/daily_med.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationService{

  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();


  static Future init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsDarwin =
    DarwinInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) => null);
    final LinuxInitializationSettings initializationSettingsLinux =
    LinuxInitializationSettings(
        defaultActionName: 'Open notification');
    final InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsDarwin,
        linux: initializationSettingsLinux);
    _flutterLocalNotificationsPlugin.initialize(initializationSettings, onDidReceiveNotificationResponse:(details) => null);
  }

  static Future showScheduleNotification(List<bool> notiList, DaileyMedModel daileyMedModel) async {
    print("dai list: " + daileyMedModel.morningTimeMinute.toString());
    print(notiList);
    tz.initializeTimeZones();
    final String? timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName!));
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    List<tz.TZDateTime> notiTime = [];
    for(int i = 0; i < notiList.length;i++){
      if(notiList[i] == true){
        switch(i){
          case 0: notiTime.add(tz.TZDateTime(tz.local, now.year, now.month, now.day, daileyMedModel.morningTimeHour, daileyMedModel.morningTimeMinute)); break;
          case 1: notiTime.add(tz.TZDateTime(tz.local, now.year, now.month, now.day, daileyMedModel.noonTimeHour, daileyMedModel.noonTimeMinute)); break;
          case 2: notiTime.add(tz.TZDateTime(tz.local, now.year, now.month, now.day, daileyMedModel.eveningTimeHour, daileyMedModel.eveningTimeMinute)); break;
          case 3: notiTime.add(tz.TZDateTime(tz.local, now.year, now.month, now.day, daileyMedModel.nightTimeHour, daileyMedModel.nightTimeMinute)); break;
        }
      }
    }
    print("jukru: " + notiTime.toString());
    // for(int i = 0;i < notiTime.length;i++){
    //   await _flutterLocalNotificationsPlugin.zonedSchedule(
    //       i,
    //       'Medication Notification',
    //       'Morning Medication!!!',
    //       notiTime[i],
    //       const NotificationDetails(
    //           android: AndroidNotificationDetails('your channel id', 'your channel name',
    //               channelDescription: 'your channel description')),
    //       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    //       uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime);
    // }
  }


  // static Future showSimpleNotification({
  //   required String title,
  //   required String body,
  //   required String payload,
  // }) async {
  //   const AndroidNotificationDetails androidNotificationDetails =
  //   AndroidNotificationDetails('your channel id', 'your channel name',
  //       channelDescription: 'your channel description',
  //       importance: Importance.max,
  //       priority: Priority.high,
  //       ticker: 'ticker');
  //   const NotificationDetails notificationDetails =
  //   NotificationDetails(android: androidNotificationDetails);
  //   await _flutterLocalNotificationsPlugin
  //       .show(0, title, body, notificationDetails, payload: payload);
  // }

  // static Future showScheduleNotification({
  //   required String title,
  //   required String body,
  //   required String payload,
  // }) async {
  //   tz.initializeTimeZones();
  //   print(tz.TZDateTime.now(tz.local).add(const Duration(hours: 7,seconds: 30)));
  //   await _flutterLocalNotificationsPlugin.zonedSchedule(
  //       0,
  //       title,
  //       body,
  //       tz.TZDateTime.now(tz.local).add(const Duration(hours: 7, seconds: 30)),
  //       const NotificationDetails(
  //           android: AndroidNotificationDetails(
  //               'channel 1', 'scheduled notification',
  //               channelDescription: 'notify daily notification',
  //               importance: Importance.max,
  //               priority: Priority.high,
  //               ticker: 'ticker')),
  //       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
  //       uiLocalNotificationDateInterpretation:
  //       UILocalNotificationDateInterpretation.absoluteTime, payload: payload);
  // }


  }