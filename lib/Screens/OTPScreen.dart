import 'dart:async';
import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:camera/camera.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:graduation_project/Screens/sign-up.dart';
import 'package:pin_code_fields/pin_code_fields.dart' as pinCode;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:synchronized/synchronized.dart';

import '../Services/FirebaseApi.dart';
import '../Services/facenet.service.dart';
import '../Services/ml_kit_service.dart';
import '../db/database.dart';
import '../widgets/Constants.dart';

// ignore: must_be_immutable
class OTPScreen extends StatefulWidget {
  static const String id = 'OTPScreen';


  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  String _code = '';
  static const _privateCode = '100100';
  var _lock = new Lock();

  FaceNetService _faceNetService = FaceNetService();

  MLKitService _mlKitService = MLKitService();

  DataBaseService _dataBaseService = DataBaseService();

  bool loading = false;


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

  CameraDescription cameraDescription;

  TextEditingController _controller = TextEditingController();
  StreamController<pinCode.ErrorAnimationType> _errorController =
  StreamController<pinCode.ErrorAnimationType>();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  // ignore: missing_return
  Future<bool> checkCode(String code) async {
    if(code.compareTo(_privateCode) == 0)
      return true;
    else
      return false;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _code = '';

  }

  void showError() {
    _errorController.add(
        pinCode.ErrorAnimationType.shake); // Triggering error shake animation
    showSnackBar(_scaffoldKey, 'Wrong code! please try again').show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 30,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      key: _scaffoldKey,
      backgroundColor: Colors.grey[900],
      body: SingleChildScrollView(
            child: SafeArea(
                child: Column(
                  children: [
                    Text(
                        "Please enter the Security Code",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold
                        ),
                    ),
                    Container(
                      height: 500,
                      child: FlareActor(
                        'assets/check.flr',
                        animation: 'otp',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Column(
                      children: [
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: pinCode.PinCodeTextField(
                              controller: _controller,
                              errorAnimationController: _errorController,
                              animationType: pinCode.AnimationType.fade,
                              appContext: context,
                              obscureText: false,
                              autoDisposeControllers: false,
                              length: 6,
                              onChanged: (value) {
                                setState(() {
                                  _code = value;
                                });
                              },
                              pinTheme: pinCode.PinTheme(
                                  inactiveFillColor: Colors.grey,
                                  shape: pinCode.PinCodeFieldShape.box,
                                  borderRadius: BorderRadius.circular(20),
                                  fieldHeight: 50,
                                  fieldWidth: 45,
                                  activeFillColor: Colors.white,
                                  selectedFillColor: Colors.grey),
                              animationDuration: Duration(milliseconds: 300),
                              backgroundColor: Colors.transparent,
                              enableActiveFill: true,
                              autoDismissKeyboard: true,
                              keyboardType: TextInputType.number,
                            )),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: loadingButtons(
                              loadingType: SpinKitChasingDots(
                                color: Colors.white,
                              ),
                              width: 300,
                              colour: Color(0xff32C8A2),
                              text: 'VERIFY',
                              textColor: Colors.white,
                              onTap: (startLoading, stopLoading, btnState) async {
                                startLoading();

                                if (_code.length != 6) {
                                  showError();
                                  _controller.clear();
                                  stopLoading();
                                  return;
                                }

                                bool _result = await _lock.synchronized(() async {
                                  return await checkCode(_code);
                                });

                                if (_result) {

                                  setState(() {
                                      Alert(
                                        style: AlertStyle(
                                            animationType: AnimationType.fromTop,
                                            isCloseButton: false,
                                            isOverlayTapDismiss: false,
                                            descStyle:
                                            TextStyle(fontWeight: FontWeight.bold),
                                            animationDuration:
                                            Duration(milliseconds: 1000),
                                            alertBorder: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(15),
                                              side: BorderSide(
                                                color: Colors.grey,
                                              ),
                                            )),
                                        type: AlertType.success,
                                        context: context,
                                        title: "Validation Successful",
                                        buttons: [
                                          DialogButton(
                                            gradient: LinearGradient(colors: [
                                              Color.fromRGBO(116, 116, 191, 1.0),
                                              Color.fromRGBO(52, 138, 199, 1.0)
                                            ]),
                                            child: Text(
                                              "Sign Up!",
                                              style: TextStyle(
                                                  color: Colors.white, fontSize: 16),
                                            ),
                                            onPressed: () async{

                                              await _startUp();

                                              setState(() {
                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => SignUp(cameraDescription: cameraDescription)
                                                    )
                                                );
                                              });
                                            },
                                            width: 120,
                                          ),
                                        ],
                                        content: Container(
                                          height: 350,
                                          child: FlareActor(
                                            'assets/done.flr',
                                            animation: 'otpDone',
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ).show();
                                      _controller.clear();
                                      stopLoading();
                                  });
                                } else {
                                  showError();

                                  _controller.clear();
                                  stopLoading();
                                  return;
                                }
                              }),
                        ),
                      ],
                    )
                  ],
                )),
          )
    );
  }
}