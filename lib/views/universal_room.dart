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
  List possibleActions = ["Door", "Windows", "Curtains", "Lights"];
  List allowedActions = [];
  List roomDetails = [];
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
        for (var element in event.snapshot.children) {
          temp.add(element.key.toString());
        }
        for (int count = 0; count < 4; count++) {
          if (!temp.contains(possibleActions[count])) {
            allowedActions.add(possibleActions[count]);
          }
        }
        devtools.log(allowedActions.toString());
        setState(() {
          roomDetails = temp;
          isLoaded = true;
        });
      });
    } catch (e) {
      showErrorDialog(context, e.toString());
    }
  }

  Future addRoomAction(BuildContext context, String room) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: const Text("Add action item"),
              content: SizedBox(
                height: 300,
                child: ListView.builder(
                    itemCount: allowedActions.length,
                    itemBuilder: ((context, index) {
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: ListTile(
                          title: Text(allowedActions[index]),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      );
                    })),
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(10, 29, 77, 1),
        foregroundColor: Colors.white,
        title: Text(widget.roomName),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              addRoomAction(context, widget.roomName);
            },
          ),
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
                    shape: const RoundedRectangleBorder(
                        side: BorderSide(width: 1),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    title: Text(
                      roomDetails[index],
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 20),
                    ),
                    onTap: () {},
                  ),
                );
              },
            )
          : const Text('No actions found'),
    );
  }

  @override
  void deactivate() {
    super.deactivate();
    roomDetailsListener.cancel();
  }
}
