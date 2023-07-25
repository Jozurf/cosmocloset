import 'package:cosmocloset/resources/fonts.dart';
import 'package:cosmocloset/utils/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class EditButtons extends StatelessWidget {
  final String text;
  final void Function()? function;
  const EditButtons({super.key, required this.text, required this.function});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: function,
      child: Container(
        width: MediaQuery.of(context).size.width*0.2,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: const ShapeDecoration(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12))),
          color: buttonColor,
        ),
        child: Text(text, style: buttonTextStyle,),
      ),
    );
  }
}
