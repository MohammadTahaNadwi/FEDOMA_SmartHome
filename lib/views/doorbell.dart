import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Doorbell extends StatefulWidget {
  const Doorbell({super.key});

  @override
  State<Doorbell> createState() => _DoorbellState();
}

class _DoorbellState extends State<Doorbell> {
  String timeNow = DateFormat("dd-MM-yyyy HH:mm:ss").format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Doorbell'),
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
        body: Container(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          decoration: const BoxDecoration(
            color: Colors.blueGrey,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    timeNow,
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
