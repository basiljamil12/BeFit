import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mybefitapp/views/controlflow/main_redirect.dart';
import 'package:mybefitapp/views/homescreen_view.dart';
import 'package:mybefitapp/views/login_view.dart';
import 'package:mybefitapp/views/register_view.dart';
import 'package:mybefitapp/utilities/constant_routes.dart';
import 'package:mybefitapp/views/verify_email_view.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //alarminit();
  runApp(const MyApp());
}

void alarminit() async {
  await AndroidAlarmManager.initialize();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BeFit',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: const Redirect(),
      routes: {
        registerScreen: (context) => const RegisterView(),
        homeScreen: (context) => const HomePage(),
        loginScreen: (context) => const LoginView(),
        verifyEmail: (context) => const VerifyEmail(),
      },
    );
  }
}
