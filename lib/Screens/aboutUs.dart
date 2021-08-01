import 'package:flutter/material.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({key}) : super(key: key);

  static const String id = 'AboutUs';

  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us!!'),
      ),
      backgroundColor: Color(0XFFC7FFBE),
      body: Container(
        height: double.infinity,
        // write here the about us page
      ),
    );
  }
}
