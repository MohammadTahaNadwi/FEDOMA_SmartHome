import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smarthome/views/pop_up_screens.dart';

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
          IconButton(onPressed: () {}, icon: const Icon(Icons.help)),
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
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: roomActionValues[index] == "Open"
                            ? Colors.green
                            : Colors.red,
                      ),
                      child: Column(children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                roomDetails[index],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 24, color: Colors.white),
                              ),
                            ]),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "Status: " + roomActionValues[index],
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.white),
                            ),
                          ],
                        ),
                        roomActionValues[index] == "Open"
                            ? const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "Tap to Close",
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 15),
                                  )
                                ],
                              )
                            : const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "Tap to Open",
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 15),
                                  )
                                ],
                              )
                      ]),
                    ),
                    onTap: () {
                      late final currentAction = FirebaseDatabase.instance
                          .ref("$roomPath/" + roomDetails[index]);
                      if (roomActionValues[index] == "Open") {
                        currentAction.set("Closed");
                      } else {
                        currentAction.set("Open");
                      }
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
    super.deactivate();
    roomDetailsListener.cancel();
  }
}
