import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:juniorapp/Pages/home.dart';
class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
        splash: Column(
          children: [
            Image.asset("assets/images/animation.gif"),
          ],
        ),
        nextScreen: Home(),
      duration: 3000,

 splashIconSize: MediaQuery.of(context).size.width,
    );

  }
}
