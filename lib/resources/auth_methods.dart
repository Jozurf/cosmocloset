import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cosmocloset/model/user.dart' as model;

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap = await _firestore.collection('users').doc(currentUser.uid).get();

    if (snap.exists) {
      return model.User.fromSnap(snap);
    } else {
      return model.User.fromGooogleSnap(currentUser.displayName, currentUser.email, currentUser.uid);
    }
  }
  
  //signing up user
  Future<String> signUpUser({
    required String email,
    required String password,
    required String confirmPassword,
    required String username,
  }) async {
    String res = "Some error occurred";
    try {
      if (password != confirmPassword) {
        throw ErrorDescription("passwords typed are different");
      }
      if (email.isNotEmpty && password.isNotEmpty && confirmPassword.isNotEmpty) {
        // reigster user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
        print(cred.user!.uid);
        // create user
        model.User user = model.User(
          email: email,
          password: password,
          uid: cred.user!.uid,
          username: username
        );
        // add user to the database
        await _firestore.collection('users').doc(cred.user!.uid).set(user.toJson());
        // sucess added to database\
        res = "success";
      } else {
        throw ErrorDescription("please fill up all the fields");
      }
    } on FirebaseAuthException catch(err) {
      if (err.toString() == 'invalid-email') {
        res = "Email is badly formatted";
      } else if (err.toString() == 'weak-password') {
        res = 'Password should at least be 6 characters';
      } else {
        res = err.toString();
      }
    }
     catch(err) { // error if there are problems creating the 
      res = err.toString();
    }
    return res;
  }


  Future<String> loginUser({
    required String email,
    required String password
  }) async {
    String res = "some error occured";
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(email: email, password: password);
        res = "success";
      } else {
        res = "please enter all the fields";
      }
    } on FirebaseAuthException catch(err) {
      if (err.code == 'user_not_found') {
        res = "user doesnt exist";
      } else if (err.code == 'wrong-password') {
        res = "incorrect password was given";
      }
    } catch(err) {
      res = err.toString();
    }
    return res;
  }


  Future<void> signOut() async {
    await _auth.signOut();
  }
}