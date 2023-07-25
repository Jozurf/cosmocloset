import 'package:cosmocloset/provider/user_provider.dart';
import 'package:cosmocloset/reponsive/mobile_layout.dart';
import 'package:cosmocloset/reponsive/responsive_layout.dart';
import 'package:cosmocloset/reponsive/web_layout.dart';
import 'package:cosmocloset/resources/google_sign.dart';
import 'package:cosmocloset/screens/login_screen.dart';
import 'package:cosmocloset/screens/signup_screen.dart';
import 'package:cosmocloset/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyAQWfkfL8ok2bufo56BPiUDZZdEzX1294U",
        appId: "1:644524535205:web:3f3f1930a49d4a2a2c0c4c",
        messagingSenderId: "644524535205",
        projectId: "cosmocloset-b931c",
        storageBucket: "cosmocloset-b931c.appspot.com",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UserProvider()), ChangeNotifierProvider(create: (context) => GoogleSignInProvider())],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData.light().copyWith(
            scaffoldBackgroundColor: backgroundColor,
          ),
          home: StreamBuilder(
            stream: FirebaseAuth.instance.userChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                  ),
                );
              }
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  return ResponsiveLayout(
                      webScreenLayout: const WebScreenLayout(),
                      mobileScreenLayout: MobileScreenLayout());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('${snapshot.error}'),
                  );
                }
              }
              return const LoginScreen();
            },
          )
          ),
    );
  }
}
