import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';

import 'DashBoard.dart';
import 'control_room.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({key}) : super(key: key);

  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Control Room'),
      ),
      backgroundColor: Color(0XFFC7FFBE),
      body: Container(
        height: double.infinity,
        // write here the about us page
      ),
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.react,
        items: [
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.videogame_asset, title: 'Control'),
          TabItem(icon: Icons.assignment_late_outlined, title: 'About Us'),
          TabItem(icon: Icons.logout, title: 'Log Out'),
        ],
        initialActiveIndex: 1,
        backgroundColor: Colors.blueGrey,
        onTap: (int i) {
          if(i == 1){
            Navigator.pushReplacementNamed(context, DashBoard.id);
          }
          else if(i == 2){
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (BuildContext context) => ControlRoom(
            //           this.predictedUser.user,
            //           imagePath: _cameraService.imagePath,
            //         )));
          }
          else if(i == 4){
            Navigator.pushReplacementNamed(context, DashBoard.id);
          }
        },
      ),
    );
  }
}
