import 'dart:math';
import 'package:bubble/bubble.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/Constants.dart';
import 'navbar.dart';
import 'package:audioplayers/audioplayers.dart';

class ChatBot extends StatefulWidget {
  const ChatBot({Key key,@required this.bot,@required this.commands, @required this.username}) : super(key: key);

  final List<String> bot;
  final List<String> commands;
  final String username;

  @override
  State<ChatBot> createState() => _ChatBotState(bot,commands,username);
}

class _ChatBotState extends State<ChatBot> {


  int _counter = 0;
  bool isFirst = true;

  String username;


  Future<void> playSound(bool isBot) async {
    !isBot ? await AudioCache().play("sendSound.mp3") : await AudioCache().play("receiveSound.mp3");
  }

  String firstReply;
  String secondReply;
  String thirdReply;
  String fourthReply;
  String lastReply;
  String errorReply;

  String backwardCommand = "Enter the command equivalent to Backward.";
  String rightCommand = "Enter the command equivalent to Right.";
  String leftCommand = "Enter the command equivalent to Left.";
  String stopCommand = "Enter the command equivalent to Stop.";

  _ChatBotState(this.bot, this.commands, this.username);

  @override
  void initState() {
    super.initState();
    startMessages();
  }


  void response(int counter) async {
    setState(() {
      messages.insert(0, {"data": 0, "message": bot[counter]});
    });
  }

  final messageInsert = TextEditingController();

  List<Map> messages = [];
  List<String> bot;

  int count = 0;

  List<String> commands;


  bool error = false;
  int size = 0;

  Future<void> startMessages() async{
    if(isFirst) {
      error = true;
      await Future.delayed(Duration(milliseconds: 1000));
      response(_counter);
      _counter++;
      playSound(true);

      await Future.delayed(Duration(milliseconds: 1500));
      response(_counter);
      _counter++;
      playSound(true);

      await Future.delayed(Duration(milliseconds: 1500));
      response(_counter);
      _counter++;
      playSound(true);

      await Future.delayed(Duration(milliseconds: 1500));
      response(_counter);
      _counter++;
      playSound(true);


      error = false;
      isFirst = false;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder:
            (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              pinned: true,
              expandedHeight: 250,
              flexibleSpace: FlexibleSpaceBar(
                background: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Lottie.asset('assets/helloRobot.json',
                    height: 130,
                    fit: BoxFit.contain,
                    animate: true,
                    repeat: true,
                    alignment: Alignment.center,
                  ),
                ),
                title: Text(
                  "Daisy",
                  style: TextStyle(
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                    fontFamily: "Times New Roman",
                  ),
                ),
                titlePadding: const EdgeInsets.only(bottom: 5),
                centerTitle: true,
              ),
              backgroundColor: chatBotColor,
            ),
          ];
        },
        body: Container(
            child: Builder(builder: (context) {
              return Column(
                children: <Widget>[
                  SizedBox(height: 70,),
                  Flexible(
                      child: ListView.builder(
                          reverse: true,
                          primary: true,
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            return chat(messages[index]["message"].toString(),
                                messages[index]["data"]);
                          })),
                  SizedBox(
                    height: 20,
                  ),
                  Divider(
                    height: 5.0,
                    thickness: 1,
                    color: chatBotColor,
                  ),
                  Container(
                    child: ListTile(
                      title: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          color: error
                              ? Colors.black12
                              : Color.fromRGBO(220, 220, 220, 1),
                        ),
                        padding: EdgeInsets.only(left: 15,bottom: 5, right: 5,top: 8),
                        child: TextFormField(
                          enabled: error ? false : true,
                          controller: messageInsert,
                          decoration: InputDecoration(
                            hintText: error ? "" : "Enter a Message...",
                            hintStyle: TextStyle(color: Colors.black26),
                            contentPadding: EdgeInsets.only(bottom: 5),
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                          ),
                          style: TextStyle(fontSize: 16, color: Colors.black),
                          maxLength: 15,
                          onChanged: (value) {},
                          autovalidateMode: AutovalidateMode.onUserInteraction,

                        ),
                      ),
                      trailing: IconButton(
                          icon: Icon(
                            Icons.send,
                            size: 30.0,
                            color: error ? Colors.black12 : chatBotColor,
                          ),
                          onPressed: () async{
                            final prefs = await SharedPreferences.getInstance();
                            String userMessage = messageInsert.text;

                            if (!error) {
                              if (userMessage.isNotEmpty) {
                                bool isFound = false;

                                for(int i = 0; i < commands.length; i++){
                                  if(userMessage.toLowerCase().compareTo(commands[i]) == 0){
                                    isFound = true;
                                  }
                                }

                                if(isFound){
                                  messages.insert(
                                      0, {"data": 1, "message": userMessage});

                                  playSound(false);


                                  int test = 0 + Random().nextInt(3 - 0);

                                  switch(test){
                                    case 0:{
                                      errorReply = "Sorry this command already exists and you cant use it.\nTry adding a new one.";
                                      break;
                                    }
                                    case 1:{
                                      errorReply = "I already know that command.\nTry adding a new one.";
                                      break;
                                    }
                                    case 2:{
                                      errorReply = "Error: This command already exists\nhaha just kidding it's not an error but you still need to change the command.";
                                      break;
                                    }
                                    case 3:{
                                      errorReply = "I wonder where i have seen this command before. Aha in my database!\nTry adding a different command.";
                                      break;
                                    }
                                  }

                                  bot.add(errorReply);

                                  FocusScopeNode currentFocus = FocusScope.of(context);
                                  if (!currentFocus.hasPrimaryFocus) {
                                    currentFocus.unfocus();
                                  }

                                  messageInsert.clear();

                                  await Future.delayed(Duration(milliseconds: 500));

                                  response(bot.length - 1);
                                  playSound(true);
                                  bot.removeLast();

                                  await Future.delayed(Duration(milliseconds: 1000));

                                  _counter--;
                                  response(_counter);
                                  _counter++;
                                  playSound(true);

                                  return;
                                }

                                int status;
                                int temp = 0 + Random().nextInt(2 - 0);

                                setState(() {
                                  int lang;
                                  RegExp englishRegex = new RegExp(r'^[a-zA-Z0-9. -_?]*$');
                                  RegExp arabicRegex = new RegExp(r'^[\u0600-\u065F\u066A-\u06EF\u06FA-\u06FFa-zA-Z]+[\u0600-\u065F\u066A-\u06EF\u06FA-\u06FFa-zA-Z-_]*$');

                                  try{
                                    status = prefs.getInt("message");
                                    print(status);
                                    print(status);
                                    print(status);
                                    print(status);
                                    if(status == null){
                                      status = 0;
                                    }
                                  }catch(e){}

                                  if(userMessage.contains(englishRegex)){
                                    lang = 1;
                                  }else if (userMessage.contains(arabicRegex)){
                                    lang = 2;
                                  }

                                  switch(status){
                                    case 0: {
                                      lang == 1 ? firstReply = "This is English right? I am pretty good at it too." : firstReply = "This is Arabic right? Such an interesting Language.";
                                      secondReply = "It has a nice Tone to it.";
                                      thirdReply = "Almost there lets keep going!";
                                      fourthReply = "One more to go and you can control that vehicle with those cool commands.";
                                      lastReply = "We made it!\nNow let me save those new commands.";
                                      break;
                                    }
                                    case 1: {
                                      lang == 1 ? firstReply = "I have been programmed to detect your language ammmmm.. is it English?" : firstReply = "I have been programmed to detect your language ammmmm.. is it Arabic?";
                                      lang == 1 ? secondReply = "That's a great choice of words i like it!" : secondReply = "I know how to speak arabic too want to see?";
                                      lang == 1 ? thirdReply = "I wish my developers added those words in the first place." : thirdReply = "السلام عليكم انا ديزي";
                                      lang == 1 ? fourthReply = "I hope we meet again my friend one more word to go." : fourthReply = "you must have been surprised admit it!";
                                      lang == 1 ? lastReply = "You did great now it's my time to sync all of your data\nBRB!" : lastReply = "You did great now it's my time to sync all of your data\nBRB! or should i say سوف اعود بعد قليل";
                                      break;
                                    }
                                    case 2: {
                                      lang == 1 ? firstReply = "You really do change your commands alot do you do the same for cars?" : firstReply = "مرحبااا";
                                      secondReply = "mhm mhm i would have said the same.";
                                      thirdReply = "Do you think i should get a raise?\nplease tell my developers";
                                      lang == 1 ? fourthReply = "Ofcourse you know but i will say it again\nOne more word to GO!" : fourthReply = "I hope we meet again my friend one more word to go.";
                                      lang == 1 ? lastReply = "You did great now it's my time to sync all of your data\nBRB!" : lastReply = "You did great now it's my time to sync all of your data\nBRB! or should i say سوف اعود بعد قليل";
                                      break;
                                    }
                                  }

                                  bot.add(firstReply);
                                  bot.add(backwardCommand);
                                  bot.add(secondReply);
                                  bot.add(rightCommand);
                                  bot.add(thirdReply);
                                  bot.add(leftCommand);
                                  bot.add(fourthReply);
                                  bot.add(stopCommand);
                                  bot.add(lastReply);

                                  commands.add(userMessage);

                                  messages.insert(
                                      0, {"data": 1, "message": userMessage});

                                  playSound(false);

                                  FocusScopeNode currentFocus = FocusScope.of(context);
                                  if (!currentFocus.hasPrimaryFocus) {
                                    currentFocus.unfocus();
                                  }

                                  messageInsert.clear();
                                });

                                await Future.delayed(Duration(milliseconds: 1000));
                                response(_counter);
                                _counter++;
                                playSound(true);


                                size++;
                                if (size == 5) {
                                  if(status < 2){
                                    prefs.setInt("message", status+1);
                                  }else{
                                    prefs.setInt("message", temp);
                                  }

                                  error = true;

                                  prefs.setStringList("commands", commands);

                                  await Future.delayed(Duration(milliseconds: 2000));

                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) {
                                      return AlertDialog(
                                        content: Lottie.asset(
                                          'assets/loadRobot.json',
                                          height: 400,
                                          width: 350,
                                          fit: BoxFit.contain,
                                          animate: true,
                                          onLoaded: (value) async {
                                            await Future.delayed(
                                                const Duration(seconds: 5), () {
                                              Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => NavBar.Info(
                                                        username: username,
                                                        index: 1,

                                                        //imagePath: _imagePath,
                                                      )),
                                                      (Route<dynamic> route) => false);
                                            });
                                          },
                                          alignment: Alignment.center,
                                          repeat: false,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        backgroundColor: Colors.black,
                                        elevation: 11,
                                        title: Text(
                                          'I am working hard to save your data!\nPlease Wait...'
                                              .tr()
                                              .toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontStyle: FontStyle.italic,
                                              fontSize: 23,
                                              color: Colors.white),
                                          textAlign: TextAlign.center,
                                        ),
                                      );
                                    },
                                  );

                                  return;
                                }
                              }

                              await Future.delayed(Duration(milliseconds: 1000));
                              response(_counter);
                              _counter++;
                              playSound(true);

                            }
                          }),
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  )
                ],
              );
            })),
      ),
    );
  }

  Widget chat(String message, int data) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Row(
        mainAxisAlignment:
        data == 1 ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          data == 0
              ? Container(
                  height: 60,
                  width: 60,
                  child: CircleAvatar(
                    backgroundImage: AssetImage("assets/Images/robot.jpg"),
                  ),
                )
              : Container(),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Bubble(
                radius: Radius.circular(15.0),
                color: data == 0 ? Colors.blueGrey : chatBotColor,
                elevation: 0.0,
                child: Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Flexible(
                          child: Container(
                            constraints: BoxConstraints(maxWidth: 200),
                            child: Text(
                              message,
                              style: TextStyle(
                                  color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ))
                    ],
                  ),
                )),
          ),
          data == 1
              ? Container(
                  height: 60,
                  width: 60,
                  child: CircleAvatar(
                    backgroundImage: AssetImage("assets/Images/Seby.jpeg"),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
