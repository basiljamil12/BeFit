import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mybefitapp/model/user_model.dart';
import 'package:mybefitapp/utilities/constants.dart' as constants;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late Future<UserModel> _userData;

  @override
  void initState() {
    super.initState();
    _userData = getData();
  }

  Future<UserModel> getData() async {
    try {
      var res =
          await http.get(Uri.parse("http://192.168.100.2:5000/userprofile"));
      if (res.statusCode == 200) {
        var r = json.decode(res.body);
        return UserModel.fromJson(r);
      } else {
        throw Exception('HTTP request failed with status: ${res.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: FutureBuilder<UserModel>(
          future: _userData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final model = snapshot.data!;
              return Column(
                children: <Widget>[
                  Text(model.name ?? 'a'),
                  Text(model.username ?? 'a'),
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
