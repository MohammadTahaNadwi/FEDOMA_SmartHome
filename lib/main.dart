import 'package:smarthome/constants/routes.dart';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import 'package:smarthome/navbar.dart';

void main() {
  runApp(
    MaterialApp(
      home: MainApp(),
      debugShowCheckedModeBanner: false,
      routes: {
        homeRoute: (context) => MainApp(),
      },
    ),
  );
}

class MainApp extends StatefulWidget {
  MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  bool vibrat = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavBar(),
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('FEDOMA Smart Home'),
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
          const Row(
            children: [
              Expanded(
                child: Text(
                  'Main Door',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, height: 5),
                ),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Image.network(
                    'https://s3media.angieslist.com/s3fs-public/blue-front-door-concrete-floor.jpeg?impolicy=leadImage'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
