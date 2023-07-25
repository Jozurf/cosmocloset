import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosmocloset/resources/fonts.dart';
import 'package:cosmocloset/utils/remove_scroll_effect.dart';
import 'package:cosmocloset/widgets/clothing_card.dart';
import 'package:cosmocloset/widgets/skelton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FeedScreen extends StatelessWidget {
  final bool isAll;
  final String? type;
  const FeedScreen({
    super.key,
    required this.isAll,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: StreamBuilder(
          stream: isAll == true
              ? FirebaseFirestore.instance
                  .collection('posts')
                  .where('uid',
                      isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                  .snapshots()
              : FirebaseFirestore.instance
                  .collection('posts')
                  .where('uid',
                      isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                  .where('clothingType', isEqualTo: type)
                  .snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: ListView.separated(
                      itemBuilder: (context, index) =>
                          const Skelton(height: 90, width: 120),
                      separatorBuilder: (context, index) => const SizedBox(
                            height: 12,
                          ),
                      itemCount: 5),
                );
            }

            return snapshot.data!.docs.isEmpty
                ? Center(
                    child: Text(
                      "Add your wardrobe!",
                      style: descriptionStyle,
                    ),
                  )
                : ScrollConfiguration(
                    behavior: MyBehavior(),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) =>
                          ClothingCard(snap: snapshot.data!.docs[index].data()),
                    ),
                  );
          }),
    ));
  }
}
