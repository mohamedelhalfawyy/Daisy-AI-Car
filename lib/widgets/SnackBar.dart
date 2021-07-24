import 'package:flutter/material.dart';

class ShowSnackBar {
  BuildContext context;
  String text;
  Color color;

  ShowSnackBar({@required this.context, @required this.text, @required this.color});

  void show() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        text,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
      elevation: 20,
      behavior: SnackBarBehavior.floating,
      backgroundColor: color,
      duration: Duration(seconds: 3),
    ));
  }
}
