import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosmocloset/provider/user_provider.dart';
import 'package:cosmocloset/screens/closet_screen.dart';
import 'package:cosmocloset/screens/home_screen.dart';
import 'package:cosmocloset/screens/profile_screen.dart';
import 'package:cosmocloset/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cosmocloset/model/user.dart' as model;

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({super.key,});

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _page = 0;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void navigationTapped(int value) {
    pageController.jumpToPage(value);
  }

  void onPageChanged(int value) {
    setState(() {
      _page = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        children: const [
          HomeScreen(),
          ClosetScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        currentIndex: _page,
        selectedItemColor: Colors.black,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        unselectedItemColor: Colors.grey.withOpacity(0.5),
        elevation: 0,
        items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_rounded,),
          label: 'home',
          backgroundColor: backgroundColor,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.checkroom_rounded),
          label: 'closet',
          backgroundColor: backgroundColor,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_2_rounded),
          label: 'profile',
          backgroundColor: backgroundColor,
        ),
        ],
        onTap: navigationTapped,
      ),
    );
  }


}
