import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graduation_project/Screens/DashBoard.dart';
import 'package:graduation_project/Screens/EmailValidation.dart';
import 'package:graduation_project/Screens/Email_password.dart';
import 'package:graduation_project/Screens/ForgotPassword.dart';
import 'package:graduation_project/Screens/LoadingScreen.dart';
import 'package:graduation_project/Screens/ResetPassword.dart';
import 'package:graduation_project/Screens/aboutUs.dart';
import 'package:graduation_project/Screens/sign-in.dart';
import 'package:graduation_project/Screens/voiceControl.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
    child: MyApp(),
    path: "languages/langs",
    saveLocale: true,
    supportedLocales: [
      Locale('ar', 'EG'),
      Locale('en', 'US'),
    ],
  ),);

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
              debugShowMaterialGrid: false,
              theme: ThemeData(
                primarySwatch: Colors.blue,
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              localizationsDelegates: context.localizationDelegates,
              title: 'Daisy',
              initialRoute: '/',
              routes: {
                '/': (context) => LoadingScreen(),
                DashBoard.id: (context) => DashBoard(),
                SignIn.id: (context) => SignIn(),
                AboutUs.id: (context) => AboutUs(),
                VoiceControl.id: (context) => VoiceControl(),
                Email_Password.id: (context) => Email_Password(),
                ForgotPassword.id: (context) => ForgotPassword(),
                EmailValidation.id: (context) => EmailValidation(),
                ResetPassword.id: (context) => ResetPassword(),
              },
              debugShowCheckedModeBanner: true,
            );
  }
}
