import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/Screens/OTPScreen.dart';
import 'package:graduation_project/Screens/sign-in.dart';
import 'package:graduation_project/Services/facenet.service.dart';
import 'package:graduation_project/Services/ml_kit_service.dart';
import 'package:graduation_project/db/database.dart';
import 'package:graduation_project/widgets/Constants.dart';
import 'package:graduation_project/widgets/FadeAnimation.dart';
import 'package:page_transition/page_transition.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        tooltip: "SignUp Button",
        backgroundColor: Color(0xff0E4EC9),
        onPressed: () {},
        child: IconButton(
          iconSize: 40,
          onPressed: () {
            Navigation(widget: widget, context: context, type: PageTransitionType.topToBottomJoined, screen: OTPScreen()).navigate();
          },
          icon: Icon(Icons.add),
        ),
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
              // Lottie.asset(
              //   lottieFile,
              //   height: 300,
              // ),
              //SizedBox(height: 30,),
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
                height: 250.0,
                width: 250.0,
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
                  DataBaseService().cleanDB();
/*                  Navigation(
                          context: context,
                          screen: Email_Password(),
                          widget: widget,
                          type: PageTransitionType.bottomToTopJoined)
                      .navigate();*/
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
              // ElevatedButton(
              //   style: ButtonStyle(
              //       shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              //           RoundedRectangleBorder(
              //             borderRadius: BorderRadius.circular(20),
              //           ))),
              //   onPressed: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //           builder: (BuildContext context) => SignUp(cameraDescription: cameraDescription)
              //       ),
              //     );
              //   },
              //   child: Padding(
              //     padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
              //     child: Text(
              //       'Sign Up',
              //       style: TextStyle(
              //         color: Colors.white,
              //         fontSize: 22,
              //       ),
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
