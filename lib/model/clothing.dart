import 'package:cloud_firestore/cloud_firestore.dart';

class Clothing {
  final String uid;
  final String name;
  final String clothingType;
  final String color;
  final String photoUrl;
  final String clothingId;
  final bool? formal;
  final bool? waterproof;
  final bool? shorts;
  final bool? light;
  final String? subtype;

  const Clothing({
    required this.uid,
    required this.name,
    required this.clothingType,
    required this.color,
    required this.photoUrl,
    required this.clothingId,
    required this.formal,
    required this.waterproof,
    required this.shorts,
    required this.light,
    required this.subtype
  });

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "name": name,
        "clothingType": clothingType,
        "color": color,
        "photoUrl": photoUrl,
        "clothingId": clothingId,
        "formal": formal,
        "waterproof": waterproof,
        "shorts": shorts,
        "light": light,
        "subtype": subtype
      };

  Map<String, dynamic> toTypeAndJson(Map<String, dynamic> additionalSettings) {
    switch (clothingType) {
      case "Bottom":
        return {
          "uid": uid,
          "name": name,
          "color": color,
          "photoUrl": photoUrl,
          "clothingType": clothingType,
          "clothingId": clothingId,
          "formal": additionalSettings['formal'],
          "shorts": additionalSettings['shorts']
        };
      case "Outerwear":
        return {
          "uid": uid,
          "name": name,
          "color": color,
          "photoUrl": photoUrl,
          "clothingType": clothingType,
          "clothingId": clothingId,
          "formal": additionalSettings['formal'],
          "waterproof": additionalSettings['waterproof'],
          "light": additionalSettings['light']
        };
      case "Footwear":
        return {
          "uid": uid,
          "name": name,
          "color": color,
          "photoUrl": photoUrl,
          "clothingType": clothingType,
          "clothingId": clothingId,
          "formal": additionalSettings['formal'],
        };
      case "Accessories":
        return {
          "uid": uid,
          "name": name,
          "color": color,
          "photoUrl": photoUrl,
          "clothingType": clothingType,
          "clothingId": clothingId,
          "formal": additionalSettings['formal'],
          "subtype": additionalSettings['subtype']
        };
      default: return {
        "uid": uid,
          "name": name,
          "color": color,
          "photoUrl": photoUrl,
          "clothingType": clothingType,
          "clothingId": clothingId,
          "formal": additionalSettings['formal'],
      };
    }
  }

  static Clothing fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Clothing(
        uid: snapshot['uid'],
        name: snapshot['name'],
        clothingType: snapshot['clothingType'],
        color: snapshot['color'],
        photoUrl: snapshot['photoUrl'],
        clothingId: snapshot['clothingId'],
        formal: snapshot['formal'],
        waterproof : snapshot['waterproof'],
        shorts: snapshot['shorts'],
        light: snapshot['light'],
        subtype: snapshot['subtype']
        );
  }

  // static Clothing fromMap(Map<String, dynamic> snapData) {
  //   return Clothing(
  //     uid: snapData['uid'],
  //     name: snapData['name'],
  //     clothingType: snapData['clothingType'],
  //     color: snapData['color'],
  //     photoUrl: snapData['photoUrl'],
  //     clothingId: snapData['clothingId']
  //     );
  // }
}
