import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smarthome/constants/routes.dart';
import 'package:smarthome/views/pop_up_messages.dart';

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
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          TextField(
            keyboardType: TextInputType.emailAddress,
            enableSuggestions: false,
            autocorrect: false,
            decoration:
                const InputDecoration(hintText: 'Enter your email here!'),
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
                final userCredential =
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
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
            child: const Text('Register'),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(loginRoute, (route) => false);
              },
              child: const Text('Already registered? Login here'))
        ],
      ),
    );
  }
}
