import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
final FirebaseAuth _auth = FirebaseAuth.instance;

AuthServices();

Future<dynamic> signInWithEmail(String email, String password) {
  return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

}