import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/Screens/navbar.dart';
import 'package:rive_splash_screen/rive_splash_screen.dart';
import 'package:video_player/video_player.dart';

class LoadingScreen extends StatefulWidget {
  static const String id = 'LoadingScreen';

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/Images/SplashScreen.mp4')
      ..initialize().then((_) {
        setState(() {});
      });
    playVideo();
    checkConnection();
  }

  Future checkConnection() async {
    try {
      var _result = await (Connectivity().checkConnectivity());

      if (_result == ConnectivityResult.mobile ||
          _result == ConnectivityResult.wifi) await Firebase.initializeApp();
    } catch (e) {
      print(e);
    }
  }

  void playVideo() async{
    _controller.play();

    await Future.delayed(Duration(seconds: 5));

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => NavBar()));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
        body: Center(
      child: _controller.value.isInitialized
          ? AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            )
          : Container(),
    ));
  }
}
