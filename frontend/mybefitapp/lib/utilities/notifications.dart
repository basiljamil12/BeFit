
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Notifications{
  static Future initialize(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    const androidInitialize =  AndroidInitializationSettings('drawable/app_icon');
    const initializationSettings = InitializationSettings(android: androidInitialize);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static Future<void> scheduleOneTimeTimer(Duration scheduledTime, FlutterLocalNotificationsPlugin fln) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'check_app_notification',
      'your_channel_name',
      importance: Importance.high,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
        print('a');

    await AndroidAlarmManager.oneShot(
      scheduledTime,
      0, // Alarm ID
      () async {
         print('alarm go bzzzzzzzzz');
        // Trigger the local notification
        await fln.show(
          0, // Notification ID
          'Timer Expired', // Notification title
          'Your time is up', // Notification body
          platformChannelSpecifics,
        );
      },
      exact: true,
      wakeup: true,
      rescheduleOnReboot: true,
    );
  }
}