import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:smarthome/views/navbar.dart';
import 'package:vibration/vibration.dart';
import 'package:audioplayers/audioplayers.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool vibrate = true;
  bool soundMode = true;

  final player = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  color: Colors.purple,
                  padding: const EdgeInsets.all(5),
                  child: const Text(
                    'Notifications',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text(
                'Sound',
                style: TextStyle(fontSize: 16),
              ),
              Switch(
                value: soundMode,
                onChanged: (bool val) async {
                  if (val) {
                    await player.play(AssetSource('Sounds/Notification.mp3'));
                  } else {}
                  setState(
                    () {
                      soundMode = val;
                    },
                  );
                },
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text(
                'Vibration',
                style: TextStyle(fontSize: 16),
              ),
              Switch(
                value: vibrate,
                onChanged: (bool value) {
                  if (value) {
                    Vibration.vibrate(duration: 300);
                  } else {
                    Vibration.cancel();
                  }
                  setState(
                    () {
                      vibrate = value;
                    },
                  );
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}
