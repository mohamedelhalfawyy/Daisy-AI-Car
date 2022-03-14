import 'dart:io';
import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:graduation_project/Models/user.model.dart';
import 'package:graduation_project/Screens/navbar.dart';
import 'package:graduation_project/Services/AuthServices.dart';
import 'package:graduation_project/Services/Firestore_Services.dart';
import 'package:graduation_project/Services/camera.service.dart';
import 'package:graduation_project/Services/facenet.service.dart';
import 'package:graduation_project/db/database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:rive_splash_screen/rive_splash_screen.dart';
import 'Constants.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:async';

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
  var _imagePa;

  final ImagePicker _picker = ImagePicker();
  dynamic _pickImageError;
  List<XFile> _imageFileList;

  set _imageFile(XFile value) {
    _imageFileList = value == null ? null : <XFile>[value];
  }

  Future<void> saveImage() async {
    try {
      _imagePa = _imageFileList.last.path.split("/").last;

      firebase_storage.FirebaseStorage _storage =
          firebase_storage.FirebaseStorage.instance;

      Reference db = _storage.ref("users/$_imagePa");

      await db.putFile(File(_imageFileList.last.path));

      return await db.getDownloadURL();
    } catch (e) {
      print('$e +10');
    }
  }

  Future<void> loadAssets(ImageSource source,
      {BuildContext context, bool isMultiImage = false}) async {
    try {
      final XFile pickedFile = await _picker.pickImage(
        source: source,
      );

      setState(() {
        _imageFile = pickedFile;
      });

      saveImage();
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
  }

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
                'Email Address Already Exists!'.tr().toString(),
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
      await FireStoreServices().addUser(_email, _password, _name, _imagePa);
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
                      photo: _imagePa,
                      index: 1,
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
                var _imagePath = await FireStoreServices().getPhotoWithPass(password);

                if (_imagePath.isEmpty) {
                  _imagePath = _cameraService.imagePath;
                }

                await Future.delayed(const Duration(seconds: 5), () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NavBar.Info(
                                username: this.predictedUser.user,
                                photo: _imagePath,
                                index: 1,
                              ),
                      ),
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
              'Checking Credentials\n Please Wait...'.tr().toString(),
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
              'Incorrect Password'.tr().toString(),
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
          color: buttonsColor,
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
              'CAPTURE'.tr().toString(),
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
                          'User not found 😞'.tr().toString(),
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
                                  'Enter your Full Name'.tr().toString(),
                              labelText: 'Full Name'.tr().toString(),
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
                              hintText: 'Enter your Password'.tr().toString(),
                              labelText: 'Password'.tr().toString(),
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
                              hintText: 'Enter your Email'.tr().toString(),
                              labelText: 'Email'.tr().toString(),
                              keyboardType: TextInputType.emailAddress,
                              maxLength: 30,
                              validator: Validations().emailValidator,
                              controller: _emailTextEditingController,
                              isAutoValidate: _validate,
                            )
                          : Container(),
                      SizedBox(height: 15),
                      !widget.isLogin ?
                      InkWell(
                        onTap: () {
                          loadAssets(ImageSource.gallery, context: context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey[350],
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
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: 60,
                          child: Row(
                            children: [
                              Icon(Icons.photo, color: Colors.blueGrey),
                              SizedBox(width: 10,),
                              Text(
                                'Pick Image'.tr().toString(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                        ),
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
                            color: buttonsColor,
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
                                'LOGIN'.tr().toString(),
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
                                  'SIGN UP'.tr().toString(),
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(Icons.person_add, color: Colors.white)
                              ],
                            ),
                            color: buttonsColor,
                            borderRadius: 12,
                            padding: EdgeInsets.symmetric(
                                vertical: 14, horizontal: 16),
                            elevation: 5,
                            loader: SpinKitSquareCircle(
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
