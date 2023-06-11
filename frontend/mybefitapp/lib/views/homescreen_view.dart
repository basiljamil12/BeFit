import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:mybefitapp/utilities/app_styles.dart';
import 'package:mybefitapp/views/hometabs/main_home.dart';
import 'package:mybefitapp/views/hometabs/profile.dart';
import 'package:mybefitapp/views/hometabs/summary.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1;
  static final List<Widget> _widgetOptions = <Widget>[
    const MainHome(),
    const ProfilePage(),
    const SummaryPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions[_selectedIndex],
      ),
      backgroundColor: Styles.bgColor,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
        child: GNav(
          rippleColor: const Color.fromARGB(255, 236, 164, 188),
          //currentIndex: _selectedIndex,
          onTabChange: _onItemTapped,
          activeColor: Colors.pinkAccent,
          tabBackgroundColor: Colors.grey.shade300,
          gap: 20,
          tabs: const [
            GButton(
              icon: Icons.home,
              text: 'Home',
            ),
            GButton(
              icon: Icons.person,
              text: 'Profile',
            ),
            GButton(
              icon: Icons.view_list_rounded,
              text: 'Summary',
            ),
          ],
        ),
      ),
    );
  }
}
