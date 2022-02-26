import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:graduation_project/Models/user.model.dart';
import 'package:graduation_project/Screens/DashBoard.dart';
import 'package:graduation_project/Screens/control_room.dart';
import 'package:graduation_project/Screens/navbar.dart';
import 'package:graduation_project/Services/AuthServices.dart';
import 'package:graduation_project/Services/Firestore_Services.dart';
import 'package:graduation_project/Services/camera.service.dart';
import 'package:graduation_project/Services/facenet.service.dart';
import 'package:graduation_project/db/database.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rive_splash_screen/rive_splash_screen.dart';
import 'Constants.dart';
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
  final TextEditingController _emailTextEditingController =
      TextEditingController(text: '');

  final _formKey = GlobalKey<FormState>();

  User predictedUser;

  bool _isSecure = true;
  AutovalidateMode _validate = AutovalidateMode.onUserInteraction;

  bool _isTaken;

  Future _signUp(context) async {
    /// gets predicted data from facenet service (user face detected)
    List predictedData = _faceNetService.predictedData;
    String _email = _emailTextEditingController.text;
    String _name = _userTextEditingController.text;
    String _password = _passwordTextEditingController.text;

    _isTaken = await FireStoreServices().checkEmail(_email);

    if (_isTaken) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              content: Text(
                'Email Address Already Exists!',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 24),
                textAlign: TextAlign.center,
              ),
              backgroundColor: Colors.white,
              elevation: 11,
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Lottie.asset(
                    'assets/emailTaken.json',
                    height: 130,
                    fit: BoxFit.cover,
                    animate: true,
                    repeat: false,
                ),
              )
          );
        },
      );

      _emailTextEditingController.clear();
      _passwordTextEditingController.clear();
    } else {
      await FireStoreServices().addUser(_email, _password, _name);
      await AuthServices().createUserWithEmail(_email, _password);

      /// creates a new user in the 'database'
      await _dataBaseService.saveData(_name, _password, predictedData);

      /// resets the face stored in the face net sevice
      this._faceNetService.setPredictedData(null);

      await Future.delayed(const Duration(seconds: 5), () {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => NavBar.Info(
                      username: _name,
                      index: 1,

                      //imagePath: _imagePath,
                    )),
            (Route<dynamic> route) => false);
      });
    }
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
                } else if (_name.startsWith('h|H')) {
                  _imagePath = 'assets/Images/Halfawy.jpeg';
                } else if (_name.startsWith('m|M')) {
                  _imagePath = 'assets/Images/Marwan.jpeg';
                } else if (_name.startsWith('f|F')) {
                  _imagePath = 'assets/Images/Farida.jpeg';
                } else
                  _imagePath = _cameraService.imagePath;

                await Future.delayed(const Duration(seconds: 5), () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NavBar.Info(
                                username: this.predictedUser.user,
                                index: 1,

                                //imagePath: _imagePath,
                              )),
                      (Route<dynamic> route) => false);
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
          color: Color(0xFF1B50B7),
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
              style: TextStyle(color: Colors.white, fontSize: 20),
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
                        SizedBox(
                          height: 15,
                        ),
                        Lottie.asset(
                          "assets/faceError.json",
                          height: 100,
                        ),
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
                          ? LTextField(
                              icon: Icons.person,
                              isSecured: false,
                              hintText:
                                  'Enter your Full Name'.trim().toString(),
                              labelText: 'Full Name'.trim().toString(),
                              keyboardType: TextInputType.name,
                              maxLength: 20,
                              validator: Validations().nameValidator,
                              controller: _userTextEditingController,
                              isAutoValidate: _validate,
                            )
                          : Container(),
                      SizedBox(height: 15),
                      widget.isLogin && predictedUser == null
                          ? Container()
                          : LTextField(
                              icon: Icons.lock,
                              isSecured: _isSecure,
                              hintText: 'Enter your Password'.trim().toString(),
                              labelText: 'Password'.trim().toString(),
                              keyboardType: TextInputType.visiblePassword,
                              maxLength: 20,
                              validator: Validations().passwordValidator,
                              controller: _passwordTextEditingController,
                              isAutoValidate: _validate,
                            ),
                      SizedBox(height: 15),
                      !widget.isLogin
                          ? LTextField(
                              icon: Icons.email,
                              isSecured: false,
                              hintText: 'Enter your Email'.trim().toString(),
                              labelText: 'Email'.trim().toString(),
                              keyboardType: TextInputType.emailAddress,
                              maxLength: 30,
                              validator: Validations().emailValidator,
                              controller: _emailTextEditingController,
                              isAutoValidate: _validate,
                            )
                          : Container(),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Divider(),
                SizedBox(height: 10),
                widget.isLogin && predictedUser != null
                    ? InkWell(
                        onTap: () async {
                          await _signIn(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xFF1B50B7),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.1),
                                blurRadius: 1,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(
                              vertical: 14, horizontal: 16),
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: 60,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'LOGIN',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Icon(Icons.person_add, color: Colors.white)
                            ],
                          ),
                        ),
                      )
                    : !widget.isLogin
                        ? ArgonButton(
                            height: 60,
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'SIGN UP',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(Icons.person_add, color: Colors.white)
                              ],
                            ),
                            color: Color(0xFF1B50B7),
                            borderRadius: 12,
                            padding: EdgeInsets.symmetric(
                                vertical: 14, horizontal: 16),
                            elevation: 5,
                            loader: SpinKitRotatingCircle(
                              color: Colors.white,
                            ),
                            onTap: (startLoading, stopLoading, btnState) async {
                              startLoading();

                              if (_formKey.currentState.validate()) {
                                await _signUp(context);
                              }

                              stopLoading();
                            },
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
