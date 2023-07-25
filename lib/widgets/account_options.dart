import 'package:cosmocloset/utils/colors.dart';
import 'package:flutter/material.dart';

class AccountOptions extends StatelessWidget {
  final void Function()? function;
  final String optionText;

  const AccountOptions({
    super.key,
    required this.function,
    required this.optionText
    });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.only(top: 8, left: 20, right: 8, bottom: 8),
      decoration: const BoxDecoration(
        color: panelColor,
        borderRadius: BorderRadius.all(Radius.circular(12))
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(optionText),
          IconButton(
          onPressed: function,
          icon: const Icon(Icons.chevron_right_rounded))
        ],
      ),
    );
  }
}