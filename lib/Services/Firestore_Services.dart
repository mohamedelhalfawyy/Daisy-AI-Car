import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreServices {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  CollectionReference _users = FirebaseFirestore.instance.collection('Users');

  bool _isTaken;

  Future<void> addUser(String email, String password, String name) async {
    await _fireStore.collection('Users').add({
      'Email': email,
      'Name': name,
      'Password': password,
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