import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:smarthome/constants/routes.dart';
import 'package:flutter/material.dart';
import 'package:smarthome/firebase_options.dart';
import 'package:smarthome/user/emailVerifier.dart';
import 'package:smarthome/user/login.dart';
import 'package:smarthome/user/register.dart';
import 'package:smarthome/views/reports.dart';
import 'package:smarthome/views/doorbell.dart';
import 'package:smarthome/views/helpPage.dart';
import 'package:smarthome/views/homePage.dart';
import 'package:smarthome/views/splashView.dart';
import 'package:smarthome/views/universal_room.dart';

void main() {
  runApp(
    MaterialApp(
      home: SplashView(),
      debugShowCheckedModeBanner: false,
      routes: {
        homeRoute: (context) => HomePage(),
        roomPageRoute: (context) => UniversalRoom(
              roomName: ModalRoute.of(context)!.settings.arguments
                  as String, // Access arguments
            ),
        doorbellRoute: (context) => Doorbell(),
        helpPageRoute: (context) => const HelpPage(),
        reportsRoute: (context) => Reports(),
        loginRoute: (context) => LoginView(),
        registerRoute: (context) => RegisterView(),
        verifyEmailRoute: (context) => EmailVerifier(),
      },
    ),
  );
}

class InitializeSmarthome extends StatelessWidget {
  const InitializeSmarthome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              if (user.emailVerified) {
                return HomePage();
              } else {
                return EmailVerifier();
              }
            } else {
              return LoginView();
            }
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
