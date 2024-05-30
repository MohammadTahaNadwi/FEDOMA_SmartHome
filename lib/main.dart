import 'package:flutter/widgets.dart';
import 'package:smarthome/constants/routes.dart';
import 'package:flutter/material.dart';
import 'package:smarthome/rooms/bedRoom.dart';
import 'package:smarthome/rooms/livingRoom.dart';
import 'package:smarthome/rooms/outside.dart';
import 'package:smarthome/views/analytics.dart';
import 'package:smarthome/views/doorbell.dart';
import 'package:smarthome/views/helpPage.dart';
import 'package:smarthome/views/settings.dart';
import 'package:smarthome/views/navbar.dart';

void main() {
  runApp(
    MaterialApp(
      home: MainApp(),
      debugShowCheckedModeBanner: false,
      routes: {
        homeRoute: (context) => MainApp(),
        settingsRoute: (context) => const Settings(),
        livingRoomRoute: (context) => LivingRoom(),
        outsideRoute: (context) => Outside(),
        bedroomRoute: (context) => const Bedroom(),
        doorbellRoute: (context) => Doorbell(),
        helpPageRoute: (context) => const HelpPage(),
        analyticsRoute: (context) => Analytics(),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavBar(),
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('My Home'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(doorbellRoute);
            },
            icon: Icon(Icons.doorbell),
            tooltip: "Doorbell",
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(helpPageRoute);
            },
            icon: Icon(Icons.help),
            tooltip: "Help",
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.fromLTRB(10, 15, 10, 0),
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: InkWell(
                splashColor: Colors.black,
                onTap: () {
                  Navigator.of(context).pushNamed(outsideRoute);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Ink.image(
                      image: const AssetImage('assets/images/MainDoor.jpg'),
                      height: 200,
                      fit: BoxFit.fill,
                    ),
                    const Text(
                      'Outside',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.blueGrey),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(10, 15, 10, 0),
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(10)),
                  child: InkWell(
                    splashColor: Colors.black,
                    onTap: () {
                      Navigator.of(context).pushNamed(livingRoomRoute);
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Ink.image(
                          image: const NetworkImage(
                              'https://images.pexels.com/photos/3209045/pexels-photo-3209045.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'),
                          height: 200,
                          fit: BoxFit.fill,
                        ),
                        const Text(
                          'Living Room',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.blueGrey),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(10, 15, 10, 0),
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(10)),
                  child: InkWell(
                    splashColor: Colors.black,
                    onTap: () {
                      Navigator.of(context).pushNamed(bedroomRoute);
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Ink.image(
                          image: const NetworkImage(
                              'https://images.pexels.com/photos/90317/pexels-photo-90317.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'),
                          height: 200,
                          fit: BoxFit.fill,
                        ),
                        const Text(
                          'Bedroom',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.blueGrey),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
