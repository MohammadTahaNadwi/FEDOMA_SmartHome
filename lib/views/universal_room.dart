import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smarthome/constants/routes.dart';
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
  List roomControlValues = [];
  bool isLoaded = false;
  late StreamSubscription roomDetailsListener;

  @override
  void initState() {
    super.initState();
    try {
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
        List tempRoomControlValues = [];

        for (var element in event.snapshot.children) {
          temp.add(element.key.toString());
          tempRoomActionValues.add(element.child("Status").value.toString());
          tempRoomControlValues.add(element.child("Control").value.toString());
        }

        setState(() {
          roomDetails = temp;
          roomActionValues = tempRoomActionValues;
          roomControlValues = tempRoomControlValues;
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
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(settingsRoute);
              },
              icon: Icon(Icons.settings)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.help)),
        ],
      ),
      body: isLoaded
          ? ListView.builder(
              itemCount: roomDetails.length,
              itemBuilder: (context, index) {
                final isSensorMode = roomControlValues[index] == "Sensor";
                final isLight = roomDetails[index].toLowerCase() == "lights";

                // Adjust status text for lights
                final statusText = isLight
                    ? (roomActionValues[index] == "On" ? "On" : "Off")
                    : roomActionValues[index];

                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: _getBackgroundColor(
                          index,
                          isSensorMode,
                          isLight,
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                roomDetails[index],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 24, color: Colors.white),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "Status: $statusText",
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                isSensorMode
                                    ? "Sensor mode enabled"
                                    : roomActionValues[index] == "On"
                                        ? (isLight
                                            ? "Tap to Turn Off"
                                            : "Tap to Close")
                                        : (isLight
                                            ? "Tap to Turn On"
                                            : "Tap to Open"),
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 15),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Disable onTap if Control is "Sensor"
                    onTap: isSensorMode
                        ? null
                        : () {
                            _toggleAction(index, isLight);
                          },
                  ),
                );
              },
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Color _getBackgroundColor(int index, bool isSensorMode, bool isLight) {
    if (isSensorMode) {
      return Colors.grey.shade400; // Grey for Sensor mode
    }
    if (isLight) {
      return roomActionValues[index] == "On" ? Colors.green : Colors.red;
    } else {
      return roomActionValues[index] == "Open" ? Colors.green : Colors.red;
    }
  }

  void _toggleAction(int index, bool isLight) {
    final currentAction =
        FirebaseDatabase.instance.ref("$roomPath/${roomDetails[index]}");

    if (isLight) {
      // For lights, update to On/Off status
      if (roomActionValues[index] == "On") {
        currentAction.child("Status").set("Off"); // Turn light off
      } else {
        currentAction.child("Status").set("On"); // Turn light on
      }
    } else {
      // For other appliances, update Open/Closed status
      if (roomActionValues[index] == "Open") {
        currentAction.child("Status").set("Closed");
      } else {
        currentAction.child("Status").set("Open");
      }
    }
  }

  @override
  void deactivate() {
    super.deactivate();
    roomDetailsListener.cancel();
  }
}
