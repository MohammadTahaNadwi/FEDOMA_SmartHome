import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smarthome/constants/routes.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const UserAccountsDrawerHeader(
            accountName: Text(
              'FEDOMA ',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
            ),
            accountEmail: Text('mtnmtn9th@gmail.com'),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(homeRoute, (route) => false);
            },
          ),
          ListTile(
            leading: const Icon(Icons.doorbell_rounded),
            title: const Text('Doorbell'),
            onTap: () {
              Navigator.of(context).pushNamed(doorbellRoute);
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              Navigator.of(context).pushNamed(settingsRoute);
            },
          ),
          ListTile(
            leading: const Icon(Icons.analytics),
            title: const Text('Analytics'),
            onTap: () {
              Navigator.of(context).pushNamed(analyticsRoute);
            },
          ),
          ListTile(
            leading: Icon(Icons.help),
            title: Text('Help'),
            onTap: () {
              Navigator.of(context).pushNamed(helpPageRoute);
            },
          )
        ],
      ),
    );
  }
}
