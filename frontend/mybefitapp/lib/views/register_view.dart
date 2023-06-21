import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:mybefitapp/model/user_model.dart';
import 'package:mybefitapp/services/auth/auth_service.dart';
import 'package:mybefitapp/utilities/constant_routes.dart';
import 'package:mybefitapp/services/Api/user_api_call.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _confirmPassword;
  late final TextEditingController _name;
  String _selectedGender = 'Male'; // Selected gender option
  late final TextEditingController _dob;
  int _currentStep = 0;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _confirmPassword = TextEditingController();
    _name = TextEditingController();
    _dob = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    _name.dispose();
    _dob.dispose();
    super.dispose();
  }

  bool isPasswordMatch() {
    return _password.text == _confirmPassword.text;
  }

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

  void _nextStep() {
    setState(() {
      _currentStep += 1;
    });
  }

  void _previousStep() {
    setState(() {
      _currentStep -= 1;
    });
  }

  UserModel createUserModel() {
    String email = _email.text;
    String password = _password.text;
    String name = _name.text;
    String gender = _selectedGender;
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
    final screenWidth = MediaQuery.of(context).size.width;
    const aspectRatio = 16 / 12; // Replace with your image's aspect ratio
    final imageHeight = screenWidth / aspectRatio;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        // Wrap with SingleChildScrollView
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: screenWidth,
              height: imageHeight,
              child: Image.asset(
                'assets/image.png',
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
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
            ),
            const SizedBox(height: 16.0),
            _currentStep == 0
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Column(
                      children: [
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
                          controller: _confirmPassword,
                          enableSuggestions: false,
                          autocorrect: false,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Confirm Password',
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                width: 3,
                                color: Colors.pinkAccent,
                              ),
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
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
                                color: Color.fromRGBO(0, 0, 0, 0.30),
                                blurRadius: 5,
                              )
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () async {
                              if (isPasswordMatch()) {
                                _nextStep();
                              } else {
                                CoolAlert.show(
                                      context: context,
                                      type: CoolAlertType.error,
                                      confirmBtnColor: Colors.pinkAccent,
                                      text: "Passwords do not match!",
                                      // onConfirmBtnTap: () {
                                      //   Navigator.of(context).pop();
                                      // },
                                    );
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
                              'Next',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                loginScreen,
                                (route) => false,
                              );
                            },
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            child: ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: [Colors.red, Colors.pinkAccent],
                              ).createShader(bounds),
                              child: const Text(
                                'Already have an account? Sign in!',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Column(
                      children: [
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
                        DropdownButtonFormField<String>(
                          value: _selectedGender,
                          onChanged: (newValue) {
                            setState(() {
                              _selectedGender = newValue!;
                            });
                          },
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
                          items: <String>['Male', 'Female']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
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
                            ),
                          ),
                          readOnly: true,
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1950),
                              lastDate: DateTime(2100),
                            );

                            if (pickedDate != null) {
                              String formattedDate = pickedDate.toString();
                              setState(() {
                                _dob.text = formattedDate;
                              });
                            }
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
                                color: Color.fromRGBO(0, 0, 0, 0.30),
                                blurRadius: 5,
                              )
                            ],
                          ),
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
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      verifyEmail, (route) => false);
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
                        const SizedBox(height: 15.0),
                        SizedBox(
                          width: double.infinity,
                          child: TextButton(
                            onPressed: () {
                              try {
                                _previousStep();
                              } catch (e) {
                                print(e);
                              }
                            },
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            child: ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: [Colors.red, Colors.pinkAccent],
                              ).createShader(bounds),
                              child: const Text(
                                'Previous',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
