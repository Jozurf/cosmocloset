import 'package:cosmocloset/resources/fonts.dart';
import 'package:cosmocloset/resources/google_sign.dart';
import 'package:cosmocloset/screens/signup_screen.dart';
import 'package:cosmocloset/utils/colors.dart';
import 'package:cosmocloset/utils/utils.dart';
import 'package:cosmocloset/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../reponsive/mobile_layout.dart';
import '../reponsive/responsive_layout.dart';
import '../reponsive/web_layout.dart';
import '../resources/auth_methods.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailcontroller.dispose();
    _passwordcontroller.dispose();
  }

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().loginUser(
        email: _emailcontroller.text, password: _passwordcontroller.text);

    if (res != 'success') {
      showSnackBar(res, context);
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const ResponsiveLayout(
            webScreenLayout: WebScreenLayout(),
            mobileScreenLayout: MobileScreenLayout()),
      ));
    }

    setState(() {
      _isLoading = false;
    });
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
        builder: (context) => const ResponsiveLayout(
            webScreenLayout:  WebScreenLayout(),
            mobileScreenLayout: MobileScreenLayout()),
      ));
    }
  }

  void navigateToSignUp() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SignupScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          // padding: const EdgeInsets.symmetric(horizontal: 16),
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // title for the app
                Container(
                  margin: const EdgeInsets.only(top: 70.00, bottom: 32.00),
                  child: Text(
                    "CosmoCloset",
                    style: titleStyle,
                  ), // text title
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
                        "Welcome Back",
                        style: GoogleFonts.plusJakartaSans(
                            fontSize: 32, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Text(
                        "Fill out the information below in order to access your account.",
                        style: descriptionStyle,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      TextFieldInput(
                          textEditingController: _emailcontroller,
                          hintText: "email",
                          textInputType: TextInputType.emailAddress),
                      const SizedBox(
                        height: 16,
                      ),
                      TextFieldInput(
                        textEditingController: _passwordcontroller,
                        hintText: "password",
                        textInputType: TextInputType.text,
                        isPass: true,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      InkWell(
                        onTap: loginUser,
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
                                ))
                              : Text(
                                  "Sign in",
                                  style: buttonTextStyle,
                                ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
                        child: Text(
                          "or sign in with",
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
                              Text("Sign in with ", style: buttonTextStyle,),
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
                              "Don't have an account? ",
                              style: descriptionStyle,
                            ),
                          ),
                          GestureDetector(
                            onTap: navigateToSignUp,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: const Text(
                                "Sign up here",
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
