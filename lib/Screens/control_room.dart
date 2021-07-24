import 'dart:io';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/widgets/app_button.dart';
import 'DashBoard.dart';
import 'dart:math' as math;

class ControlRoom extends StatelessWidget {

  const ControlRoom(this.username, {Key key, this.imagePath}) : super(key: key);
  final String username;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    final double mirror = math.pi;
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
                    width: 50,
                    height: 50,
                    // child: Transform(
                    //     alignment: Alignment.center,
                    //     child: FittedBox(
                    //       fit: BoxFit.cover,
                    //       child: Image.file(File(imagePath)),
                    //     ),
                    //     transform: Matrix4.rotationY(mirror)),
                  ),
                  AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText('Hi $username!',textStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        fontSize: 25,
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
    );
  }
}
