// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'StartingScreen/frontscreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.removeAfter(initialization);

  runApp(const MyApp());
}

const api = 'https://genorion1.herokuapp.com/';

 var changeColor;
 Image? setImage;
 
 


class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: changeColor??Colors.blue,
      ),
      home: const GettingStartedScreen(),
    );
  }
}
