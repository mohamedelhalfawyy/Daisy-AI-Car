import 'dart:io';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/Screens/voiceControl.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:graduation_project/Services/connection.dart';
import 'DashBoard.dart';
import 'aboutUs.dart';

class ControlRoom extends StatelessWidget {

  const ControlRoom(this.username, {Key key, this.imagePath}) : super(key: key);
  final String username;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder(
        future: FlutterBluetoothSerial.instance.requestEnable(),
        builder: (context, future) {
          if (future.connectionState != ConnectionState.waiting) {
            return Scaffold(
              appBar: AppBar(
                title: Text('Control Room'),
              ),
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
                              TypewriterAnimatedText('Welcome $username!',
                                  textStyle: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                    fontSize: 30,
                                  ),
                                  speed: Duration(milliseconds: 500)),
                            ],
                            totalRepeatCount: 1,
                            displayFullTextOnTap: true,
                          ),
                        ],
                      ),
                      Spacer(),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              SelectBondedDevicePage(
                                onChatPage: (device1) {
                                  BluetoothDevice device = device1;
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return VoiceControl(server: device);
                                      },
                                    ),
                                  );
                                },
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color(0xFF0F0BDB),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                    color: Colors.blue.withOpacity(0.1),
                                    blurRadius: 1,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 16),
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Voice'
                                        'Control',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Icon(Icons.keyboard_voice, color: Colors.white)
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                              width:20
                          ),
                          InkWell(
                            onTap: () {
                              //manual page
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color(0xFF0F0BDB),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                    color: Colors.blue.withOpacity(0.1),
                                    blurRadius: 1,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 16),
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Manual'
                                        'Control',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Icon(Icons.gamepad, color: Colors.white)
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
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
                onTap: (int i) {
                  if(i == 1){
                    Navigator.pushReplacementNamed(context, DashBoard.id);
                  }
                  else if(i == 3){
                    Navigator.pushReplacement(context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => AboutUs(),
                      ),
                    );
                  }
                  else if(i == 4){
                    Navigator.pushReplacementNamed(context, DashBoard.id);
                  }
                },
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
    return Scaffold(
      body: Container(
        height: double.infinity,
        child: Center(
          child: Icon(
            Icons.bluetooth_disabled,
            size: 200.0,
            color: Colors.blue,
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
        onTap: (int i) {
          if(i == 1){
            Navigator.pushReplacementNamed(context, DashBoard.id);
          }
          else if(i == 3){
            Navigator.pushReplacement(context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) => AboutUs(),
              ),
            );
          }
          else if(i == 4){
            Navigator.pushReplacementNamed(context, DashBoard.id);
          }
        },
      ),
    );
  }
}

