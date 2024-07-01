import 'dart:ffi';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smarthome/constants/routes.dart';

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
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (pwd.text == 'admin') {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(analyticsRoute, (route) => false);
              }
            },
            child: const Text('Submit'),
          )
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

Future<void> addRoom(BuildContext context) {
  late TextEditingController roomName = TextEditingController();

  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add a Room"),
          content: TextField(
            autofocus: true,
            decoration:
                const InputDecoration(hintText: "Enter room name here..."),
            controller: roomName,
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel')),
            TextButton(
              onPressed: () async {
                final dbReference = FirebaseDatabase.instance.ref('Rooms/');
                await dbReference.update({roomName.text: ""});
                Navigator.of(context).pop();
              },
              child: const Text('Add Room'),
            )
          ],
        );
      });
}
