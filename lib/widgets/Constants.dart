import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:page_transition/page_transition.dart';

class LTextField extends StatelessWidget {
  final IconData icon;
  final endIcon;
  final bool isSecured;
  final String hintText;
  final String labelText;
  final keyboardType;
  final int maxLength;
  final Function validator;
  final Function onChanged;
  final AutovalidateMode isAutoValidate;
  final TextEditingController controller;

  LTextField(
      {@required this.icon,
      this.hintText,
      this.labelText,
      @required this.isSecured,
      this.keyboardType,
      this.maxLength,
      this.validator,
      this.onChanged,
      this.controller,
      this.endIcon,
      this.isAutoValidate = AutovalidateMode.disabled});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.deepOrangeAccent),
          borderRadius: BorderRadius.circular(30),
        ),
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.black),
        prefixIcon: Icon(
          icon,
          color: Colors.blueGrey,
        ),
        suffixIcon: endIcon,
        filled: true,
        fillColor: Colors.grey[350],
        labelText: labelText,
        labelStyle: TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
      obscureText: isSecured,
      keyboardType: keyboardType,
      maxLengthEnforced: true,
      maxLength: maxLength,
      validator: validator,
      onChanged: onChanged,
      controller: controller,
      autovalidateMode: isAutoValidate,
    );
  }
}

// ignore: camel_case_types
class loadingButtons extends StatelessWidget {
  final String text;
  final loadingType;
  final Color colour;
  final double width;
  final Color textColor;
  final Function onTap;
  final double height;
  final double fontsize;

  loadingButtons(
      {this.text,
      @required this.loadingType,
      this.colour,
      this.width,
      this.textColor,
      this.onTap,
      this.height = 50,
      this.fontsize = 18});

  @override
  Widget build(BuildContext context) {
    return ArgonButton(
        height: height,
        width: width,
        borderRadius: 30,
        elevation: 12,
        color: colour,
        child: Text(text,
            textAlign: TextAlign.start,
            style: TextStyle(
              color: textColor,
              fontSize: fontsize,
              fontWeight: FontWeight.w700,
            )),
        loader: Container(
          padding: EdgeInsets.all(10),
          child: loadingType,
        ),
        onTap: onTap);
  }
}

class Connection {
  Future<bool> checkConnection() async {
    var _result = await (Connectivity().checkConnectivity());
    if (_result == ConnectivityResult.mobile ||
        _result == ConnectivityResult.wifi) {
      log('connected to internet');
      return true;
    } else {
      log('no connection');
      return false;
    }
  }
}

class showSnackBar {
  GlobalKey<ScaffoldState> _scaffoldKey;
  String _text;

  showSnackBar(this._scaffoldKey, this._text);

  void show() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(
        _text,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
      elevation: 20,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.red,
      duration: Duration(seconds: 3),
    ));
  }
}

class Validations {
  final passwordValidator = MultiValidator([
    RequiredValidator(errorText: 'password is required'.trim().toString()),
    MinLengthValidator(8, errorText: 'password must be at least 8 digits long'),
    PatternValidator(r'(?=.*?[#?!@$%^&*-])',
        errorText: 'passwords must have at least one special character'),
    PatternValidator(r'(?=.*?[A-Z])',
        errorText: 'passwords must have at least one uppercase character'),
  ]);

  final emailValidator = MultiValidator([
    RequiredValidator(errorText: 'Email is required'),
    EmailValidator(errorText: 'Enter a valid email address')
  ]);

  final nameValidator = MultiValidator([
    RequiredValidator(errorText: 'Name is required'),
    MinLengthValidator(6, errorText: 'name must be at least 6 characters long'),
  ]);
}

List<BoxShadow> shadowList = [
  BoxShadow(color: Colors.grey[300], blurRadius: 30.0, offset: Offset(0, 10))
];

class Navigation {
  final Widget widget;
  final screen;
  final context;
  final PageTransitionType type;


  Navigation(
      {this.widget,
        this.screen,
        this.context,
        this.type
      });

    void navigate(){
      Navigator.of(context).push(PageTransition(
          type: type,
          duration: Duration(milliseconds: 800),
          reverseDuration: Duration(milliseconds: 600),
          child: screen
      ));
    }
}

const Color mainColor = Color(0xff4A7FE4);

