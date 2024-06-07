import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smarthome/constants/routes.dart';
import 'package:smarthome/user/login.dart';
import 'package:smarthome/views/pop_up_messages.dart';
import 'dart:developer' as devtools show log;

class NavBar extends StatefulWidget {
  const NavBar({super.key});
  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  String userEmail = getUserEmail();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text(
              'FEDOMA ',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
            ),
            accountEmail: Text(userEmail),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              User? user = FirebaseAuth.instance.currentUser;
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(homeRoute, (route) => false);
              devtools.log(user.toString());
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
            onTap: () async {
              await analyticsViewAuthentication(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.help),
            title: Text('Help'),
            onTap: () {
              Navigator.of(context).pushNamed(helpPageRoute);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(loginRoute, (route) => false);
            },
          )
        ],
      ),
    );
  }
}
