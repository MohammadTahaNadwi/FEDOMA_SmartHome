import 'dart:async';
import 'package:smarthome/constants/routes.dart';
import 'package:smarthome/main.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:developer' as devtools show log;

class FirebaseAPI {
  // final _firebaseMessagingInstance = FirebaseMessaging.instance;

  //initialize firebase instance reference
  DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
  // Future<void> initiateNotifications() async {
  //   // request permission for notifications on modile device
  //   await _firebaseMessagingInstance.requestPermission();

  //   //get firebase cloud messaging(FCM) token
  //   final token = await _firebaseMessagingInstance.getToken();

  //   //print FCM token
  //   devtools.log("Token: $token");

  //   //update firebase database with latest FCM token
  //   databaseReference.child('fcm-token/$token').set({"token": token});
  //   // initPushNotifications();
  // }

  // void handleMessage(RemoteMessage? message) {
  //   if (message == null) return;

  //   navigatorKey.currentState?.pushNamed(intrusionsRoute);
  // }

  // void initPushNotifications() async {
  //   FirebaseMessaging.onMessage.listen(handleMessage);
  //   await FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
  //   FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  // }
}
