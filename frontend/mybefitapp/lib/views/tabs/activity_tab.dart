import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mybefitapp/model/step_model.dart';
import 'package:mybefitapp/services/Api/step_api_call.dart';
import 'package:mybefitapp/services/auth/auth_service.dart';
import 'package:mybefitapp/services/libraries/steps_service.dart';
import 'package:mybefitapp/utilities/app_styles.dart';

class Activity extends StatefulWidget {
  const Activity({super.key});

  @override
  State<Activity> createState() => _ActivityState();
}

class _ActivityState extends State<Activity> {
  late Future<dynamic> _stepData;
  String email = AuthService.firebase().currentUser?.email.toString() ?? '';

  String getMonthName(int monthNumber) {
    return DateFormat('MMMM').format(DateTime(0, monthNumber));
  }

  @override
  void initState() {
    super.initState();
    //call step service here to get all steps
    _stepData = StepsClient().getAllStepData(email);
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
                    'Activity',
                    style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            FutureBuilder(
                future: _stepData,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final model = snapshot.data!;
                    List<dynamic> stepList =
                        StepsClient().parseJsonToList(model);
                    //WEEK
                    List<dynamic> filteredList =
                        StepsClient().filterStepsList(stepList);
                    double weeklyAverage =
                        StepsClient().calculateAverageSteps(filteredList);
                    //YEAR
                    List<dynamic> filteredYearList = StepsClient()
                        .filterStepsByYear(
                            stepList, DateTime.now().year.toInt());
                    double yearlyAverage =
                        StepsClient().calculateAverageSteps(filteredYearList);
                    //MONTH
                    List<dynamic> filteredMonthList = StepsClient()
                        .filterStepsByMonth(
                            stepList,
                            DateTime.now().month.toInt(),
                            DateTime.now().year.toInt());
                    String monthName =
                        getMonthName(DateTime.now().month.toInt());
                    String lastmonthName =
                        getMonthName(DateTime.now().month.toInt() - 1);
                    double monthlyAverage =
                        StepsClient().calculateAverageSteps(filteredMonthList);
                    return Column(
                      children: [
                        Row(
                          children: const [
                            Padding(
                              padding:
                                  EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 10.0),
                              child: Text(
                                'Highlights: ',
                                style: TextStyle(
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Colors.white,
                          ),
                          width: 320,
                          child: Column(
                            children: [
                              Row(
                                children: const [
                                  Icon(
                                    Icons.local_fire_department_rounded,
                                    color: Colors.pinkAccent,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      'Steps',
                                      style: TextStyle(
                                        color: Colors.pink,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    5.0, 8.0, 5.0, 8.0),
                                child: Text(
                                  "You're averaging more steps a day this year than last year.",
                                ),
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        8.0, 8.0, 4.0, 8.0),
                                    child: Text(
                                      weeklyAverage.toString(),
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'steps/day',
                                  ),
                                ],
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  color: Colors.pinkAccent,
                                ),
                                width: 280,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('This Week'),
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        8.0, 8.0, 4.0, 8.0),
                                    child: Text(
                                      weeklyAverage.toString(),
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'steps/day',
                                  ),
                                ],
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  color: Colors.grey,
                                ),
                                width: 280,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('Last Week'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Container(
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Colors.white,
                          ),
                          width: 320,
                          child: Column(
                            children: [
                              Row(
                                children: const [
                                  Icon(
                                    Icons.local_fire_department_rounded,
                                    color: Colors.pinkAccent,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      'Steps',
                                      style: TextStyle(
                                        color: Colors.pink,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    5.0, 8.0, 5.0, 8.0),
                                child: Text(
                                  "You're averaging more steps a day this year than last year.",
                                ),
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        8.0, 8.0, 4.0, 8.0),
                                    child: Text(
                                      weeklyAverage.toString(),
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'steps/day',
                                  ),
                                ],
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  color: Colors.pinkAccent,
                                ),
                                width: 280,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(monthName),
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        8.0, 8.0, 4.0, 8.0),
                                    child: Text(
                                      weeklyAverage.toString(),
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'steps/day',
                                  ),
                                ],
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  color: Colors.grey,
                                ),
                                width: 280,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(lastmonthName),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Container(
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Colors.white,
                          ),
                          width: 320,
                          child: Column(
                            children: [
                              Row(
                                children: const [
                                  Icon(
                                    Icons.local_fire_department_rounded,
                                    color: Colors.pinkAccent,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      'Steps',
                                      style: TextStyle(
                                        color: Colors.pink,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    5.0, 8.0, 5.0, 8.0),
                                child: Text(
                                  "You're averaging more steps a day this year than last year.",
                                ),
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        8.0, 8.0, 4.0, 8.0),
                                    child: Text(
                                      weeklyAverage.toString(),
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'steps/day',
                                  ),
                                ],
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  color: Colors.pinkAccent,
                                ),
                                width: 280,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(DateTime.now().year.toString()),
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        8.0, 8.0, 4.0, 8.0),
                                    child: Text(
                                      weeklyAverage.toString(),
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'steps/day',
                                  ),
                                ],
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  color: Colors.grey,
                                ),
                                width: 280,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text((DateTime.now().year.toInt() - 1)
                                      .toString()),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return const CircularProgressIndicator();
                  }
                })
          ],
        ),
      ),
    );
  }
}
