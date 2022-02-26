import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServices {
final FirebaseAuth _auth = FirebaseAuth.instance;

static final _googleSignIn = GoogleSignIn(scopes: ['https://mail.google.com/']);

AuthServices();

Future<dynamic> signInWithEmail(String email, String password) {
  return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

Future<dynamic> createUserWithEmail(String email, String password) {
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