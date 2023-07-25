import 'package:cosmocloset/resources/firestore_methods.dart';
import 'package:cosmocloset/resources/fonts.dart';
import 'package:cosmocloset/screens/edit_clothing_popup.dart';
import 'package:cosmocloset/utils/colors.dart';
import 'package:cosmocloset/utils/utils.dart';
import 'package:cosmocloset/widgets/custom_animation.dart';
import 'package:cosmocloset/widgets/hero_animation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cosmocloset/utils/global_variables.dart';

class ClothingCard extends StatelessWidget {
  final Map<String, dynamic> snap;
  const ClothingCard({super.key, required this.snap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => EditClothingPopup(specifications: snap)));
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: textFieldColor,
        ),
        child: Row(
          children: [
            Hero(
              tag: snap['clothingId'],
              createRectTween: (begin, end) {
                return CustomRectTween(begin: begin!, end: end!);
              },
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
                width: MediaQuery.of(context).size.width * 0.2,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    snap['photoUrl'],
                    fit: BoxFit.cover,
                  ),
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
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) => Dialog(
                            child: ListView(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shrinkWrap: true,
                              children: [
                                'Delete',
                              ]
                                  .map(
                                    (e) => InkWell(
                                      onTap: () async {
                                        String res = await FirestoreMethods()
                                            .deleteItem(snap['clothingId'], snap['clothingType'], snap['photoUrl']);
                                        Navigator.of(context).pop();
                                        if (res != "success") {
                                          showSnackBar("deleted", context);
                                        } else {
                                          showSnackBar(res, context);
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12, horizontal: 16),
                                        child: Text(e),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ));
                },
                icon: const Icon(Icons.delete)),
          ],
        ),
      ),
    );
  }
}
