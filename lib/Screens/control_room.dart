import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:lottie/lottie.dart';
import 'Voice.dart';

class ControlRoom extends StatelessWidget {

  const ControlRoom(this.username, {Key key}) : super(key: key);

  static const String id = 'ControlRoomScreen';

  final String username ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: FlutterBluetoothSerial.instance.requestEnable(),
        builder: (context, future) {
          if (future.connectionState != ConnectionState.waiting) {
            return SafeArea(
              child: Scaffold(
                backgroundColor: Color(0Xff3c73e1),
                body: Column(
                  children: [
                    Container(
                      width: 200,
                        height: 200,
                        child: Image.asset('assets/Images/daisy.png')
                    ),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(360),
                          ),
                          margin: EdgeInsets.all(20),
                          width: 55,
                          height: 75,
                          child: Image.asset('assets/Images/Marwan.jpeg'),
                        ),

                        AnimatedTextKit(
                          animatedTexts: [
                            TypewriterAnimatedText('Welcome\n $username',
                                textStyle: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 28,
                                ),
                                speed: Duration(milliseconds: 200)),
                          ],
                          totalRepeatCount: 1,
                          displayFullTextOnTap: true,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      //mainAxisSize: MainAxisSize.min,
                      children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return Voice();
                                  },
                                ),
                              );
                            },
                          child: Container(
                            width: MediaQuery.of(context).size.width*0.9,
                            height: 200,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  bottomRight: Radius.circular(20)
                              ),
                            ),
                            child: Center(
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text('Voice\ncontrol',
                                    style: TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  // SizedBox(
                                  //   width: 5,
                                  // ),
                                  Lottie.asset(
                                    'assets/loadRobot.json',
                                    height: 300,
                                    width: MediaQuery.of(context).size.width*0.42,
                                  ),
                                ],
                              ),
                            ),

                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      //mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: () {
                            //manual page
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width*0.9,
                            height: 200,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  bottomLeft: Radius.circular(20)
                              ),
                            ),
                            child: Center(
                              child: Row(
                                children: [
                                  Lottie.asset(
                                    'assets/loadRobot.json',
                                    height: 300,
                                    width: MediaQuery.of(context).size.width*0.42,
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text('Manual\ncontrol',
                                    style: TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  // SizedBox(
                                  //   width: 5,
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Column(
                    //   children: [
                    //     InkWell(
                    //       onTap: () {
                    //         Navigator.push(
                    //           context,
                    //           MaterialPageRoute(
                    //             builder: (context) {
                    //               return Voice();
                    //             },
                    //           ),
                    //         );
                    //       },
                    //       child: Container(
                    //         decoration: BoxDecoration(
                    //           borderRadius: BorderRadius.circular(10),
                    //           color: Color(0xFF0F0BDB),
                    //           boxShadow: <BoxShadow>[
                    //             BoxShadow(
                    //               color: Colors.blue.withOpacity(0.1),
                    //               blurRadius: 1,
                    //               offset: Offset(0, 2),
                    //             ),
                    //           ],
                    //         ),
                    //         alignment: Alignment.center,
                    //         padding: EdgeInsets.symmetric(
                    //             vertical: 14, horizontal: 16),
                    //         width: MediaQuery.of(context).size.width * 0.8,
                    //         child: Row(
                    //           mainAxisAlignment: MainAxisAlignment.center,
                    //           children: [
                    //             Text(
                    //               'Voice'
                    //                   'Control',
                    //               style: TextStyle(color: Colors.white),
                    //             ),
                    //             SizedBox(
                    //               width: 10,
                    //             ),
                    //             Icon(Icons.keyboard_voice, color: Colors.white)
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //     SizedBox(
                    //         height:20
                    //     ),
                    //     InkWell(
                    //       onTap: () {
                    //         //manual page
                    //       },
                    //       child: Container(
                    //         decoration: BoxDecoration(
                    //           borderRadius: BorderRadius.circular(10),
                    //           color: Color(0xFF0F0BDB),
                    //           boxShadow: <BoxShadow>[
                    //             BoxShadow(
                    //               color: Colors.blue.withOpacity(0.1),
                    //               blurRadius: 1,
                    //               offset: Offset(0, 2),
                    //             ),
                    //           ],
                    //         ),
                    //         alignment: Alignment.center,
                    //         padding: EdgeInsets.symmetric(
                    //             vertical: 14, horizontal: 16),
                    //         width: MediaQuery.of(context).size.width * 0.8,
                    //         child: Row(
                    //           mainAxisAlignment: MainAxisAlignment.center,
                    //           children: [
                    //             Text(
                    //               'Manual'
                    //                   'Control',
                    //               style: TextStyle(color: Colors.black),
                    //
                    //             ),
                    //             SizedBox(
                    //               width: 10,
                    //             ),
                    //             Icon(Icons.gamepad, color: Colors.white)
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
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
    );
  }
}

