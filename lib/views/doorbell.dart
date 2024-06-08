import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smarthome/views/pop_up_messages.dart';

class Doorbell extends StatefulWidget {
  const Doorbell({super.key});

  @override
  State<Doorbell> createState() => _DoorbellState();
}

class _DoorbellState extends State<Doorbell> {
  String timeNow = DateFormat("dd-MM-yyyy HH:mm:ss").format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    final doorbellDB = FirebaseDatabase.instance.ref('Doorbell/');
    return Scaffold(
        appBar: AppBar(
          title: const Text('Doorbell'),
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
        body: Container(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          decoration: const BoxDecoration(
            color: Colors.blueGrey,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        try {
                          await doorbellDB.set({
                            'Answered': 0,
                            'Date': DateFormat("dd-MM-yyyy")
                                .format(DateTime.now())
                                .toString(),
                            'Time': DateFormat("HH:mm:ss")
                                .format(DateTime.now())
                                .toString(),
                          });
                        } catch (e) {
                          showErrorDialog(context, e.toString());
                        }
                      },
                      child: const Text('Press the doorbell'))
                ],
              ),
            ],
          ),
        ));
  }
}
