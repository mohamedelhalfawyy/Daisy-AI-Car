import 'dart:developer';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rive_splash_screen/rive_splash_screen.dart';

import 'DashBoard.dart';



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
          _result == ConnectivityResult.wifi) {

        log('connected to internet');

        await Firebase.initializeApp();

      } else {
        //Navigator.pushReplacementNamed(context, NoNetworkScreen.id);

        log('no connection');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: Center(
        child: SplashScreen.callback(
          fit: BoxFit.cover,
          name: riveFile,
          onSuccess: (data) {
            Navigator.of(context).pushReplacementNamed(DashBoard.id);
          },
          onError: (err, stack) {
          },
          startAnimation: 'Animation',
          until: () => Future.delayed(Duration(milliseconds: 100)),
          endAnimation: '1',
          loopAnimation: '1',
        ),
      ),
    ));
  }
}
