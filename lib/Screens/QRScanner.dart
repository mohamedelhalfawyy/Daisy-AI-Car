import 'dart:developer';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graduation_project/Screens/DetailsScreen.dart';
import 'package:graduation_project/Screens/scan_screen.dart';
import 'package:graduation_project/widgets/Constants.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'navbar.dart';

class QR_Scanner extends StatefulWidget {
  const QR_Scanner({
    Key key,
    this.username,
    this.photo,
  }) : super(key: key);

  final username;
  final photo;

  @override
  State<QR_Scanner> createState() => _QR_ScannerState();
}

class _QR_ScannerState extends State<QR_Scanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  Barcode barcode;
  QRViewController controller;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool showSpinner = false;
  bool isWrong = true;

  void scanCode(int carNumber) async {
    setState(() {
      showSpinner = true;
      controller.dispose();
    });

    if (carNumber == 1) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetailsScreen(
                    username: widget.username,
                    photo: widget.photo,
                    batColor: Colors.greenAccent,
                    batIcon: FontAwesomeIcons.batteryFull,
                    isPaired: false,
                    batPer: "100%",
                    name: "Daisy V1",
                  )));
    }else if(carNumber == 2){
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetailsScreen(
                username: widget.username,
                photo: widget.photo,
                batColor: Colors.orangeAccent,
                batIcon: FontAwesomeIcons.batteryQuarter,
                isPaired: true,
                batPer: "20%",
                name: "Daisy V2",
              )));
    }else if(carNumber == 3){
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetailsScreen(
                username: widget.username,
                photo: widget.photo,
                batColor: Colors.redAccent,
                batIcon: FontAwesomeIcons.batteryEmpty,
                isPaired: false,
                batPer: "0%",
                name: "Daisy V3",
              )));
    }

    setState(() {
      showSpinner = false;
    });
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    } else if (Platform.isIOS) {
      controller.resumeCamera();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xFF1F1F21),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: backColor,
        title: Text(
          "Scan QR Code".tr().toString(),
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              fontFamily: "Times New Roman",
              fontSize: 28),
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        opacity: 0.5,
        progressIndicator: Lottie.asset('assets/indicator.json',
            height: 130, fit: BoxFit.cover, animate: true, repeat: true),
        child: Stack(
          alignment: Alignment.center,
          children: [
            buildQrView(context),
            Positioned(
              child: buildResult(),
              bottom: 10,
            ),
            Positioned(
              child: buildControlButtons(),
              top: 10,
            )
          ],
        ),
      ),
    );
  }

  Widget buildResult() => Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.white24),
        child: Text(
          barcode != null ? 'Result : ${barcode.code}' : 'Wrong Vehicle'.tr().toString(),
          maxLines: 3,
          style: TextStyle(color: kPrimaryLightColor),
        ),
      );

  Widget buildControlButtons() => Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.white24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [],
        ),
      );

  Widget buildQrView(BuildContext context) => QRView(
        key: qrKey,
        onQRViewCreated: onQRViewCreated,
        overlay: QrScannerOverlayShape(
            borderColor: backColor,
            borderWidth: 10,
            borderLength: 20,
            borderRadius: 10,
            cutOutSize: MediaQuery.of(context).size.width * 0.8),
      );

  void onQRViewCreated(QRViewController controller) async {
    setState(() {
      this.controller = controller;
    });

    controller.scannedDataStream.listen((barcode) => setState(() {
          this.barcode = barcode;

          if (barcode.code != null) {
            if (barcode.code.compareTo("DaisyV1") == 0)
              scanCode(1);
            else if (barcode.code.compareTo("DaisyV2") == 0)
              scanCode(2);
            else if (barcode.code.compareTo("DaisyV3") == 0) scanCode(3);
          }
        }));
  }
}
