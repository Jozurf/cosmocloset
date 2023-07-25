import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosmocloset/model/clothing.dart';
import 'package:cosmocloset/resources/storage_methods.dart';
import 'package:cosmocloset/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadClothing(String uid, String name, Uint8List file,
      String clothingType, String color, Map<String, dynamic> additionalSettings) async {
    String res = "some error occurred";
    try {
      // save the photo in photos and retrieve its url
      String photoUrl =
          await StorageMethods().uploadImageToStorage('posts', file);
      // making a unique id for clothing
      String clothingId = const Uuid().v1();
      // make the clothing
      Clothing tempClothing = Clothing(
          uid: uid,
          name: name,
          clothingType: clothingType,
          color: color,
          photoUrl: photoUrl,
          clothingId: clothingId,
          formal: additionalSettings['formal'],
          waterproof: additionalSettings['waterproof'],
          shorts: additionalSettings['shorts'],
          light: additionalSettings['light'],
          subtype: additionalSettings['subtype']);
      // upload to database
      _firestore.collection('posts').doc(clothingId).set(tempClothing.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> deleteItem(String clothingId, String clothingType, String photoUrl) async {
    String res = "some error occurred";
    try {
      _firestore.collection('posts').doc(clothingId).delete();
      //TODO delete all the images
      StorageMethods().deleteImageToStorage(photoUrl);
      res = "deleted";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> updateClothing(
      String name,
      Uint8List? file,
      String clothingType,
      String color,
      String clothingUid,
      String originalPhotoUrl,
      String originalClothingType, Map<String, dynamic> additionalSettings) async {
    String res = "some error occurred";
    try {
      // save the photo in photos and retrieve its url
      String photoUrl = file == null
          ? originalPhotoUrl
          : await StorageMethods().uploadImageToStorage('posts', file);
      // update the clothing in main
      final docClothing =
          FirebaseFirestore.instance.collection('posts').doc(clothingUid);
      docClothing.update({
        'name': name,
        'color': color,
        'clothingType': clothingType,
        'photoUrl': photoUrl,
        'formal' : additionalSettings['formal'],
        'waterproof': additionalSettings['waterproof'],
        'shorts': additionalSettings['shorts'],
        'light': additionalSettings['light'],
        'subtype': additionalSettings['subtype']
      });
      // update the individual

      if (file != null) {
        // delete the original file
        StorageMethods().deleteImageToStorage(originalPhotoUrl);
      }
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
