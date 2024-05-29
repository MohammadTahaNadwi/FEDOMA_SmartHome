import 'package:flutter/material.dart';

class LivingRoom extends StatefulWidget {
  LivingRoom({super.key});

  @override
  State<LivingRoom> createState() => _LivingRoomState();
}

class _LivingRoomState extends State<LivingRoom> {
  String lightStatus = 'Off';

  String lightToggle = 'On';

  String curtainStatus = 'Closed';

  String curtainToggle = 'Open';

  String windowStatus = 'Closed';

  String windowToggle = 'Open';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Living Room'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        decoration: const BoxDecoration(
          color: Colors.blueGrey,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Light is $lightStatus',
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (lightStatus == 'Off') {
                        lightStatus = 'On';
                        lightToggle = 'Off';
                      } else {
                        lightStatus = 'Off';
                        lightToggle = 'On';
                      }
                    });
                  },
                  child: Text('Turn $lightToggle'),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Curtain is $curtainStatus',
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (curtainStatus == 'Closed') {
                        curtainStatus = 'Open';
                        curtainToggle = 'Close';
                      } else {
                        curtainStatus = 'Closed';
                        curtainToggle = 'Open';
                      }
                    });
                  },
                  child: Text(curtainToggle),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Window is $windowStatus',
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (windowStatus == 'Closed') {
                        windowStatus = 'Open';
                        windowToggle = 'Close';
                      } else {
                        windowStatus = 'Closed';
                        windowToggle = 'Open';
                      }
                    });
                  },
                  child: Text(windowToggle),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
