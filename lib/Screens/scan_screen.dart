import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/Screens/Email_password.dart';
import 'package:graduation_project/Screens/sign-in.dart';
import 'package:graduation_project/Screens/sign-up.dart';
import 'package:graduation_project/Services/facenet.service.dart';
import 'package:graduation_project/Services/ml_kit_service.dart';
import 'package:graduation_project/db/database.dart';
import 'package:lottie/lottie.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({Key key}) : super(key: key);

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen>{
  final lottieFile = 'assets/faceError.json';

  FaceNetService _faceNetService = FaceNetService();

  MLKitService _mlKitService = MLKitService();

  DataBaseService _dataBaseService = DataBaseService();

  CameraDescription cameraDescription;



  bool loading = false;

  @override
  void initState() {
    super.initState();
    _startUp();
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
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                    Hero(
                      tag: 'logo',
                      child: Container(
                        height: 150.0,
                        width: 150.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/Images/daisy.png'),
                            fit: BoxFit.fill,
                          ),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ))),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => SignIn(
                              cameraDescription: cameraDescription,
                            ),
                          ),
                        );
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
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ))),
                      onPressed: () {
                        Navigator.push(
                          context,
                            PageRouteBuilder(
                            transitionDuration: Duration(seconds: 2),
                                reverseTransitionDuration: Duration(milliseconds: 50),
                                pageBuilder: (_, __, ___) => Email_Password())
                        );
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
      ),
    );
  }
}
