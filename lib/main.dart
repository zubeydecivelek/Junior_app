import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:juniorapp/Pages/RegisterPage.dart';
import 'package:juniorapp/Pages/SignUpPage.dart';
import 'package:juniorapp/Pages/landingPage.dart';
import 'package:juniorapp/Pages/paymentPage.dart';
import 'package:juniorapp/Pages/pricingPage.dart';

import 'Pages/ProfilePage.dart';

import 'package:juniorapp/Pages/blogPage.dart';
import 'package:juniorapp/Pages/splashScreen.dart';


Future<void> main() async {
  await WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.montserratTextTheme(Theme.of(context).textTheme),
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}