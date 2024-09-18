import 'package:flutter/material.dart';
import 'package:smarthome/constants/routes.dart';
import 'package:smarthome/views/reportView.dart';

Future<void> analyticsViewAuthentication(BuildContext context) async {
  return await showDialog(
    context: context,
    builder: (context) {
      final TextEditingController pwd = TextEditingController();
      return AlertDialog(
        title: const Text('Access Restricted'),
        content: const Text(
            'Please enter password to access analytical information about the your home'),
        actions: [
          TextField(
            controller: pwd,
            obscureText: true,
          ),
          TextButton(
            onPressed: () {
              if (pwd.text == 'admin') {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(reportsRoute);
              }
            },
            child: const Text('Submit'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
        ],
      );
    },
  );
}

Future<void> showErrorDialog(
  BuildContext context,
  String text,
) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('An error occured'),
        content: Text(text),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'))
        ],
      );
    },
  );
}
