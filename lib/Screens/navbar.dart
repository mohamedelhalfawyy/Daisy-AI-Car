import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';

import 'DashBoard.dart';
import 'aboutUs.dart';
import 'control_room.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key key}) : super(key: key);

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedScreen = 0;
  var _screens = [DashBoard(),ControlRoom(),AboutUs()];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.reactCircle,
        items: [
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.videogame_asset, title: 'Control'),
          TabItem(
            icon: Icons.assignment_late_outlined,
            title: 'About Us',
          ),
        ],
        initialActiveIndex: 0,
        backgroundColor: Colors.indigo,
        onTap: (int index) {
          setState(() {
            _selectedScreen = index;
          });
        },
      ),
      body: _screens[_selectedScreen],
    );
  }
}
