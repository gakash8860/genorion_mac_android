// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables, unused_local_variable

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:genorion_mac_android/SubAccessModels/subaccessdevice.dart';
import 'package:genorion_mac_android/SubAccessModels/subaccessroom.dart';
import 'package:genorion_mac_android/main.dart';
import 'package:http/http.dart' as http;

class TempAccessRoom extends StatefulWidget {
  var ownerName;
  var rId;
  TempAccessRoom({Key? key, required this.ownerName, required this.rId})
      : super(key: key);

  @override
  _TempAccessRoomState createState() => _TempAccessRoomState();
}

class _TempAccessRoomState extends State<TempAccessRoom>
    with TickerProviderStateMixin {
  List<SubAccessRoom> subAccessRoom = [];
  List<SubAccessDevice> subAccessDevice = [];
  final storage = const FlutterSecureStorage();
  List devicePinStatus = [];
  List namesDataList = [];
  var roomData;
  TabController? tabC;
  Future? roomFuture;
  var nameFuture;
  ScrollController? _controller;
  var switchFuture;
  List changeIcon = List.filled(9, null);
  var icon1 = Icons.ac_unit;
  var icon2 = FontAwesomeIcons.iceCream;
  var icon3 = FontAwesomeIcons.lightbulb;
  var icon4 = FontAwesomeIcons.fan;
  var icon5 = Icons.wash_sharp;
  var icon6 = FontAwesomeIcons.fire;
  var icon7 = FontAwesomeIcons.lightbulb;
  var icon8 = FontAwesomeIcons.lightbulb;
  var icon9 = FontAwesomeIcons.lightbulb;
  var icon10 = FontAwesomeIcons.lightbulb;
  var icon11 = FontAwesomeIcons.lightbulb;
  var icon12 = FontAwesomeIcons.lightbulb;
  List<String> iconCode = [
    '001',
    '002',
    '003',
    '004',
    '005',
    '006',
    '007',
    '008',
    '009',
    '010',
    '011'
  ];
  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _controller!.addListener(_scrollListener);
    roomFuture = getRooms();


  }

  _scrollListener() {
    if (_controller!.offset >= _controller!.position.maxScrollExtent &&
        !_controller!.position.outOfRange) {
      if (kDebugMode) {
        print("reach the bottom");
      }
    }
    if (_controller!.offset <= _controller!.position.minScrollExtent &&
        !_controller!.position.outOfRange) {
      if (kDebugMode) {
        print("reach the bottom");
      }
    }
  }

  Future<String?> getToken() async {
    final tokenVar = await storage.read(key: "token");

    return tokenVar;
  }

  Future<bool> getRooms() async {
    String? token = await getToken();
    String url = api + 'getyouroomname/?r_id=' + widget.rId.toString();
    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Token $token',
    });
    if (response.statusCode == 200) {
      var ans = jsonDecode(response.body);
      if (kDebugMode) {
        print(ans);
      }
      setState(() {
        tabC = TabController(length: 1, vsync: this);
        roomData = ans;
      });
      if (kDebugMode) {
        print("roomData $roomData");
      }
      await     getDevice();
      return true;
    } else {
      if (kDebugMode) {
        print(response.body);
      }
      return false;
    }
  }

  Future getDevice() async {
    String? token = await getToken();
    var url = api + 'getalldevicesbyonlyroomidr_id/?r_id=' + widget.rId;
    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Token $token',
    });
    if (response.statusCode == 200) {
      List<dynamic> deviceData = jsonDecode(response.body);
      switchFuture = getPinStatusData(deviceData[0]['d_id']);
      nameFuture = getPinNames(deviceData[0]['d_id'],0);
      setState(() {
        subAccessDevice =
            deviceData.map((data) => SubAccessDevice.fromJson(data)).toList();
      });
    }
  }

  Future<bool> getPinStatusData(did) async {
    var token = await getToken();

    var url = api + "getpostdevicePinStatus/?d_id=" + did;
    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Token $token',
    });
    if (response.statusCode == 200) {
      var ans = jsonDecode(response.body);
      setState(() {
        devicePinStatus = [
          ans['pin1Status'],
          ans['pin2Status'],
          ans['pin3Status'],
          ans['pin4Status'],
          ans['pin5Status'],
          ans['pin6Status'],
          ans['pin7Status'],
          ans['pin8Status'],
          ans['pin9Status'],
          ans['pin10Status'],
          ans['pin11Status'],
          ans['pin12Status'],
        ];
      });

      if (kDebugMode) {
        print("devicePinStatus");
      }
      return true;
    } else {
      return false;
    }
  }

  Future<bool> getPinNames(did, index) async {
    String? token = await getToken();
    var url = api + "editpinnames/?d_id=" + did;
    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Token $token',
    });
    if (response.statusCode == 200) {
      var ans = jsonDecode(response.body);
      setState(() {
        namesDataList = [
          ans['pin1Name'],
          ans['pin2Name'],
          ans['pin3Name'],
          ans['pin4Name'],
          ans['pin5Name'],
          ans['pin6Name'],
          ans['pin7Name'],
          ans['pin8Name'],
          ans['pin9Name'],
          ans['pin10Name'],
          ans['pin11Name'],
          ans['pin12Name'],
        ];
      });
      print("WQWERR $namesDataList");
      String pin1 = ans['pin1Name'];

      var indexOfPin1Name = pin1.indexOf(',');
      var pin1FinalName = pin1.substring(0, indexOfPin1Name);

      String pin2 = ans['pin2Name'];
      var indexOfPin2Name = pin2.indexOf(',');
      var pin2FinalName = pin2.substring(0, indexOfPin2Name);

      String pin3 = ans['pin3Name'];
      var indexOfPin3Name = pin3.indexOf(',');
      var pin3FinalName = pin3.substring(0, indexOfPin3Name);

      String pin4 = ans['pin4Name'];
      var indexOfPin4Name = pin4.indexOf(',');
      var pin4FinalName = pin4.substring(0, indexOfPin4Name);

      String pin5 = ans['pin5Name'];
      var indexOfPin5Name = pin5.indexOf(',');
      var pin5FinalName = pin5.substring(0, indexOfPin5Name);

      String pin6 = ans['pin6Name'];
      var indexOfPin6Name = pin6.indexOf(',');
      var pin6FinalName = pin6.substring(0, indexOfPin6Name);

      String pin7 = ans['pin7Name'];
      var indexOfPin7Name = pin7.indexOf(',');
      var pin7FinalName = pin7.substring(0, indexOfPin7Name);

      String pin8 = ans['pin8Name'];
      var indexOfPin8Name = pin8.indexOf(',');
      var pin8FinalName = pin8.substring(0, indexOfPin8Name);

      String pin9 = ans['pin9Name'];
      var indexOfPin9Name = pin9.indexOf(',');
      var pin9FinalName = pin9.substring(0, indexOfPin9Name);

      String pin10 = ans['pin10Name'];
      var indexOfPin10Name = pin10.indexOf(',');
      var pin10FinalName = pin9.substring(0, indexOfPin10Name);

      String pin11 = ans['pin11Name'];
      var indexOfPin11Name = pin11.indexOf(',');
      var pin11FinalName = pin11.substring(0, indexOfPin11Name);

      String pin12 = ans['pin12Name'];
      var indexOfPin12Name = pin12.indexOf(',');
      var pin12FinalName = pin12.substring(0, indexOfPin12Name);

      setState(() {
        namesDataList = [
          pin1FinalName,
          pin2FinalName,
          pin3FinalName,
          pin4FinalName,
          pin5FinalName,
          pin6FinalName,
          pin7FinalName,
          pin8FinalName,
          pin9FinalName,
          pin10FinalName,
          pin11FinalName,
          pin12FinalName,
        ];
      });
      print("FINALNAMES $namesDataList");
      for (int i = 0; i < namesDataList.length; i++) {
        if (pin1.contains('001') ||
            pin1.contains('002') ||
            pin1.contains('003') ||
            pin1.contains('004') ||
            pin1.contains('005') ||
            pin1.contains('006') ||
            pin1.contains('007') ||
            pin1.contains('008') ||
            pin1.contains('009') ||
            pin1.contains('0010') ||
            pin1.contains('0011')) {
          // icon1=Icons.ac_unit;
          if (pin1.contains('001')) {
            setState(() {
              changeIcon[index] = icon1;
            });
          }
          if (pin1.contains('002')) {
            changeIcon[index] = icon2;
          }
          if (pin1.contains('003')) {
            // changeIcon[index]=icon3;
            setState(() {
              changeIcon[index] = icon3;
            });
          }
          if (pin1.contains('004')) {
            changeIcon[index] = icon4;
          }
          if (pin1.contains('005')) {
            changeIcon[index] = icon5;
          }
          if (pin1.contains('007')) {
            changeIcon[index] = icon6;
          }
          if (pin1.contains('008')) {
            changeIcon[index] = icon7;
          }
          if (pin1.contains('009')) {
            changeIcon[index] = icon8;
          }
          if (pin1.contains('0010')) {
            changeIcon[index] = icon9;
          }
          if (pin1.contains('0011')) {
            changeIcon[index] = icon10;
          }
          if (pin1.contains('0012')) {
            changeIcon[index] = icon12;
          }
        }

        if (pin2.contains('001') ||
            pin2.contains('002') ||
            pin2.contains('003') ||
            pin2.contains('004') ||
            pin2.contains('005') ||
            pin2.contains('006') ||
            pin2.contains('007') ||
            pin2.contains('008') ||
            pin2.contains('009') ||
            pin2.contains('0010') ||
            pin2.contains('0011')) {
          // icon2=Icons.ac_unit;
          // changeIcon[index+1]=icon2;
          if (pin2.contains('001')) {
            changeIcon[index + 1] = icon1;
          }
          if (pin2.contains('002')) {
            changeIcon[index + 1] = icon2;
          }
          if (pin2.contains('003')) {
            changeIcon[index + 1] = icon3;
          }
          if (pin2.contains('004')) {
            changeIcon[index + 1] = icon5;
          }
          if (pin2.contains('005')) {
            changeIcon[index + 1] = icon6;
          }
          if (pin2.contains('007')) {
            changeIcon[index + 1] = icon6;
          }
          if (pin2.contains('008')) {
            changeIcon[index + 1] = icon7;
          }
          if (pin2.contains('009')) {
            changeIcon[index] = icon8;
          }
          if (pin2.contains('0010')) {
            changeIcon[index + 1] = icon9;
          }
          if (pin2.contains('0011')) {
            changeIcon[index + 1] = icon10;
          }
          if (pin2.contains('0012')) {
            changeIcon[index + 1] = icon12;
          }
        }

        if (pin3.contains('001') ||
            pin3.contains('002') ||
            pin3.contains('003') ||
            pin3.contains('004') ||
            pin3.contains('005') ||
            pin3.contains('006') ||
            pin3.contains('007') ||
            pin3.contains('008') ||
            pin3.contains('009') ||
            pin3.contains('0010') ||
            pin3.contains('0011')) {
          // icon2=Icons.ac_unit;
          // changeIcon[index+1]=icon2;
          if (pin3.contains('001')) {
            changeIcon[index + 2] = icon1;
          }
          if (pin3.contains('002')) {
            changeIcon[index + 2] = icon2;
          }
          if (pin3.contains('003')) {
            changeIcon[index + 2] = icon3;
          }
          if (pin3.contains('004')) {
            changeIcon[index + 2] = icon5;
          }
          if (pin3.contains('005')) {
            changeIcon[index + 2] = icon6;
          }
          if (pin3.contains('007')) {
            changeIcon[index + 2] = icon6;
          }
          if (pin3.contains('008')) {
            changeIcon[index + 2] = icon7;
          }
          if (pin3.contains('009')) {
            changeIcon[index + 2] = icon8;
          }
          if (pin3.contains('0010')) {
            changeIcon[index + 2] = icon9;
          }
          if (pin3.contains('0011')) {
            changeIcon[index + 2] = icon10;
          }
          if (pin3.contains('0012')) {
            changeIcon[index + 2] = icon12;
          }
        }

        if (pin4.contains('001') ||
            pin4.contains('002') ||
            pin4.contains('003') ||
            pin4.contains('004') ||
            pin4.contains('005') ||
            pin4.contains('006') ||
            pin4.contains('007') ||
            pin4.contains('008') ||
            pin4.contains('009') ||
            pin4.contains('0010') ||
            pin4.contains('0011')) {
          // icon2=Icons.ac_unit;
          // changeIcon[index+1]=icon2;
          if (pin4.contains('001')) {
            changeIcon[index + 3] = icon1;
          }
          if (pin4.contains('002')) {
            changeIcon[index + 3] = icon2;
          }
          if (pin4.contains('003')) {
            changeIcon[index + 3] = icon3;
          }
          if (pin4.contains('004')) {
            changeIcon[index + 3] = icon5;
          }
          if (pin4.contains('005')) {
            changeIcon[index + 3] = icon6;
          }
          if (pin4.contains('007')) {
            changeIcon[index + 3] = icon6;
          }
          if (pin4.contains('008')) {
            changeIcon[index + 3] = icon7;
          }
          if (pin4.contains('009')) {
            changeIcon[index + 3] = icon8;
          }
          if (pin4.contains('0010')) {
            changeIcon[index + 3] = icon9;
          }
          if (pin4.contains('0011')) {
            changeIcon[index + 3] = icon10;
          }
          if (pin4.contains('0012')) {
            changeIcon[index + 3] = icon12;
          }
        }
        if (pin5.contains('001') ||
            pin5.contains('002') ||
            pin5.contains('003') ||
            pin5.contains('004') ||
            pin5.contains('005') ||
            pin5.contains('006') ||
            pin5.contains('007') ||
            pin5.contains('008') ||
            pin5.contains('009') ||
            pin5.contains('0010') ||
            pin5.contains('0011')) {
          // icon2=Icons.ac_unit;
          // changeIcon[index+1]=icon2;
          if (pin5.contains('001')) {
            changeIcon[index + 4] = icon1;
          }
          if (pin5.contains('002')) {
            changeIcon[index + 4] = icon2;
          }
          if (pin5.contains('003')) {
            changeIcon[index + 4] = icon3;
          }
          if (pin5.contains('004')) {
            changeIcon[index + 4] = icon5;
          }
          if (pin5.contains('005')) {
            changeIcon[index + 4] = icon6;
          }
          if (pin5.contains('007')) {
            changeIcon[index + 4] = icon6;
          }
          if (pin5.contains('008')) {
            changeIcon[index + 4] = icon7;
          }
          if (pin5.contains('009')) {
            changeIcon[index + 4] = icon8;
          }
          if (pin5.contains('0010')) {
            changeIcon[index + 4] = icon9;
          }
          if (pin5.contains('0011')) {
            changeIcon[index + 4] = icon10;
          }
          if (pin5.contains('0012')) {
            changeIcon[index + 4] = icon12;
          }
        }
        if (pin6.contains('001') ||
            pin6.contains('002') ||
            pin6.contains('003') ||
            pin6.contains('004') ||
            pin6.contains('005') ||
            pin6.contains('006') ||
            pin6.contains('007') ||
            pin6.contains('008') ||
            pin6.contains('009') ||
            pin6.contains('0010') ||
            pin6.contains('0011')) {
          // icon2=Icons.ac_unit;
          // changeIcon[index+1]=icon2;
          if (pin6.contains('001')) {
            changeIcon[index + 5] = icon1;
          }
          if (pin6.contains('002')) {
            changeIcon[index + 5] = icon2;
          }
          if (pin6.contains('003')) {
            changeIcon[index + 5] = icon3;
          }
          if (pin6.contains('004')) {
            changeIcon[index + 5] = icon5;
          }
          if (pin6.contains('005')) {
            changeIcon[index + 5] = icon6;
          }
          if (pin6.contains('007')) {
            changeIcon[index + 5] = icon6;
          }
          if (pin6.contains('008')) {
            changeIcon[index + 5] = icon7;
          }
          if (pin6.contains('009')) {
            changeIcon[index + 5] = icon8;
          }
          if (pin6.contains('0010')) {
            changeIcon[index + 5] = icon9;
          }
          if (pin6.contains('0011')) {
            changeIcon[index + 5] = icon10;
          }
          if (pin6.contains('0012')) {
            changeIcon[index + 5] = icon12;
          }
        }
        if (pin7.contains('001') ||
            pin7.contains('002') ||
            pin7.contains('003') ||
            pin7.contains('004') ||
            pin7.contains('005') ||
            pin7.contains('006') ||
            pin7.contains('007') ||
            pin7.contains('008') ||
            pin7.contains('009') ||
            pin7.contains('0010') ||
            pin7.contains('0011')) {
          // icon2=Icons.ac_unit;
          // changeIcon[index+1]=icon2;
          if (pin7.contains('001')) {
            changeIcon[index + 6] = icon1;
          }
          if (pin7.contains('002')) {
            changeIcon[index + 6] = icon2;
          }
          if (pin7.contains('003')) {
            changeIcon[index + 6] = icon3;
          }
          if (pin7.contains('004')) {
            changeIcon[index + 6] = icon5;
          }
          if (pin7.contains('005')) {
            changeIcon[index + 6] = icon6;
          }
          if (pin7.contains('007')) {
            changeIcon[index + 6] = icon6;
          }
          if (pin7.contains('008')) {
            changeIcon[index + 6] = icon7;
          }
          if (pin7.contains('009')) {
            changeIcon[index + 6] = icon8;
          }
          if (pin7.contains('0010')) {
            changeIcon[index + 6] = icon9;
          }
          if (pin7.contains('0011')) {
            changeIcon[index + 6] = icon10;
          }
          if (pin7.contains('0012')) {
            changeIcon[index + 6] = icon12;
          }
        }
        if (pin8.contains('001') ||
            pin8.contains('002') ||
            pin8.contains('003') ||
            pin8.contains('004') ||
            pin8.contains('005') ||
            pin8.contains('006') ||
            pin8.contains('007') ||
            pin8.contains('008') ||
            pin8.contains('009') ||
            pin8.contains('0010') ||
            pin8.contains('0011')) {
          // icon2=Icons.ac_unit;
          // changeIcon[index+1]=icon2;
          if (pin8.contains('001')) {
            changeIcon[index + 7] = icon1;
          }
          if (pin8.contains('002')) {
            changeIcon[index + 7] = icon2;
          }
          if (pin8.contains('003')) {
            changeIcon[index + 7] = icon3;
          }
          if (pin8.contains('004')) {
            changeIcon[index + 7] = icon5;
          }
          if (pin8.contains('005')) {
            changeIcon[index + 7] = icon6;
          }
          if (pin8.contains('007')) {
            changeIcon[index + 7] = icon6;
          }
          if (pin8.contains('008')) {
            changeIcon[index + 7] = icon7;
          }
          if (pin8.contains('009')) {
            changeIcon[index + 7] = icon8;
          }
          if (pin8.contains('0010')) {
            changeIcon[index + 7] = icon9;
          }
          if (pin8.contains('0011')) {
            changeIcon[index + 7] = icon10;
          }
          if (pin8.contains('0012')) {
            changeIcon[index + 7] = icon12;
          }
        }
        if (pin9.contains('001') ||
            pin9.contains('002') ||
            pin9.contains('003') ||
            pin9.contains('004') ||
            pin9.contains('005') ||
            pin9.contains('006') ||
            pin9.contains('007') ||
            pin9.contains('008') ||
            pin9.contains('009') ||
            pin9.contains('0010') ||
            pin9.contains('0011')) {
          // icon2=Icons.ac_unit;
          // changeIcon[index+1]=icon2;
          if (pin9.contains('001')) {
            changeIcon[index + 8] = icon1;
          }
          if (pin9.contains('002')) {
            changeIcon[index + 8] = icon2;
          }
          if (pin9.contains('003')) {
            changeIcon[index + 8] = icon3;
          }
          if (pin9.contains('004')) {
            changeIcon[index + 8] = icon5;
          }
          if (pin9.contains('005')) {
            changeIcon[index + 8] = icon6;
          }
          if (pin9.contains('007')) {
            changeIcon[index + 8] = icon6;
          }
          if (pin9.contains('008')) {
            changeIcon[index + 8] = icon7;
          }
          if (pin9.contains('009')) {
            changeIcon[index + 8] = icon8;
          }
          if (pin9.contains('0010')) {
            changeIcon[index + 8] = icon9;
          }
          if (pin9.contains('0011')) {
            changeIcon[index + 8] = icon10;
          }
          if (pin9.contains('0012')) {
            changeIcon[index + 8] = icon12;
          }
        }
      }
      return true;
    }
    return true;
  }

  Future<void> dataUpdate(dId) async {
    String? token = await getToken();
    var url = api + 'getpostdevicePinStatus/?d_id=' + dId;
    Map data = {
      'put': 'yes',
      "d_id": dId,
      'pin1Status': devicePinStatus[0],
      'pin2Status': devicePinStatus[1],
      'pin3Status': devicePinStatus[2],
      'pin4Status': devicePinStatus[3],
      'pin5Status': devicePinStatus[4],
      'pin6Status': devicePinStatus[5],
      'pin7Status': devicePinStatus[6],
      'pin8Status': devicePinStatus[7],
      'pin9Status': devicePinStatus[8],
      'pin10Status': devicePinStatus[9],
      'pin11Status': devicePinStatus[10],
      'pin12Status': devicePinStatus[11],
    };

    final response =
        await http.post(Uri.parse(url), body: jsonEncode(data), headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Token $token',
    });
    if (response.statusCode == 201 || response.statusCode == 200) {
      if (kDebugMode) {
        print(response.body);
      }
      return;
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff121421),
      body: SafeArea(
          child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 28,
              right: 18,
              top: 16,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    )),
                Row(
                  children: const [
                    SingleChildScrollView(
                      child: Text("Temp Room",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(360),
                  child: const SizedBox(
                    height: 35,
                    width: 35,
                    child: Center(
                        // child: Icon(
                        //   Icons.add,
                        //   color: Colors.white,
                        // ),
                        ),
                  ),
                ),
              ],
            ),
          ),
          FutureBuilder(
              future: roomFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height / 0.5,
                    child: DefaultTabController(
                        length: 1,
                        child: CustomScrollView(slivers: [
                          SliverToBoxAdapter(
                            child: Column(
                              children: <Widget>[
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.27,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Color(0xff669df4),
                                          Color(0xff4e80f3)
                                        ]),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30),
                                      topRight: Radius.circular(30),
                                      bottomLeft: Radius.circular(30),
                                      bottomRight: Radius.circular(30),
                                    ),
                                  ),
                                  padding: const EdgeInsets.only(
                                    top: 40,
                                    bottom: 10,
                                    left: 30,
                                    right: 30,
                                  ),
                                  alignment: Alignment.topLeft,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      GestureDetector(
                                        child: Row(
                                          children: [
                                            const Text(
                                              'Assigned By ',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle: FontStyle.italic),
                                            ),
                                            Text(
                                              widget.ownerName.toString(),
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle: FontStyle.italic),
                                            ),
                                          ],
                                        ),
                                        onTap: () {
                                          // _createAlertDialogDropDown(context);
                                        },
                                      ),
                                      const SizedBox(height: 22),

                                      // Row(
                                      //   // mainAxisAlignment: MainAxisAlignment.start,
                                      //   children: <Widget>[
                                      //     FutureBuilder(
                                      //       future: deviceSensorVal,
                                      //       builder: (context, snapshot) {
                                      //         if (snapshot.hasData) {
                                      //           print('SnapShot ${snapshot}');
                                      //           return Column(
                                      //             children: <Widget>[
                                      //               Row(
                                      //                 children: <Widget>[
                                      //                   SizedBox(
                                      //                     width: 8,
                                      //                   ),
                                      //                   Column(children: <Widget>[
                                      //                     Icon(
                                      //                       FontAwesomeIcons.fire,
                                      //                       color: Colors.yellow,
                                      //                     ),
                                      //                     SizedBox(
                                      //                       height: 32,
                                      //                     ),
                                      //                     Row(
                                      //                       children: <Widget>[
                                      //                         Container(
                                      //                           child: Text(
                                      //                             // 'aa',
                                      //                               sensorData['sensor1'].toString(),                                                            style: TextStyle(
                                      //                               fontSize:
                                      //                               14,
                                      //                               fontFamily: fonttest==null?changeFont:fonttest,
                                      //                               color: Colors
                                      //                                   .white70)),
                                      //                         ),
                                      //                       ],
                                      //                     ),
                                      //                   ]),
                                      //                   SizedBox(
                                      //                     width: 35,
                                      //                   ),
                                      //                   Column(children: <Widget>[
                                      //                     Icon(
                                      //                       FontAwesomeIcons
                                      //                           .temperatureLow,
                                      //                       color: Colors.orange,
                                      //                     ),
                                      //                     SizedBox(
                                      //                       height: 30,
                                      //                     ),
                                      //                     Row(
                                      //                       children: <Widget>[
                                      //                         Container(
                                      //                           child: Text(
                                      //                             // 's',
                                      //                               sensorData['sensor2'].toString(),
                                      //                               style: TextStyle(
                                      //                                   fontFamily: fonttest==null?changeFont:fonttest,
                                      //                                   fontSize:
                                      //                                   14,
                                      //                                   color: Colors
                                      //                                       .white70)),
                                      //                         ),
                                      //                       ],
                                      //                     ),
                                      //                   ]),
                                      //                   SizedBox(
                                      //                     width: 45,
                                      //                   ),
                                      //                   Column(children: <Widget>[
                                      //                     Icon(
                                      //                       FontAwesomeIcons.wind,
                                      //                       color: Colors.white,
                                      //                     ),
                                      //                     SizedBox(
                                      //                       height: 30,
                                      //                     ),
                                      //                     Row(
                                      //                       children: <Widget>[
                                      //                         Container(
                                      //                           child: Text(
                                      //                             // 's',
                                      //                               sensorData['sensor3'].toString(),
                                      //                               style: TextStyle(
                                      //                                   fontFamily: fonttest==null?changeFont:fonttest,
                                      //                                   fontSize:
                                      //                                   14,
                                      //                                   color: Colors
                                      //                                       .white70)),
                                      //                         ),
                                      //                       ],
                                      //                     ),
                                      //                   ]),
                                      //                   SizedBox(
                                      //                     width: 42,
                                      //                   ),
                                      //                   Column(children: <Widget>[
                                      //                     Icon(
                                      //                       FontAwesomeIcons.cloud,
                                      //                       color: Colors.orange,
                                      //                     ),
                                      //                     SizedBox(
                                      //                       height: 30,
                                      //                     ),
                                      //                     Row(
                                      //                       children: <Widget>[
                                      //                         Container(
                                      //                           child: Text(
                                      //                               sensorData['sensor4'].toString(),
                                      //                               style: TextStyle(
                                      //                                   fontFamily: fonttest==null?changeFont:fonttest,
                                      //                                   fontSize:
                                      //                                   14,
                                      //                                   color: Colors
                                      //                                       .white70)),
                                      //                         ),
                                      //                       ],
                                      //                     ),
                                      //                   ]),
                                      //                 ],
                                      //               ),
                                      //               SizedBox(
                                      //                 height: 22,
                                      //               ),
                                      //               Text(
                                      //                   sensorData['d_id'].toString(),
                                      //                   style: TextStyle(
                                      //                       fontFamily: fonttest==null?changeFont:fonttest,
                                      //                       fontSize:
                                      //                       14,
                                      //                       color: Colors
                                      //                           .white70)),
                                      //             ],
                                      //           );
                                      //         } else {
                                      //           return Center(
                                      //             child: Text('Loading...'),
                                      //           );
                                      //         }
                                      //       },
                                      //     ),
                                      //   ],
                                      // )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          SliverAppBar(
                            automaticallyImplyLeading: false,
                            // centerTitle: true,
                            floating: true,
                            pinned: true,
                            backgroundColor: Colors.white,

                            title: Container(
                              alignment: Alignment.bottomLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        GestureDetector(
                                          child: TabBar(
                                            indicatorColor: Colors.blueAccent,
                                            controller: tabC,
                                            labelColor: Colors.blueAccent,
                                            indicatorWeight: 2.0,
                                            isScrollable: true,
                                            tabs: [Text(roomData[0]['r_name'])],
                                            onTap: (index) async {},
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SliverList(
                            delegate:
                                SliverChildBuilderDelegate((context, index) {
                              if (index < subAccessDevice.length) {
                                if (subAccessDevice.isEmpty) {
                                  return Container();
                                }
                                return deviceContainer(
                                    subAccessDevice[index].dId,
                                    index,
                                    ScrollController);
                              } else {
                                return Container();
                              }
                            }),
                          )
                        ])),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              })
        ],
      )),
    );
  }

  Widget deviceContainer(
    dId,
    index,
    _controller,
  ) {
    getPinStatusData(dId);
    getPinStatusData(dId);
    return Container(
      height: MediaQuery.of(context).size.height * 2.9,
      color: Colors.red,
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18.0),
                  child: Text(
                    'Turn Off All Appliances',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 14,
                ),
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: GestureDetector(
                    child: const Icon(
                      Icons.update,
                      color: Colors.white,
                    ),
                    onTap: () async {},
                  ),
                ),
         
              
                Container(
                  width: 14,
                  height: 14,

                  decoration: const BoxDecoration(
                      color: Colors.green, shape: BoxShape.circle),
                  // child: ...
                ),
                Switch(
                  value: false,
                  //boolean value
                  onChanged: (val) async {},
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: GestureDetector(
                    child: const Icon(
                      Icons.settings_remote,
                      color: Colors.white,
                    ),
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: Colors.orangeAccent,
            height: MediaQuery.of(context).size.height / 0.9,
            child: GridView.count(
              crossAxisSpacing: 8,
              childAspectRatio: 2 / 1.7,
              mainAxisSpacing: 4,
              crossAxisCount: 2,
              scrollDirection: Axis.vertical,
              physics: const NeverScrollableScrollPhysics(),
              children: List.generate(9, (index) {
                return SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                        alignment: const FractionalOffset(1.0, 0.0),
                        // alignment: Alignment.bottomRight,
                        height: 120,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 1, vertical: 10),
                        margin: index % 2 == 0
                            ? const EdgeInsets.fromLTRB(15, 7.5, 7.5, 7.5)
                            : const EdgeInsets.fromLTRB(7.5, 7.5, 15, 7.5),
                        // margin: EdgeInsets.fromLTRB(15, 7.5, 7.5, 7.5),
                        decoration: BoxDecoration(
                            boxShadow: const <BoxShadow>[
                              BoxShadow(
                                  blurRadius: 10,
                                  offset: Offset(8, 10),
                                  color: Colors.black)
                            ],
                            color: Colors.white,
                            border: Border.all(
                                width: 1,
                                style: BorderStyle.solid,
                                color: const Color(0xffa3a3a3)),
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: FutureBuilder(
                                    future: nameFuture,
                                    builder: (context, snapshot) {
                                      if (snapshot.data != null) {
                                        return TextButton(
                                          child: Text(
                                            '${namesDataList[index].toString()} ',
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: const TextStyle(
                                              fontSize: 10,
                                            ),
                                          ),
                                          onPressed: () async {},
                                        );
                                      } else {
                                        return Container();
                                      }
                                    },
                                  ),
                                ),
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 4.5,
                                    ),
                                    child: FutureBuilder(
                                        future: switchFuture,
                                        builder: (context, snapshot) {
                                          if (snapshot.data != null) {
                                            return Switch(
                                              value: devicePinStatus[index] == 0
                                                  ? false
                                                  : true,
                                              onChanged: (value) async {
                                                if (devicePinStatus[index] ==
                                                    0) {
                                                  setState(() {
                                                    devicePinStatus[index] = 1;
                                                  });
                                                  await dataUpdate(dId);
                                                  switchFuture =
                                                      getPinStatusData(dId);
                                                } else {
                                                  setState(() {
                                                    devicePinStatus[index] = 0;
                                                  });
                                                  await dataUpdate(dId);
                                                  await getPinStatusData(dId);
                                                }
                                              },
                                            );
                                          } else {
                                            return Container();
                                          }
                                        })),
                              ],
                            ),
                          ],
                        )),
                  ),
                );
              }),
            ),
          ),
          Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 2.2,
                child: GridView.count(
                  crossAxisSpacing: 8,
                  childAspectRatio: 2 / 1.8,
                  mainAxisSpacing: 4,
                  crossAxisCount: 2,
                  scrollDirection: Axis.vertical,
                  physics: const NeverScrollableScrollPhysics(),
                  children: List.generate(3, (index) {
                    return SizedBox(
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                            alignment: const FractionalOffset(1.0, 0.0),
                            // alignment: Alignment.bottomRight,
                            height: 120,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 1, vertical: 10),
                            margin: index % 2 == 0
                                ? const EdgeInsets.fromLTRB(15, 7.5, 7.5, 7.5)
                                : const EdgeInsets.fromLTRB(7.5, 7.5, 15, 7.5),
                            // margin: EdgeInsets.fromLTRB(15, 7.5, 7.5, 7.5),
                            decoration: BoxDecoration(
                                boxShadow: const <BoxShadow>[
                                  BoxShadow(
                                      blurRadius: 10,
                                      offset: Offset(8, 10),
                                      color: Colors.black)
                                ],
                                color: Colors.white,
                                border: Border.all(
                                    width: 1,
                                    style: BorderStyle.solid,
                                    color: const Color(0xffa3a3a3)),
                                borderRadius: BorderRadius.circular(20)),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: FutureBuilder(
                                        future: nameFuture,
                                        builder: (context, snapshot) {
                                          if (snapshot.data != null) {
                                            return TextButton(
                                              child: Text(
                                                // '$index',
                                                namesDataList[index + 9]
                                                    .toString(),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: const TextStyle(
                                                  fontSize: 10,
                                                ),
                                              ),
                                              onPressed: () async {
                                                int newIndex = index + 9;
                                              },
                                            );
                                          } else {
                                            return Container();
                                          }
                                        },
                                      ),
                                    ),
                                    FutureBuilder(
                                        future: switchFuture,
                                        builder: (context, snapshot) {
                                          if (snapshot.data != null) {
                                            return SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  3.9,
                                              child: Slider(
                                                  value: double.parse(
                                                      devicePinStatus[index + 9]
                                                          .toString()),
                                                  min: 0,
                                                  max: 10,
                                                  label:
                                                      '${double.parse(devicePinStatus[index + 9].toString())}',
                                                  onChanged: (onChanged) async {
                                                    setState(() {
                                                      devicePinStatus[
                                                              index + 9] =
                                                          onChanged.round();
                                                    });
                                                    // await dataUpdate(dId);
                                                  }),
                                            );
                                          } else {
                                            return Container();
                                          }
                                        }),
                                  ],
                                ),
                                GestureDetector(
                                    onTap: () {}, child: const Icon(Icons.add))
                              ],
                            )),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
