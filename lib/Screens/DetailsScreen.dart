import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/widgets/Constants.dart';
import 'dart:ui' as ui;
import 'QRScanner.dart';
import 'navbar.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen(
      {Key key,
      this.username,
      this.photo,
      this.batColor,
      this.batIcon,
      this.batPer,
      this.isPaired,
      this.name})
      : super(key: key);

  final username;
  final photo;
  final batColor;
  final batIcon;
  final batPer;
  final isPaired;
  final name;

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xff383838),
      body: Stack(
        children: [
          Positioned(
              top: -size.height * 0.15,
              right: -size.height * 0.20,
              child: AnimatedContainer(
                duration: const Duration(microseconds: 400),
                height: size.height * 0.5,
                width: size.height * 0.5,
                decoration: BoxDecoration(
                  color: backColor,
                  shape: BoxShape.circle,
                ),
              )),
          Directionality(
            textDirection: ui.TextDirection.ltr,
            child: Positioned(
              top: 50,
                left: 16,
                right: 16,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: (){
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QR_Scanner(
                                username: widget.username,
                                photo: widget.photo,
                              ),
                            ),
                                (Route<dynamic> route) => false);
                      },
                      child: const Icon(
                        Icons.arrow_back_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ],
                )
            ),
          ),
          Positioned(
            top: size.height * 0.20,
            right: 0,
            left: 0,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: FittedBox(
                child: Text(
                  widget.name,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[100],
                      fontFamily: "ARIAL"),
                ),
              ),
            ),
          ),
          Positioned(
              top: size.height * 0.35,
              right: size.height * 0.07,
              left: size.height * 0.07,
              child: Image(
                  fit: BoxFit.cover,
                  image: AssetImage(
                    "assets/Images/car.png",
                  ))),
          Positioned(
              top: size.height * 0.65,
              left: 16,
              right: 16,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Battery: ${widget.batPer}".tr().toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 22,
                            color: Colors.white),
                      ),
                      Icon(
                        widget.batIcon,
                        color: widget.batColor,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.isPaired ? "Paired: Yes".tr().toString() : "Paired: No".tr().toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 22,
                            color: Colors.white),
                      ),
                      Icon(
                        widget.isPaired
                            ? Icons.bluetooth_connected
                            : Icons.bluetooth_disabled,
                        color: widget.isPaired ? Colors.blue : Colors.blueGrey,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 120,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              widget.isPaired || widget.batPer.compareTo("0%") == 0 ? Colors.grey : Colors.lightBlue,
                            ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ))),
                        onPressed: widget.isPaired || widget.batPer.compareTo("0%") == 0 ? (){
                                  if(widget.isPaired){
                                    showSnackBar(
                                        _scaffoldKey,
                                        'Vehicle already paired!'.tr().toString()
                                            .toString())
                                        .show();
                                  }else{
                                    showSnackBar(
                                        _scaffoldKey,
                                        'Battery Empty Please Charge!'.tr().toString()
                                            .toString())
                                        .show();
                                  }
                        } :() async {
                          //todo seby connection

                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NavBar.Info(
                                  username: widget.username,
                                  photo: widget.photo,
                                  index: 1,
                                ),
                              ),
                              (Route<dynamic> route) => false);
                        },
                        child: Container(
                          width: 250,
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                            child: Text(
                              "Connect".tr().toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
