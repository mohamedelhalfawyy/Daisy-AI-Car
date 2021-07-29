import 'dart:io';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/Screens/voiceControl.dart';
import 'package:graduation_project/widgets/app_button.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:graduation_project/Services//connection.dart';
import 'DashBoard.dart';
import 'dart:math' as math;

class ControlRoom extends StatelessWidget {

  const ControlRoom(this.username, {Key key, this.imagePath}) : super(key: key);
  final String username;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    final double mirror = math.pi;
    return MaterialApp(
        home: FutureBuilder(
        future: FlutterBluetoothSerial.instance.requestEnable(),
    builder: (context, future) {
    if (future.connectionState == ConnectionState.waiting) {
    return Scaffold(
      backgroundColor: Color(0XFFC7FFBE),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: FileImage(File(imagePath)),
                      ),
                    ),
                    margin: EdgeInsets.all(20),
                    width: 55,
                    height: 75,
                  ),
                  AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText('Welcome $username!',textStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        fontSize: 30,
                      ),
                          speed: Duration(milliseconds: 500))
                    ],
                    totalRepeatCount: 1,
                    displayFullTextOnTap: true,
                  ),
                ],
              ),
              Spacer(),
              AppButton(
                text: "LOG OUT",
                onPressed: () {
                  Navigator.pushReplacementNamed(context, DashBoard.id);
                },
                icon: Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
                color: Color(0xFFFF6161),
              ),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ),
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
        onTap: (int i) => print('click index=$i'),
      ),
    );
    } else {
    return Home();
    }
    },
    ),
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Connection'),
          ),
          body: SelectBondedDevicePage(
            onCahtPage: (device1) {
              BluetoothDevice device = device1;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return ChatPage(server: device);
                  },
                ),
              );
            },
          ),
        ));
  }
}