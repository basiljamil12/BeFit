import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mybefitapp/model/step_model.dart';
import 'package:mybefitapp/model/user_model.dart';
import 'package:mybefitapp/services/auth/auth_service.dart';
import 'package:mybefitapp/services/libraries/steps_sensor.dart';
import 'package:mybefitapp/services/libraries/steps_service.dart';
import 'package:mybefitapp/utilities/app_styles.dart';
import '../../services/Api/user_api_call.dart';

class MainHome extends StatefulWidget {
  const MainHome({super.key});

  @override
  State<MainHome> createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  late Future<dynamic> _userData;
  late Future<dynamic> _stepData;
  final StepTracker stepTracker = StepTracker();
  late Timer _timer;
  late Timer _updateSteps;

  @override
  void initState() {
    super.initState();
    String email = AuthService.firebase().currentUser?.email.toString() ?? '';

    DateTime now = DateTime.now().toUtc();
    DateTime utcDate = DateTime.utc(now.year, now.month, now.day);
    //String utcString = DateFormat("yyyy-MM-ddTHH:mm:ss'Z'").format(utcDate);

    _userData = BaseUserClient().getUserApi(email);
    _stepData = StepsClient().getDataFromApiOrPostNew(email, '0', utcDate);

    stepTracker.startTracking();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {});
    });
    _updateSteps = Timer.periodic(const Duration(seconds: 5), (_) {
      StepsClient().updateSteps(email, utcDate, stepTracker.stepCount);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
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
                            fontSize: 25.0,
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
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: const [
                    Center(
                      child: Text(
                        'Today',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 35.0),
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
                        borderRadius:
                            BorderRadius.circular(20.0), // set border radius
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
                                    fontSize: 20.0),
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
                        borderRadius:
                            BorderRadius.circular(20.0), // set border radius
                      ),
                      padding: const EdgeInsets.all(10.0),
                      child: ListTile(
                        leading:
                            const Icon(Icons.local_fire_department_rounded),
                        title: const Text('Steps'),
                        subtitle: Text(
                          '${stepTracker.stepCount}',
                        ),
                        trailing: const Icon(Icons.arrow_right),
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  await AuthService.firebase().logOut();
                },
                child: const Text('logout'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
