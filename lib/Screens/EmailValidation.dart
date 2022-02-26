import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:pin_code_fields/pin_code_fields.dart' as pinCode;
import 'package:rflutter_alert/rflutter_alert.dart';

import '../widgets/Constants.dart';
import 'ResetPassword.dart';

class EmailValidation extends StatefulWidget {
  static const String id = 'EmailValidation';

  static String emailCode;

  @override
  _EmailValidationState createState() => _EmailValidationState(emailCode);
}

class _EmailValidationState extends State<EmailValidation> {
  TextEditingController _controller = TextEditingController();
  StreamController<pinCode.ErrorAnimationType> _errorController =
      StreamController<pinCode.ErrorAnimationType>();

  bool showSpinner = false;

  String _code;
  String _emailCode;

  _EmailValidationState(this._emailCode);

  @override
  void initState() {
    super.initState();

    _code = '';
  }

  void showError() {
    _errorController.add(
        pinCode.ErrorAnimationType.shake); // Triggering error shake animation
    showSnackBar(_scaffoldKey, 'Wrong code! please try again').show();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFd4ebe8),
        elevation: 0,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 30,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      key: _scaffoldKey,
      backgroundColor: Color(0xFFd4ebe8),
      body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          opacity: 0.5,
          progressIndicator: Lottie.asset('assets/indicator.json',
              height: 130, fit: BoxFit.cover, animate: true, repeat: true),
          child: SingleChildScrollView(
            child: SafeArea(
                child: Column(
              children: [
                Lottie.asset(
                  'assets/email.json',
                  repeat: true,
                  fit: BoxFit.cover,
                  height: 250,
                  width: 250,
                  animate: true,
                ),
                SizedBox(
                  height: 15,
                ),
                Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 100),
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 0),
                      child: loadingButtons(
                          loadingType: SpinKitChasingDots(
                            color: Colors.white,
                          ),
                          width: 300,
                          colour: Colors.green,
                          text: 'VERIFY',
                          textColor: Colors.white,
                          onTap: (startLoading, stopLoading, btnState) async {
                            startLoading();
                            setState(() {
                              showSpinner = true;
                            });
                            if (_code.compareTo(_emailCode) == 0) {
                              Navigator.pushReplacementNamed(
                                  context, ResetPassword.id);
                              _controller.clear();
                              stopLoading();
                              setState(() {
                                setState(() {
                                  showSpinner = false;
                                });
                              });
                            } else {
                              setState(() {
                                showSpinner = false;
                              });
                              showError();
                              _controller.clear();
                              stopLoading();
                            }
                          }),
                    ),
                  ],
                )
              ],
            )),
          )),
    );
  }
}
