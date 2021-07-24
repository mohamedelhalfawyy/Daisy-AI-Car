import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/Screens/sign-in.dart';
import 'package:graduation_project/Screens/sign-up.dart';
import 'package:graduation_project/Services/facenet.service.dart';
import 'package:graduation_project/Services/ml_kit_service.dart';
import 'package:graduation_project/db/database.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key key}) : super(key: key);

  static const String id = 'DashBoard';
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {

  /**
   * ? 1 Obtain a list of the available cameras on the device
   * ?.2 loads the face net model
   */

  FaceNetService _faceNetService = FaceNetService();
  MLKitService _mlKitService = MLKitService();
  DataBaseService _dataBaseService = DataBaseService();

  CameraDescription cameraDescription;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _startUp();
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFC7FFBE),
      appBar: AppBar(
        leading: Container(),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20, top: 20),
            child: PopupMenuButton<String>(
              child: Icon(
                Icons.more_vert,
                color: Colors.black,
              ),
              onSelected: (value) {
                switch (value) {
                  case 'Clear DB':
                    _dataBaseService.cleanDB();
                    break;
                }
              },
              itemBuilder: (BuildContext context) {
                return {'Clear DB'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ),
        ],
      ),
      body: !loading
          ? SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => SignIn(
                            cameraDescription: cameraDescription,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.1),
                            blurRadius: 1,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(
                          vertical: 14, horizontal: 16),
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'ControlRoom',
                            style: TextStyle(color: Color(0xFF0F0BDB)),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(Icons.login, color: Color(0xFF0F0BDB))
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => SignUp(
                            cameraDescription: cameraDescription,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xFF0F0BDB),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.1),
                            blurRadius: 1,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(
                          vertical: 14, horizontal: 16),
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'SIGN UP',
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(Icons.person_add, color: Colors.white)
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Divider(
                      thickness: 2,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      )
          : Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
