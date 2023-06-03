import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mybefitapp/model/user_model.dart';
import 'package:mybefitapp/utilities/constants.dart';
import 'package:mybefitapp/services/Api/api_call.dart';

//THIS IS A TEST PAGE DO NOT TOUCH IT

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late Future<dynamic> _userData;

  @override
  void initState() {
    super.initState();
    _userData = BaseClient().getUserApi('userprofile');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: FutureBuilder<dynamic>(
          future: _userData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final model = snapshot.data!;
              return Column(
                children: <Widget>[
                  Text(model),
                ],
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
