import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInAuth {
  static final _googleSignIn = GoogleSignIn();
  static Future<GoogleSignInAccount?> login() => _googleSignIn.signIn();
  static Future<GoogleSignInAccount?> logOut() => _googleSignIn.signOut();
  static Future<bool> isUserLoggedInWithGoogle() async {
    return await _googleSignIn.isSignedIn();
  }
}
