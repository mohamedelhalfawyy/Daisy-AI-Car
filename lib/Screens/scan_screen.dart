import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:camera/camera.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graduation_project/Screens/Chatbot.dart';
import 'package:graduation_project/Screens/EmailValidation.dart';
import 'package:graduation_project/Screens/OTPScreen.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:graduation_project/Screens/ResetPassword.dart';
import 'package:graduation_project/Screens/sign-in.dart';
import 'package:graduation_project/Services/facenet.service.dart';
import 'package:graduation_project/Services/ml_kit_service.dart';
import 'package:graduation_project/db/database.dart';
import 'package:graduation_project/widgets/Constants.dart';
import 'package:graduation_project/widgets/FadeAnimation.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../widgets/languages.dart';
import 'Email_password.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'dart:ui' as ui;
import 'dart:developer' as dev;
import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:camera/camera.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/languages.dart';
import 'Email_password.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';




class ScanScreen extends StatefulWidget {
  const ScanScreen({Key key}) : super(key: key);

  //final String username;

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  /*
  *                       Navigation(
                              widget: widget,
                              context: context,
                              type: PageTransitionType.rightToLeft,
                              screen: OTPScreen())
                          .navigate();
  * */

  final lottieFile = 'assets/faceError.json';

  FaceNetService _faceNetService = FaceNetService();

  MLKitService _mlKitService = MLKitService();

  DataBaseService _dataBaseService = DataBaseService();

  CameraDescription cameraDescription;

  bool loading = false;

  bool isDone = false;

  List<String> bot = [];
  List<String> commands = [];

  String welcomeMessage;
  String description;
  String note;
  String forwardCommand = "Enter the command equivalent to Forward.";

  String username = "Halfawy";

  //_ScanScreenState(this.username);

  Future<void> load() async{
    bot.clear();

    final prefs = await SharedPreferences.getInstance();

    int status;

    int temp = 0 + Random().nextInt(4 - 0);


    try{
      status = prefs.getInt("status");
      if(status == null){
        status = 0;
      }
    }catch(e){
      dev.log(e.toString());
    }

    try{
      commands = prefs.getStringList("commands");
      if(commands == null){
        commands = ["forward", "backward", "right", "left","stop"];
      }
    }catch(e){
      dev.log(e.toString());
    }


    switch(status){
      case 0:{
        welcomeMessage = "BEEB POOP\nHello, I am Daisy Learning Bot.";
        description = "I am here to help you add commands in your own language to make you control the vehicle in an easier and more comfortable way.\n\nLets Get Started!";
        note = "Please Note that the Application is still in the Beta phase.\nSo we only support English and Arabic for now.";
        prefs.setInt("status", 1);
        break;
      }
      case 1:{
        welcomeMessage = "BEEB POOP\nI see we meet again Hello, I am Daisy Learning Bot.";
        description = "Don't forget I am here to make it easier for you to control your vehicle by adding your own commands.\n\nLets Get Started!";
        note = "We are doing our best to add more languages but for now we only support English and Arabic.";
        prefs.setInt("status", 2);
        break;
      }
      case 2: {
        welcomeMessage = "BEEP POOP\nLet me try and guess your name is it... ammm...\nI will remember it next time.";
        description = "You should already know but i will say it again\nI am here to make it easier for you to control your vehicle by adding your own commands.\n\nLets Get Started!";
        note = "No we still did not add new languages we will notify you once it's added so only type in English and Arabic";
        prefs.setInt("status", 3);
        break;
      }
      case 3: {
        welcomeMessage = "BEEP POOP\nAHAA I told you i will remember your name it is $username";
        description = "You should already know but i will say it again\nI am here to make it easier for you to control your vehicle by adding your own commands.\n\nLets Get Started!";
        note = "Supportiamo solo inglese e arabo\nThat means we only support English and Arabic in italian";
        prefs.setInt("status", 4);
        break;
      }
      case 4:{
        welcomeMessage = "BEEP POOP\nWelcome back my dear Friend $username";
        description = "You should already know but i will say it again\nI am here to make it easier for you to control your vehicle by adding your own commands.\n\nLets Get Started!";
        note = "We are working hard to add as many languages as we could but we only support English and Arabic for now.";

        prefs.setInt("status", temp);
        break;
      }
    }

    bot.add(welcomeMessage);
    bot.add(description);
    bot.add(note);
    bot.add(forwardCommand);
  }

  void _changeLanguage(Language language) {
    Locale _temp;
    switch (language.LanguageCode) {
      case 'en':
        _temp = Locale(language.LanguageCode, 'US');
        break;
      case 'ar':
        _temp = Locale(language.LanguageCode, 'EG');
        break;
      default:
        _temp = Locale(language.LanguageCode, 'US');
    }
    EasyLocalization.of(context).setLocale(_temp);
  }

  _startUp() async {
    _setLoading(true);

    List<CameraDescription> cameras = await availableCameras();

    /// takes the front camera
    cameraDescription = cameras.firstWhere(
      (CameraDescription camera) =>
          camera.lensDirection == CameraLensDirection.front,
    );

    // start the services
    await _faceNetService.loadModel();
    await _dataBaseService.loadDB();
    _mlKitService.initialize();

    _setLoading(false);
  }

  _setLoading(bool value) {
    setState(() {
      loading = value;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: loading,
      opacity: 0.5,
      progressIndicator: Lottie.asset('assets/indicator.json',
          height: 130, fit: BoxFit.cover, animate: true, repeat: true),
      child: Directionality(
        textDirection: ui.TextDirection.ltr,
        child: Scaffold(
            floatingActionButton: SpeedDial(
              animatedIcon: AnimatedIcons.menu_close,
              backgroundColor: Colors.redAccent,
              overlayColor: Colors.black,
              overlayOpacity: 0.4,
              spacing: 12,
              spaceBetweenChildren: 10,
              tooltip: 'Menu Options'.tr().toString(),
              childrenButtonSize: Size(65, 65),
              children: [
                SpeedDialChild(
                    child: Icon(
                      Icons.language,
                      color: Colors.white,
                      size: 30,
                    ),
                    backgroundColor: Color(0xff0E4EC9),
                    onTap: () {
                      setState(() {
                        Alert(
                            style: AlertStyle(
                                animationType: AnimationType.fromTop,
                                isButtonVisible: false,
                                isCloseButton: true,
                                isOverlayTapDismiss: true,
                                animationDuration: Duration(milliseconds: 700),
                                alertBorder: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  side: BorderSide(
                                    color: Colors.grey,
                                  ),
                                )),
                            context: context,
                            title: "Choose Language".tr().toString(),
                            content: Directionality(
                              textDirection: ui.TextDirection.ltr    ,
                              child: DropdownButton(
                                hint: Text("Change Language".tr().toString(),style: TextStyle(
                                  color: Colors.blue,
                                ),
                                ),
                                onChanged: (Language language) {
                                  _changeLanguage(language);
                                  Navigator.pop(context);
                                },
                                dropdownColor: Colors.white,
                                items: Language.languageList()
                                    .map<DropdownMenuItem<Language>>(
                                        (lang) => DropdownMenuItem(
                                      value: lang,
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          Text(
                                            lang.flag,
                                            style: TextStyle(fontSize: 23),
                                          ),
                                          Text(
                                            lang.name,
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.black),
                                          )
                                        ],
                                      ),
                                    ))
                                    .toList(),
                                icon: Icon(
                                  Icons.language,
                                  size: 35,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                        ).show();
                      });
                    }),
                SpeedDialChild(
                    child: Directionality(
                      textDirection: ui.TextDirection.ltr,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 0.0,bottom: 5,right: 5),
                        child: Icon(
                          FontAwesomeIcons.robot,
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                    ),
                    backgroundColor: Color(0xff0E4EC9),
                    onTap: () async{

                      await load();

                      Navigation(
                          widget: widget,
                          context: context,
                          type: PageTransitionType.fade,
                          screen: ChatBot(bot: bot,commands: commands,))
                          .navigate();
                    }),
              ],
            ),
            appBar: NewGradientAppBar(
              elevation: 2,
              gradient: backgroundGradientColor,
              centerTitle: true,
              title: !isDone
                  ? Directionality(
                textDirection:
                EasyLocalization.of(context).locale ==
                    Locale('ar', 'EG')
                    ? ui.TextDirection.rtl
                    : ui.TextDirection.ltr,
                    child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const SizedBox(width: 20.0, height: 100.0),
                          DefaultTextStyle(
                            style: const TextStyle(
                                fontSize: 40.0,
                                fontFamily: 'Horizon',
                                color: Colors.black),
                            child: AnimatedTextKit(
                              animatedTexts: [
                                RotateAnimatedText('KEEP'.tr().toString(),),
                                RotateAnimatedText('STAY'.tr().toString()),
                              ],
                              isRepeatingAnimation: false,
                              onFinished: () {
                                setState(() {
                                  isDone = true;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 20.0, height: 100.0),
                          DefaultTextStyle(
                            style: const TextStyle(
                                fontSize: 40.0,
                                fontFamily: 'Horizon',
                                color: Colors.black),
                            child: AnimatedTextKit(
                              animatedTexts: [
                                RotateAnimatedText('DISTANCE'.tr().toString()),
                                RotateAnimatedText('SAFE'.tr().toString()),
                              ],
                              isRepeatingAnimation: false,
                              onFinished: () {
                                setState(() {
                                  isDone = true;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                  )
                  : Directionality(
                textDirection:
                EasyLocalization.of(context).locale ==
                    Locale('ar', 'EG')
                    ? ui.TextDirection.rtl
                    : ui.TextDirection.ltr,
                    child: DefaultTextStyle(
                        style: const TextStyle(
                            fontSize: 40.0,
                            fontFamily: 'Horizon',
                            color: Colors.black),
                        child: FadeAnimation(1, Text("DAISY".tr().toString())),
                      ),
                  ),
            ),
            body: Directionality(
              textDirection:
              EasyLocalization.of(context).locale ==
                  Locale('ar', 'EG')
                  ? ui.TextDirection.rtl
                  : ui.TextDirection.ltr,
              child: Container(
                decoration: BoxDecoration(
                  gradient: backgroundGradientColor,
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(30, 0, 20, 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Scan your face to log in.'.tr().toString(),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Press on the button whenever you are ready.'.tr().toString(),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Container(
                          height: 220.0,
                          width: 220.0,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/Images/daisy.png'),
                              fit: BoxFit.fill,
                            ),
                            shape: BoxShape.circle,
                          ),
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                buttonsColor,
                              ),
                              shape:
                                  MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ))),
                          onPressed: () async {
                            await _startUp();

                            Navigation(
                                    context: context,
                                    screen: SignIn(
                                      cameraDescription: cameraDescription,
                                    ),
                                    widget: widget,
                                    type: PageTransitionType.rightToLeftWithFade)
                                .navigate();
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                            child: Text(
                              "Scan Face To Authenticate".tr().toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                buttonsColor,
                              ),
                              shape:
                                  MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ))),
                          onPressed: () {
                            Navigation(
                                    context: context,
                                    screen: Email_Password(),
                                    widget: widget,
                                    type: PageTransitionType.bottomToTop)
                                .navigate();
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                            child: Text(
                              'Email/Password'.tr().toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )),
      ),
    );
  }
}
