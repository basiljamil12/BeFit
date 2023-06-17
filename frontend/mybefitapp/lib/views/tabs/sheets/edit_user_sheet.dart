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

  @override
  void initState() {
    _password = TextEditingController();
    _name = TextEditingController();
    _dob = TextEditingController();
    super.initState();

    String email = AuthService.firebase().currentUser?.email.toString() ?? '';


    _userData = BaseUserClient().getUserApi(email);

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
      height: MediaQuery.of(context).size.height * 0.7,
      color: Styles.bgColor,
      child: SingleChildScrollView(
        child: FutureBuilder(
          future: _userData,
          builder: (context, snapshot){
            if (snapshot.hasData){
final model = snapshot.data!;
UserModel forUser = userModelFromJson(model);
                String id = forUser.id!;
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
                          padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 15.0),
                          child: Text(
                            'Edit Body Measurements',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                );
            }else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return const CircularProgressIndicator();
              }
          }
        )
      )
    );
  }
}
