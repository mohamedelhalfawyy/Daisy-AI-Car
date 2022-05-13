import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'package:camera/camera.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/Screens/navbar.dart';
import 'package:graduation_project/Services/camera.service.dart';
import 'package:graduation_project/Services/facenet.service.dart';
import 'package:graduation_project/Services/ml_kit_service.dart';
import 'package:graduation_project/widgets/FacePainter.dart';
import 'package:graduation_project/widgets/auth-action-button.dart';
import 'package:graduation_project/widgets/camera_header.dart';
import 'package:lottie/lottie.dart';

class SignUp extends StatefulWidget {
  final CameraDescription cameraDescription;

  const SignUp({Key key, @required this.cameraDescription}) : super(key: key);

  @override
  SignUpState createState() => SignUpState();
}

class SignUpState extends State<SignUp> {
  String imagePath;
  Face faceDetected;
  Size imageSize;

  bool _detectingFaces = false;
  bool pictureTaked = false;

  Future _initializeControllerFuture;
  bool cameraInitializated = false;

  /**
   * *switchs when the user press the camera
   * **/
  bool _saving = false;
  bool _bottomSheetVisible = false;

  /**
   * *The services we need for the face recognition
   * **/
  MLKitService _mlKitService = MLKitService();
  CameraService _cameraService = CameraService();
  FaceNetService _faceNetService = FaceNetService();

  @override
  void initState() {
    super.initState();

    /**
     * *starts the camera & start framing faces
     * **/
    _start();
  }

  @override
  void dispose() {
    /**
     * *Dispose of the controller when the widget is disposed.
     * **/
    _cameraService.dispose();
    super.dispose();
  }

  /// starts the camera & start framing faces
  _start() async {
    _initializeControllerFuture =
        _cameraService.startService(widget.cameraDescription);
    await _initializeControllerFuture;

    setState(() {
      cameraInitializated = true;
    });

    _frameFaces();
  }

  Future<void> onShot() async {
    /**
     * *if no face is detected
     * *Then a pop up dialog will appear to notice the user that no face is detected
     * **/
    if (faceDetected == null) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(
              'No face detected!'.tr().toString(),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 24),
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.white,
            elevation: 11,
            title: Lottie.asset(
              'assets/noFace.json',
              width: 200,
              height: 150,
            ),
          );
        },
      );

      return false;
    } else {
      /**
       *  *If the button is pressed first we check if there is any face detected
       * *If a face is detected then we will delay for 500 miliSeconds and stop the
       * *image stream then we take that picture take and put it in a file and save it
       * *in our Database withe all the data of the face registered
       * **/
      _saving = true;
      await Future.delayed(Duration(milliseconds: 500));
      await _cameraService.cameraController.stopImageStream();
      await Future.delayed(Duration(milliseconds: 200));
      XFile file = await _cameraService.takePicture();
      imagePath = file.path;

      setState(() {
        _bottomSheetVisible = true;
        pictureTaked = true;
      });

      return true;
    }
  }

  _frameFaces() {
    /**
     * *draws rectangles when detects faces
     * *by calling the mlkitservice to get the face detected from the image
     * *if no face detected then no rectangle will be drawn
     * **/
    imageSize = _cameraService.getImageSize();

    _cameraService.cameraController.startImageStream((image) async {
      if (_cameraService.cameraController != null) {
        // if its currently busy, avoids overprocessing
        if (_detectingFaces) return;

        _detectingFaces = true;

        try {
          List<Face> faces = await _mlKitService.getFacesFromImage(image);

          if (faces.length > 0) {
            setState(() {
              faceDetected = faces[0];
            });

            if (_saving) {
              _faceNetService.setCurrentPrediction(image, faceDetected);
              setState(() {
                _saving = false;
              });
            }
          } else {
            setState(() {
              faceDetected = null;
            });
          }

          _detectingFaces = false;
        } catch (e) {
          print(e);
          _detectingFaces = false;
        }
      }
    });
  }

  _onBackPressed() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => NavBar.ind(index: 1,isUser: false,)
        ),(Route<dynamic> route) => false
    );
  }

  _reload() {
    setState(() {
      _bottomSheetVisible = false;
      cameraInitializated = false;
      pictureTaked = false;
    });
    this._start();
  }

  @override
  Widget build(BuildContext context) {
    final double mirror = math.pi;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Stack(
          children: [
            FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (pictureTaked) {
                    return Container(
                      width: width,
                      height: height,
                      child: Transform(
                          alignment: Alignment.center,
                          child: FittedBox(
                            fit: BoxFit.cover,
                            child: Image.file(File(imagePath)),
                          ),
                          transform: Matrix4.rotationY(mirror)),
                    );
                  } else {
                    return Transform.scale(
                      scale: 1.0,
                      child: AspectRatio(
                        aspectRatio: MediaQuery.of(context).size.aspectRatio,
                        child: OverflowBox(
                          alignment: Alignment.center,
                          child: FittedBox(
                            fit: BoxFit.fitHeight,
                            child: Container(
                              width: width,
                              height: width *
                                  _cameraService
                                      .cameraController.value.aspectRatio,
                              child: Stack(
                                fit: StackFit.expand,
                                children: <Widget>[
                                  CameraPreview(
                                      _cameraService.cameraController),
                                  CustomPaint(
                                    painter: FacePainter(
                                        face: faceDetected,
                                        imageSize: imageSize),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
            CameraHeader(
              "SIGN UP".tr().toString(),
              onBackPressed: _onBackPressed,
            )
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: !_bottomSheetVisible
            ? AuthActionButton(
                _initializeControllerFuture,
                onPressed: onShot,
                isLogin: false,
                reload: _reload,
              )
            : Container());
  }
}
