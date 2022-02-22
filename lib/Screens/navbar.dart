import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/Screens/control_room.dart';
import 'package:graduation_project/Screens/scan_screen.dart';

import 'DashBoard.dart';
import 'aboutUs.dart';

class NavBar extends StatefulWidget {
  NavBar({Key key}) : super(key: key);

  NavBar.Info({
    this.username,
    this.index,
  });

  String username = '';
  int index = 0;

  @override
  _NavBarState createState() => _NavBarState(username,index);
}

class _NavBarState extends State<NavBar> {
  int _selectedScreen = 0;
  String username;
  int index;

  _NavBarState(this.username, this.index);

  var _screens = [DashBoard(), ScanScreen(), AboutUs()];
  var _screens2 ;


 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkScreen();
  }


void checkScreen (){
  if (index == 1){
    print('am in');
    _screens2 = [DashBoard(), ControlRoom(username), AboutUs()];
    _selectedScreen = 1;
  }
}

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
        initialActiveIndex: index,
        backgroundColor: Colors.blue,
        onTap: (int value) {
          setState(() {
            _selectedScreen = value;
          });
        },
      ),
      body: index == 1 ? _screens2[_selectedScreen]: _screens[_selectedScreen],
    );
  }
}
