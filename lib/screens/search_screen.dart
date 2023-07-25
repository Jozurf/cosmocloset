import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosmocloset/utils/remove_scroll_effect.dart';
import 'package:cosmocloset/widgets/clothing_card.dart';
import 'package:cosmocloset/widgets/skelton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  final TextEditingController searchController;
  const SearchScreen({super.key, required this.searchController});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where('name', isGreaterThanOrEqualTo: widget.searchController.text)
          .where('name',
              isLessThanOrEqualTo: '${widget.searchController.text}\uf8ff')
          .get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: ListView.separated(
                  itemBuilder: (context, index) =>
                      const Skelton(height: 80, width: 100),
                  separatorBuilder: (context, index) => const SizedBox(
                        height: 12,
                      ),
                  itemCount: 5),
            ),
          );
        }

        return ScrollConfiguration(
          behavior: MyBehavior(),
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) =>
                  ClothingCard(snap: snapshot.data!.docs[index].data()),
            ),
          ),
        );
      },
    );
  }
}
