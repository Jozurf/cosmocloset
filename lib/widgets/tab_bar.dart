import 'package:cosmocloset/resources/fonts.dart';
import 'package:cosmocloset/utils/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TabBarItemWid extends StatelessWidget {
  final int selectedValue;
  final int toActivate;
  final String tabText;
  const TabBarItemWid(
      {super.key,
      required this.selectedValue,
      required this.toActivate,
      required this.tabText});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16),
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: selectedValue == toActivate ? panelColor : backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        tabText,
        style: selectedValue == toActivate ? GoogleFonts.plusJakartaSans(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ) : GoogleFonts.plusJakartaSans(
          color: panelColor,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        )
        ),
    );
  }
}
