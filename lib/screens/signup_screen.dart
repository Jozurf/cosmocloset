import 'package:cosmocloset/resources/auth_methods.dart';
import 'package:cosmocloset/resources/google_sign.dart';
import 'package:cosmocloset/screens/login_screen.dart';
import 'package:cosmocloset/utils/colors.dart';
import 'package:cosmocloset/utils/utils.dart';
import 'package:cosmocloset/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../reponsive/mobile_layout.dart';
import '../reponsive/responsive_layout.dart';
import '../reponsive/web_layout.dart';
import '../resources/fonts.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _usernameController.dispose();
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().signUpUser(
      email: _emailController.text,
      password: _passwordController.text,
      confirmPassword: _confirmController.text,
      username: _usernameController.text
    );

    if (res != 'success') {
      showSnackBar(res, context);
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => ResponsiveLayout(
            webScreenLayout:const WebScreenLayout(),
            mobileScreenLayout: MobileScreenLayout()),
      ));
    }

    setState(() {
      _isLoading = false;
    });
  }

  void navigateToLogin() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  void loginUserGoogle() async {
    final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
    String res = await provider.googleLogin();
    if (res != "success") {
      if (res != "no problem") {
        showSnackBar(res, context);
      }
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => ResponsiveLayout(
            webScreenLayout:const WebScreenLayout(),
            mobileScreenLayout: MobileScreenLayout()),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // title for the app
                Container(
                  margin: const EdgeInsets.only(top: 70.00, bottom: 8.00),
                  child: Text(
                    "CosmoCloset",
                    style: titleStyle,
                  ), // text title // text title
                ),
                // container to contain textfields and buttons
                Container(
                  margin: const EdgeInsets.all(16.0),
                  padding: const EdgeInsets.all(32.00),
                  decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      color: panelColor),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Create an Account",
                        style: GoogleFonts.plusJakartaSans(
                            fontSize: 32, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Text(
                        "Lets get started by filling up the form below.",
                        style: descriptionStyle,
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      TextFieldInput(
                          textEditingController: _usernameController,
                          hintText: "username",
                          textInputType: TextInputType.text),
                      const SizedBox(
                        height: 16,
                      ),
                      TextFieldInput(
                          textEditingController: _emailController,
                          hintText: "email",
                          textInputType: TextInputType.emailAddress),
                      const SizedBox(
                        height: 16,
                      ),
                      TextFieldInput(
                        textEditingController: _passwordController,
                        hintText: "password",
                        textInputType: TextInputType.text,
                        isPass: true,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      TextFieldInput(
                        textEditingController: _confirmController,
                        hintText: "confirm password",
                        textInputType: TextInputType.text,
                        isPass: true,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      InkWell(
                        onTap: signUpUser,
                        child: Container(
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
                                  ),
                                )
                              : Text(
                                  "Get Started!",
                                  style: buttonTextStyle,
                                ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 8),
                        child: Text(
                          "or sign up with",
                          style: descriptionStyle,
                        ),
                      ),
                      InkWell(
                        onTap: loginUserGoogle,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: const ShapeDecoration(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12))),
                            color: buttonColor,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Sign up with ", style: buttonTextStyle,),
                              const SizedBox(width: 8,),
                              Image.asset('assets/google-icon.png', height: 24,),
                            ],
                          )
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              "Already have an account? ",
                              style: descriptionStyle,
                            ),
                          ),
                          GestureDetector(
                            onTap: navigateToLogin,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: const Text(
                                "Sign in here",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
