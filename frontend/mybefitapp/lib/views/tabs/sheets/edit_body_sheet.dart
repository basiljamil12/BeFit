import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:mybefitapp/model/body_model.dart';
import 'package:mybefitapp/services/Api/body_api_call.dart';
import 'package:mybefitapp/services/auth/auth_service.dart';
import 'package:mybefitapp/services/libraries/body_service.dart';
import 'package:mybefitapp/utilities/app_styles.dart';

class EditBody extends StatefulWidget {
  const EditBody({super.key});

  @override
  State<EditBody> createState() => _EditBodyState();
}

class _EditBodyState extends State<EditBody> {
  late final TextEditingController _height;
  late final TextEditingController _weight;
  late Future<dynamic> _bodyData;
  String email = AuthService.firebase().currentUser?.email.toString() ?? '';

  @override
  void initState() {
    _height = TextEditingController();
    _weight = TextEditingController();
    _bodyData = BodyClient().checkAndGetBody(email);
    super.initState();
  }

  @override
  void dispose() {
    _height.dispose();
    _weight.dispose();
    super.dispose();
  }

  BodyModel createBodyModel() {
    String emailReal = email;
    int height = int.parse(_height.text);
    int weight = int.parse(_weight.text);

    return BodyModel(height: height, weight: weight, email: emailReal);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
        color: Styles.bgColor,
        border: Border.all(
          width: 1.0,
          color: Colors.black,
        ),
      ),
      child: SingleChildScrollView(
        child: FutureBuilder(
            future: _bodyData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final model = snapshot.data!;
                BodyModel forBody = bodyModelFromJson(model);
                String id = forBody.id!;
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
                              'Save your Height & Weight',
                              style: TextStyle(
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                                30.0, 20.0, 30.0, 0.0),
                            child: TextField(
                              controller: _height,
                              enableSuggestions: false,
                              autocorrect: false,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: 'Height',
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
                          const SizedBox(height: 16.0),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                                30.0, 0.0, 30.0, 10.0),
                            child: TextField(
                              controller: _weight,
                              enableSuggestions: false,
                              autocorrect: false,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: 'Weight',
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
                          const SizedBox(height: 16.0),
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
                                BodyModel body = createBodyModel();
                                var response = await BaseBodyClient()
                                    .putBodyApi(body, id)
                                    .catchError((e) {});
                                if (response == null) return;

                                await CoolAlert.show(
                                  context: context,
                                  type: CoolAlertType.success,
                                  confirmBtnColor: Colors.pinkAccent,
                                  text: "Information has been saved!",
                                  onConfirmBtnTap: () {
                                    Navigator.of(context).pop();// Pops two screens
                                  },
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
            }),
      ),
    );
  }
}
