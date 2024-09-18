import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smarthome/api/firebaseAPI.dart';

class Doorbell extends StatefulWidget {
  const Doorbell({super.key});

  @override
  State<Doorbell> createState() => _DoorbellState();
}

class _DoorbellState extends State<Doorbell> {
  String timeNow = DateFormat("dd-MM-yyyy HH:mm:ss").format(DateTime.now());
  late StreamSubscription _doorbellListening;
  Map<String, String> doorbellPress = {};
  @override
  void initState() {
    super.initState();
    doorbellListener();
  }

  void doorbellListener() {
    _doorbellListening = FirebaseAPI()
        .databaseReference
        .child("Doorbell")
        .onValue
        .listen((event) {
      setState(() {
        doorbellPress["Time"] =
            event.snapshot.children.last.child("Time").value.toString();
        doorbellPress["Date"] =
            event.snapshot.children.last.child("Date").value.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Doorbell'),
          backgroundColor: const Color.fromRGBO(10, 29, 77, 1),
          foregroundColor: Colors.white,
        ),
        body: Container(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Image.asset(
                  "assets/images/human-icon.webp",
                  width: 200,
                ),
              ),
              Text("Time:  ${doorbellPress["Time"].toString()}"),
              Text("Date: ${doorbellPress["Date"].toString()}"),
            ],
          ),
        ));
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    _doorbellListening.cancel();
  }
}
