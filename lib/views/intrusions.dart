import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smarthome/views/navbar.dart';

class Intrusions extends StatefulWidget {
  const Intrusions({super.key});

  @override
  State<Intrusions> createState() => _IntrusionsState();
}

class _IntrusionsState extends State<Intrusions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(10, 29, 77, 1),
        foregroundColor: Colors.white,
        title: const Text("Intrusions"),
      ),
    );
  }
}
