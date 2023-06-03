import 'package:flutter/material.dart';
import 'package:mybefitapp/views/controlflow/main_redirect.dart';
import 'package:mybefitapp/views/homescreen_view.dart';
import 'package:mybefitapp/views/login_view.dart';
import 'package:mybefitapp/views/register_view.dart';
import 'package:mybefitapp/utilities/constant_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BeFit',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: const Redirect(),
      routes: {
        registerview: (context) => const RegisterView(),
        homeScreen: (context) => const HomePage(),
        loginScreen: (context) => const LoginView(),
      },
    );
  }
}
