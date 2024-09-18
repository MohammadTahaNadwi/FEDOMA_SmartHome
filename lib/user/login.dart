import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smarthome/constants/routes.dart';
import 'package:smarthome/views/pop_up_screens.dart';

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
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromRGBO(10, 29, 77, 1),
      ),
      body: Container(
        margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/icon/App_logo.webp",
              width: 100,
              fit: BoxFit.fill,
            ),
            const SizedBox(
              height: 30,
            ),
            TextField(
              keyboardType: TextInputType.emailAddress,
              enableSuggestions: false,
              autocorrect: false,
              autofocus: true,
              decoration: const InputDecoration(
                  hintText: 'Enter email here', focusColor: Colors.white),
              controller: _email,
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              decoration: const InputDecoration(
                hintText: 'Enter password here',
              ),
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              controller: _password,
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll<Color>(
                      Color.fromRGBO(10, 29, 77, 1))),
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
                    await showErrorDialog(
                        context, "Incorrect login credentials");
                  } else {
                    await showErrorDialog(context, "Error : ${e.code}");
                  }
                } catch (e) {
                  await showErrorDialog(context, 'Error : ${e.toString()}');
                }
              },
              child: const Text(
                'Login',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(registerRoute, (route) => false);
              },
              child: const Text("Not registered yet? Register here!",
                  style: TextStyle(color: Color.fromRGBO(10, 29, 77, 1))),
            )
          ],
        ),
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
