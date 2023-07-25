import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String password;
  final String uid;
  final String username;

  const User({
    required this.email,
    required this.password,
    required this.uid,
    required this.username,
  });

  Map<String, dynamic> toJson() => {
    "email": email,
    "password": password,
    "uid": uid,
    "username": username
  };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return User(
      email: snapshot['email'],
      password: snapshot['password'],
      uid: snapshot['uid'],
      username: snapshot['username']);
  }

  static User fromGooogleSnap(String? displayName, String? userEmail, String uid) {
    return User(email: userEmail!, username: displayName!, uid: uid, password: "");
  }
}