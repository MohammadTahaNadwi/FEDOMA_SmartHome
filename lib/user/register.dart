import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smarthome/constants/routes.dart';
import 'package:smarthome/views/pop_up_screens.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  @override
  void initState() {
    // TODO: implement initState
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: const Color.fromRGBO(10, 29, 77, 1),
        foregroundColor: Colors.white,
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/icon/App_logo.webp",
              width: 100,
              fit: BoxFit.fill,
            ),
            SizedBox(
              height: 30,
            ),
            TextField(
              keyboardType: TextInputType.emailAddress,
              enableSuggestions: false,
              autocorrect: false,
              autofocus: true,
              decoration: const InputDecoration(hintText: 'Enter email here'),
              controller: _email,
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              decoration:
                  const InputDecoration(hintText: 'Enter password here'),
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              controller: _password,
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                      const Color.fromRGBO(10, 29, 77, 1))),
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;
                try {
                  final userCredential = await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                    email: email,
                    password: password,
                  );
                  final user = userCredential.user;
                  await user?.sendEmailVerification();
                  Navigator.of(context).pushNamed(verifyEmailRoute);
                } on FirebaseAuthException catch (e) {
                  if (e.code == "weak-password") {
                    await showErrorDialog(context, 'Error : Weak password');
                  } else if (e.code == "email-already-in-use") {
                    await showErrorDialog(
                        context, 'Error : Email already in use');
                  } else {
                    await showErrorDialog(context, 'Error : ${e.code}');
                  }
                } catch (e) {
                  await showErrorDialog(context, 'Error : ${e.toString()}');
                }
              },
              child: const Text(
                'Register',
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(loginRoute, (route) => false);
                },
                child: const Text(
                  'Already registered? Login here',
                  style: TextStyle(color: const Color.fromRGBO(10, 29, 77, 1)),
                ))
          ],
        ),
      ),
    );
  }
}
