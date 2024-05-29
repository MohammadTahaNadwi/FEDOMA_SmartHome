import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MainDoor extends StatefulWidget {
  MainDoor({super.key});

  @override
  State<MainDoor> createState() => _MainDoorState();
}

class _MainDoorState extends State<MainDoor> {
  String doorStatus = "Closed";
  String doorToggle = 'Open';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Door'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              'Door is $doorStatus',
              style: TextStyle(fontSize: 20),
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
      ),
    );
  }
}
