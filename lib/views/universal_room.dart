import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:smarthome/constants/routes.dart';
import 'package:smarthome/views/pop_up_screens.dart';

import 'dart:developer' as devtools show log;

class UniversalRoom extends StatefulWidget {
  final String roomName;

  const UniversalRoom({super.key, required this.roomName});

  @override
  State<UniversalRoom> createState() => _UniversalRoomState();
}

class _UniversalRoomState extends State<UniversalRoom> {
  late final roomPath = "Rooms/${widget.roomName}";
  late final roomDetailsRef = FirebaseDatabase.instance.ref();
  List roomDetails = [];
  List roomActionValues = [];
  bool isLoaded = false;
  late StreamSubscription roomDetailsListener;

  @override
  void initState() {
    try {
      super.initState();
      runRoomListener();
    } catch (e) {
      showErrorDialog(context, e.toString());
    }
  }

  void runRoomListener() {
    try {
      roomDetailsListener =
          roomDetailsRef.child(roomPath).onValue.listen((event) {
        List temp = [];
        List tempRoomActionValues = [];
        for (var element in event.snapshot.children) {
          temp.add(element.key.toString());
          tempRoomActionValues.add(element.value.toString());
        }

        setState(() {
          roomDetails = temp;
          roomActionValues = tempRoomActionValues;
          isLoaded = true;
        });
      });
    } catch (e) {
      showErrorDialog(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(10, 29, 77, 1),
        foregroundColor: Colors.white,
        title: Text(widget.roomName),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.help)),
        ],
      ),
      body: isLoaded
          ? ListView.builder(
              itemCount: roomDetails.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Container(
                      color: Color.fromRGBO(10, 29, 77, 1),
                      child: Column(children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              roomDetails[index],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 20, color: Colors.white),
                            ),
                            Text(
                              "Status: " + roomActionValues[index],
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "Tap to Close",
                              style: TextStyle(color: Colors.grey),
                            )
                          ],
                        )
                      ]),
                    ),
                    onTap: () {},
                  ),
                );
              },
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  @override
  void deactivate() {
    super.deactivate();
    roomDetailsListener.cancel();
  }
}
