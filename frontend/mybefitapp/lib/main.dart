import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mybefitapp/services/auth/auth_user.dart';
import 'package:mybefitapp/views/homescreen_view.dart';
import 'package:mybefitapp/views/login_view.dart';
import 'package:mybefitapp/views/register_view.dart';
import 'package:mybefitapp/utilities/constant_routes.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mybefitapp/model/user_model.dart';
import 'package:mybefitapp/services/auth/auth_service.dart';
import 'package:mybefitapp/utilities/constant_routes.dart';
import 'package:mybefitapp/utilities/constants.dart';

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
      home: const MainHome(),
      routes: {
        registerview: (context) => const RegisterView(),
        homeScreen: (context) => const HomePage(),
      },
    );
  }
}

class MainHome extends StatelessWidget {
  const MainHome({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              // if (user.emailVerified) {
              //   return const NotesView();
              // } else {
              //   return const VerifyEmailView();
              // }
              return const HomePage();
            } else {
              return const LoginView();
            }
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
