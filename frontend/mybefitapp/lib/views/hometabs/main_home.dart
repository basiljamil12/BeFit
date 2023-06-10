import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mybefitapp/model/body_model.dart';
import 'package:mybefitapp/model/step_model.dart';
import 'package:mybefitapp/model/user_model.dart';
import 'package:mybefitapp/services/Api/user_api_call.dart';
import 'package:mybefitapp/services/auth/auth_service.dart';
import 'package:mybefitapp/services/libraries/steps_sensor.dart';
import 'package:mybefitapp/services/libraries/steps_service.dart';
import 'package:mybefitapp/utilities/app_styles.dart';
import 'package:mybefitapp/utilities/constant_routes.dart';
import 'package:mybefitapp/services/Api/body_api_call.dart';
import 'package:mybefitapp/views/widgets/step_chart.dart';

class MainHome extends StatefulWidget {
  const MainHome({Key? key}) : super(key: key);

  @override
  State<MainHome> createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  late Future<dynamic> _userData;
  late Future<dynamic> _stepData;
  late Future<dynamic> _bodyData;
  final StepTracker stepTracker = StepTracker();
  late Timer _timer;
  late Timer _updateSteps;
  String emailForScreen =
      AuthService.firebase().currentUser?.email.toString() ?? '';

  @override
  void initState() {
    super.initState();
    refreshData();

    DateTime now = DateTime.now().toUtc();
    DateTime utcDate = DateTime.utc(now.year, now.month, now.day);

    stepTracker.startTracking();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {});
    });
    _updateSteps = Timer.periodic(const Duration(seconds: 60), (_) {
      StepsClient().updateSteps(emailForScreen, utcDate, stepTracker.stepCount);
      stepTracker.stepCount = 0;
    });
  }

  @override
  void dispose() {
    stepTracker.stopTracking();
    _timer.cancel();
    _updateSteps.cancel();
    super.dispose();
  }

  Future<void> refreshData() async {
    String email = AuthService.firebase().currentUser?.email.toString() ?? '';

    DateTime now = DateTime.now().toUtc();
    DateTime utcDate = DateTime.utc(now.year, now.month, now.day);

    _userData = BaseUserClient().getUserApi(email);
    _stepData = StepsClient().getDataFromApiOrPostNew(email, '0', utcDate);
    _bodyData = BaseBodyClient().getBodyApi(email);

    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.bgColor,
      body: RefreshIndicator(
        onRefresh: refreshData,
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: 130.0,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.elliptical(
                      MediaQuery.of(context).size.width,
                      100.0,
                    ),
                  ),
                  color: Colors.pinkAccent,
                ),
              ),
              Column(
                children: [
                  const SizedBox(
                    height: 55,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Center(
                      child: FutureBuilder(
                        future: _userData,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final model = snapshot.data!;
                            UserModel jsonDataa = userModelFromJson(model);
                            String name = jsonDataa.name;
                            return Text(
                              'Welcome, $name',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
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
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(25.0, 70.0, 25.0, 0.0),
                    child: Row(
                      children: const [
                        Center(
                          child: Text(
                            'Daily Activities',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30.0,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          padding: const EdgeInsets.all(10.0),
                          child: ListTile(
                            leading:
                                const Icon(Icons.local_fire_department_rounded),
                            title: const Text('Steps'),
                            subtitle: FutureBuilder(
                              future: _stepData,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final model = snapshot.data!;
                                  StepModel forSteps = stepModelFromJson(model);
                                  return Text(
                                    forSteps.steps,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  return const CircularProgressIndicator();
                                }
                              },
                            ),
                            trailing: const Icon(Icons.arrow_right),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          padding: const EdgeInsets.all(10.0),
                          child: ListTile(
                            leading:
                                const Icon(Icons.local_fire_department_rounded),
                            title: const Text('Weight'),
                            subtitle: FutureBuilder(
                              future: _bodyData,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final model = snapshot.data!;
                                  BodyModel forBody = bodyModelFromJson(model);
                                  return Text(
                                    '${forBody.weight.toString()} kg',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  return const CircularProgressIndicator();
                                }
                              },
                            ),
                            trailing: const Icon(Icons.arrow_right),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          padding: const EdgeInsets.all(10.0),
                          child: ListTile(
                            leading:
                                const Icon(Icons.local_fire_department_rounded),
                            title: const Text('Height'),
                            subtitle: FutureBuilder(
                              future: _bodyData,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final model = snapshot.data!;
                                  BodyModel forBody = bodyModelFromJson(model);
                                  return Text(
                                    '${forBody.height.toString()} cm',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  return const CircularProgressIndicator();
                                }
                              },
                            ),
                            trailing: const Icon(Icons.arrow_right),
                          ),
                        ),
                        const SizedBox(height: 15),
                        const Divider(
                          color: Colors.grey,
                          thickness: 1,
                          indent: 20,
                          endIndent: 20,
                        ),
                        const SizedBox(height: 15),
                        Container(
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
                                    color: Colors.grey,
                                  ),
                                  child: const LinePage(),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Container(
                                  width: 265.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.grey,
                                  ),
                                  child: const LinePage(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await AuthService.firebase().logOut();
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        loginScreen,
                        (route) => false,
                      );
                    },
                    child: const Text('logout'),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
