import 'dart:math';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'dart:ui' as ui;

import '../Services/AuthServices.dart';
import '../Services/Firestore_Services.dart';
import '../widgets/Constants.dart';
import '../widgets/FadeAnimation.dart';
import 'DashBoard.dart';
import 'navbar.dart';

class ResetPassword extends StatefulWidget {
  static const String id = 'ResetPassword';

  static String userEmail;

  @override
  _ResetPasswordState createState() => _ResetPasswordState(userEmail);
}

class _ResetPasswordState extends State<ResetPassword> {
  int index = 0;

  bool showSpinner = false;

  String _password;

  bool _isSecure = true;

  var _changedIcon = Icon(Icons.visibility);

  String _userEmail;

  _ResetPasswordState(this._userEmail);

  TextEditingController _passController = TextEditingController();
  TextEditingController _confirmController = TextEditingController();

  final _formKey = GlobalKey<FormState>();


  @override
  void dispose() {
    _confirmController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height * 0.05;
    return Directionality(
      textDirection: ui.TextDirection.ltr,
      child: Scaffold(
          backgroundColor: Color(0xff4A7FE4),
          body: ModalProgressHUD(
            inAsyncCall: showSpinner,
            opacity: 0.5,
            progressIndicator: Lottie.asset('assets/indicator.json',
                height: 100, fit: BoxFit.cover, animate: true, repeat: true),
            child: SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Lottie.asset('assets/reset.json',
                          height: 400,
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.fill,
                          animate: true,
                          repeat: true)
                    ]),
                    Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(60),
                                topLeft: Radius.circular(60)),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 20,
                              )
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: height,
                                    ),
                                    FadeAnimation(
                                      1,
                                      LTextField(
                                        icon: Icons.lock,
                                        isSecured: _isSecure,
                                        hintText: 'Enter your Password'
                                            .tr()
                                            .toString(),
                                        labelText: 'Password'.tr().toString(),
                                        keyboardType:
                                            TextInputType.visiblePassword,
                                        maxLength: 20,
                                        validator:
                                            Validations().passwordValidator,
                                        onChanged: (String value) =>
                                            _password = value,
                                        controller: _passController,
                                        endIcon: IconButton(
                                          icon: _changedIcon,
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
                                                _changedIcon =
                                                    Icon(Icons.visibility);
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: height,
                                    ),
                                    FadeAnimation(
                                      1.3,
                                      LTextField(
                                          icon: Icons.lock,
                                          isSecured: _isSecure,
                                          hintText: 'Enter your Password'
                                              .tr()
                                              .toString(),
                                          labelText: 'ConfirmPassword'
                                              .tr()
                                              .toString(),
                                          keyboardType:
                                              TextInputType.visiblePassword,
                                          maxLength: 20,
                                          validator: (val) => MatchValidator(
                                                errorText:
                                                    'Passwords do not match'
                                                        .tr()
                                                        .toString(),
                                              ).validateMatch(val, _password),
                                          controller: _confirmController,
                                          endIcon: IconButton(
                                              icon: _changedIcon,
                                              onPressed: () {
                                                if (_isSecure) {
                                                  setState(() {
                                                    _isSecure = false;
                                                    _changedIcon = Icon(
                                                        Icons.visibility_off);
                                                  });
                                                } else {
                                                  setState(() {
                                                    _isSecure = true;
                                                    _changedIcon =
                                                        Icon(Icons.visibility);
                                                  });
                                                }
                                              })),
                                    ),
                                    SizedBox(
                                      height: height,
                                    ),
                                    loadingButtons(
                                        loadingType: SpinKitDualRing(
                                          color: Colors.white,
                                        ),
                                        width: 350,
                                        textColor: Colors.white,
                                        text: 'Reset'.tr().toString(),
                                        colour: Color(0xFF051D6D),
                                        onTap: (startLoading, stopLoading,
                                            btnState) async {
                                          /**
                                           * *First we check that the password is validated successfully
                                           * *Then we get the old password of this user and compare it to the
                                           * *new password if they are the same we give an error else
                                           * *the new password is saved and updated in firebase then the user
                                           * *is directed back to login page
                                           * **/
                                          if (_formKey.currentState
                                              .validate()) {
                                            startLoading();
                                            setState(() {
                                              showSpinner = true;
                                            });
                                            String oldPassword =
                                                await FireStoreServices()
                                                    .getPassword(_userEmail);

                                            if (oldPassword ==
                                                _passController.text) {
                                              alertFlutter(
                                                  'You are trying to change to same Password'
                                                      .tr()
                                                      .toString(),
                                                  'Try another Password'
                                                      .tr()
                                                      .toString(),
                                                  AlertType.error);
                                            }else{
                                              await AuthServices()
                                                  .signInWithEmail(
                                                  _userEmail, oldPassword);

                                              await AuthServices().updatePassword(_passController.text);
                                              await AuthServices.signOut();


                                              DashBoard.isUser = false;
                                              Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => NavBar.ind(index: 1,isUser: false)
                                                  ),(Route<dynamic> route) => false
                                              );

                                            }

                                            stopLoading();
                                            setState(() {
                                              showSpinner = false;
                                            });
                                          }
                                        })
                                  ],
                                )),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }

  void alertFlutter(String title, String desc, AlertType icon) {
    var style = AlertStyle(
      animationType: AnimationType.grow,
      isCloseButton: false,
      isOverlayTapDismiss: false,
      descStyle: TextStyle(fontWeight: FontWeight.bold),
      animationDuration: Duration(milliseconds: 400),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
        side: BorderSide(
          color: Colors.grey,
        ),
      ),
      titleStyle: TextStyle(
        color: Colors.green,
      ),
    );
    Alert(
      context: context,
      style: style,
      type: icon,
      title: title,
      desc: desc,
      buttons: [
        DialogButton(
          child: Text(
            'Confirm'.tr().toString(),
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => null,
          color: Color.fromRGBO(0, 179, 134, 1.0),
          radius: BorderRadius.circular(0.0),
        ),
      ],
    ).show();
  }
}
