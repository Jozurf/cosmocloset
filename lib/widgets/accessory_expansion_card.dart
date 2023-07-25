import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosmocloset/resources/fonts.dart';
import 'package:cosmocloset/utils/colors.dart';
import 'package:cosmocloset/widgets/clothing_gen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AccessoriesExpandCard extends StatefulWidget {
  final String clothingType;
  final Random rand;
  const AccessoriesExpandCard(
      {super.key, required this.clothingType, required this.rand});

  @override
  State<AccessoriesExpandCard> createState() => _AccessoriesExpandCardState();
}

class _AccessoriesExpandCardState extends State<AccessoriesExpandCard> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection(widget.clothingType)
            .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                strokeWidth: 1,
              ),
            );
          }

          if (snapshot.data!.docs.isEmpty) {
            return Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: textFieldColor,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      'Add an item in the ${widget.clothingType} category first!',
                      style: buttonTextStyle,
                    ),
                  )
                ],
              ),
            );
          }

          List<int> representingProbabilities = algorithim(snapshot.data!.docs);
          // plus one since we add the items probability before checking if it beats the number to beat
          // otherwise, the first item will always beat as all items will have probability of 1 by default
          int numberToBeat =
              widget.rand.nextInt(snapshot.data!.docs.length) + 1;
          // randomly pick
          int indexToChoose =
              priorityPicking(representingProbabilities, numberToBeat);

          return Card(
            elevation: 0,
            color: textFieldColor,
            child: ExpansionTile(
              title: Text(
                "Accessories (optional)",
                style: buttonTextStyle,
              ),
              children: [
                ClothingGen(snap: snapshot.data!.docs[indexToChoose].data()),
              ],
            ),
          );
        });
  }

  List<int> algorithim(List<QueryDocumentSnapshot<Map<String, dynamic>>> docs) {
    List<int> temp = List.empty(growable: true);
    docs.forEach((element) {
      int priority = 1;
      // if its field matches the preferences, then priority + 1,
      temp.add(priority);
    });
    return temp;
  }

  int priorityPicking(List<int> representingProbabilities, int randNum) {
    int cumulativeProbability = 0;
    for (int i = 0; i < representingProbabilities.length; i++) {
      cumulativeProbability += representingProbabilities[i];
      if (randNum <= cumulativeProbability) {
        return i;
      }
    }
    return 0;
  }
}
