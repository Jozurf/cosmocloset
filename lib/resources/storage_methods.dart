import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> uploadImageToStorage(String childName, Uint8List file,) async {

    Reference ref = _storage.ref().child(childName).child(_auth.currentUser!.uid);

    String id = const Uuid().v1();
    ref = ref.child(id);
    UploadTask uploadTask = ref.putData(file);


    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  void deleteImageToStorage(String originalPhotoUrl) {
    _storage.refFromURL(originalPhotoUrl).delete().then((_) => print("sucessfully delete previous file"));
  }
}