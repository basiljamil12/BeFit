import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mybefitapp/model/user_model.dart';
import 'package:mybefitapp/services/Api/user_api_call.dart';
import 'package:mybefitapp/services/auth/auth_service.dart';
import 'package:mybefitapp/utilities/app_styles.dart';
import 'package:mybefitapp/utilities/constant_routes.dart';
import 'package:mybefitapp/views/tabs/sheets/edit_user_sheet.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<dynamic> _userData;
  String emailForScreen =
      AuthService.firebase().currentUser?.email.toString() ?? '';
  int _currentStep = 0;
  int _editStep = 0;

  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _name;
  String _selectedGender = 'Male'; // Selected gender option
  late final TextEditingController _dob;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _name = TextEditingController();
    _dob = TextEditingController();
    super.initState();

    String email = AuthService.firebase().currentUser?.email.toString() ?? '';

    DateTime now = DateTime.now().toUtc();
    DateTime utcDate = DateTime.utc(now.year, now.month, now.day);

    _userData = BaseUserClient().getUserApi(email);
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _name.dispose();
    _dob.dispose();
    super.dispose();
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

  void _nextEdit() {
    setState(() {
      _editStep += 1;
    });
  }

  void _previousEdit() {
    setState(() {
      _editStep -= 1;
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
    return Scaffold(
      backgroundColor: Styles.bgColor,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.redAccent,
                    Colors.pinkAccent,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 2),
                    blurRadius: 6,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  FutureBuilder(
                    future: _userData,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final model = snapshot.data!;
                        UserModel jsonDataa = userModelFromJson(model);
                        String name = jsonDataa.name;
                        return Padding(
                          padding: const EdgeInsets.only(top: 40),
                          child: Text(
                            name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                              color: Colors.white,
                            ),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return const CircularProgressIndicator();
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  Text(
                    emailForScreen,
                    style: const TextStyle(
                      fontSize: 15.0,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FutureBuilder(
                        future: _userData,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final model = snapshot.data!;
                            UserModel jsonDataa = userModelFromJson(model);
                            String gender = jsonDataa.gender;
                            return Text(
                              'Gender: $gender',
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            return const CircularProgressIndicator();
                          }
                        },
                      ),
                      FutureBuilder(
                        future: _userData,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final model = snapshot.data!;
                            UserModel jsonDataa = userModelFromJson(model);
                            String dob = jsonDataa.dob.toString();
                            DateTime currentDate = DateTime.now();
                            DateTime birthDate =
                                DateFormat("yyyy-MM-dd HH:mm:ss.SSSZ")
                                    .parse(dob);

                            Duration ageDifference =
                                currentDate.difference(birthDate);
                            int ageInYears =
                                (ageDifference.inDays / 365).floor();
                            return Text(
                              'Age: $ageInYears',
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            return const CircularProgressIndicator();
                          }
                        },
                      ),
                    ],
                  ),
                  //more widgets tba here
                  const SizedBox(height: 100),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 180.0, 10.0, 10.0),
                child: Container(
                  width: 500,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.white,
                  ),
                  // Add your content for the second container here
                  child: Column(
                    children: [
                      Container(
                        padding:
                            const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 5.0),
                        child: Column(
                          children: [
                            ListTile(
                              onTap: () {
                                _previousStep();
                              },
                              title: const Text('View Profile Information'),
                              trailing: const Icon(
                                Icons.arrow_drop_down,
                                color: Colors.pinkAccent,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  20.0, 10.0, 20.0, 20.0),
                              child: Container(
                                padding: const EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  color: Styles.bgColor,
                                ),
                                child: FutureBuilder(
                                  future: _userData,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      final model = snapshot.data!;
                                      UserModel jsonDataa =
                                          userModelFromJson(model);
                                      String name = jsonDataa.name;
                                      String password = jsonDataa.password;
                                      String gender = jsonDataa.gender;
                                      String dob = jsonDataa.dob.toString();

                                      DateTime currentDate = DateTime.now();
                                      DateTime birthDate =
                                          DateFormat("yyyy-MM-dd HH:mm:ss.SSSZ")
                                              .parse(dob);

                                      Duration ageDifference =
                                          currentDate.difference(birthDate);
                                      int ageInYears =
                                          (ageDifference.inDays / 365).floor();
                                      return Column(
                                        children: [
                                          const SizedBox(height: 10),
                                          Container(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const Text(
                                                  'Name:',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                  ),
                                                ),
                                                Text(
                                                  name,
                                                  style: const TextStyle(
                                                    fontSize: 15.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Divider(
                                            color: Colors.grey,
                                            thickness: 1,
                                            indent: 0,
                                            endIndent: 0,
                                          ),
                                          const SizedBox(height: 10),
                                          Container(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const Text(
                                                  'Email:',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                  ),
                                                ),
                                                Text(
                                                  emailForScreen,
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Divider(
                                            color: Colors.grey,
                                            thickness: 1,
                                            indent: 0,
                                            endIndent: 0,
                                          ),
                                          const SizedBox(height: 10),
                                          Container(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const Text(
                                                  'Password:',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                  ),
                                                ),
                                                Text(
                                                  password,
                                                  style: const TextStyle(
                                                    fontSize: 15.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Divider(
                                            color: Colors.grey,
                                            thickness: 1,
                                            indent: 0,
                                            endIndent: 0,
                                          ),
                                          const SizedBox(height: 10),
                                          Container(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const Text(
                                                  'Gender:',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                  ),
                                                ),
                                                Text(
                                                  gender,
                                                  style: const TextStyle(
                                                    fontSize: 15.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Divider(
                                            color: Colors.grey,
                                            thickness: 1,
                                            indent: 0,
                                            endIndent: 0,
                                          ),
                                          const SizedBox(height: 10),
                                          Container(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const Text(
                                                  'Age:',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                  ),
                                                ),
                                                Text(
                                                  ageInYears.toString(),
                                                  style: const TextStyle(
                                                    fontSize: 15.0,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 15),
                                          DecoratedBox(
                                            decoration: BoxDecoration(
                                              gradient:
                                                  const LinearGradient(colors: [
                                                Colors.redAccent,
                                                Colors.pinkAccent,
                                              ]),
                                              borderRadius:
                                                  BorderRadius.circular(50.0),
                                              boxShadow: const <BoxShadow>[
                                                BoxShadow(
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 0.30),
                                                  blurRadius: 5,
                                                ),
                                              ],
                                            ),
                                            child: ElevatedButton(
                                              onPressed: () async {
                                                showModalBottomSheet<void>(
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(25.0),
                                                      topRight:
                                                          Radius.circular(25.0),
                                                    ),
                                                  ),
                                                  isScrollControlled: true,
                                                  useRootNavigator: true,
                                                  useSafeArea: true,
                                                  enableDrag: true,
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return const EditUser();
                                                  },
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.transparent,
                                                disabledForegroundColor:
                                                    Colors.transparent,
                                                shadowColor: Colors.transparent,
                                                minimumSize:
                                                    const Size(100, 40),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50.0),
                                                ),
                                              ),
                                              child: const Text(
                                                'Edit',
                                                style: TextStyle(
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                          ),
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
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
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
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () async {
                            await AuthService.firebase().logOut();
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              loginScreen,
                              (route) => false,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            disabledForegroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            minimumSize: const Size(100, 40),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                          ),
                          child: const Text(
                            'Sign Out',
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                      //work here
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
