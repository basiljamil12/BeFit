import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mybefitapp/services/auth/auth_service.dart';
import 'package:mybefitapp/services/libraries/steps_service.dart';
import 'package:mybefitapp/utilities/app_styles.dart';
import 'package:mybefitapp/views/widgets/monthly_step_chart.dart';
import 'package:mybefitapp/views/widgets/weekly_step_chart.dart';

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
      height: MediaQuery.of(context).size.height * 0.9,
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
                    double weeklyAverageBefore =
                        StepsClient().calculateAverageSteps(filteredList);
                    double weeklyAverage =
                        double.parse((weeklyAverageBefore).toStringAsFixed(2));

                    //LAST WEEK
                    List<dynamic> filteredPastWeekList =
                        StepsClient().filterStepsForPreviousWeek(stepList);
                    double pastWeeklyAverageBefore = StepsClient()
                        .calculateAverageSteps(filteredPastWeekList);
                    double pastWeeklyAverage = double.parse(
                        (pastWeeklyAverageBefore).toStringAsFixed(2));

                    //YEAR
                    List<dynamic> filteredYearList = StepsClient()
                        .filterStepsByYear(
                            stepList, DateTime.now().year.toInt());
                    double yearlyAverageBefore =
                        StepsClient().calculateAverageSteps(filteredYearList);
                    double yearlyAverage =
                        double.parse((yearlyAverageBefore).toStringAsFixed(2));

                    //LAST YEAR
                    List<dynamic> filteredLastYearList = StepsClient()
                        .filterStepsByYear(
                            stepList, DateTime.now().year.toInt() - 1);
                    double yearlyLastAverageBefore = StepsClient()
                        .calculateAverageSteps(filteredLastYearList);
                    double yearlyLastAverage = double.parse(
                        (yearlyLastAverageBefore).toStringAsFixed(2));

                    //MONTH
                    List<dynamic> filteredMonthList = StepsClient()
                        .filterStepsByMonth(
                            stepList,
                            DateTime.now().month.toInt(),
                            DateTime.now().year.toInt());
                    String monthName =
                        getMonthName(DateTime.now().month.toInt());
                    double monthlyAverageBefore =
                        StepsClient().calculateAverageSteps(filteredMonthList);
                    double monthlyAverage =
                        double.parse((monthlyAverageBefore).toStringAsFixed(2));

                    //LAST MONTH
                    List<dynamic> filteredLastMonthList = StepsClient()
                        .filterStepsByMonth(
                            stepList,
                            DateTime.now().month.toInt() - 1,
                            DateTime.now().year.toInt());
                    String lastmonthName =
                        getMonthName(DateTime.now().month.toInt() - 1);
                    double monthlyLastAverageBefore = StepsClient()
                        .calculateAverageSteps(filteredLastMonthList);
                    double monthlyLastAverage = double.parse(
                        (monthlyLastAverageBefore).toStringAsFixed(2));

                    //WORK
                    return Column(
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(20.0, 0.0, 15.0, 10.0),
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 20.0),
                            height: 240.0,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: Container(
                                    width: 265.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.white,
                                    ),
                                    child: const WeekChart(),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Container(
                                    width: 265.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.white,
                                    ),
                                    child: const MonthChart(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
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
                                      pastWeeklyAverage.toString(),
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
                                      monthlyAverage.toString(),
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
                                      monthlyLastAverage.toString(),
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
                                      yearlyAverage.toString(),
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
                                      yearlyLastAverage.toString(),
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
                        const SizedBox(height: 10.0),
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
                                'About Steps',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Text(
                                    'Step count is the number of steps you take throughout the day. Pedometers and digital activity trackers can help you determine your step count. these devices count steps for any activity that involves step-like movement, including walking, running, stair-climbing, cross-country skiing, and even movement as you go about your daily chores.'),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
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
