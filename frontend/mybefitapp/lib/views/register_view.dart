import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mybefitapp/model/user_model.dart';
import 'package:mybefitapp/services/auth/auth_service.dart';
import 'package:mybefitapp/services/auth/auth_user.dart';
import 'package:mybefitapp/utilities/constants.dart';
import 'package:intl/intl.dart';
import 'package:mybefitapp/services/Api/api_call.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _username;
  late final TextEditingController _name;
  late final TextEditingController _gender;
  late final TextEditingController _dob;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _username = TextEditingController();
    _name = TextEditingController();
    _gender = TextEditingController();
    _dob = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _username.dispose();
    _name.dispose();
    _gender.dispose();
    _dob.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: Colors.pinkAccent,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          // Wrap with SingleChildScrollView
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Registration',
                  style: TextStyle(
                    fontSize: 35.0,
                    color: Colors.pink,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 32.0),
                TextField(
                  controller: _username,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    hintText: 'Username',
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: _email,
                  enableSuggestions: false,
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'Email',
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: _password,
                  enableSuggestions: false,
                  autocorrect: false,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: 'Password',
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: _name,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    hintText: 'Name',
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: _gender,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    hintText: 'Gender',
                  ),
                ),
                const SizedBox(height: 16.0),
                // TextField(
                //   controller: _dob,
                //   decoration: const InputDecoration(
                //     icon: Icon(Icons.calendar_today),
                //     hintText: "Enter Date",
                //   ),
                //   readOnly: true,
                //   onTap: () async {
                //     DateTime? pickedDate = await showDatePicker(
                //         context: context,
                //         initialDate: DateTime.now(),
                //         firstDate: DateTime(1950),
                //         lastDate: DateTime(2100));

                //     if (pickedDate != null) {
                //       print(pickedDate);
                //       String formattedDate =
                //           DateFormat('yyyy-MM-dd').format(pickedDate);
                //       print(formattedDate);
                //       setState(() {
                //         _dob.text = formattedDate;
                //       });
                //     } else {}
                //   },
                // ),
                const SizedBox(height: 24.0),
                ElevatedButton(
                  onPressed: () async {
                    final email = _email.text;
                    final password = _password.text;

                    try {
                      //await AuthService.firebase()
                      //    .createUser(email: email, password: password);
                      final username = _username.text;
                      final password = _password.text;
                      final name = _name.text;
                      final gender = _gender.text;
                      const dob = "a";
                      final email = _email.text;
                      final user = UserModel(
                        username: username,
                        password: password,
                        name: name,
                        gender: gender,
                        dob: dob,
                        email: email,
                      );
                      print(user.dob);
                      var response = await BaseClient()
                          .postUserApi('/userprofile', user)
                          .catchError((e) {});
                      print(response);
                      if (response == null) return;
                      print('user created');
                    } catch (e) {
                      print(e);
                    }
                  },
                  child: const Text('REGISTER'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await AuthService.firebase().logOut();
                  },
                  child: const Text('Logout'),
                ),
                const SizedBox(height: 80.0), // Add extra spacing at the bottom
              ],
            ),
          ),
        ),
      ),
    );
  }
}
