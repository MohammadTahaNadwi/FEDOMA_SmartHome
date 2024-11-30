import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:smarthome/constants/routes.dart';
import 'package:smarthome/views/pop_up_screens.dart';
import 'package:smarthome/views/reportView.dart';

class Reports extends StatelessWidget {
  const Reports({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select a Report'),
        backgroundColor: const Color.fromRGBO(10, 29, 77, 1),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          ListTile(
            title: const Text(
              "Intrusion Detections",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
            leading: const Icon(Icons.broken_image),
            trailing: const Icon(Icons.arrow_forward_ios_rounded),
            subtitle: const Text(
              "View statistical report for intrusions",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            onTap: () async {
              Navigator.of(context)
                  .pushNamed(reportViewRoute, arguments: "Intrusions");
            },
          ),
          ListTile(
            leading: const Icon(Icons.doorbell),
            title: const Text(
              "Doorbell Interactions",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
            trailing: const Icon(Icons.arrow_forward_ios_rounded),
            subtitle: const Text(
              "View statistical report for doorbell interactions",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            onTap: () async {
              Navigator.of(context)
                  .pushNamed(reportViewRoute, arguments: "Doorbell");
            },
          ),
        ],
      ),
    );
  }
}
