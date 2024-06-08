import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:smarthome/constants/routes.dart';
import 'package:flutter/material.dart';
import 'package:smarthome/views/navbar.dart';
import 'dart:developer' as devtools show log;

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

final dbRef = FirebaseDatabase.instance.ref();

List rooms = [];
bool isLoaded = false;

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    runListener();
  }

  void runListener() {
    dbRef.child('Rooms/').onValue.listen((event) {
      List temp = [];
      for (var element in event.snapshot.children.indexed) {
        temp.add(element.$2.key.toString());
      }
      setState(() {
        rooms = temp;
        isLoaded = true;
      });
    });
  }

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
            icon: const Icon(Icons.doorbell),
            tooltip: "Doorbell",
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(helpPageRoute);
            },
            icon: const Icon(Icons.help),
            tooltip: "Help",
          )
        ],
      ),
      body: isLoaded
          ? ListView.builder(
              itemCount: rooms.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: ListTile(
                    shape: const RoundedRectangleBorder(
                        side: BorderSide(width: 1),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    title: Text(
                      rooms[index],
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                    ),
                    onTap: () {},
                  ),
                );
              },
            )
          : const Text('No rooms found'),
    );
  }
}
