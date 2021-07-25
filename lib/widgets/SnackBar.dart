import 'package:flutter/material.dart';

class ShowSnackBar {
  BuildContext context;
  String text;
  Color color;
  bool isWifi;
  IconData icon;

  ShowSnackBar({@required this.context, @required this.text, @required this.color,@required this.isWifi, @required this.icon});

  void show() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: isWifi ? Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(width: 10,),
          Icon(icon,color: Colors.white,),
        ],
      ): Text(
        text,
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
      elevation: 20,
      behavior: SnackBarBehavior.floating,
      backgroundColor: color,
      duration: Duration(seconds: 3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0, // Inner padding for SnackBar content.
      ),
    ));
  }
}
