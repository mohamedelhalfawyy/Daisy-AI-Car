import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/Screens/ForgotPassword.dart';
import 'package:graduation_project/Services/Firestore_Services.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../Services/AuthServices.dart';
import '../widgets/Constants.dart';
import '../widgets/FadeAnimation.dart';
import 'QRScanner.dart';
import 'navbar.dart';

class Email_Password extends StatefulWidget {
  const Email_Password({Key key}) : super(key: key);

  static const String id = 'EmailScreen';

  @override
  _Email_PasswordState createState() => _Email_PasswordState();
}

class _Email_PasswordState extends State<Email_Password> {

  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool showSpinner = false;

  String _email;
  String _password;
  bool _isSecure = true;
  AutovalidateMode _validate = AutovalidateMode.onUserInteraction;


  var _changedIcon = Icon(Icons.visibility);

  TextEditingController _passController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  _onBackPressed() {
    Navigator.of(context).pop();
  }

  String change = 'idle';

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: ModalProgressHUD(
              inAsyncCall: showSpinner,
              opacity: 0.5,
              progressIndicator: Lottie.asset('assets/indicator.json',
                  height: 130, fit: BoxFit.cover, animate: true, repeat: true),
              child: SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  color: Colors.white,
                  child: Column(
                    children: [
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              child: InkWell(
                                onTap: _onBackPressed,
                                child: Container(
                                  margin: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: Colors.white70,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  height: 50,
                                  width: 50,
                                  child: Center(child: Icon(Icons.arrow_back)),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Image(
                                image: AssetImage('assets/Images/daisy2.png'),
                                fit: BoxFit.cover,
                                width: 170,
                                height: 150,
                              ),
                            ),
                            SizedBox(
                              width: 90,
                            ),
                          ],
                        ),
                      ),
                      AnimatedContainer(
                        height: MediaQuery.of(context).size.height,
                        duration: Duration(seconds: 50),
                        curve: Curves.fastOutSlowIn,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(60),
                              topLeft: Radius.circular(60)),
                          color: backColor,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 20,
                            )
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.fromLTRB(4, 0, 0, 20),
                                  child: Text(
                                    'Sign In'.tr().toString(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                FadeAnimation(
                                  1,
                                  LTextField(
                                    icon: Icons.email,
                                    isSecured: false,
                                    hintText: 'Enter your Email'.tr().toString(),
                                    labelText: 'Email'.tr().toString(),
                                    keyboardType: TextInputType.emailAddress,
                                    maxLength: 30,
                                    validator: Validations().emailValidator,
                                    onChanged: (String val) {
                                      _email = val;
                                      setState(() {
                                        change = 'success';
                                      });
                                    },
                                    controller: _emailController,
                                    isAutoValidate: _validate,
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                FadeAnimation(
                                  1.3,
                                  LTextField(
                                    icon: Icons.lock,
                                    isSecured: _isSecure,
                                    hintText:
                                    'Enter your Password'.tr().toString(),
                                    labelText: 'Password'.tr().toString(),
                                    keyboardType: TextInputType.visiblePassword,
                                    maxLength: 20,
                                    validator: Validations().passwordValidator,
                                    onChanged: (String value) => _password = value,
                                    controller: _passController,
                                    isAutoValidate: _validate,
                                    endIcon: IconButton(
                                      icon: _changedIcon,
                                      color: Colors.black,
                                      onPressed: () {
                                        if (_isSecure) {
                                          setState(() {
                                            _isSecure = false;
                                            _changedIcon =
                                                Icon(Icons.visibility_off);
                                          });
                                        } else {
                                          setState(() {
                                            _isSecure = true;
                                            _changedIcon = Icon(Icons.visibility);
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                FadeAnimation(
                                  1.6,
                                  loadingButtons(
                                    loadingType: SpinKitDualRing(
                                      color: Colors.white,
                                    ),
                                    colour: Colors.white,
                                    text: 'Login'.tr().toString(),
                                    width: 350,
                                    textColor: Colors.black,
                                    onTap:
                                        (startLoading, stopLoading, btnState) async {
                                      /**
                                       * *First we validate the information the user entered
                                       * *if it's validated then we make sure that the user is connected to the firebase
                                       * *and then start signIn with the email and password user entered
                                       * **/
                                      if (_formKey.currentState.validate()) {
                                        startLoading();
                                        bool _isConnected =
                                        await Connection().checkConnection();
                                        if (_isConnected) {
                                          setState(() {
                                            showSpinner = true;
                                          });
                                          try {
                                            final user = await AuthServices()
                                                .signInWithEmail(_email, _password);

                                            final name = await FireStoreServices().getName(_email);
                                            final photo = await FireStoreServices().getPhoto(_email);

                                            if (user != null) {
                                              /**
                                               * *If user is found in the firebase then login successful and direct to control room
                                               * **/
                                              await Future.delayed(const Duration(seconds: 5), () {
                                                Navigator.pushAndRemoveUntil(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => QR_Scanner(
                                                        username: name,
                                                        photo: photo,
                                                      ),
                                                    ),
                                                        (Route<dynamic> route) => false);
                                              });
                                            }
                                            _passController.clear();
                                            stopLoading();
                                          } catch (e) {
                                            /**
                                             * *Else the user is not found and cant login
                                             * **/
                                            log(e.toString());
                                            showSnackBar(
                                                _scaffoldKey,
                                                'Wrong email or password!'
                                                    .tr()
                                                    .toString())
                                                .show();
                                            _passController.clear();
                                            stopLoading();
                                            setState(() {
                                              showSpinner = false;
                                            });
                                          }
                                        } else {
                                          /**
                                           * *If the user is not connected to the internet
                                           * **/
                                          showSnackBar(
                                              _scaffoldKey,
                                              'No internet connection'
                                                  .tr()
                                                  .toString())
                                              .show();
                                          _passController.clear();
                                          stopLoading();
                                        }
                                      }
                                    },
                                  ),
                                ),
                                SizedBox(height: 20),
                                FadeAnimation(
                                  1.7,
                                  FlatButton(
                                    onPressed: () async {
                                      Navigator.pushNamed(
                                          context, ForgotPassword.id);
                                    },
                                    child: Text(
                                      'Forgot Password?'.tr().toString(),
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ),
            ),
          ),
        )
    );
  }
}
