// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:genorion_mac_android/DrawerPages/setting.dart';
import 'package:genorion_mac_android/ProfilePage/utility.dart';
import 'package:genorion_mac_android/StartingScreen/frontscreen.dart';



const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    // 'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('A bg message just showed up :  ${message.messageId}');
}

Future<void> main() async {

 if(Platform.isAndroid){
   WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp();

   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

   await flutterLocalNotificationsPlugin
       .resolvePlatformSpecificImplementation<
       AndroidFlutterLocalNotificationsPlugin>()
       ?.createNotificationChannel(channel);

   await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
     alert: true,
     badge: true,
     sound: true,
   );
   runApp(MyApp());
 }else {
   runApp(MyApp());
 }
 }

const api = 'http://146.190.32.184:8000/';
bool changeDone = false;
 MaterialColor? changeColor;
 Image? setImage;
Color dropDownColor = Colors.white;
 


class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher',
              ),
            ));
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text(notification.title.toString()),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(notification.body.toString())],
                  ),
                ),
              );
            });
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: changeDone?changeColor:Colors.blue,
      ),
      home: const GettingStartedScreen(),
    );
  }
}
