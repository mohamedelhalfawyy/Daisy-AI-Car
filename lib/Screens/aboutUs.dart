import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:page_flip_builder/page_flip_builder.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({key}) : super(key: key);

  static const String id = 'AboutUs';

  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {

  @override
  Widget build(BuildContext context) {

    final pageFlipKey = GlobalKey<PageFlipBuilderState>();
    final pageFlipKey2 = GlobalKey<PageFlipBuilderState>();
    final pageFlipKey3 = GlobalKey<PageFlipBuilderState>();
    final pageFlipKey4 = GlobalKey<PageFlipBuilderState>();
    final pageFlipKey5 = GlobalKey<PageFlipBuilderState>();
    final pageFlipKey6 = GlobalKey<PageFlipBuilderState>();
    final pageFlipKey7 = GlobalKey<PageFlipBuilderState>();
    final pageFlipKey8 = GlobalKey<PageFlipBuilderState>();
    final pageFlipKey9 = GlobalKey<PageFlipBuilderState>();
    final pageFlipKey10 = GlobalKey<PageFlipBuilderState>();

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 50.0),
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(width: 10.0),
                Container(
                  height: 70,
                  width: 120,
                  child: Image.asset('assets/Images/daisy.png'),
                ),
                SizedBox(width: 20.0),
                Text('Daisy', style: TextStyle(
                  fontSize: 40.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Horizon',
                ),
                ),
              ],
            ),
            Container(
              height: 300,
              width: 300,
              margin: const EdgeInsets.all(15.0),
              padding: const EdgeInsets.all(20.0),
              child: Carousel(
                showIndicator: false,
                dotColor: Colors.transparent,
                dotBgColor: Colors.transparent,
                autoplay: true,
                autoplayDuration: Duration(seconds: 5),
                images: [
                  Container(
                    width: 300,
                    margin: EdgeInsets.all(10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image(
                        image: AssetImage('assets/Images/car1.jpeg'),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image(
                        image: AssetImage('assets/Images/car2.jpeg'),
                      ),
                    ),
                  ),
                  Container(
                    width: 300,
                    margin: EdgeInsets.all(10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image(
                        image: AssetImage('assets/Images/car3.jpeg'),
                      ),
                    ),
                  ),
                  Container(
                    width: 300,
                    margin: EdgeInsets.all(10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image(
                        image: AssetImage('assets/Images/car4.jpeg'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left:20, top:20, right:20),
              child: Row(
                children: [
                  Expanded(
                    flex:1,
                    child: Container(
                      color: Colors.black,
                      width: 120,
                      height: 120,
                      child: PageFlipBuilder(
                        key: pageFlipKey,
                        frontBuilder: (_) => LightHomePage(
                          image: 'assets/Images/arduinoUno1.jpeg',
                          onFlip: () => pageFlipKey.currentState?.flip(),
                        ),
                        backBuilder: (_) => DarkHomePage(
                          image: 'assets/Images/arduinoUno2.jpeg',
                          onFlip: () => pageFlipKey.currentState?.flip(),
                        ),
                        maxTilt: 0.003,
                        maxScale: 0.2,
                      ),
                    ),
                  ),
                  SizedBox(width:20),
                  Expanded(
                    flex: 2,
                    child: Container(
                      width: 200,
                      height: 140,
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent.shade100,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Column(
                        children: [
                          Text('Arduino Uno',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height:5),
                          AutoSizeText('The Arduino Uno is an open-source microcontroller board based'
                              'on the Microchip ATmega328P microcontroller and developed by Arduino',
                            maxFontSize: 16,
                            minFontSize: 12,
                            maxLines: 3,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left:20, top:20, right:20),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      color: Colors.black,
                      width: 120,
                      height: 120,
                      child: PageFlipBuilder(
                        key: pageFlipKey2,
                        frontBuilder: (_) => LightHomePage(
                          image: 'assets/Images/dcGearedMotor1.jpeg',
                          onFlip: () => pageFlipKey2.currentState?.flip(),
                        ),
                        backBuilder: (_) => DarkHomePage(
                          image: 'assets/Images/dcGearedMotor2.jpeg',
                          onFlip: () => pageFlipKey2.currentState?.flip(),
                        ),
                        maxTilt: 0.003,
                        maxScale: 0.2,
                      ),
                    ),
                  ),
                  SizedBox(width:20),
                  Expanded(
                    flex: 2,
                    child: Container(
                      width: 200,
                      height: 140,
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent.shade100,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Column(
                        children: [
                          Text('Dc Gearmotor',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height:5),
                          AutoSizeText('A gearmotor is a type of gear reducer based around an ac or dc electrical '
                              'motor. The gear and the motors are combined into one unit. A gearmotor delivers '
                              'high torque at low horsepower or low speed.',
                            maxFontSize: 16,
                            minFontSize: 12,
                            maxLines: 3,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left:20, top:20, right:20),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      color: Colors.black,
                      width: 120,
                      height: 120,
                      child: PageFlipBuilder(
                        key: pageFlipKey3,
                        frontBuilder: (_) => LightHomePage(
                          image: 'assets/Images/microServoMotor1.jpeg',
                          onFlip: () => pageFlipKey3.currentState?.flip(),
                        ),
                        backBuilder: (_) => DarkHomePage(
                          image: 'assets/Images/microServoMotor2.jpeg',
                          onFlip: () => pageFlipKey3.currentState?.flip(),
                        ),
                        maxTilt: 0.003,
                        maxScale: 0.2,
                      ),
                    ),
                  ),
                  SizedBox(width:20),
                  Expanded(
                    flex: 2,
                    child: Container(
                      width: 200,
                      height: 140,
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent.shade100,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Column(
                        children: [
                          Text('Micro Servomotor',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height:5),
                          AutoSizeText('Micro Servo Motor SG90 is a tiny and lightweight server motor with high '
                              'output power. Servo can rotate approximately 180 degrees.',
                            maxFontSize: 16,
                            minFontSize: 12,
                            maxLines: 3,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left:20, top:20, right:20),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      color: Colors.black,
                      width: 120,
                      height: 120,
                      child: PageFlipBuilder(
                        key: pageFlipKey4,
                        frontBuilder: (_) => LightHomePage(
                          image: 'assets/Images/motorDriverShield1.jpeg',
                          onFlip: () => pageFlipKey4.currentState?.flip(),
                        ),
                        backBuilder: (_) => DarkHomePage(
                          image: 'assets/Images/motorDriverShield2.jpeg',
                          onFlip: () => pageFlipKey4.currentState?.flip(),
                        ),
                        maxTilt: 0.003,
                        maxScale: 0.2,
                      ),
                    ),
                  ),
                  SizedBox(width:20),
                  Expanded(
                    flex: 2,
                    child: Container(
                      width: 200,
                      height: 140,
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent.shade100,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Column(
                        children: [
                          Text('Motor Driver',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height:5),
                          AutoSizeText('The L293D is a dual-channel H-Bridge motor driver. A single IC is able '
                              'to control two DC motors or one stepper motor.',
                            maxFontSize: 16,
                            minFontSize: 12,
                            maxLines: 3,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left:20, top:20, right:20),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      color: Colors.black,
                      width: 120,
                      height: 120,
                      child: PageFlipBuilder(
                        key: pageFlipKey5,
                        frontBuilder: (_) => LightHomePage(
                          image: 'assets/Images/ultrasonicSensor1.jpeg',
                          onFlip: () => pageFlipKey5.currentState?.flip(),
                        ),
                        backBuilder: (_) => DarkHomePage(
                          image: 'assets/Images/ultrasonicSensor2.jpeg',
                          onFlip: () => pageFlipKey5.currentState?.flip(),
                        ),
                        maxTilt: 0.003,
                        maxScale: 0.2,
                      ),
                    ),
                  ),
                  SizedBox(width:20),
                  Expanded(
                    flex: 2,
                    child: Container(
                      width: 200,
                      height: 140,
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent.shade100,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Column(
                        children: [
                          Text('Ultrasonic Sensor',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height:5),
                          AutoSizeText('Ultrasonic sensors emit a chirp usually between 23 kHz and 40 kHz, '
                              'much higher than the typical audible range of human hearing at 20 kHz.',
                            maxFontSize: 16,
                            minFontSize: 12,
                            maxLines: 3,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left:20, top:20, right:20),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      color: Colors.black,
                      width: 120,
                      height: 120,
                      child: PageFlipBuilder(
                        key: pageFlipKey6,
                        frontBuilder: (_) => LightHomePage(
                          image: 'assets/Images/serialBluetoothModule1.jpeg',
                          onFlip: () => pageFlipKey6.currentState?.flip(),
                        ),
                        backBuilder: (_) => DarkHomePage(
                          image: 'assets/Images/serialBluetoothModule2.jpeg',
                          onFlip: () => pageFlipKey6.currentState?.flip(),
                        ),
                        maxTilt: 0.003,
                        maxScale: 0.2,
                      ),
                    ),
                  ),
                  SizedBox(width:20),
                  Expanded(
                    flex: 2,
                    child: Container(
                      width: 200,
                      height: 140,
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent.shade100,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Column(
                        children: [
                          Text('HC-05 Bluetooth Module',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height:5),
                          AutoSizeText('HC-05 Bluetooth module provides switching mode between master and '
                              'slave mode which means it able to use neither receiving nor transmitting data.',
                            maxFontSize: 16,
                            minFontSize: 12,
                            maxLines: 3,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left:20, top:20, right:20),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      color: Colors.black,
                      width: 120,
                      height: 120,
                      child: PageFlipBuilder(
                        key: pageFlipKey7,
                        frontBuilder: (_) => LightHomePage(
                          image: 'assets/Images/batteryHolderBox1.jpeg',
                          onFlip: () => pageFlipKey7.currentState?.flip(),
                        ),
                        backBuilder: (_) => DarkHomePage(
                          image: 'assets/Images/batteryHolderBox2.jpeg',
                          onFlip: () => pageFlipKey7.currentState?.flip(),
                        ),
                        maxTilt: 0.003,
                        maxScale: 0.2,
                      ),
                    ),
                  ),
                  SizedBox(width:20),
                  Expanded(
                    flex: 2,
                    child: Container(
                      width: 200,
                      height: 140,
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent.shade100,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Column(
                        children: [
                          Text('Battery Holder Box',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height:5),
                          AutoSizeText('The Holder Box is used to hold a maximum of 2 battery and is connected with'
                              'the vehicle.',
                            maxFontSize: 16,
                            minFontSize: 12,
                            maxLines: 3,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left:20, top:20, right:20),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      color: Colors.black,
                      width: 120,
                      height: 120,
                      child: PageFlipBuilder(
                        key: pageFlipKey8,
                        frontBuilder: (_) => LightHomePage(
                          image: 'assets/Images/maleAndFemaleJumperWire1.jpeg',
                          onFlip: () => pageFlipKey8.currentState?.flip(),
                        ),
                        backBuilder: (_) => DarkHomePage(
                          image: 'assets/Images/maleAndFemaleJumperWire2.jpeg',
                          onFlip: () => pageFlipKey8.currentState?.flip(),
                        ),
                        maxTilt: 0.003,
                        maxScale: 0.2,
                      ),
                    ),
                  ),
                  SizedBox(width:20),
                  Expanded(
                    flex: 2,
                    child: Container(
                      width: 200,
                      height: 140,
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent.shade100,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Column(
                        children: [
                          Text('Male and Female Jumper wires',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height:5),
                          AutoSizeText('Jumper wires typically come in three versions: male-to-male, male-to-female '
                              'and female-to-female. Male ends have a pin protruding and can plug into things, '
                              'while female ends do not and are used to plug things into.',
                            maxFontSize: 16,
                            minFontSize: 12,
                            maxLines: 3,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left:20, top:20, right:20),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      color: Colors.black,
                      width: 120,
                      height: 120,
                      child: PageFlipBuilder(
                        key: pageFlipKey9,
                        frontBuilder: (_) => LightHomePage(
                          image: 'assets/Images/protectedRechargeableLi-ionBattery1.jpeg',
                          onFlip: () => pageFlipKey9.currentState?.flip(),
                        ),
                        backBuilder: (_) => DarkHomePage(
                          image: 'assets/Images/protectedRechargeableLi-ionBattery2.jpeg',
                          onFlip: () => pageFlipKey9.currentState?.flip(),
                        ),
                        maxTilt: 0.003,
                        maxScale: 0.2,
                      ),
                    ),
                  ),
                  SizedBox(width:20),
                  Expanded(
                    flex: 2,
                    child: Container(
                      width: 200,
                      height: 140,
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent.shade100,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Column(
                        children: [
                          Text('Protected Lithium-Ion Battery',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height:5),
                          AutoSizeText('Protected Lithium-Ion (Li-ion) batteries have a small electronic circuit '
                              'integrated into the cell packaging. Most lithium ion batteries charge to a '
                              'voltage of 4.2 volts per cell',
                            maxFontSize: 16,
                            minFontSize: 12,
                            maxLines: 3,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left:20, top:20, right:20),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      color: Colors.black,
                      width: 120,
                      height: 120,
                      child: PageFlipBuilder(
                        key: pageFlipKey10,
                        frontBuilder: (_) => LightHomePage(
                          image: 'assets/Images/wheel1.jpeg',
                          onFlip: () => pageFlipKey10.currentState?.flip(),
                        ),
                        backBuilder: (_) => DarkHomePage(
                          image: 'assets/Images/wheel2.jpeg',
                          onFlip: () => pageFlipKey10.currentState?.flip(),
                        ),
                        maxTilt: 0.003,
                        maxScale: 0.2,
                      ),
                    ),
                  ),
                  SizedBox(width:20),
                  Expanded(
                    flex: 2,
                    child: Container(
                      width: 200,
                      height: 140,
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent.shade100,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Column(
                        children: [
                          Text('Wheels',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height:5),
                          AutoSizeText('The wheels are utilized to move the vehicle in the corrispettive directions.'
                              'The number of wheels utilized are 4.',
                            maxFontSize: 16,
                            minFontSize: 12,
                            maxLines: 3,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LightHomePage extends StatelessWidget {
  const LightHomePage({Key key, this.image,this.onFlip}) : super(key: key);
  final VoidCallback onFlip;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        brightness: Brightness.light,
        textTheme: TextTheme(
          headline3: Theme.of(context)
              .textTheme
              .headline3
              .copyWith(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
      ),
      child: Scaffold(
        body: Container(
          decoration: kIsWeb
              ? BoxDecoration(
            border: Border.all(color: Colors.black, width: 5),
          )
              : null,
          child: InkWell(
            onTap: onFlip,
            child: Image.asset(
                image,
                fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }
}

class DarkHomePage extends StatelessWidget {
  const DarkHomePage({Key key, this.image,this.onFlip}) : super(key: key);
  final VoidCallback onFlip;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        brightness: Brightness.dark,
        textTheme: TextTheme(
          headline3: Theme.of(context)
              .textTheme
              .headline3
              .copyWith(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      child: Scaffold(
        body: Container(
          decoration: kIsWeb
              ? BoxDecoration(
            border: Border.all(color: Colors.black, width: 5),
          )
              : null,
          child: InkWell(
            onTap: onFlip,
            child: FittedBox(
                child: Image.asset(image),
                fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}