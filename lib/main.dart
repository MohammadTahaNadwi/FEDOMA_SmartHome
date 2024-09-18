import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:smarthome/constants/routes.dart';
import 'package:flutter/material.dart';
import 'package:smarthome/firebase_options.dart';
import 'package:smarthome/user/emailVerifier.dart';
import 'package:smarthome/user/login.dart';
import 'package:smarthome/user/register.dart';
import 'package:smarthome/views/intrusions.dart';
import 'package:smarthome/views/reportView.dart';
import 'package:smarthome/views/reports.dart';
import 'package:smarthome/views/doorbell.dart';
import 'package:smarthome/views/helpPage.dart';
import 'package:smarthome/views/homePage.dart';
import 'package:smarthome/views/splashView.dart';
import 'package:smarthome/views/universal_room.dart';

void main() async {
  runApp(
    MaterialApp(
      home: const SplashView(),
      debugShowCheckedModeBanner: false,
      routes: {
        homeRoute: (context) => const HomePage(),
        roomPageRoute: (context) => UniversalRoom(
              roomName: ModalRoute.of(context)!.settings.arguments
                  as String, // Access arguments
            ),
        doorbellRoute: (context) => const Doorbell(),
        helpPageRoute: (context) => const HelpPage(),
        reportsRoute: (context) => const Reports(),
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        verifyEmailRoute: (context) => const EmailVerifier(),
        intrusionsRoute: (context) => const Intrusions(),
        reportViewRoute: (context) => reportView(
              reportName: ModalRoute.of(context)!.settings.arguments as String,
            )
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
                return const HomePage();
              } else {
                return const EmailVerifier();
              }
            } else {
              return const LoginView();
            }
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
