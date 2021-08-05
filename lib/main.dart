import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graduation_project/Screens/DashBoard.dart';
import 'package:graduation_project/Screens/LoadingScreen.dart';
import 'package:graduation_project/Screens/aboutUs.dart';
import 'package:graduation_project/Screens/control_room.dart';
import 'package:graduation_project/Screens/sign-in.dart';
import 'package:graduation_project/Screens/voiceControl.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
      MyApp()
  );

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
        return MaterialApp(
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          title: 'Daisy',
          initialRoute: '/',
          routes: {
            '/' : (context) => LoadingScreen(),
            DashBoard.id : (context) => DashBoard(),
            SignIn.id : (context) => SignIn(),
            AboutUs.id : (context) => AboutUs(),
            VoiceControl.id : (context) => VoiceControl(),
          },
          debugShowCheckedModeBanner: false,
        );
  }
}