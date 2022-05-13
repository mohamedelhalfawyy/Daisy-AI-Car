import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServices {
  /**
   * *Here we make a varialbe of the FirebaseAuth instance
   **/
final FirebaseAuth _auth = FirebaseAuth.instance;

static final _googleSignIn = GoogleSignIn(scopes: ['https://mail.google.com/']);

AuthServices();

Future<dynamic> signInWithEmail(String email, String password) {
  /**
   * *In this function we call the built-in method of firebaseAuth to sign in with
   * *Email and password and we send the variables we receive from the user
   **/
  return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

Future<dynamic> createUserWithEmail(String email, String password) {
  /**
   * *In this function we call the built-in method of firebaseAuth to sign up with
   * *Email and password and we send the variables we receive from the user
   **/
   return _auth.createUserWithEmailAndPassword(email: email, password: password);
}

Future<GoogleSignInAccount> googleSignIn() async{
  if(await _googleSignIn.isSignedIn()){
    return _googleSignIn.currentUser;
  }else{
    return await _googleSignIn.signIn();
  }
}

static Future signOut() => _googleSignIn.signOut();

}