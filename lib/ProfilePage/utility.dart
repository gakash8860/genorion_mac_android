// ignore_for_file: constant_identifier_names

import 'dart:convert';
import 'dart:typed_data';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:genorion_mac_android/ProfilePage/photo.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../LocalDatabase/alldb.dart';
import '../main.dart';
import 'package:http/http.dart' as http;

const IMAGE_KEY = 'IMAGE_KEY';

class Utility {



  static Widget circularIndicator(){
    return Container(
      height: 54,
      width: 45,
      child: CircularProgressIndicator(
        color: Colors.red,
      ),
    );
  }



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
  static getImage() async {
    String? token = await getToken();

    final url = api + 'testimages123/?user=' +  getUidShared().toString();
    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Token $token',
    });
    if (response.statusCode == 200) {
      setImage = null;
      var ans = jsonDecode(response.body);
      await AllDatabase.instance.deletePhoto();

      PhotoModel  photo = PhotoModel.fromMap(ans);
       bool checkImage = true;

        setImage = Utility.imageFrom64BaseString(photo!.file);

        AllDatabase.instance.savePhoto(photo!);
        checkPutPostImage(checkImage);


      // refreshImages();
    } else {
      if (kDebugMode) {
        print("Image Get Response ${response.statusCode}");
      }
    }
  }

 static checkPutPostImage(value) async {
    final pref = await SharedPreferences.getInstance();
    pref.setBool("checkimage", value);
  }

  static Future<void> dataUpdate(dId,responseGetData) async {
    String? token = await getToken();
    var url = api + 'getpostdevicePinStatus/?d_id=' + dId;
    Map data = {
      'put': 'yes',
      "d_id": dId,
      'pin1Status': responseGetData[0],
      'pin2Status': responseGetData[1],
      'pin3Status': responseGetData[2],
      'pin4Status': responseGetData[3],
      'pin5Status': responseGetData[4],
      'pin6Status': responseGetData[5],
      'pin7Status': responseGetData[6],
      'pin8Status': responseGetData[7],
      'pin9Status': responseGetData[8],
      'pin10Status': responseGetData[9],
      'pin11Status': responseGetData[10],
      'pin12Status': responseGetData[11],
      'sensor1': responseGetData[12],
      'sensor2': responseGetData[13],
      'sensor3': responseGetData[14],
      'sensor4': responseGetData[15],
      'sensor5': responseGetData[16],
      'sensor6': responseGetData[17],
      'sensor7': responseGetData[18],
      'sensor8': responseGetData[19],
      'sensor9': responseGetData[20],
      'sensor10': responseGetData[21],
    };

    final response =
    await http.post(Uri.parse(url), body: jsonEncode(data), headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Token $token',
    });
    if (response.statusCode == 201 || response.statusCode == 200) {
      return;
    } else {
      print("DATA   AASSA   ${response.statusCode}");
    }
  }

  static Future<bool> getChangeColorStatus()async{
    bool  value = false;
    final prefs = await SharedPreferences.getInstance();
     value = prefs.getBool("changeDone")!;
    print("VALUE   -> $value");
    return value;
  }


  static thereIsNoData(context) {
    return AwesomeDialog(
      context: context,
      dialogType: DialogType.ERROR,
      animType: AnimType.BOTTOMSLIDE,
      title: 'Empty',
      desc: 'There is No Data....',
      btnCancelOnPress: () {
        Navigator.of(context).pop();
      },
      btnOkOnPress: () async {
        Navigator.of(context).pop();
      },
    )..show();
  }
  static Future<Object?> getColor1() async {
    final pref = await SharedPreferences.getInstance();
    var ans = pref.get("color");

    return ans;
  }
}
