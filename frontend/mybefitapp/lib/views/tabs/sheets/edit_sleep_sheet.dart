import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:mybefitapp/model/sleep_model.dart';
import 'package:mybefitapp/services/Api/sleep_api_call.dart';
import 'package:mybefitapp/services/auth/auth_service.dart';
import 'package:mybefitapp/services/libraries/sleep_service.dart';
import 'package:mybefitapp/utilities/app_styles.dart';

class EditSleep extends StatefulWidget {
  const EditSleep({super.key});

  @override
  State<EditSleep> createState() => _EditSleepState();
}

class _EditSleepState extends State<EditSleep> {
  late final TextEditingController _starttime;
  late final TextEditingController _endtime;
  String email = AuthService.firebase().currentUser?.email.toString() ?? '';
  late Future<dynamic> _sleepData;

  @override
  void initState() {
    _starttime = TextEditingController();
    _endtime = TextEditingController();

    super.initState();
    _sleepData = SleepClient().checkAndGetSleep(email);
  }

  @override
  void dispose() {
    _starttime.dispose();
    _endtime.dispose();
    super.dispose();
  }

  SleepModel createSleepModel() {
    DateTime starttime = DateTime.parse(_starttime.text);
    DateTime endtime = DateTime.parse(_endtime.text);

    return SleepModel(starttime: starttime, endtime: endtime, email: email);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
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
                  padding: EdgeInsets.fromLTRB(18.0, 15.0, 0.0, 15.0),
                  child: Text(
                    'Edit Sleep Schedule',
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
                child: FutureBuilder(
                    future: _sleepData,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final model = snapshot.data!;
                        SleepModel sleepy = sleepModelFromJson(model);
                        String id = sleepy.id!;
                        return Column(children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Edit your sleeping schedule',
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
                              controller: _starttime,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.bedtime_rounded),
                                hintText: 'Start Time',
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
                                TimeOfDay? selectedTime = await showTimePicker(
                                  initialTime: TimeOfDay.now(),
                                  context: context,
                                );
                                DateTime combinedDateTime = DateTime.now();
                                if (selectedTime != null) {
                                  DateTime currentDateTime =
                                      DateTime.now().toUtc();
                                  combinedDateTime = DateTime(
                                    currentDateTime.year,
                                    currentDateTime.month,
                                    currentDateTime.day,
                                    selectedTime.hour,
                                    selectedTime.minute,
                                  ).toUtc();
                                }
                                setState(() {
                                  _starttime.text = combinedDateTime.toString();
                                });
                              },
                            ), //GET SLEEP START TIME HERE
                          ),
                          const SizedBox(height: 16.0),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                                30.0, 0.0, 30.0, 10.0),
                            child: TextField(
                              controller: _endtime,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.sunny),
                                hintText: 'End Time',
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
                                TimeOfDay? selectedTime = await showTimePicker(
                                  initialTime: TimeOfDay.now(),
                                  context: context,
                                );
                                DateTime combinedDateTime = DateTime.now();
                                if (selectedTime != null) {
                                  DateTime currentDateTime =
                                      DateTime.now().toUtc();
                                  combinedDateTime = DateTime(
                                    currentDateTime.year,
                                    currentDateTime.month,
                                    currentDateTime.day,
                                    selectedTime.hour,
                                    selectedTime.minute,
                                  ).toUtc();
                                }
                                setState(() {
                                  _endtime.text = combinedDateTime.toString();
                                });
                              },
                            ), //GET SLEEP END TIME HERE
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
                                SleepModel sleep = createSleepModel();
                                var response = await BaseSleepClient()
                                    .putSleepApi(sleep, id)
                                    .catchError((e) {});
                                if (response == null) return;
                                //DIALOG BOX THAT DISPLAYS 'SAVED'
                                CoolAlert.show(
                                  context: context,
                                  type: CoolAlertType.success,
                                  text: "Information has been updated!",
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
                        ]);
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return const CircularProgressIndicator();
                      }
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
