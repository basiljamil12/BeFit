import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:mybefitapp/model/user_model.dart';
import 'package:mybefitapp/services/Api/user_api_call.dart';
import 'package:mybefitapp/services/auth/auth_service.dart';
import 'package:mybefitapp/utilities/app_styles.dart';

class EditUser extends StatefulWidget {
  const EditUser({super.key});

  @override
  State<EditUser> createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  late Future<dynamic> _userData;
  late final TextEditingController _name;
  late final TextEditingController _password;
  String _selectedGender = 'Male';
  late final TextEditingController _dob;

  String email = AuthService.firebase().currentUser?.email.toString() ?? '';

  @override
  void initState() {
    _password = TextEditingController();
    _name = TextEditingController();
    _dob = TextEditingController();
    super.initState();

    _userData = BaseUserClient().getUserApi(email);
  }

  UserModel createUserModel() {
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
  void dispose() {
    _password.dispose();
    _name.dispose();
    _dob.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.8,
        color: Styles.bgColor,
        child: SingleChildScrollView(
            child: FutureBuilder(
                future: _userData,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final model = snapshot.data!;
                    UserModel jsonDataa = userModelFromJson(model);
                    String name = jsonDataa.name;
                    String password = jsonDataa.password;
                    String dob = jsonDataa.dob.toString();
                    String id = jsonDataa.id.toString();

                    _name.text = name;
                    _password.text = password;
                    _dob.text = dob;
                    return Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: SizedBox(
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: ShaderMask(
                                    shaderCallback: (bounds) =>
                                        const LinearGradient(
                                      colors: [Colors.red, Colors.pinkAccent],
                                    ).createShader(bounds),
                                    child: const Text(
                                      'Back',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const Padding(
                              padding:
                                  EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 15.0),
                              child: Text(
                                'Edit Your Information',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.white,
                            ),
                            child: Column(children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Save Your Information',
                                  style: TextStyle(
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    30.0, 20.0, 30.0, 10.0),
                                child: TextField(
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
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    30.0, 0.0, 30.0, 10.0),
                                child: TextField(
                                  controller: _password,
                                  enableSuggestions: false,
                                  autocorrect: false,
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
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    30.0, 0.0, 30.0, 10.0),
                                child: DropdownButtonFormField<String>(
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
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    30.0, 0.0, 30.0, 10.0),
                                child: TextField(
                                  controller: _dob,
                                  decoration: InputDecoration(
                                    prefixIcon:
                                        const Icon(Icons.calendar_today),
                                    hintText: 'Date Of Birth',
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
                                      String formattedDate =
                                          pickedDate.toString();
                                      setState(() {
                                        _dob.text = formattedDate;
                                      });
                                    }
                                  },
                                ),
                              ),
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
                                    UserModel user = createUserModel();
                                    var response = await BaseUserClient()
                                        .putUserApi(user, id)
                                        .catchError((e) {});
                                    if (response == null) return;
                                    //DIALOG BOX THAT DISPLAYS 'SAVED'
                                    CoolAlert.show(
                                      context: context,
                                      type: CoolAlertType.success,
                                      text: "Information has been saved!",
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
                                    'Save',
                                    style: TextStyle(fontSize: 17.0),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15.0),
                            ]),
                          ),
                        )
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return const CircularProgressIndicator();
                  }
                })));
  }
}
