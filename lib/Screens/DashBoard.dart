import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/Screens/navbar.dart';
import 'package:graduation_project/widgets/SnackBar.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'dart:ui' as ui;
import '../widgets/Constants.dart';
import 'OTPScreen.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key key}) : super(key: key);

  static const String id = 'DashBoardScreen';

  static bool isUser = false;

  @override
  _DashBoardState createState() => _DashBoardState(isUser);
}

class _DashBoardState extends State<DashBoard> {
  StreamSubscription<ConnectivityResult> subscription;

  bool _isUser;

  _DashBoardState(this._isUser);

  @override
  void initState() {
    super.initState();

    checkConnection();
  }

  // if (user != null) {
  // await Future.delayed(const Duration(seconds: 5), () {
  // Navigator.pushAndRemoveUntil(
  // context,
  // MaterialPageRoute(
  // builder: (context) => NavBar.Info(
  // username: name,
  // index: 1,
  //
  // //imagePath: _imagePath,
  // )
  // ),(Route<dynamic> route) => false
  // );
  // });

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
      if (result != ConnectivityResult.mobile &&
          result != ConnectivityResult.wifi) {
        ShowSnackBar(
                context: context,
                text: 'No Connection',
                color: Colors.red,
                isWifi: true,
                icon: Icons.wifi_off)
            .show();
      }
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
    return Directionality(
      textDirection: ui.TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Color(0XFF1E90FF),
        body: ListView(
          children: [
            Container(
              height: 100,
              width: 200,
              child: Image.asset('assets/Images/daisy.png'),
            ),
            Center(
              child: Text(
                'Welcome to Daisy'.tr().toString(),
                style: TextStyle(
                  fontSize: 40.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Horizon',
                ),
              ),
            ),
            SizedBox(height: 15.0),
            Center(
              child: AutoSizeText(
                'Lets get you started \nand deliver on time'.tr().toString(),
                maxFontSize: 26,
                minFontSize: 20,
                maxLines: 2,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 10.0),
            Center(
              child: Lottie.asset(
                'assets/medicals.json',
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.42,
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(height: 10.0),
            !_isUser? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigation(
                        widget: widget,
                        context: context,
                        type: PageTransitionType.leftToRight,
                        screen: OTPScreen())
                        .navigate();
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20)),
                    ),
                    child: Center(
                      child: Text(
                        'Sign up'.tr().toString(),
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
            : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    DashBoard.isUser = false;
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NavBar.ind(index: 1,isUser: false)
                        ),(Route<dynamic> route) => false
                    );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20)),
                    ),
                    child: Center(
                      child: Text(
                        'Sign out'.tr().toString(),
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
