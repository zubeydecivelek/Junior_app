import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:juniorapp/Pages/RegisterPage.dart';

import 'HomePage.dart';
import 'navigationPage.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        return (snapshot.hasData) ?  NavigationPage() : RegisterPage();
      },
    );
  }
}