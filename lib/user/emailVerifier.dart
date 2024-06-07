import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smarthome/constants/routes.dart';

class EmailVerifier extends StatefulWidget {
  const EmailVerifier({super.key});

  @override
  State<EmailVerifier> createState() => _EmailVerifierState();
}

class _EmailVerifierState extends State<EmailVerifier> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
      ),
      body: Column(
        children: [
          const Text(
              "We've sent you an email verification. Please open it to verify your account."),
          const Text(
              "If you have't received a verification email yet, press the button below  "),
          TextButton(
              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;
                await user
                    ?.sendEmailVerification(ActionCodeSettings(url: homeRoute));
              },
              child: const Text('Send email verification')),
          TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(loginRoute, (route) => false);
              },
              child: const Text("Not logged in? Click here to login"))
        ],
      ),
    );
  }
}
