import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help - User Manual'),
        backgroundColor: const Color.fromRGBO(10, 29, 77, 1),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            'Smart Home App User Manual',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          buildManualSection(
            title: '1. My Home Page',
            steps: [
              'This is the main page where you can access individual rooms.',
              'Each room contains buttons to control appliances: doors, windows, curtains, and lights.',
              'Buttons are color-coded: \n- Green indicates "on/open." \n- Red indicates "off/closed."',
              'Tap a button to toggle the state of the appliance.',
            ],
          ),
          buildManualSection(
            title: '2. Doorbell Page',
            steps: [
              'Displays the image of the visitor at your door.',
              'Shows the time and date of the visitor\'s arrival.',
            ],
          ),
          buildManualSection(
            title: '3. Intrusions Page',
            steps: [
              'Displays details of any detected intrusions.',
              'Shows the room where the intrusion occurred.',
              'Includes the date and time of the intrusion.',
            ],
          ),
          buildManualSection(
            title: '4. Settings Page',
            steps: [
              'Navigate to the "Settings Page" to manage control modes for each element in all rooms.',
              'Each room will have toggle options for elements like lights, doors, and curtains.',
              'Switch between "Mobile Control" and "Sensor Control" for any selected element.',
              'The changes will be updated in real-time and saved to the database for effective control management.',
              'Tap a button once to make alter any control',
            ],
          ),
          buildManualSection(
            title: '5. Reports Page',
            steps: [
              'Access reports for Doorbell and Intrusion records.',
              'Tap the "Doorbell Report" or "Intrusion Report" button to view a graph of monthly records for the entire year.',
              'At the top of the page, use the "Select Month" button to choose a specific month.',
              'Download a detailed PDF report for the selected month.',
            ],
          ),
        ],
      ),
    );
  }

  Widget buildManualSection(
      {required String title, required List<String> steps}) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...steps.map(
              (step) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '• ',
                      style: TextStyle(fontSize: 16),
                    ),
                    Expanded(
                      child: Text(
                        step,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
