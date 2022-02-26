import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_flip_builder/page_flip_builder.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({key}) : super(key: key);

  static const String id = 'AboutUs';

  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  bool _isLoaded = false;

  @override
  Widget build(BuildContext context) {
    final pageFlipKey = GlobalKey<PageFlipBuilderState>();

    return Scaffold(
      body: ListView(
        children: [
          SizedBox(height: 10.0),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(width: 10.0),
              Container(
                height: 70,
                width: 120,
                child: Image.asset('assets/Images/car1.jpeg'),
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
          SizedBox(height: 10),
          Container(
            height: 300,
            width: 300,
            margin: const EdgeInsets.all(15.0),
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
            ),
            child: Carousel(
              showIndicator: false,
              dotColor: Colors.transparent,
              dotBgColor: Colors.transparent,
              autoplay: true,
              autoplayDuration: Duration(seconds: 7),
              images: [
                Image.asset('assets/Images/car1.jpeg'),
                Image.asset('assets/Images/car2.jpeg'),
                Image.asset('assets/Images/car3.jpeg'),
                Image.asset('assets/Images/car4.jpeg'),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left:10, top:20, right:10),
            child: Row(
              children: [
                Container(
                  color: Colors.black,
                  width: 180,
                  height: 200,
                  child: PageFlipBuilder(
                    key: pageFlipKey,
                    frontBuilder: (_) => LightHomePage(
                      image: 'assets/Images/car4.jpeg',
                      onFlip: () => pageFlipKey.currentState?.flip(),
                    ),
                    backBuilder: (_) => DarkHomePage(
                      image: 'assets/Images/car3.jpeg',
                      onFlip: () => pageFlipKey.currentState?.flip(),
                    ),
                    maxTilt: 0.003,
                    maxScale: 0.2,
                  ),
                ),
              ],
            ),
          ),
          // Padding(
          //   padding: EdgeInsets.only(left:10, top:20, right:10),
          //   child: Row(
          //     children: [
          //       Container(
          //         color: Colors.black,
          //         width: 180,
          //         height: 200,
          //         child: PageFlipBuilder(
          //           key: pageFlipKey,
          //           frontBuilder: (_) => LightHomePage(
          //             image: 'assets/Images/dcGearedMotor1.jpeg',
          //             onFlip: () => pageFlipKey.currentState?.flip(),
          //           ),
          //           backBuilder: (_) => DarkHomePage(
          //             image: 'assets/Images/dcGearedMotor2.jpeg',
          //             onFlip: () => pageFlipKey.currentState?.flip(),
          //           ),
          //           maxTilt: 0.003,
          //           maxScale: 0.2,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          // Padding(
          //   padding: EdgeInsets.only(left:10, top:20, right:10),
          //   child: Row(
          //     children: [
          //       Container(
          //         color: Colors.black,
          //         width: 180,
          //         height: 200,
          //         child: PageFlipBuilder(
          //           key: pageFlipKey,
          //           frontBuilder: (_) => LightHomePage(
          //             image: 'assets/Images/microServoMotor1.jpeg',
          //             onFlip: () => pageFlipKey.currentState?.flip(),
          //           ),
          //           backBuilder: (_) => DarkHomePage(
          //             image: 'assets/Images/microServoMotor2.jpeg',
          //             onFlip: () => pageFlipKey.currentState?.flip(),
          //           ),
          //           maxTilt: 0.003,
          //           maxScale: 0.2,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          // Padding(
          //   padding: EdgeInsets.only(left:10, top:20, right:10),
          //   child: Row(
          //     children: [
          //       Container(
          //         color: Colors.black,
          //         width: 180,
          //         height: 200,
          //         child: PageFlipBuilder(
          //           key: pageFlipKey,
          //           frontBuilder: (_) => LightHomePage(
          //             image: 'assets/Images/motorDriverShield1.jpeg',
          //             onFlip: () => pageFlipKey.currentState?.flip(),
          //           ),
          //           backBuilder: (_) => DarkHomePage(
          //             image: 'assets/Images/motorDriverShield2.jpeg',
          //             onFlip: () => pageFlipKey.currentState?.flip(),
          //           ),
          //           maxTilt: 0.003,
          //           maxScale: 0.2,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          // Padding(
          //   padding: EdgeInsets.only(left:10, top:20, right:10),
          //   child: Row(
          //     children: [
          //       Container(
          //         color: Colors.black,
          //         width: 180,
          //         height: 200,
          //         child: PageFlipBuilder(
          //           key: pageFlipKey,
          //           frontBuilder: (_) => LightHomePage(
          //             image: 'assets/Images/ultrasonicSensor1.jpeg',
          //             onFlip: () => pageFlipKey.currentState?.flip(),
          //           ),
          //           backBuilder: (_) => DarkHomePage(
          //             image: 'assets/Images/ultrasonicSensor2.jpeg',
          //             onFlip: () => pageFlipKey.currentState?.flip(),
          //           ),
          //           maxTilt: 0.003,
          //           maxScale: 0.2,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          // Padding(
          //   padding: EdgeInsets.only(left:10, top:20, right:10),
          //   child: Row(
          //     children: [
          //       Container(
          //         color: Colors.black,
          //         width: 180,
          //         height: 200,
          //         child: PageFlipBuilder(
          //           key: pageFlipKey,
          //           frontBuilder: (_) => LightHomePage(
          //             image: 'assets/Images/serialBluetoothModule1.jpeg',
          //             onFlip: () => pageFlipKey.currentState?.flip(),
          //           ),
          //           backBuilder: (_) => DarkHomePage(
          //             image: 'assets/Images/serialBluetoothModule2.jpeg',
          //             onFlip: () => pageFlipKey.currentState?.flip(),
          //           ),
          //           maxTilt: 0.003,
          //           maxScale: 0.2,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          // Padding(
          //   padding: EdgeInsets.only(left:10, top:20, right:10),
          //   child: Row(
          //     children: [
          //       Container(
          //         color: Colors.black,
          //         width: 180,
          //         height: 200,
          //         child: PageFlipBuilder(
          //           key: pageFlipKey,
          //           frontBuilder: (_) => LightHomePage(
          //             image: 'assets/Images/batteryHolderBox1.jpeg',
          //             onFlip: () => pageFlipKey.currentState?.flip(),
          //           ),
          //           backBuilder: (_) => DarkHomePage(
          //             image: 'assets/Images/batteryHolderBox2.jpeg',
          //             onFlip: () => pageFlipKey.currentState?.flip(),
          //           ),
          //           maxTilt: 0.003,
          //           maxScale: 0.2,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          // Padding(
          //   padding: EdgeInsets.only(left:10, top:20, right:10),
          //   child: Row(
          //     children: [
          //       Container(
          //         color: Colors.black,
          //         width: 180,
          //         height: 200,
          //         child: PageFlipBuilder(
          //           key: pageFlipKey,
          //           frontBuilder: (_) => LightHomePage(
          //             image: 'assets/Images/maleAndFemaleJumperWire1.jpeg',
          //             onFlip: () => pageFlipKey.currentState?.flip(),
          //           ),
          //           backBuilder: (_) => DarkHomePage(
          //             image: 'assets/Images/maleAndFemaleJumperWire2.jpeg',
          //             onFlip: () => pageFlipKey.currentState?.flip(),
          //           ),
          //           maxTilt: 0.003,
          //           maxScale: 0.2,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          // Padding(
          //   padding: EdgeInsets.only(left:10, top:20, right:10),
          //   child: Row(
          //     children: [
          //       Container(
          //         color: Colors.black,
          //         width: 180,
          //         height: 200,
          //         child: PageFlipBuilder(
          //           key: pageFlipKey,
          //           frontBuilder: (_) => LightHomePage(
          //             image: 'assets/Images/wheel1.jpeg',
          //             onFlip: () => pageFlipKey.currentState?.flip(),
          //           ),
          //           backBuilder: (_) => DarkHomePage(
          //             image: 'assets/Images/wheel2.jpeg',
          //             onFlip: () => pageFlipKey.currentState?.flip(),
          //           ),
          //           maxTilt: 0.003,
          //           maxScale: 0.2,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          // Padding(
          //   padding: EdgeInsets.only(left:10, top:20, right:10),
          //   child: Row(
          //     children: [
          //       Container(
          //         color: Colors.black,
          //         width: 180,
          //         height: 200,
          //         child: PageFlipBuilder(
          //           key: pageFlipKey,
          //           frontBuilder: (_) => LightHomePage(
          //             image: 'assets/Images/maleAndFemaleJumperWire1.jpeg',
          //             onFlip: () => pageFlipKey.currentState?.flip(),
          //           ),
          //           backBuilder: (_) => DarkHomePage(
          //             image: 'assets/Images/maleAndFemaleJumperWire2.jpeg',
          //             onFlip: () => pageFlipKey.currentState?.flip(),
          //           ),
          //           maxTilt: 0.003,
          //           maxScale: 0.2,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
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
            child: SvgPicture.asset(
              image,
              semanticsLabel: 'Forest',
              width: 180,
              height: 200,
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
            child: SvgPicture.asset(
              image,
              semanticsLabel: 'Forest',
              width: 180,
              height: 200,
            ),
          ),
        ),
      ),
    );
  }
}