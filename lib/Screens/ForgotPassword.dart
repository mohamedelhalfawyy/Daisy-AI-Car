import 'package:auto_size_text/auto_size_text.dart';
import 'package:date_format/date_format.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:graduation_project/Services/AuthServices.dart';
import 'package:lottie/lottie.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'dart:math';
import 'package:google_sign_in/google_sign_in.dart';

import '../Services/Firestore_Services.dart';
import '../widgets/Constants.dart';
import '../widgets/FadeAnimation.dart';
import 'EmailValidation.dart';
import 'ResetPassword.dart';

class ForgotPassword extends StatefulWidget {
  static const String id = 'ForgetScreen';

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  TextEditingController _emailController = TextEditingController();

  String _adminEmail = 'MMFS.DAISY@gmail.com';
  String _adminPassword = 'DAISY1234';

  String _email;
  String _code;

  @override
  void initState() {
    super.initState();
    _code = '';
  }

  void getCode() {
    for (int i = 0; i < 6; i++) {
      _code += Random().nextInt(10).toString();
    }
  }

  bool showSpinner = false;

  Future<void> sendEmail(String userEmail) async {
    getCode();

    final user = await AuthServices().googleSignIn();
    final email = user.email;
    final auth = await user.authentication;
    final token = auth.accessToken;

    print("Authenticated: $email");

    final smtpServer = gmailSaslXoauth2(email, token);

// ignore: non_constant_identifier_names
    var Date = formatDate(
        DateTime.now(), [yyyy, '-', mm, '-', dd, '\t', h, ':', nn, ' ', am]);

    final message = Message()
      ..from = Address(email, 'Daisy Team')
      ..recipients.add(_email)
      ..subject = 'Reset your password for Daisy Application $Date'
      ..text = 'Hello,'
          '\n\nPlease Enter this confirmation code in your application to reset your password:\n\n'
          ' $_code'
          ' \n\nIf you didn\'t ask to reset your password, you can ignore this email.\n\n'
          'Thanks,\n\n'
          'Beeb Boop\n\n'
          'Your Daisy Support Team.';

    try {
      final sendReport =
          await send(message, smtpServer, timeout: Duration(seconds: 15));

      print('Message sent: ' + sendReport.toString());

      setState(() {
        EmailValidation.emailCode = _code;
        ResetPassword.userEmail = _email;
      });

      Navigator.pushNamed(context, EmailValidation.id);
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }

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
              Lottie.asset("assets/read.json",
                  alignment: Alignment.center,
                  fit: BoxFit.cover,
                  animate: true,
                  repeat: true),
              SizedBox(
                height: 15,
              ),
              FadeAnimation(
                1.2,
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AutoSizeText(
                    'We will send you an email to reset your password',
                    style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                    maxLines: 2,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: FadeAnimation(
                    1.3,
                    LTextField(
                      icon: Icons.email,
                      isSecured: false,
                      hintText: "Enter your email address",
                      labelText: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      maxLength: 30,
                      validator: Validations().emailValidator,
                      onChanged: (String val) => _email = val,
                      controller: _emailController,
                      isAutoValidate: AutovalidateMode.onUserInteraction,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              FadeAnimation(
                1.4,
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: loadingButtons(
                      loadingType: SpinKitFadingCircle(
                        color: Colors.white,
                      ),
                      colour: Colors.green,
                      text: 'Send',
                      width: 350,
                      textColor: Colors.white,
                      onTap: (startLoading, stopLoading, btnState) async {
                        if (_formKey.currentState.validate()) {
                          startLoading();
                          setState(() {
                            showSpinner = true;
                          });

                          bool _isConnected =
                              await Connection().checkConnection();

                          if (_isConnected) {
                            try {
                              bool isValid =
                                  await FireStoreServices().checkEmail(_email);

                              if (isValid) {
                                await sendEmail(_email);

                                stopLoading();
                                setState(() {
                                  showSpinner = false;
                                });
                                _emailController.clear();
                              } else {
                                showSnackBar(_scaffoldKey,
                                        "Email address does not exist!\n please try again")
                                    .show();

                                setState(() {
                                  showSpinner = false;
                                  _emailController.clear();
                                });

                                stopLoading();

                                return;
                              }
                            } catch (e) {
                              stopLoading();
                              setState(() {
                                showSpinner = false;
                                _emailController.clear();
                              });
                              showSnackBar(_scaffoldKey,
                                      "Email address does not exist!\n please try again")
                                  .show();
                            }
                          } else {
                            showSnackBar(_scaffoldKey, 'No internet connection')
                                .show();
                            stopLoading();
                            setState(() {
                              showSpinner = false;
                            });
                          }
                        }
                      }),
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }
}
