import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class Notifications {
  static Future initlize(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    const androidInitialize =
        AndroidInitializationSettings('mipmap/ic_launcher');
    const initializationSettings =
        InitializationSettings(android: androidInitialize);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static Future<void> scheduleOneTimeTimer(
      Duration scheduledTime, FlutterLocalNotificationsPlugin fln) async {
    // Get the current timezone
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Karachi'));
    final String timeZoneName = tz.local.name;

    // Set the desired time for the notification
    final Time notificationTime = Time(11, 36, 0); // 8:00 AM
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'check_app_notification',
      'your_channel_name',
      importance: Importance.high,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await fln.zonedSchedule(
      0, // Notification ID
      'Notification Title',
      'Notification Body',
      tz.TZDateTime.now(tz.local).add(const Duration(minutes: 1)),
      platformChannelSpecifics,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
