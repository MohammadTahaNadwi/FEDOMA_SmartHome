import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/utils/stream_subscriber_mixin.dart';
import 'package:smarthome/constants/routes.dart';
import 'package:flutter/material.dart';
import 'package:smarthome/views/navbar.dart';
import 'dart:developer' as devtools show log;

import 'package:smarthome/views/pop_up_screens.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final dbRef = FirebaseDatabase.instance.ref();
  late StreamSubscription _roomListener;
  List rooms = [];
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    runListener();
  }

  void runListener() {
    _roomListener = dbRef.child('Rooms').onValue.listen((event) {
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
        backgroundColor: Color.fromRGBO(10, 29, 77, 1),
        foregroundColor: Colors.white,
        title: const Text('My Home'),
        actions: [
          IconButton(
            onPressed: () async {
              await addRoom(context);
            },
            icon: const Icon(Icons.add),
            tooltip: "Add a room",
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
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed(roomPageRoute, arguments: rooms[index]);
                    },
                  ),
                );
              },
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  @override
  void deactivate() {
    _roomListener.cancel();
    super.deactivate();
  }
}
