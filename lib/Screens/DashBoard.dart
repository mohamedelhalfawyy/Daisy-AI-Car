import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/widgets/SnackBar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

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

  _buildCard({
    Config config,
    Color backgroundColor = Colors.transparent,
    DecorationImage backgroundImage,
    double height = 820,
  }) {
    return Container(
      height: height,
      width: double.infinity,
      child: WaveWidget(
        config: config,
        backgroundColor: backgroundColor,
        backgroundImage: backgroundImage,
        size: Size(double.infinity, double.infinity),
        waveAmplitude: 0,
      ),
    );
  }

  MaskFilter _blur;
  // final List<MaskFilter> _blurs = [
  //   null,
  //   MaskFilter.blur(BlurStyle.normal, 50.0),
  // ];
  //int _blurIndex = 0;
  // MaskFilter _nextBlur() {
  //   if (_blurIndex == _blurs.length - 1) {
  //     _blurIndex = 0;
  //   } else {
  //     _blurIndex = _blurIndex + 1;
  //   }
  //   _blur = _blurs[_blurIndex];
  //   return _blurs[_blurIndex];
  // }

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

      //   _storage
      //     .ref()
      //     .child(imageLocation); // To be aligned with the latest firebase API(4.0)
      //
      // final metadata = firebase_storage.SettableMetadata(
      //     contentType: 'image/jpeg',
      //     customMetadata: {'picked-file-path': fileName});

      // firebase_storage.UploadTask uploadTask = ref.putData(imageData);
      //
      // await uploadTask.onComplete;
      //
      // final refs = FirebaseStorage.instance.ref().child(imageLocation);
      //
      // var imageString = await refs.getDownloadURL();

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
      body: Center(
        child: Stack(
          children: [
            ListView(
              children: <Widget>[
                _buildCard(
                    config: CustomConfig(
                      colors: [
                        Colors.blueAccent.shade200,
                      ],
                      durations: [102000],
                      heightPercentages: [MediaQueryData().size.height*0.00065],
                      blur: _blur,
                    ),
                    backgroundColor: Colors.white60),
              ],
            ),
          ListView(
            children: [
              SizedBox(width: 20.0, height: 20.0),
              Container(
                height: 150,
                width: 200,
                child: Image.asset('assets/Images/daisy.png'),
              ),
              SizedBox(width: 20.0, height: 10.0),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(width: 30.0),
                  Text('Welcome to Daisy', style: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Horizon',
                  ),
                  ),
                ],
              ),
              Container(
                width: MediaQueryData().size.width,
                height: 140,
                margin: const EdgeInsets.all(15.0),
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.blueAccent.shade100,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Text('Daisy is here to help you deliver food and medicine to your patients',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Row(
                children: [
                  SizedBox(width: MediaQueryData().size.width*0.32),
                  Text('please log in to start ',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  SizedBox(width: MediaQueryData().size.width*0.70),
                  Text('delivering',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  SizedBox(width: MediaQueryData().size.width*0.68),
                  Container(
                    width: 120,
                    height: 80,
                    margin: const EdgeInsets.all(15.0),
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent.shade200,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text('log in',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                'Upload Your Photo',
                style: TextStyle(fontSize: 20),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25, top: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FloatingActionButton(
                      onPressed: () {
                        loadAssets(ImageSource.gallery, context: context);
                      },
                      heroTag: 'image',
                      tooltip: 'Pick Image from gallery',
                      child: const Icon(Icons.photo),
                    ),
                  ],
                ),
              ),
            ],
          ),
          ],
        ),
      ),
    );
  }
}