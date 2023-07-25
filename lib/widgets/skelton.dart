import 'package:cosmocloset/utils/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class Skelton extends StatelessWidget {
  final double? height, width;
  const Skelton({super.key, required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: darkerTextFieldColor,
      highlightColor: textFieldColor.withOpacity(0.9),
      period: const Duration(milliseconds: 1000),
      child: Container(
          height: height,
          width: width,
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: textFieldColor,
          )),
    );
  }
}
