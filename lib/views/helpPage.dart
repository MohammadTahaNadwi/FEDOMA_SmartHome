import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
    );
  }
}
