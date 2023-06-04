import 'package:flutter/material.dart';
import 'package:mybefitapp/services/auth/auth_service.dart';
import 'package:mybefitapp/services/auth/auth_user.dart';
import 'package:mybefitapp/utilities/app_styles.dart';

import '../../services/Api/api_call.dart';

class MainHome extends StatefulWidget {
  const MainHome({super.key});

  @override
  State<MainHome> createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  AuthUser? _user;
  late Future<dynamic> _userData;

  @override
  void initState() {
    super.initState();
    // Retrieve the current user when the widget initializes
    _userData = BaseClient().getUserApi("weird@gmail.com");
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
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Center(
                  child: Text(
                    'Welcome, Diyan Ali Shaikh',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    Center(
                      // child: FutureBuilder(
                      //   future: _userData,
                      //   builder: (context, snapshot) {
                      //     if (snapshot.hasData) {
                      //       final model = snapshot.data!;
                      //       return Text(model);
                      //     } else if (snapshot.hasError) {
                      //       return Text('Error: ${snapshot.error}');
                      //     } else {
                      //       return const CircularProgressIndicator();
                      //     }
                      //   },
                      // ),
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
                      child: const ListTile(
                        leading: Icon(Icons.local_fire_department_rounded),
                        title: Text('Steps'),
                        subtitle: Text('a'),
                        trailing: Icon(Icons.arrow_right),
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
              )
            ],
          ),
        ),
      ),
    );
    // ElevatedButton(
    //   onPressed: () async {
    //     await AuthService.firebase().logOut();
    //   },
    //   child: const Text('logout'),
    // );
  }
}
