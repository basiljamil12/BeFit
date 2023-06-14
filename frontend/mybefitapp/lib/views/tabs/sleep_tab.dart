import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mybefitapp/model/sleep_model.dart';
import 'package:mybefitapp/services/auth/auth_service.dart';
import 'package:mybefitapp/services/libraries/sleep_service.dart';
import 'package:mybefitapp/utilities/app_styles.dart';
import 'package:mybefitapp/views/tabs/sheets/add_sleep_sheet.dart';

class Sleep extends StatefulWidget {
  const Sleep({super.key});

  @override
  State<Sleep> createState() => _SleepState();
}

class _SleepState extends State<Sleep> {
  late Future<dynamic> _sleepData;
  int _editStep = 0;
  String email = AuthService.firebase().currentUser?.email.toString() ?? '';

  @override
  void initState() {
    super.initState();
    //REMINDER TO SELF: INSTEAD OF TYPED EMAIL, USE VARIABLE WHEN WORKING ON DISPLAYING BODY MEASUREMENTS
    _sleepData = SleepClient().checkAndGetSleep(email);
  }

  Duration getDurationBetween(DateTime dateTime1, DateTime dateTime2) {
    DateTime startDateTime = dateTime1;
    DateTime endDateTime = dateTime2;

    // Swap the start and end DateTime if necessary
    if (startDateTime.isAfter(endDateTime)) {
      DateTime temp = startDateTime;
      startDateTime = endDateTime;
      endDateTime = temp;
    }

    Duration duration = endDateTime.difference(startDateTime);
    return duration;
  }

  String getQuality(int hours) {
    if (hours <= 3) {
      return "Bad";
    } else if (hours > 3 && hours <= 6) {
      return "Average";
    } else if (hours > 6 && hours <= 9) {
      return "Good";
    } else if (hours > 9) {
      return "Over Sleep";
    } else {
      return "Can't measure quality.";
    }
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
                  TimeOfDay startingtime =
                      TimeOfDay.fromDateTime(start.toLocal());
                  DateTime end = sleepy.endtime;
                  TimeOfDay endingtime = TimeOfDay.fromDateTime(end.toLocal());
                  Duration duration = getDurationBetween(start, end);
                  int hours = duration.inHours;
                  int minutes = duration.inMinutes % 60;
                  String forQuality = getQuality(hours);
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
                                      '${startingtime}',
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
                                      '${endingtime}',
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
