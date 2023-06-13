import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mybefitapp/utilities/app_styles.dart';
import 'package:mybefitapp/views/tabs/activity_tab.dart';
import 'package:mybefitapp/views/tabs/body_tab.dart';
import 'package:mybefitapp/views/tabs/sleep_tab.dart';

class SummaryPage extends StatefulWidget {
  const SummaryPage({Key? key}) : super(key: key);

  @override
  State<SummaryPage> createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.bgColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: const [
                Padding(
                  padding: EdgeInsets.fromLTRB(30.0, 60.0, 0.0, 15.0),
                  child: Text(
                    'Health Categories',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 20.0),
              child: Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    ListTile(
                      onTap: () {
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
                            return const Activity();
                          },
                        );
                      },
                      leading: const Icon(
                        Icons.local_fire_department_rounded,
                        color: Colors.pinkAccent,
                      ),
                      title: const Text(
                        'Activity',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.arrow_right,
                        color: Colors.pinkAccent,
                      ),
                    ),
                    const Divider(
                      color: Colors.grey,
                      indent: 20,
                      endIndent: 20,
                    ),
                    ListTile(
                      onTap: () {
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
                            return const Body();
                          },
                        );
                      },
                      leading: const Icon(
                        Icons.directions_run_rounded,
                        color: Colors.pinkAccent,
                      ),
                      title: const Text(
                        'Body Measurements',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.arrow_right,
                        color: Colors.pinkAccent,
                      ),
                    ),
                    const Divider(
                      color: Colors.grey,
                      indent: 20,
                      endIndent: 20,
                    ),
                    ListTile(
                      onTap: () {
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
                            return const Sleep();
                          },
                        );
                      },
                      leading: const Icon(
                        CupertinoIcons.bed_double_fill,
                        color: Colors.pinkAccent,
                      ),
                      title: const Text(
                        'Sleep',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.arrow_right,
                        color: Colors.pinkAccent,
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
                    'About Summary',
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
          ],
        ),
      ),
    );
  }
}
