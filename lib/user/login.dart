import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smarthome/constants/routes.dart';
import 'package:smarthome/views/pop_up_messages.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          TextField(
            keyboardType: TextInputType.emailAddress,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(hintText: 'Enter email here'),
            controller: _email,
          ),
          TextField(
            decoration: const InputDecoration(hintText: 'Enter password here'),
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            controller: _password,
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: email,
                  password: password,
                );
                final user = FirebaseAuth.instance.currentUser;
                if (user?.emailVerified ?? false) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    homeRoute,
                    (route) => false,
                  );
                } else {
                  user?.sendEmailVerification();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    verifyEmailRoute,
                    (route) => false,
                  );
                }
              } on FirebaseAuthException catch (e) {
                if (e.code == 'invalid-email') {
                  await showErrorDialog(context, "Invalid Email Address");
                } else if (e.code == 'invalid-credential') {
                  await showErrorDialog(context, "Incorrect login credentials");
                } else {
                  await showErrorDialog(context, "Error : ${e.code}");
                }
              } catch (e) {
                await showErrorDialog(context, 'Error : ${e.toString()}');
              }
            },
            child: const Text('Login'),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(registerRoute, (route) => false);
              },
              child: Text("Not registered yet? Register here!"))
        ],
      ),
    );
  }
}
String getUserEmail() {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    return user.email!;
  } else {
    return "No user found";
  }
}
