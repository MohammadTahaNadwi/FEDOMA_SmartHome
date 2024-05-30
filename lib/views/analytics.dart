import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Analytics extends StatelessWidget {
  const Analytics({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: const Stack(
        children: [
          Text('Reports'),
        ],
      ),
    );
  }
}
