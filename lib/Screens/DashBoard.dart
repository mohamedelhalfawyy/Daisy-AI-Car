import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:camera/camera.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/Services/facenet.service.dart';
import 'package:graduation_project/Services/ml_kit_service.dart';
import 'package:graduation_project/db/database.dart';
import 'package:graduation_project/widgets/SnackBar.dart';

import 'aboutUs.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key key}) : super(key: key);

  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  FaceNetService _faceNetService = FaceNetService();
  MLKitService _mlKitService = MLKitService();
  DataBaseService _dataBaseService = DataBaseService();

  CameraDescription cameraDescription;
  bool loading = false;
  StreamSubscription<ConnectivityResult> subscription;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();

    _startUp();
    checkConnection();
  }

  checkConnection() async {
    var _result = await (Connectivity().checkConnectivity());

    if (_result != ConnectivityResult.mobile &&
        _result != ConnectivityResult.wifi) {
      ShowSnackBar(
          context: context,
          text: 'Not Connected to Internet',
          color: Colors.red,
          isWifi: true,
          icon: Icons.wifi_off)
          .show();
    }

    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        ShowSnackBar(
            context: context,
            text: 'Connection Restored',
            color: Colors.green,
            isWifi: true,
            icon: Icons.wifi)
            .show();
        await Future.delayed(Duration(seconds: 5));
      } else
        ShowSnackBar(
            context: context,
            text: 'No Connection',
            color: Colors.red,
            isWifi: true,
            icon: Icons.wifi_off)
            .show();
    });
  }

  _startUp() async {
    _setLoading(true);

    List<CameraDescription> cameras = await availableCameras();

    /// takes the front camera
    cameraDescription = cameras.firstWhere(
          (CameraDescription camera) =>
      camera.lensDirection == CameraLensDirection.front,
    );

    // start the services
    await _faceNetService.loadModel();
    await _dataBaseService.loadDB();
    _mlKitService.initialize();

    _setLoading(false);
  }

  _setLoading(bool value) {
    setState(() {
      loading = value;
    });
  }

  @override
  void dispose() {
    super.dispose();

    subscription.cancel();
  }

  //Control Room navigation:

  // Navigator.push(
  // context,
  // MaterialPageRoute(
  // builder: (BuildContext context) => SignIn(
  // cameraDescription: cameraDescription,
  // ),
  // ),
  // );

  //Signup Navigation:

  // Navigator.push(
  // context,
  // MaterialPageRoute(
  // builder: (BuildContext context) => SignUp(
  // cameraDescription: cameraDescription,
  // ),
  // ),
  // );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          centerTitle: true,
          title: !_isLoaded ? Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(width: 20.0, height: 100.0),
              const SizedBox(width: 20.0, height: 100.0),
              DefaultTextStyle(
                style: const TextStyle(
                  fontSize: 40.0,
                  fontFamily: 'Horizon',
                ),
                child: AnimatedTextKit(
                    isRepeatingAnimation: false,
                    onFinished: (){
                      setState(() {
                        _isLoaded = true;
                      });
                    },
                    animatedTexts: [
                      RotateAnimatedText('BE UNIQUE'),
                      RotateAnimatedText('BE CREATIVE'),
                      RotateAnimatedText('BE DIFFERENT'),
                    ]),
              ),
            ],
          ) : Text('Daisy', style: TextStyle(
            fontSize: 40.0,
            fontFamily: 'Horizon',
          ),)),
    );
  }
}