import 'package:flutter/material.dart';
import 'package:mybefitapp/model/user_model.dart';
import 'package:mybefitapp/services/auth/auth_service.dart';
import 'package:mybefitapp/utilities/constant_routes.dart';

import '../services/Api/user_api_call.dart';

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
    _name = TextEditingController();
    _gender = TextEditingController();
    _dob = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _name.dispose();
    _gender.dispose();
    _dob.dispose();
    super.dispose();
  }

  UserModel createUserModel() {
    String email = _email.text;
    String password = _password.text;
    String name = _name.text;
    String gender = _gender.text;
    DateTime dob = DateTime.parse(_dob.text);

    return UserModel(
      email: email,
      password: password,
      name: name,
      gender: gender,
      dob: dob,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            // Wrap with SingleChildScrollView
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: const [
                      SizedBox(height: 32.0),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Create Account',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 35.0,
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Become a part of BeFit and stay healthy',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: _email,
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 3,
                          color: Colors.pinkAccent,
                        ),
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: _password,
                    enableSuggestions: false,
                    autocorrect: false,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 3,
                          color: Colors.pinkAccent,
                        ),
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: _name,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: InputDecoration(
                      hintText: 'Name',
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 3,
                          color: Colors.pinkAccent,
                        ),
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: _gender,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: InputDecoration(
                      hintText: 'Gender',
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 3,
                          color: Colors.pinkAccent,
                        ),
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: _dob,
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.calendar_today),
                        hintText: 'Date of Birth',
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                            width: 3,
                            color: Colors.pinkAccent,
                          ),
                          borderRadius: BorderRadius.circular(50),
                        )),
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
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [
                        Colors.redAccent,
                        Colors.pinkAccent,
                      ]),
                      borderRadius: BorderRadius.circular(50.0),
                      boxShadow: const <BoxShadow>[
                        BoxShadow(
                            color: Color.fromRGBO(
                                0, 0, 0, 0.30), //shadow for button
                            blurRadius: 5)
                      ],
                    ), //blur radius of shadow),
                    child: ElevatedButton(
                      onPressed: () async {
                        try {
                          final isTrue = await fireBaseSignin();
                          if (isTrue) {
                            UserModel user = createUserModel();
                            var response = await BaseUserClient()
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
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        disabledForegroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        minimumSize: const Size(150, 60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                      ),
                      child: const Text(
                        'Create Account',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  const SizedBox(
                      height: 80.0), // Add extra spacing at the bottom
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
