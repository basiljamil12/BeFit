import 'package:flutter/material.dart';
import 'package:mybefitapp/model/body_model.dart';
import 'package:mybefitapp/services/Api/body_api_call.dart';
import 'package:mybefitapp/services/auth/auth_service.dart';
import 'package:mybefitapp/services/libraries/body_service.dart';
import 'package:mybefitapp/utilities/app_styles.dart';
import 'package:mybefitapp/views/tabs/sheets/add_body_sheet.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  late Future<dynamic> _bodyData;
  int _editStep = 0;
  late final TextEditingController _height;
  late final TextEditingController _weight;
  String email = AuthService.firebase().currentUser?.email.toString() ?? '';

  @override
  void initState() {
    _height = TextEditingController();
    _weight = TextEditingController();
    super.initState();
    String email = AuthService.firebase().currentUser?.email.toString() ?? '';
    //REMINDER TO SELF: INSTEAD OF TYPED EMAIL, USE VARIABLE WHEN WORKING ON DISPLAYING BODY MEASUREMENTS
    _bodyData = BodyClient().checkAndGetBody(email);
  }

  @override
  void dispose() {
    _height.dispose();
    _weight.dispose();
    super.dispose();
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

  BodyModel createBodyModel() {
    String emailReal = email;
    int height = int.parse(_height.text);
    int weight = int.parse(_weight.text);

    return BodyModel(height: height, weight: weight, email: emailReal);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      color: Styles.bgColor,
      child: SingleChildScrollView(
        child: Column(
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
                        shaderCallback: (bounds) => const LinearGradient(
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
                  padding: EdgeInsets.fromLTRB(45.0, 15.0, 0.0, 15.0),
                  child: Text(
                    'Body',
                    style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
            FutureBuilder(
              future: _bodyData,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final model = snapshot.data!;
                  BodyModel forBody = bodyModelFromJson(model);
                  int height = forBody.height;
                  int weight = forBody.weight;
                  String id = forBody.id!;
                  String bmi = BodyClient().forBmi(height, weight).toString();
                  //REMINDER TO SELF: WORK FOR DISPLAYING BODY MEASUREMENTS HERE
                  return Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.white,
                        ),
                        width: 320,
                        child: Column(
                          children: [
                            Text(
                              'Body Information',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.fromLTRB(
                                  10.0, 30.0, 10.0, 5.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Height:',
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                      Text(
                                        '${height.toString()} cm',
                                        style: const TextStyle(
                                          fontSize: 15.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Divider(
                                    color: Colors.grey,
                                    indent: 0,
                                    endIndent: 0,
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Weight:',
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                      Text(
                                        '${weight.toString()} kg',
                                        style: const TextStyle(
                                          fontSize: 15.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Divider(
                                    color: Colors.grey,
                                    indent: 0,
                                    endIndent: 0,
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'BMI:',
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                      Text(
                                        bmi,
                                        style: const TextStyle(
                                          fontSize: 15.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.white,
                        ),
                        width: 320,
                        child: _editStep == 0
                            ? ListTile(
                                onTap: _nextEdit,
                                title: const Text('Edit Body Information'),
                                trailing: const Icon(
                                  Icons.arrow_right,
                                  color: Colors.pinkAccent,
                                ),
                              )
                            : Column(
                                children: [
                                  ListTile(
                                    onTap: _previousEdit,
                                    title: const Text('Edit Body Information'),
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
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        color: Styles.bgColor,
                                      ),
                                      child: Column(
                                        children: [
                                          const SizedBox(height: 10),
                                          TextField(
                                            controller: _height,
                                            enableSuggestions: false,
                                            autocorrect: false,
                                            decoration: const InputDecoration(
                                              hintText: 'Height',
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          TextField(
                                            controller: _weight,
                                            enableSuggestions: false,
                                            autocorrect: false,
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            decoration: const InputDecoration(
                                              hintText: 'Weight',
                                            ),
                                          ),
                                          const SizedBox(height: 16.0),
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
                                                )
                                              ],
                                            ),
                                            child: ElevatedButton(
                                              onPressed: () async {
                                                BodyModel body =
                                                    createBodyModel();
                                                var response =
                                                    await BaseBodyClient()
                                                        .putBodyApi(body, id)
                                                        .catchError((e) {});
                                                if (response == null) return;
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.transparent,
                                                disabledForegroundColor:
                                                    Colors.transparent,
                                                shadowColor: Colors.transparent,
                                                minimumSize: const Size(90, 30),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50.0),
                                                ),
                                              ),
                                              child: const Text(
                                                'Save',
                                                style: TextStyle(fontSize: 15),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.white,
                    ),
                    width: 320,
                    child: Column(
                      children: [
                        const Icon(
                          Icons.directions_run_rounded,
                          color: Colors.pinkAccent,
                          size: 100,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Add Body Measurements',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                              'You can add your body measurements here to keep track of them and view other related data.'),
                        ),
                        const SizedBox(height: 15),
                        DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [
                              Colors.redAccent,
                              Colors.pinkAccent,
                            ]),
                            borderRadius: BorderRadius.circular(20.0),
                            boxShadow: const <BoxShadow>[
                              BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.30),
                                blurRadius: 5,
                              )
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              showModalBottomSheet<void>(
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(25.0),
                                    topRight: Radius.circular(25.0),
                                  ),
                                ),
                                isScrollControlled: true,
                                useRootNavigator: true,
                                useSafeArea: true,
                                enableDrag: true,
                                context: context,
                                builder: (BuildContext context) {
                                  return const AddBody();
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              disabledForegroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              minimumSize: const Size(100, 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                            child: const Text(
                              'Get Started',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.white,
              ),
              width: 320,
              child: Column(
                children: const [
                  Text(
                    'About Body Measurements',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                        'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
