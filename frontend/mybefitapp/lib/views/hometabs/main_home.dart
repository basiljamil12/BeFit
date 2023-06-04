import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mybefitapp/services/Api/step_api_call.dart';
import 'package:mybefitapp/services/auth/auth_service.dart';
import 'package:mybefitapp/utilities/app_styles.dart';
import 'package:pedometer/pedometer.dart';
import '../../services/Api/user_api_call.dart';

class MainHome extends StatefulWidget {
  const MainHome({super.key});

  @override
  State<MainHome> createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  late Future<dynamic> _userData;
  late Future<dynamic> _stepData;

  @override
  void initState() {
    super.initState();
    // Retrieve the current user when the widget initializes
    String email = AuthService.firebase().currentUser?.email.toString() ?? '';
    _userData = BaseUserClient().getUserApi(email);
    _stepData = BaseStepClient().getStepApi(email);
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
                        Map<String, dynamic> jsonData = json.decode(model);
                        List<dynamic> users = jsonData['users'];
                        String name = users[0]['name'];
                        return Text(
                          'Welcome, $name',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20.0),
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
                        leading: Icon(Icons.local_fire_department_rounded),
                        title: const Text('Steps'),
                        subtitle: FutureBuilder(
                          future: _stepData,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final model = snapshot.data!;
                              Map<String, dynamic> jsonData =
                                  json.decode(model);
                              List<dynamic> forSteps = jsonData['steps'];
                              String stepsCount =
                                  forSteps[0]['steps'].toString();
                              return Text(
                                stepsCount,
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
                      child: const ListTile(
                        leading: Icon(Icons.local_fire_department_rounded),
                        title: Text('Steps'),
                        subtitle: Text('a'),
                        trailing: Icon(Icons.arrow_right),
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
