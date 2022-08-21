// ignore_for_file: prefer_typing_uninitialized_variables, must_be_immutable, avoid_print

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/emergencymodel.dart';
import '../main.dart';
import 'package:http/http.dart' as http;

class EmergencyNumber extends StatefulWidget {
  var deviceId;
  EmergencyNumber({Key? key, required this.deviceId}) : super(key: key);

  @override
  _EmergencyNumberState createState() => _EmergencyNumberState();
}

class _EmergencyNumberState extends State<EmergencyNumber> {
  TextEditingController mobile1 = TextEditingController();
  TextEditingController mobile2 = TextEditingController();
  TextEditingController mobile3 = TextEditingController();
  TextEditingController mobile4 = TextEditingController();
  TextEditingController mobile5 = TextEditingController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  var getUidVariable;
  final storage = const FlutterSecureStorage();
  bool checkWidget = false;
  double width = 12;
  EmergencyNumberModel? emergencyNumberModel;
  @override
  void initState() {
    super.initState();
    getUidShared();
    getEmergencyNumber();
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
                      Text("Emergency Number",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(360),
                    onTap: () {},
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
            const SizedBox(
              height: 25,
            ),
            checkWidget ? showmobileNumber() : enterMobile(),
          ],
        ),
      ),
    );
  }

  Widget enterMobile() {
    return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 15,
          ),
          Container(
            margin: const EdgeInsets.only(left: 25, right: 25),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              // color: Color(0xFF6CA8F1),
              color: Colors.white70,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6.0,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            height: 60.0,
            child: TextFormField(
              controller: mobile1,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.phone,
              
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'OpenSans',
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14.0),
                prefixIcon: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                hintText: 'Enter Mobile 1',
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Container(
            margin: const EdgeInsets.only(left: 25, right: 25),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              // color: Color(0xFF6CA8F1),
              color: Colors.white70,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6.0,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            height: 60.0,
            child: TextFormField(
              controller: mobile2,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.phone,
             
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'OpenSans',
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14.0),
                prefixIcon: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                hintText: 'Enter Mobile 2',
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Container(
            margin: const EdgeInsets.only(left: 25, right: 25),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              // color: Color(0xFF6CA8F1),
              color: Colors.white70,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6.0,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            height: 60.0,
            child: TextFormField(
              textInputAction: TextInputAction.next,
              controller: mobile3,
              keyboardType: TextInputType.phone,
             
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'OpenSans',
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14.0),
                prefixIcon: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                hintText: 'Enter Mobile 3',
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Container(
            margin: const EdgeInsets.only(left: 25, right: 25),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              // color: Color(0xFF6CA8F1),
              color: Colors.white70,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6.0,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            height: 60.0,
            child: TextFormField(
              textInputAction: TextInputAction.next,
              controller: mobile4,
              keyboardType: TextInputType.phone,
             
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'OpenSans',
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14.0),
                prefixIcon: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                hintText: 'Enter Mobile 4',
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Container(
            margin: const EdgeInsets.only(left: 25, right: 25),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              // color: Color(0xFF6CA8F1),
              color: Colors.white70,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6.0,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            height: 60.0,
            child: TextFormField(
              textInputAction: TextInputAction.next,
              controller: mobile5,
              keyboardType: TextInputType.phone,
            
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'OpenSans',
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14.0),
                prefixIcon: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                hintText: 'Enter Mobile 5',
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          _buildSubmit(),
        ],
      ),
    );
  }

  Widget showmobileNumber() {
    return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 15,
          ),
          Container(
              margin: const EdgeInsets.only(left: 25, right: 25),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                // color: Color(0xFF6CA8F1),
                color: Colors.white70,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6.0,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              height: 60.0,
              child: Row(
                children: [
                  SizedBox(
                    width: width,
                  ),
                  Text(emergencyNumberModel!.number1.toString()),
                ],
              )),
          const SizedBox(
            height: 15,
          ),
          Container(
              margin: const EdgeInsets.only(left: 25, right: 25),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                // color: Color(0xFF6CA8F1),
                color: Colors.white70,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6.0,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              height: 60.0,
              child: Row(
                children: [
                  SizedBox(
                    width: width,
                  ),
                  Text(emergencyNumberModel!.number2.toString()),
                ],
              )),
          const SizedBox(
            height: 15,
          ),
          Container(
              margin: const EdgeInsets.only(left: 25, right: 25),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                // color: Color(0xFF6CA8F1),
                color: Colors.white70,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6.0,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              height: 60.0,
              child: Row(
                children: [
                  SizedBox(
                    width: width,
                  ),
                  Text(emergencyNumberModel!.number3.toString()),
                ],
              )),
          const SizedBox(
            height: 15,
          ),
          Container(
              margin: const EdgeInsets.only(left: 25, right: 25),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                // color: Color(0xFF6CA8F1),
                color: Colors.white70,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6.0,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              height: 60.0,
              child: Row(
                children: [
                  SizedBox(
                    width: width,
                  ),
                  Text(emergencyNumberModel!.number4.toString()),
                ],
              )),
          const SizedBox(
            height: 15,
          ),
          Container(
              margin: const EdgeInsets.only(left: 25, right: 25),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                // color: Color(0xFF6CA8F1),
                color: Colors.white70,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6.0,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              height: 60.0,
              child: Row(
                children: [
                  SizedBox(
                    width: width,
                  ),
                  Text(emergencyNumberModel!.number5.toString()),
                ],
              )),
          const SizedBox(
            height: 15,
          ),
          _buildEdit(),
        ],
      ),
    );
  }

  Widget _buildSubmit() {
    return Container(
      margin: const EdgeInsets.only(left: 25, right: 25),
      padding: const EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      // ignore: deprecated_member_use
      child: ElevatedButton(
        // elevation: 5.0,
        onPressed: () async {
          await postMobileNumber();
        },
        // padding: const EdgeInsets.all(15.0),
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.circular(30.0),
        // ),
        // color: Colors.white,
        child: const Text(
          'Submit',
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Widget _buildEdit() {
    return Container(
      margin: const EdgeInsets.only(left: 25, right: 25),
      padding: const EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      // ignore: deprecated_member_use
      child: ElevatedButton(
        // elevation: 5.0,
        onPressed: () {
          setState(() {
            checkWidget = !checkWidget;
          });
        },
        // padding: const EdgeInsets.all(15.0),
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.circular(30.0),
        // ),
        // color: Colors.white,
        child: const Text(
          'Edit',
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Future<String?> getToken() async {
    final tokenVar = await storage.read(key: "token");

    return tokenVar;
  }

  Future getEmergencyNumber() async {
    String? token = await getToken();
    final url =
        api + 'getpostemergencynumber/?d_id=' + widget.deviceId.toString();
    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Token $token',
    });
    if (response.statusCode == 200) {
      var ans = jsonDecode(response.body);
      setState(() {
        emergencyNumberModel = EmergencyNumberModel.fromJson(ans);
        checkWidget = true;
      });
      print("response ${response.body}");
    } else {
      if (kDebugMode) {
        print(response.statusCode);
      }
    }
  }

  getUidShared() async {
    final SharedPreferences prefs = await _prefs;
    final a = prefs.getInt("uid");
    setState(() {
      getUidVariable = a!;
    });
  }

  Future postMobileNumber() async {
    String? token = await getToken();
    final url =
        api + 'getpostemergencynumber/?d_id=' + widget.deviceId.toString();
    var postData = {
      "user": getUidVariable,
      "d_id": widget.deviceId,
      "number1": mobile1.text.toString().isEmpty ? "0" : mobile1.text.toString(),
      "number2": mobile2.text.toString().isEmpty ? "0" : mobile2.text.toString(),
      "number3": mobile3.text.toString().isEmpty ? "0" : mobile3.text.toString(),
      "number4": mobile4.text.toString().isEmpty ? "0" : mobile4.text.toString(),
      "number5": mobile5.text.toString().isEmpty ? "0" : mobile5.text.toString(),
    };
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(postData),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      if (kDebugMode) {
        print("Kuch Bi -->${response.body}");
      }
      await getEmergencyNumber();
    } else {
      if (kDebugMode) {
        print("Kuch Bi -->${response.statusCode}    $postData");
      }
      await updateMobileNumber();
    }
  }

  Future updateMobileNumber() async {
    String? token = await getToken();
    final url =
        api + 'getpostemergencynumber/?d_id=' + widget.deviceId.toString();
    var postData = {
      "user": getUidVariable,
      "d_id": widget.deviceId,
      "number1": mobile1.text.toString().isEmpty
          ? emergencyNumberModel!.number1.toString()
          : mobile1.text.toString(),
      "number2": mobile2.text.toString().isEmpty
          ? emergencyNumberModel!.number2.toString()
          : mobile2.text.toString(),
      "number3": mobile3.text.toString().isEmpty
          ? emergencyNumberModel!.number3.toString()
          : mobile3.text.toString(),
      "number4": mobile4.text.toString().isEmpty
          ? emergencyNumberModel!.number4.toString()
          : mobile4.text.toString(),
      "number5": mobile5.text.toString().isEmpty
          ? emergencyNumberModel!.number5.toString()
          : mobile5.text.toString(),
    };
    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(postData),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      if (kDebugMode) {
        print("Kuch Bi -->${response.body}");
      }
      await getEmergencyNumber();
    } else {
      if (kDebugMode) {
        print("Kuch Bi -->${response.body} ");
        print("Kuch Bi -->${response.statusCode}    $postData");
      }
    }
  }


}
