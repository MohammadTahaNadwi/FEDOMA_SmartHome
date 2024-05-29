import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

class LivingRoom extends StatefulWidget {
  LivingRoom({super.key});

  @override
  State<LivingRoom> createState() => _LivingRoomState();
}

class _LivingRoomState extends State<LivingRoom> {
  bool vibrat = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Living Room'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                  height: 100,
                  child: Row(children: [
                    const Expanded(
                      child: Text(
                        'Vibrate',
                        style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: Switch(
                        value: vibrat,
                        onChanged: (bool value) {
                          if (value) {
                            Vibration.vibrate(duration: 5000);
                          } else {
                            Vibration.cancel();
                          }
                          setState(() {
                            vibrat = value;
                          });
                        },
                      ),
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
