// ignore_for_file: constant_identifier_names

import 'dart:convert';
import 'dart:typed_data';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

const IMAGE_KEY = 'IMAGE_KEY';

class Utility {



  static Future<bool> saveImage(String value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(IMAGE_KEY, value);
  }

  static Future<String?> getImagefrompreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? ans = preferences.getString(IMAGE_KEY);
    if (kDebugMode) {
      print("Image String $ans");
    }
    return ans;
  }

  static String base64String(Uint8List data) {
    return base64Encode(data);
  }

  // decode bytes from a string
  static imageFrom64BaseString(String base64String) {
    return Image.memory(
      base64Decode(base64String),
      fit: BoxFit.fill,
    );
  }
  static launchURL(String url) async {

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  static Future<String?> getToken() async {
    final storage = const FlutterSecureStorage();
    final token = await storage.read(key: "token");

    return token;
  }
 static Future<int> getUidShared() async {
     final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt("uid");
    int userId = id!;
    return userId;
  }

  static exitScreen(context,text,title) {
    // dialog implementation
    return AwesomeDialog(
      context: context,
      dialogType: DialogType.ERROR,
      animType: AnimType.BOTTOMSLIDE,
      title: title,
      desc: text,

      btnOkOnPress: () async {
        Navigator.pop(context);
      },
    )..show();
  }
}
