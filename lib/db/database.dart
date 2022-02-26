import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:graduation_project/Services/FirebaseApi.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';


class DataBaseService {
  // singleton boilerplate
  static final DataBaseService _cameraServiceService =
      DataBaseService._internal();

  factory DataBaseService() {
    return _cameraServiceService;
  }
  // singleton boilerplate
  DataBaseService._internal();

  /// file that stores the data on filesystem
  File jsonFile;
  UploadTask task;

  /// Data learned on memory
  Map<String, dynamic> _db = Map<String, dynamic>();
  Map<String, dynamic> get db => this._db;

  /// loads a simple json file.
  Future loadDB() async {
    var tempDir = await getApplicationDocumentsDirectory();
    String _embPath = tempDir.path + '/emb.json';

    jsonFile = new File(_embPath);

    try{
      await FirebaseStorage.instance.ref('files/emb.json').writeToFile(jsonFile);
    } catch(e){
      log("file not uploaded yet");
    }

    if (jsonFile.existsSync()) {
      _db = json.decode(jsonFile.readAsStringSync());
    }

  }

  /// [Name]: name of the new user
  /// [Data]: Face representation for Machine Learning model
  Future saveData(String user, String password, List modelData) async {
    String userAndPass = user + ':' + password;
    _db[userAndPass] = modelData;
    jsonFile.writeAsStringSync(json.encode(_db));

      if (jsonFile == null) return;

      final fileName = basename(jsonFile.path);
      final destination = 'files/$fileName';

      task = FirebaseApi.uploadFile(destination, jsonFile);

      if (task == null) return;

      final snapshot = await task.whenComplete(() {});
      final urlDownload = await snapshot.ref.getDownloadURL();

      print('Download-Link: $urlDownload');

  }

  /// deletes the created users
  cleanDB() {
    this._db = Map<String, dynamic>();
    jsonFile.writeAsStringSync(json.encode({}));
  }
}
