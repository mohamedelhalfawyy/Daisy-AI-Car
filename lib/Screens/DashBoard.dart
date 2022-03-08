import 'dart:async';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/widgets/SnackBar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key key}) : super(key: key);

  static const String id = 'DashBoardScreen' ;

  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  StreamSubscription<ConnectivityResult> subscription;

  @override
  void initState() {
    super.initState();

    checkConnection();
  }

  checkConnection() async {
    var _result = await (Connectivity().checkConnectivity());

    if (_result != ConnectivityResult.mobile &&
        _result != ConnectivityResult.wifi) {
      ShowSnackBar(
          context: context,
          text: 'Not Connected to Internet',
          color: Colors.red,
          isWifi: true,
          icon: Icons.wifi_off)
          .show();
    }

    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      if (result != ConnectivityResult.mobile &&
          result != ConnectivityResult.wifi) {
        ShowSnackBar(
            context: context,
            text: 'No Connection',
            color: Colors.red,
            isWifi: true,
            icon: Icons.wifi_off)
            .show();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

    subscription.cancel();
  }

  //Control Room navigation:

  // Navigator.push(
  // context,
  // MaterialPageRoute(
  // builder: (BuildContext context) => SignIn(
  // cameraDescription: cameraDescription,
  // ),
  // ),
  // );

  //Signup Navigation:

  // Navigator.push(
  // context,
  // MaterialPageRoute(
  // builder: (BuildContext context) => SignUp(
  // cameraDescription: cameraDescription,
  // ),
  // ),
  // );

  final ImagePicker _picker = ImagePicker();
  dynamic _pickImageError;
  List<XFile> _imageFileList;

  set _imageFile(XFile value) {
    _imageFileList = value == null ? null : <XFile>[value];
  }

  Future<void> saveImage() async {
    try {
      var _imagePath = _imageFileList.last.path.split("/").last;

      firebase_storage.FirebaseStorage _storage =  firebase_storage.FirebaseStorage.instance;

      Reference db = _storage.ref("users/$_imagePath");
      
      await db.putFile(File(_imageFileList.last.path));

      return await db.getDownloadURL();

    } catch (e) {
      print('$e +10');
    }
  }

  Future<void> loadAssets(ImageSource source,
      {BuildContext context, bool isMultiImage = false}) async {
      try {
        final XFile pickedFile = await _picker.pickImage(
          source: source,
        );
        setState(() {
          _imageFile = pickedFile;
        });
        saveImage();
      } catch (e) {
        setState(() {
          _pickImageError = e;
        });
      }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color(0XFF3C73E1),
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              height: 150,
              width: 200,
              child: Image.asset('assets/Images/daisy.png'),
            ),
            Center(
              child: Text('Welcome to Daisy', style: TextStyle(
                fontSize: 40.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: 'Horizon',
              ),
              ),
            ),
            SizedBox(height: 10.0),
            Center(
              child: AutoSizeText('Lets get you started \n'
                  'and deliver on time',
                maxFontSize: 26,
                minFontSize: 20,
                maxLines: 2,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Center(
              child: Lottie.asset(
                'assets/medicals.json',
                width: MediaQueryData().size.width*0.9,
                height: MediaQueryData().size.height*0.3,
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: MediaQueryData().size.width*0.6,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        bottomRight: Radius.circular(20)
                    ),
                  ),
                  child: Center(
                    child: Text('Sign up',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Padding(
            //   padding: const EdgeInsets.only(left: 25, top: 15),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //     children: [
            //       FloatingActionButton(
            //         onPressed: () {
            //           loadAssets(ImageSource.gallery, context: context);
            //         },
            //         heroTag: 'image',
            //         tooltip: 'Pick Image from gallery',
            //         child: const Icon(Icons.photo),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}