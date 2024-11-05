import 'package:antic/const/const.dart';
import 'package:antic/model/services/profileInfoServices.dart';
import 'package:antic/view/home.dart';
import 'package:antic/view/patients/patientsMenu.dart';
import 'package:antic/view/settings.dart';
import 'package:antic/view/signIn.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class Navigation extends StatefulWidget {
  final int index;
  const Navigation({super.key, required this.index});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  var _currentIndex = 0;
  List screens = [
    Home(),
    PatientsMenu(),
    Settings(
        userProfile:
            ProfileInfoServices.profileInfoServicesInstance.userProfile)
  ];
  @override
  void initState() {
    // TODO: implement initState
    _currentIndex = widget.index;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 5),
        child: SalomonBottomBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          items: [
            /// Home
            SalomonBottomBarItem(
              icon: Icon(CupertinoIcons.home),
              title: Text("Home"),
              selectedColor: purpleColor,
            ),

            /// Likes
            SalomonBottomBarItem(
              icon: Icon(CupertinoIcons.add),
              title: Text("Patients"),
              selectedColor: purpleColor,
            ),

            /// Profile
            SalomonBottomBarItem(
              icon: Icon(CupertinoIcons.settings),
              title: Text("Settings"),
              selectedColor: purpleColor,
            ),
          ],
        ),
      ),
    );
  }
}
