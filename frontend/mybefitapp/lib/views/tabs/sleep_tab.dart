import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:mybefitapp/main.dart';
import 'package:mybefitapp/model/sleep_model.dart';
import 'package:mybefitapp/services/auth/auth_service.dart';
import 'package:mybefitapp/services/libraries/sleep_service.dart';
import 'package:mybefitapp/utilities/app_styles.dart';
import 'package:mybefitapp/utilities/notifications.dart';
import 'package:mybefitapp/views/tabs/sheets/add_sleep_sheet.dart';
import 'package:mybefitapp/views/tabs/sheets/edit_sleep_sheet.dart';

class Sleep extends StatefulWidget {
  const Sleep({super.key});

  @override
  State<Sleep> createState() => _SleepState();
}

class _SleepState extends State<Sleep> {
  late Future<dynamic> _sleepData;
  String email = AuthService.firebase().currentUser?.email.toString() ?? '';

  @override
  void initState() {
    super.initState();
    //await AndroidAlarmManager.initialize();
    //alarminit();
    Notifications.initlize(flutterLocalNotificationsPlugin);
    //REMINDER TO SELF: INSTEAD OF TYPED EMAIL, USE VARIABLE WHEN WORKING ON DISPLAYING BODY MEASUREMENTS
    _sleepData = SleepClient().checkAndGetSleep(email);
  }

  void alarminit() async {
    await AndroidAlarmManager.initialize();
  }

  String convertToAmPmFormat(String time) {
    DateFormat inputFormat =
        DateFormat.Hm(); // Input format: 24-hour format (e.g., 14:30)
    DateFormat outputFormat =
        DateFormat.jm(); // Output format: AM/PM format (e.g., 2:30 PM)

    DateTime dateTime = inputFormat.parse(time);
    String amPmTime = outputFormat.format(dateTime);

    return amPmTime;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
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
                    'Sleep',
                    style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
            FutureBuilder(
              future: _sleepData,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final model = snapshot.data!;
                  SleepModel sleepy = sleepModelFromJson(model);
                  DateTime start = sleepy.starttime;
                  int starthour = start.hour;
                  int startminute = start.minute;
                  DateTime end = sleepy.endtime;
                  int endhour = end.hour;
                  int endminute = end.minute;
                  Duration duration =
                      SleepClient().getDurationBetween(start, end);
                  int hours = duration.inHours;
                  int minutes = duration.inMinutes % 60;
                  String forQuality = SleepClient().getQuality(hours);
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
                        child: Column(children: [
                          Text(
                            'Sleep Schedule',
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
                                      'Start Time:',
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                    Text(
                                      convertToAmPmFormat(
                                          '${starthour}:${startminute}'),
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
                                      'End Time:',
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                    Text(
                                      convertToAmPmFormat(
                                          '${endhour}:${endminute}'),
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
                                      'Duration:',
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                    Text(
                                      '$hours hours $minutes minutes',
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
                                      'Quality:',
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                    Text(
                                      '$forQuality',
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
                        ]),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
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
                                return const EditSleep();
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
                            'Edit Sleep',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
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
                            Notifications.scheduleOneTimeTimer(
                                const Duration(seconds: 4),
                                flutterLocalNotificationsPlugin);
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
                            'noti',
                            style: TextStyle(fontSize: 20),
                          ),
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
                          CupertinoIcons.bed_double_fill,
                          color: Colors.pinkAccent,
                          size: 100,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Add Sleep Schedule',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                              'Your devices can help you get better sleep and understand your sleep patterns.'),
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
                                  return const AddSleep();
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
                    'About Sleep',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                        'Sleep provides insight into your sleep habits. Sleep trackers and monitors can help you determine the amount of time you are in bed and asleep. These devices estimate your time in bed and your time asleep by analyzing changes in physical actvitiy, including movement during the night. You can also keep track of your sleep by entering your own estimation of your bed time and sleep time manually.'),
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
