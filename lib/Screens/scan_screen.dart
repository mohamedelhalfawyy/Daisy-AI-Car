import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/Screens/EmailValidation.dart';
import 'package:graduation_project/Screens/OTPScreen.dart';
import 'package:graduation_project/Screens/ResetPassword.dart';
import 'package:graduation_project/Screens/sign-in.dart';
import 'package:graduation_project/Services/facenet.service.dart';
import 'package:graduation_project/Services/ml_kit_service.dart';
import 'package:graduation_project/db/database.dart';
import 'package:graduation_project/widgets/Constants.dart';
import 'package:graduation_project/widgets/FadeAnimation.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:page_transition/page_transition.dart';
import 'Email_password.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';



class ScanScreen extends StatefulWidget {
  const ScanScreen({Key key}) : super(key: key);

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {

  final lottieFile = 'assets/faceError.json';

  FaceNetService _faceNetService = FaceNetService();

  MLKitService _mlKitService = MLKitService();

  DataBaseService _dataBaseService = DataBaseService();

  CameraDescription cameraDescription;

  bool loading = false;

  bool isDone = false;


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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: loading,
      opacity: 0.5,
      progressIndicator: Lottie.asset('assets/indicator.json',
          height: 130, fit: BoxFit.cover, animate: true, repeat: true),
      child: Scaffold(
        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          backgroundColor: Colors.redAccent,
          overlayColor: Colors.black,
          overlayOpacity: 0.4,
          spacing: 12,
          tooltip: 'Menu Options',
          childrenButtonSize: Size(65,65),
          children: [
            SpeedDialChild(
              labelStyle: TextStyle(
                fontSize: 18
              ),
              child: Icon(Icons.person_add, color: Colors.white, size: 30,),
              backgroundColor: Color(0xff0E4EC9),
              label: 'SIGN UP',
              onTap: (){
                Navigation(widget: widget, context: context, type: PageTransitionType.topToBottom, screen: OTPScreen()).navigate();
              }
            )
          ],
        ),
        appBar: AppBar(
          elevation: 2,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: !isDone
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const SizedBox(width: 20.0, height: 100.0),
                    DefaultTextStyle(
                      style: const TextStyle(
                        fontSize: 40.0,
                        fontFamily: 'Horizon',
                        color: Colors.black
                      ),
                      child: AnimatedTextKit(
                        animatedTexts: [
                          RotateAnimatedText('KEEP'),
                          RotateAnimatedText('STAY'),
                        ],
                        isRepeatingAnimation: false,
                        onFinished: () {
                          setState(() {
                            isDone = true;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 20.0, height: 100.0),
                    DefaultTextStyle(
                      style: const TextStyle(
                        fontSize: 40.0,
                        fontFamily: 'Horizon',
                          color: Colors.black
                      ),
                      child: AnimatedTextKit(
                        animatedTexts: [
                          RotateAnimatedText('DISTANCE'),
                          RotateAnimatedText('SAFE'),
                        ],
                        isRepeatingAnimation: false,
                        onFinished: () {
                          setState(() {
                            isDone = true;
                          });
                        },
                      ),
                    ),
                  ],
                )
              : DefaultTextStyle(
                  style: const TextStyle(
                    fontSize: 40.0,
                    fontFamily: 'Horizon',
                    color: Colors.black
                  ),
                  child: FadeAnimation(1, Text("DAISY")),
                ),
        ),
        backgroundColor: Colors.white,
        body: Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(30, 0, 20, 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Scan your face to log in.',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'Press on the button whenever you are ready.',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Container(
                      height: 220.0,
                      width: 220.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/Images/daisy.png'),
                          fit: BoxFit.fill,
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            mainColor,
                          ),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ))),
                      onPressed: () async {
                        await _startUp();

                        Navigation(
                                context: context,
                                screen: SignIn(
                                  cameraDescription: cameraDescription,
                                ),
                                widget: widget,
                                type: PageTransitionType.rightToLeftWithFade)
                            .navigate();
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                        child: Text(
                          'Scan Face to authenticate!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 5,),
                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            mainColor,
                          ),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ))),
                      onPressed: () {
                    Navigation(
                                context: context,
                                screen: Email_Password(),
                                widget: widget,
                                type: PageTransitionType.bottomToTop)
                            .navigate();
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                        child: Text(
                          'Email/Password',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )

      ),
    );
  }
}
