import 'package:cosmocloset/model/userSettings.dart';
import 'package:cosmocloset/provider/user_provider.dart';
import 'package:cosmocloset/resources/auth_methods.dart';
import 'package:cosmocloset/resources/fonts.dart';
import 'package:cosmocloset/resources/google_sign.dart';
import 'package:cosmocloset/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cosmocloset/model/user.dart' as model;

import '../utils/colors.dart';
import '../widgets/account_options.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key,});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.username,
                style: titleStyle,
              ),
              Container(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  children: [
                    Container(
                        padding: const EdgeInsets.only(top: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Switch to dark mode"),
                            IconButton(
                                onPressed: toggleTheme,
                                icon: const Icon(Icons.dark_mode))
                          ],
                        )),
                    Container(
                        padding: const EdgeInsets.only(top: 10),
                        child: const Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Account settings"),
                          ],
                        )),
                    AccountOptions(
                      function: () => editProfile(),
                      optionText: 'edit profile',
                    ),
                    InkWell(
                      onTap: () async {
                        setState(() {
                          _isLoading = true;
                        });
                        AuthMethods().signOut();
                        GoogleSignInProvider().signOut();
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => const LoginScreen()));
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 20),
                        width: double.infinity,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: const ShapeDecoration(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                          color: buttonColor,
                        ),
                        child: _isLoading
                            ? const Center(
                                child: CircularProgressIndicator(
                                color: Colors.black,
                              ))
                            : Text(
                                "log out",
                                style: buttonTextStyle,
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void toggleTheme() {}

  void editProfile() {}

  void logOutUser() {}
}
