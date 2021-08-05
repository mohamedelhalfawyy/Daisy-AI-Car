import 'package:flutter/material.dart';
import 'package:graduation_project/Models/user.model.dart';
import 'package:graduation_project/Screens/DashBoard.dart';
import 'package:graduation_project/Screens/control_room.dart';
import 'package:graduation_project/Screens/navbar.dart';
import 'package:graduation_project/Services/camera.service.dart';
import 'package:graduation_project/Services/facenet.service.dart';
import 'package:graduation_project/db/database.dart';
import 'package:lottie/lottie.dart';
import 'package:rive_splash_screen/rive_splash_screen.dart';
import 'app_button.dart';
import 'app_text_field.dart';

class AuthActionButton extends StatefulWidget {
  AuthActionButton(this._initializeControllerFuture,
      {Key key, @required this.onPressed, @required this.isLogin, this.reload});

  final Future _initializeControllerFuture;
  final Function onPressed;
  final bool isLogin;
  final Function reload;

  @override
  _AuthActionButtonState createState() => _AuthActionButtonState();
}

class _AuthActionButtonState extends State<AuthActionButton> {
  /// service injection
  final FaceNetService _faceNetService = FaceNetService();
  final DataBaseService _dataBaseService = DataBaseService();
  final CameraService _cameraService = CameraService();

  final TextEditingController _userTextEditingController =
      TextEditingController(text: '');
  final TextEditingController _passwordTextEditingController =
      TextEditingController(text: '');

  final _formKey = GlobalKey<FormState>();

  User predictedUser;

  Future _signUp(context) async {
    /// gets predicted data from facenet service (user face detected)
    List predictedData = _faceNetService.predictedData;
    String user = _userTextEditingController.text;
    String password = _passwordTextEditingController.text;

    /// creates a new user in the 'database'
    await _dataBaseService.saveData(user, password, predictedData);

    /// resets the face stored in the face net sevice
    this._faceNetService.setPredictedData(null);
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => DashBoard()));
  }

  Future _signIn(context) async {
    String password = _passwordTextEditingController.text;

    if (this.predictedUser.password == password) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            content: Lottie.asset(
              'assets/faceChecked.json',
              height: 400,
              width: 350,
              fit: BoxFit.contain,
              animate: true,
              onLoaded: (value) async {
                var _name = this.predictedUser.user;
                var _imagePath;

                if (_name.startsWith('s|S')) {
                  _imagePath = 'assets/Images/Seby.jpeg';
                }
                else if (_name.startsWith('h|H')) {
                  _imagePath = 'assets/Images/Halfawy.jpeg';
                }
                else if (_name.startsWith('m|M')) {
                  _imagePath = 'assets/Images/Marwan.jpeg';
                }
                else if (_name.startsWith('f|F')) {
                  _imagePath = 'assets/Images/Farida.jpeg';
                }
                else
                  _imagePath = _cameraService.imagePath;
                
                await Future.delayed(const Duration(seconds: 5), () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NavBar.Info(
                            username: this.predictedUser.user,
                            index: 1,

                            //imagePath: _imagePath,
                          )
                      ),(Route<dynamic> route) => false
                  );
                });
              },
              alignment: Alignment.center,
              repeat: false,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: Colors.black,
            elevation: 11,
            title: Text(
              'Checking Credentials\n Please Wait...',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  fontSize: 23,
                  color: Colors.white),
              textAlign: TextAlign.center,
            ),
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(
              'Incorrect Password',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 24),
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.white,
            elevation: 11,
            title: SplashScreen.callback(
              fit: BoxFit.cover,
              name: 'assets/wrong.riv',
              height: 150,
              width: 200,
              onSuccess: (data) {},
              onError: (err, stack) {},
              startAnimation: 'show',
              until: () => Future.delayed(Duration(milliseconds: 100)),
              loopAnimation: 'show',
            ),
          );
        },
      );
    }
  }

  String _predictUser() {
    String userAndPass = _faceNetService.predict();
    return userAndPass ?? null;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        try {
          // Ensure that the camera is initialized.
          await widget._initializeControllerFuture;
          // onShot event (takes the image and predict output)
          bool faceDetected = await widget.onPressed();

          if (faceDetected) {
            if (widget.isLogin) {
              var userAndPass = _predictUser();
              if (userAndPass != null) {
                this.predictedUser = User.fromDB(userAndPass);
              }
            }
            PersistentBottomSheetController bottomSheetController =
                Scaffold.of(context)
                    .showBottomSheet((context) => signSheet(context));

            bottomSheetController.closed.whenComplete(() => widget.reload());
          }
        } catch (e) {
          print(e);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color(0xFF0F0BDB),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.blue.withOpacity(0.1),
              blurRadius: 1,
              offset: Offset(0, 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        width: MediaQuery.of(context).size.width * 0.8,
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'CAPTURE',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(
              width: 10,
            ),
            Icon(Icons.camera_alt, color: Colors.white)
          ],
        ),
      ),
    );
  }

  signSheet(context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          widget.isLogin && predictedUser != null
              ? Container(
                  child: Text(
                    'Welcome back, ' + predictedUser.user + '.',
                    style: TextStyle(fontSize: 20),
                  ),
                )
              : widget.isLogin
                  ? Column(
                      children: [
                        Container(
                            child: Text(
                          'User not found 😞',
                          style: TextStyle(fontSize: 20),
                        )),
                        SizedBox(height: 15,),
                        SplashScreen.callback(
                          backgroundColor: Colors.white,
                          fit: BoxFit.cover,
                          name: 'assets/er.riv',
                          height: 150,
                          width: 200,
                          onSuccess: (data) {},
                          onError: (err, stack) {},
                          startAnimation: 'Manatime 404 Error',
                          endAnimation: 'Manatime 404 Error',
                          until: () =>
                              Future.delayed(Duration(milliseconds: 100)),
                          loopAnimation: 'Manatime 404 Error',
                        )
                      ],
                    )
                  : Container(),
          Container(
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      !widget.isLogin
                          ? AppTextField(
                              controller: _userTextEditingController,
                              labelText: "Your Name",
                            )
                          : Container(),
                      SizedBox(height: 10),
                      widget.isLogin && predictedUser == null
                          ? Container()
                          : AppTextField(
                              controller: _passwordTextEditingController,
                              labelText: "Password",
                              isPassword: true,
                            ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Divider(),
                SizedBox(height: 10),
                widget.isLogin && predictedUser != null
                    ? AppButton(
                        text: 'LOGIN',
                        onPressed: () async {
                          _signIn(context);
                        },
                        icon: Icon(
                          Icons.login,
                          color: Colors.white,
                        ),
                      )
                    : !widget.isLogin
                        ? AppButton(
                            text: 'SIGN UP',
                            onPressed: () async {
                              if (_formKey.currentState.validate())
                                await _signUp(context);
                            },
                            icon: Icon(
                              Icons.person_add,
                              color: Colors.white,
                            ),
                          )
                        : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
