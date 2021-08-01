import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/Screens/navbar.dart';
import 'package:rive_splash_screen/rive_splash_screen.dart';



class LoadingScreen extends StatefulWidget {
  static const String id = 'LoadingScreen';

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {

  final String riveFile = 'assets/loading.riv';

  @override
  void initState() {
    super.initState();
    checkConnection();
  }

  Future checkConnection() async {
    try {
      var _result = await (Connectivity().checkConnectivity());

      if (_result == ConnectivityResult.mobile ||
          _result == ConnectivityResult.wifi)
            await Firebase.initializeApp();


    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SplashScreen.callback(
        fit: BoxFit.cover,
        name: riveFile,
        onSuccess: (data) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => NavBar()));
        },
        onError: (err, stack) {},
        startAnimation: 'Animation',
        endAnimation: '1',
        loopAnimation: '1',
        isLoading: false,
      ),
    );
  }
}
