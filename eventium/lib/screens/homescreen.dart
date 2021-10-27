import 'package:eventium/screens/addjob.dart';
import 'package:eventium/screens/profilescreen.dart';
import 'package:eventium/screens/searchscreen.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import 'jobscreen.dart';
import 'messagescreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static List<Widget> _widgetOptions = <Widget>[
    SearchScreen(),
    JobScreen(),
    MessageScreen(),
    ProfileScreen(),
  ];
  var _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF060606),
      body: _widgetOptions.elementAt(_currentIndex),
      bottomNavigationBar: SalomonBottomBar(
        selectedColorOpacity: 0.3,
        itemPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: [
          /// Home
          SalomonBottomBarItem(
            icon: Icon(Icons.search, color: Color(0xFFe1e3e6)),
            title: Text("Поиск", style: TextStyle(color: Color(0xFFe1e3e6))),
            selectedColor: Theme.of(context).hintColor,
          ),

          /// Likes
          SalomonBottomBarItem(
            icon: Icon(Icons.work_outline, color: Color(0xFFe1e3e6)),
            title: Text("Работа", style: TextStyle(color: Color(0xFFe1e3e6))),
            selectedColor: Theme.of(context).hintColor,
          ),

          /// Search
          SalomonBottomBarItem(
            icon: Icon(Icons.message_outlined, color: Color(0xFFe1e3e6)),
            title: Text("Диалоги", style: TextStyle(color: Color(0xFFe1e3e6))),
            selectedColor: Theme.of(context).hintColor,
          ),

          /// Profile
          SalomonBottomBarItem(
            activeIcon: Icon(Icons.person_outline, color: Color(0xFFCB4444)),
            icon: Icon(Icons.person_outline, color: Color(0xFFe1e3e6)),
            title: Text("Профиль", style: TextStyle(color: Color(0xFFe1e3e6))),
            selectedColor: Theme.of(context).hintColor,
          ),
        ],
      ),
    );
  }
}
