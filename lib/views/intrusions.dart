import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smarthome/api/firebaseAPI.dart';

class Intrusions extends StatefulWidget {
  const Intrusions({super.key});

  @override
  State<Intrusions> createState() => _IntrusionsState();
}

class _IntrusionsState extends State<Intrusions> {
  late StreamSubscription _listeningIntrusions;
  Map<String, String> intrusionDetect = {};
  @override
  void initState() {
    super.initState();
    intrusionListener();
  }

  void intrusionListener() {
    _listeningIntrusions = FirebaseAPI()
        .databaseReference
        .child("Intrusions")
        .onValue
        .listen((event) {
      setState(() {
        intrusionDetect["Room"] =
            event.snapshot.children.last.child("Room").value.toString();
        intrusionDetect["Time"] =
            event.snapshot.children.last.child("Time").value.toString();
        intrusionDetect["Date"] =
            event.snapshot.children.last.child("Date").value.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(10, 29, 77, 1),
        foregroundColor: Colors.white,
        title: const Text("Intrusions"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Room: ${intrusionDetect["Room"]}"),
            Text("Time: ${intrusionDetect["Time"]}"),
            Text("Date: ${intrusionDetect["Date"]}")
          ],
        ),
      ),
    );
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    _listeningIntrusions.cancel();
  }
}
