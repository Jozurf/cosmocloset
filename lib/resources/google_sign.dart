
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();


  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;

  Future<String> googleLogin() async {
    String res = "some error occured";
    try {
      final googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        res = "no problem";
        return res;
      }

      _user = googleUser;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      notifyListeners();
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }


  Future<void> signOut() async {
    await googleSignIn.signOut();
  }
}