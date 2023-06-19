import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:cron/cron.dart';

var cronSchedule;

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
      String hour, String minute, FlutterLocalNotificationsPlugin fln) async {
    final cron = Cron();
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'check_app_notification',
      'your_channel_name',
      importance: Importance.high,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
        cronSchedule = cron.schedule(Schedule.parse('${minute} ${hour} * * *'), () async {
    await fln.show(
    0, // Notification ID
    'Sleep Reminder',
    'It is time to sleep!',
    platformChannelSpecifics,
  );
  });
    
  }
}
