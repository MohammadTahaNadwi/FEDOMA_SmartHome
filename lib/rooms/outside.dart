import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Outside extends StatefulWidget {
  Outside({super.key});

  @override
  State<Outside> createState() => _OutsideState();
}

class _OutsideState extends State<Outside> {
  String doorStatus = 'Closed';

  String doorToggle = 'Open';

  String lightStatus = 'Off';

  String lightToggle = 'On';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Outside'),
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
                  'Exit Door is $doorStatus',
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (doorStatus == 'Closed') {
                        doorStatus = 'Open';
                        doorToggle = 'Close';
                      } else {
                        doorStatus = 'Closed';
                        doorToggle = 'Open';
                      }
                    });
                  },
                  child: Text(doorToggle),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Outside ligths are $lightStatus',
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
          ],
        ),
      ),
    );
  }
}
