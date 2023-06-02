import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mybefitapp/model/user_model.dart';
import 'package:mybefitapp/services/auth/auth_service.dart';
import 'package:mybefitapp/utilities/constant_routes.dart';
import 'package:mybefitapp/utilities/constants.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<UserModel> postData(UserModel userModel) async {
    try {
      Map<String, dynamic> constants = Constants.getConstant();
      String postUrl = constants['userList'];

      var response = await http.post(
        Uri.parse(postUrl),
        body: userModel.toJson(),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        var r = json.decode(response.body);
        return UserModel.fromJson(r);
      } else {
        throw Exception(
            'HTTP request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Login',
                style: TextStyle(
                  fontSize: 35.0,
                  color: Colors.pink,
                ),
              ),
              const SizedBox(height: 32.0),
              TextField(
                controller: _email,
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _password,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: () async {
                  //NEEDS TO BE FIXED, DOES NOT WORK CURRENTLY (REMOVE WHEN FIXED)
                  //CREATE REGISTER VIEW FIRST
                  final email = _email.text;
                  final password = _password.text;
                  try {
                    //YOU DID NOT INTIALIZE FIREBASE DUMBASS
                    await AuthService.firebase()
                        .logIn(email: email, password: password);
                    final user = AuthService.firebase().currentUser;
                    if (user != null) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          homeScreen, (route) => false);
                    }
                  } catch (e) {
                    print(e);
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text('LOGIN'),
              ),
              const SizedBox(height: 16.0),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(registerview);
                },
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text('Not registered? Register now!'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
