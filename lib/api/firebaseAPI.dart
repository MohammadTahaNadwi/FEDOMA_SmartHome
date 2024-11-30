import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:developer' as devtools show log;

class FirebaseAPI {
  final _firebaseMessagingInstance = FirebaseMessaging.instance;

  //initialize firebase instance reference
  DatabaseReference databaseReference = FirebaseDatabase.instance.ref();

  Future<void> initPushNotifications() async {
    await _firebaseMessagingInstance.requestPermission();
    final fcmToken = await _firebaseMessagingInstance.getToken();
    databaseReference.child("fcm-token/$fcmToken").set({"token": fcmToken});
    devtools.log("Token : $fcmToken");
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }
}

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  devtools.log("Title: ${message.notification?.title}");
  devtools.log("Body: ${message.notification?.body}");
  devtools.log("Payload: ${message.data}");
}
