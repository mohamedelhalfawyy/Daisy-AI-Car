import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:camera/camera.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/Services/facenet.service.dart';
import 'package:graduation_project/Services/ml_kit_service.dart';
import 'package:graduation_project/db/database.dart';
import 'package:graduation_project/widgets/SnackBar.dart';
import 'package:page_flip_builder/page_flip_builder.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    final pageFlipKey = GlobalKey<PageFlipBuilderState>();

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
            ),
          ),
      ),
      body: ListView(
        children: [
          Container(
            height: 200,
            width: double.infinity,
            child: Carousel(
              dotColor: Colors.transparent,
              dotBgColor: Colors.transparent,
              autoplayDuration: Duration(seconds: 2),
              images: [
                Image.asset('assets/Images/car1.jpeg', fit: BoxFit.cover),
                Image.asset('assets/Images/car2.jpeg', fit: BoxFit.cover),
                Image.asset('assets/Images/car3.jpeg', fit: BoxFit.cover),
                Image.asset('assets/Images/car4.jpeg', fit: BoxFit.cover),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left:10, top:20, right:10),
            child: Row(
              children: [
                Container(
                  color: Colors.black,
                  width: 180,
                  height: 200,
                  child: PageFlipBuilder(
                    key: pageFlipKey,
                    frontBuilder: (_) => LightHomePage(
                      image: 'assets/Images/arduinoUno1.jpeg',
                      onFlip: () => pageFlipKey.currentState?.flip(),
                    ),
                    backBuilder: (_) => DarkHomePage(
                      image: 'assets/Images/arduinoUno2.jpeg',
                      onFlip: () => pageFlipKey.currentState?.flip(),
                    ),
                    maxTilt: 0.003,
                    maxScale: 0.2,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left:10, top:20, right:10),
            child: Row(
              children: [
                Container(
                  color: Colors.black,
                  width: 180,
                  height: 200,
                  child: PageFlipBuilder(
                    key: pageFlipKey,
                    frontBuilder: (_) => LightHomePage(
                      image: 'assets/Images/dcGearedMotor1.jpeg',
                      onFlip: () => pageFlipKey.currentState?.flip(),
                    ),
                    backBuilder: (_) => DarkHomePage(
                      image: 'assets/Images/dcGearedMotor2.jpeg',
                      onFlip: () => pageFlipKey.currentState?.flip(),
                    ),
                    maxTilt: 0.003,
                    maxScale: 0.2,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left:10, top:20, right:10),
            child: Row(
              children: [
                Container(
                  color: Colors.black,
                  width: 180,
                  height: 200,
                  child: PageFlipBuilder(
                    key: pageFlipKey,
                    frontBuilder: (_) => LightHomePage(
                      image: 'assets/Images/microServoMotor1.jpeg',
                      onFlip: () => pageFlipKey.currentState?.flip(),
                    ),
                    backBuilder: (_) => DarkHomePage(
                      image: 'assets/Images/microServoMotor2.jpeg',
                      onFlip: () => pageFlipKey.currentState?.flip(),
                    ),
                    maxTilt: 0.003,
                    maxScale: 0.2,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left:10, top:20, right:10),
            child: Row(
              children: [
                Container(
                  color: Colors.black,
                  width: 180,
                  height: 200,
                  child: PageFlipBuilder(
                    key: pageFlipKey,
                    frontBuilder: (_) => LightHomePage(
                      image: 'assets/Images/motorDriverShield1.jpeg',
                      onFlip: () => pageFlipKey.currentState?.flip(),
                    ),
                    backBuilder: (_) => DarkHomePage(
                      image: 'assets/Images/motorDriverShield2.jpeg',
                      onFlip: () => pageFlipKey.currentState?.flip(),
                    ),
                    maxTilt: 0.003,
                    maxScale: 0.2,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left:10, top:20, right:10),
            child: Row(
              children: [
                Container(
                  color: Colors.black,
                  width: 180,
                  height: 200,
                  child: PageFlipBuilder(
                    key: pageFlipKey,
                    frontBuilder: (_) => LightHomePage(
                      image: 'assets/Images/ultrasonicSensor1.jpeg',
                      onFlip: () => pageFlipKey.currentState?.flip(),
                    ),
                    backBuilder: (_) => DarkHomePage(
                      image: 'assets/Images/ultrasonicSensor2.jpeg',
                      onFlip: () => pageFlipKey.currentState?.flip(),
                    ),
                    maxTilt: 0.003,
                    maxScale: 0.2,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left:10, top:20, right:10),
            child: Row(
              children: [
                Container(
                  color: Colors.black,
                  width: 180,
                  height: 200,
                  child: PageFlipBuilder(
                    key: pageFlipKey,
                    frontBuilder: (_) => LightHomePage(
                      image: 'assets/Images/serialBluetoothModule1.jpeg',
                      onFlip: () => pageFlipKey.currentState?.flip(),
                    ),
                    backBuilder: (_) => DarkHomePage(
                      image: 'assets/Images/serialBluetoothModule2.jpeg',
                      onFlip: () => pageFlipKey.currentState?.flip(),
                    ),
                    maxTilt: 0.003,
                    maxScale: 0.2,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left:10, top:20, right:10),
            child: Row(
              children: [
                Container(
                  color: Colors.black,
                  width: 180,
                  height: 200,
                  child: PageFlipBuilder(
                    key: pageFlipKey,
                    frontBuilder: (_) => LightHomePage(
                      image: 'assets/Images/batteryHolderBox1.jpeg',
                      onFlip: () => pageFlipKey.currentState?.flip(),
                    ),
                    backBuilder: (_) => DarkHomePage(
                      image: 'assets/Images/batteryHolderBox2.jpeg',
                      onFlip: () => pageFlipKey.currentState?.flip(),
                    ),
                    maxTilt: 0.003,
                    maxScale: 0.2,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left:10, top:20, right:10),
            child: Row(
              children: [
                Container(
                  color: Colors.black,
                  width: 180,
                  height: 200,
                  child: PageFlipBuilder(
                    key: pageFlipKey,
                    frontBuilder: (_) => LightHomePage(
                      image: 'assets/Images/maleAndFemaleJumperWire1.jpeg',
                      onFlip: () => pageFlipKey.currentState?.flip(),
                    ),
                    backBuilder: (_) => DarkHomePage(
                      image: 'assets/Images/maleAndFemaleJumperWire2.jpeg',
                      onFlip: () => pageFlipKey.currentState?.flip(),
                    ),
                    maxTilt: 0.003,
                    maxScale: 0.2,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left:10, top:20, right:10),
            child: Row(
              children: [
                Container(
                  color: Colors.black,
                  width: 180,
                  height: 200,
                  child: PageFlipBuilder(
                    key: pageFlipKey,
                    frontBuilder: (_) => LightHomePage(
                      image: 'assets/Images/wheel1.jpeg',
                      onFlip: () => pageFlipKey.currentState?.flip(),
                    ),
                    backBuilder: (_) => DarkHomePage(
                      image: 'assets/Images/wheel2.jpeg',
                      onFlip: () => pageFlipKey.currentState?.flip(),
                    ),
                    maxTilt: 0.003,
                    maxScale: 0.2,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left:10, top:20, right:10),
            child: Row(
              children: [
                Container(
                  color: Colors.black,
                  width: 180,
                  height: 200,
                  child: PageFlipBuilder(
                    key: pageFlipKey,
                    frontBuilder: (_) => LightHomePage(
                      image: 'assets/Images/maleAndFemaleJumperWire1.jpeg',
                      onFlip: () => pageFlipKey.currentState?.flip(),
                    ),
                    backBuilder: (_) => DarkHomePage(
                      image: 'assets/Images/maleAndFemaleJumperWire2.jpeg',
                      onFlip: () => pageFlipKey.currentState?.flip(),
                    ),
                    maxTilt: 0.003,
                    maxScale: 0.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LightHomePage extends StatelessWidget {
  const LightHomePage({Key key, this.image,this.onFlip}) : super(key: key);
  final VoidCallback onFlip;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
          brightness: Brightness.light,
          textTheme: TextTheme(
            headline3: Theme.of(context)
                .textTheme
                .headline3
                .copyWith(color: Colors.black87, fontWeight: FontWeight.w600),
          ),
      ),
      child: Scaffold(
        body: Container(
          decoration: kIsWeb
              ? BoxDecoration(
            border: Border.all(color: Colors.black, width: 5),
          )
              : null,
          child: InkWell(
            onTap: onFlip,
            child: SvgPicture.asset(
              image,
              semanticsLabel: 'Forest',
              width: 180,
              height: 200,
            ),
          ),
        ),
      ),
    );
  }
}

class DarkHomePage extends StatelessWidget {
  const DarkHomePage({Key key, this.image,this.onFlip}) : super(key: key);
  final VoidCallback onFlip;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
          brightness: Brightness.dark,
          textTheme: TextTheme(
            headline3: Theme.of(context)
                .textTheme
                .headline3
                .copyWith(color: Colors.white, fontWeight: FontWeight.w600),
          ),
      ),
      child: Scaffold(
        body: Container(
          decoration: kIsWeb
              ? BoxDecoration(
            border: Border.all(color: Colors.black, width: 5),
          )
              : null,
          child: InkWell(
            onTap: onFlip,
            child: SvgPicture.asset(
              image,
              semanticsLabel: 'Forest',
              width: 180,
              height: 200,
            ),
          ),
        ),
      ),
    );
  }
}