import 'package:cosmocloset/model/clothing.dart';
import 'package:cosmocloset/resources/fonts.dart';
import 'package:cosmocloset/utils/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ClothingGen extends StatelessWidget {
  final Map<String, dynamic> snap;
  const ClothingGen({super.key, required this.snap});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: textFieldColor,
        ),
        child: Row(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.095,
              width: MediaQuery.of(context).size.width * 0.2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  snap['photoUrl'],
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(left: 12),
                child: Text(
                  snap['name'],
                  style: buttonTextStyle,
                ),
              ),
            ),
          ],
        ));
  }
}
