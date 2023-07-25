import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosmocloset/utils/colors.dart';
import 'package:cosmocloset/utils/global_variables.dart';
import 'package:cosmocloset/widgets/feed_screen.dart';
import 'package:cosmocloset/widgets/tab_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({super.key});

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  int selectedValue = 0;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 6, vsync: this, initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          TabBar(
            controller: tabController,
            splashFactory: NoSplash.splashFactory,
            isScrollable: true,
            labelColor: Colors.black,
            unselectedLabelColor: backgroundColor,
            indicatorColor: Colors.transparent,
            indicatorSize: TabBarIndicatorSize.label,
            onTap: (value) {
              setState(() {
                selectedValue = value;
                tabController.animateTo(value);
              });
            },
            tabs: [
              TabBarItemWid(
                  selectedValue: selectedValue, toActivate: 0, tabText: "All"),
              TabBarItemWid(
                  selectedValue: selectedValue, toActivate: 1, tabText: "Top"),
              TabBarItemWid(
                  selectedValue: selectedValue,
                  toActivate: 2,
                  tabText: "Bottom"),
              TabBarItemWid(
                  selectedValue: selectedValue,
                  toActivate: 3,
                  tabText: "Outerwear"),
              TabBarItemWid(
                  selectedValue: selectedValue,
                  toActivate: 4,
                  tabText: "Footwear"),
              TabBarItemWid(
                  selectedValue: selectedValue,
                  toActivate: 5,
                  tabText: "Accessories"),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              controller: tabController,
              children: const [
                FeedScreen(
                  isAll: true,
                  type: null,
                ),
                FeedScreen(
                  isAll: false,
                  type: "Top",
                ),
                FeedScreen(
                  isAll: false,
                  type: "Bottom",
                ),
                FeedScreen(
                  isAll: false,
                  type: "Outerwear",
                ),
                FeedScreen(
                  isAll: false,
                  type: "Footwear",
                ),
                FeedScreen(
                  isAll: false,
                  type: "Accessories",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
