import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreServices {
  /**
    * *Here we make a variable of the firebase cloud firestore instance to acess the
   * *Firestore, Also we make a variable of the collection called users which contain all
   * *The information of the users and the data
   * **/
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  CollectionReference _users = FirebaseFirestore.instance.collection('Users');

  bool _isTaken;

  /**
   * *Here we make a function to add the user to the firestore in the Users collection
   * *We get the parameters we need to register a user as the email/password/name/photo
   * *Then we call the Users collection and add in each parameter the value we received from the user
   * **/
  Future<void> addUser(String email, String password, String name, String photo) async {
    await _fireStore.collection('Users').add({
      'Email': email,
      'Name': name,
      'Password': password,
      'Photo': photo
    });

    log('User added successfully!');
  }

  Future<bool> checkEmail(String email) async {
    await _fireStore
        .collection('Users')
        .where('Email', isEqualTo: email)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        log('found');
        _isTaken = true;
      } else {
        log('not Found');
        _isTaken = false;
      }
    });

    return _isTaken;
  }

  Future<String> getPassword(String email) async {
    String password;

    await _fireStore
        .collection('Users')
        .where('Email', isEqualTo: email)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        password = value.docs.first.get('Password');
      } else {
        log('something wrong happened');
      }
    });

    return password;
  }

  Future<String> getName(String email) async {
    String name;

    await _fireStore
        .collection('Users')
        .where('Email', isEqualTo: email)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        name = value.docs.first.get('Name');
      } else {
        log('something wrong happened');
      }
    });

    return name;
  }

  Future<String> getPhoto(String email) async {
    String photo;

    await _fireStore
        .collection('Users')
        .where('Email', isEqualTo: email)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        photo = value.docs.first.get('Photo');
      } else {
        log('something wrong happened');
      }
    });

    return photo;
  }

  Future<String> getPhotoWithPass(String password) async {
    String photo;

    await _fireStore
        .collection('Users')
        .where('Password', isEqualTo: password)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        photo = value.docs.first.get('Photo');
      } else {
        log('something wrong happened');
      }
    });

    return photo;
  }

  Future<void> updatePassword(String email, String password, String uid) async {
    await _users.doc(uid).update({'Password': password}).then(
            (value) => log('Client password changed successfully'));
  }

  Future<String> getUserId(String email) async {
    String _uid;

    await _fireStore
        .collection('Users')
        .where('Email', isEqualTo: email)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        _uid = value.docs.first.id;
        log('id Collected');
      }
    });

    return _uid;
  }
}