import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:smarthome/constants/routes.dart';
import 'package:flutter/material.dart';

import 'package:smarthome/views/navbar.dart';

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
        backgroundColor: const Color.fromRGBO(10, 29, 77, 1),
        foregroundColor: Colors.white,
        title: const Text('My Home'),
        actions: [
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
                String img = "";
                if (rooms[index] == "Living Room") {
                  img = "Living Room";
                } else {
                  img = rooms[index];
                }

                return ListTile(
                  title: Container(
                    height: MediaQuery.of(context).size.height / 4,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            "assets/images/$img.jpg",
                          ),
                          fit: BoxFit.fitWidth,
                        ),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[200]),
                    child: Center(
                      child: Container(
                        color: Colors.grey.withOpacity(0.8),
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          rooms[index],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                              letterSpacing: 10,
                              fontFamily: "courier",
                              fontWeight: FontWeight.w900),
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed(roomPageRoute, arguments: rooms[index]);
                  },
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
