import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosmocloset/resources/fonts.dart';
import 'package:cosmocloset/utils/colors.dart';
import 'package:cosmocloset/utils/global_variables.dart';
import 'package:cosmocloset/utils/remove_scroll_effect.dart';
import 'package:cosmocloset/widgets/clothing_card.dart';
import 'package:cosmocloset/widgets/clothing_gen.dart';
import 'package:cosmocloset/widgets/skelton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:weather/weather.dart';

class RandomClothingCard extends StatefulWidget {
  final String clothingType;
  final Random rand;
  final bool weatherCondition;
  final bool formalCondition;
  final Weather? weatherInformation;
  const RandomClothingCard(
      {super.key,
      required this.clothingType,
      required this.rand,
      required this.weatherCondition,
      required this.formalCondition,
      required this.weatherInformation});

  @override
  State<RandomClothingCard> createState() => _RandomClothingCardState();
}

class _RandomClothingCardState extends State<RandomClothingCard> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _fetchSnapshot(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: Skelton(height: 90, width: 400,),
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
        // has snapshot and data
        // make a list of same length each index representing the probability of picking that index item
        List<double> representingProbabilities = algorithim(snapshot.data!.docs);
        // normalize such that adding all would equal to one
        List<double> normalizedProbabilities =
            normalizeProbabilities(representingProbabilities);
        // random double from 0 to 1
        double numberToBeat = widget.rand.nextDouble();
        // pick the index
        int indexToChoose =
            priorityPicking(normalizedProbabilities, numberToBeat);
        // choose
        return indexToChoose != -1
            ? ClothingGen(snap: snapshot.data!.docs[indexToChoose].data())
            : const SizedBox();
      },
    );
  }

  Future<QuerySnapshot<Map<String, dynamic>>> _fetchSnapshot() {
    return FirebaseFirestore.instance
        .collection('posts')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('clothingType', isEqualTo: widget.clothingType)
        .get();
  }

  List<double> algorithim(List<QueryDocumentSnapshot<Map<String, dynamic>>> docs) {
    List<double> temp = List.empty(growable: true);
    docs.forEach((element) {
      double priority = 1;
      if (widget.weatherCondition) {
        priority = checkForHeat(priority, widget.weatherInformation, element);
        priority =
            checkForClimate(priority, widget.weatherInformation, element);
      }
      if (widget.formalCondition) {
        priority = checkForFormal(priority, element);
        print("priority after: $priority");
      }
      temp.add(priority);
    });
    return temp;
  }

  List<double> normalizeProbabilities(List<double> probabilities) {
    double totalProbability = probabilities.reduce((a, b) => a + b);
    List<double> normalizedProbabilities =
        probabilities.map((p) => p / totalProbability).toList();
    return normalizedProbabilities;
  }

  int priorityPicking(List<double> normalizeProbabilities, double randNum) {
    double cumulativeProbability = 0;
    for (int i = 0; i < normalizeProbabilities.length; i++) {
      cumulativeProbability += normalizeProbabilities[i];
      if (randNum <= cumulativeProbability) {
        return i;
      }
    }
    return -1;
  }

  double checkForFormal(
      double priority, QueryDocumentSnapshot<Map<String, dynamic>> element) {
    if (element['formal']) {
      print("initial priority: $priority");
      return priority += 0.8;
    } else {
      return priority;
    }
  }

  double checkForHeat(double priority, Weather? weatherInformation,
      QueryDocumentSnapshot<Map<String, dynamic>> element) {
    // if very hot
    if (veryHotCondition(weatherInformation!)) {
      // lower jacket and increase shorts prob
      return modifyForVeryHot(priority, element);
    } else if (hotCondition(weatherInformation)) {
      // lower jacket prob
      return modifyForHot(priority, element);
    } else if (coldCondition(weatherInformation)) {
      return modifyForCold(priority, element);
    } else {
      // very cold condition
      return mocifyForVeryCold(priority, element);
    }
  }

  double checkForClimate(double priority, Weather? weatherInformation,
      QueryDocumentSnapshot<Map<String, dynamic>> element) {
    // if rain/thunderstorm/snow and element['isWaterproof']
    if (weatherIsWet(weatherInformation) && element['isWaterProof']) {
      return priority += 0.8;
    } else {
      return priority;
    }
  }

  bool weatherIsWet(Weather? weatherInformation) {
    switch (weatherInformation!.weatherMain) {
      case "Thunderstorm":
        return true;
      case "Drizzle":
        return true;
      case "Rain":
        return true;
      case "Snow":
        return true;
      default:
        return false;
    }
  }

  bool veryHotCondition(Weather weatherInformation) {
    return weatherInformation.temperature!.celsius! > 23;
  }

  bool hotCondition(Weather weatherInformation) {
    return weatherInformation.temperature!.celsius! > 20;
  }

  bool coldCondition(Weather weatherInformation) {
    return weatherInformation.temperature!.celsius! > 15;
  }

  double modifyForVeryHot(
      double priority, QueryDocumentSnapshot<Map<String, dynamic>> element) {
    if (element['clothingType'] == "Outerwear") {
      return priority -= 0.5;
    } else if (element['shorts']) {
      return priority += 0.5;
    }

    return priority;
  }

  double modifyForHot(
      double priority, QueryDocumentSnapshot<Map<String, dynamic>> element) {
    // TODO
    if (element['clothingType'] == "Outerwear") {
      return priority -= 0.5;
    }

    return priority;
  }

  double modifyForCold(
      double priority, QueryDocumentSnapshot<Map<String, dynamic>> element) {
    if (element['shorts']) {
      return priority -= 0.5;
    } else {
      return priority;
    }
  }

  double mocifyForVeryCold(
      double priority, QueryDocumentSnapshot<Map<String, dynamic>> element) {
    if (element['shorts']) {
      priority -= 0.8;
    }

    if (element['light']) {
      priority -= 0.4;
    }

    return priority;
  }
}
