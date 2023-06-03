import 'package:flutter/material.dart';
import 'package:mybefitapp/model/user_model.dart';
import 'package:mybefitapp/services/auth/auth_service.dart';
import 'package:mybefitapp/utilities/constant_routes.dart';

import '../services/Api/api_call.dart';

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

  Future<bool> fireBaseSignin() async {
    final email = _email.text;
    final password = _password.text;
    try {
      await AuthService.firebase().createUser(email: email, password: password);
      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }

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

  UserModel createUserModel() {
    String email = _email.text;
    String password = _password.text;
    String username = _username.text;
    String name = _name.text;
    String gender = _gender.text;
    DateTime dob = DateTime.parse(_dob.text);

    return UserModel(
      email: email,
      password: password,
      username: username,
      name: name,
      gender: gender,
      dob: dob,
    );
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
                    border: OutlineInputBorder(),
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
                    border: OutlineInputBorder(),
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
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: _name,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    hintText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: _gender,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    hintText: 'Gender',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: _dob,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.calendar_today),
                    hintText: 'Date of Birth',
                  ),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1950),
                        lastDate: DateTime(2100));

                    if (pickedDate != null) {
                      String formattedDate = pickedDate.toUtc().toString();
                      setState(() {
                        _dob.text = formattedDate;
                      });
                    } else {}
                  },
                ),
                const SizedBox(height: 24.0),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      final isTrue = await fireBaseSignin();
                      if (isTrue) {
                        UserModel user = createUserModel();
                        var response = await BaseClient()
                            .postUserApi(user)
                            .catchError((e) {});
                        if (response == null) return;
                        await AuthService.firebase().logOut();
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            loginScreen, (route) => false);
                      }
                    } catch (e) {
                      print(e);
                    }
                  },
                  child: const Text('REGISTER'),
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
