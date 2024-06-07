import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:smarthome/constants/routes.dart';
import 'package:flutter/material.dart';
import 'package:smarthome/firebase_options.dart';
import 'package:smarthome/rooms/bedRoom.dart';
import 'package:smarthome/rooms/livingRoom.dart';
import 'package:smarthome/rooms/outside.dart';
import 'package:smarthome/user/emailVerifier.dart';
import 'package:smarthome/user/login.dart';
import 'package:smarthome/user/register.dart';
import 'package:smarthome/views/analytics.dart';
import 'package:smarthome/views/doorbell.dart';
import 'package:smarthome/views/helpPage.dart';
import 'package:smarthome/views/homePage.dart';
import 'package:smarthome/views/settings.dart';

void main() {
  runApp(
    MaterialApp(
      home: InitializeSmarthome(),
      debugShowCheckedModeBanner: false,
      routes: {
        homeRoute: (context) => HomePage(),
        settingsRoute: (context) => const Settings(),
        livingRoomRoute: (context) => LivingRoom(),
        outsideRoute: (context) => Outside(),
        bedroomRoute: (context) => const Bedroom(),
        doorbellRoute: (context) => Doorbell(),
        helpPageRoute: (context) => const HelpPage(),
        analyticsRoute: (context) => Analytics(),
        loginRoute: (context) => LoginView(),
        registerRoute: (context) => RegisterView(),
        verifyEmailRoute: (context) => EmailVerifier()
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
