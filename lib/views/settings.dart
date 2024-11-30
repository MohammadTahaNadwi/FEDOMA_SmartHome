import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final database = FirebaseDatabase.instance.ref();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(10, 29, 77, 1),
        foregroundColor: Colors.white,
        title: const Text("Settings"),
      ),
      body: FutureBuilder(
        future: database.child("/Rooms").get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("No data available"));
          } else {
            final roomsData = snapshot.data!.value as Map;

            return ListView(
              children: roomsData.entries.map<Widget>((entry) {
                final roomName = entry.key;
                final roomDetails = entry.value as Map;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Room Header
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 25,
                      decoration: const BoxDecoration(color: Colors.red),
                      child: Text(
                        roomName,
                        textAlign: TextAlign.center,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                    // Room Features (Lights, Windows, etc.)
                    ...roomDetails.entries.map<Widget>((featureEntry) {
                      final featureName = featureEntry.key;
                      final featureControl = featureEntry.value as Map;

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(featureName),
                          ElevatedButton(
                            onPressed: () {
                              _toggleControl(
                                roomName,
                                featureName,
                                featureControl["Control"] ?? "Mobile",
                              );
                            },
                            child: Text(featureControl["Control"] ?? "Mobile"),
                          ),
                        ],
                      );
                    }),
                  ],
                );
              }).toList(),
            );
          }
        },
      ),
    );
  }

  // Function to toggle the control
  void _toggleControl(
      String roomName, String featureName, String currentControl) async {
    // Determine the new control value
    final newControl = currentControl == "Sensor" ? "Mobile" : "Sensor";

    // Update the value in Firebase
    try {
      await database
          .child("/Rooms/$roomName/$featureName/Control")
          .set(newControl);

      // Update the UI
      setState(() {
        // Force UI rebuild to reflect the updated value
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$featureName updated to $newControl")),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating $featureName: $error")),
      );
    }
  }
}
