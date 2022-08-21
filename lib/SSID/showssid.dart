// ignore_for_file: prefer_typing_uninitialized_variables, must_be_immutable, non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../Models/ssidmodel.dart';
import '../main.dart';

class ShowSSid extends StatefulWidget {
  var deviceId;
  ShowSSid({Key? key, required this.deviceId}) : super(key: key);

  @override
  _ShowSSidState createState() => _ShowSSidState();
}

class _ShowSSidState extends State<ShowSSid> {
  final storage = const FlutterSecureStorage();
  bool checkWidget = false;
  TextEditingController ssid1 = TextEditingController();
  TextEditingController ssid2 = TextEditingController();
  TextEditingController ssid3 = TextEditingController();
  TextEditingController password1 = TextEditingController();
  TextEditingController password2 = TextEditingController();
  TextEditingController password3 = TextEditingController();
  double width = 12;
  SsidModel? ssidModel;
  @override
  void initState() {
    super.initState();
    getSSid();
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
                      Text("SSID",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
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
              height: 15,
            ),
            checkWidget ? showSSid() : enterSSid(),
          ],
        ),
      ),
    );
  
  }

  Widget enterSSid() {
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
              controller: ssid1,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter SSID';
                }
                return null;
              },
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
                hintText: 'Enter SSID 1',
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
              controller: password1,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter full name';
                }
                return null;
              },
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
                hintText: 'Enter Password',
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
              controller: ssid2,
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter full name';
                }
                return null;
              },
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
                hintText: 'SSID 2',
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
              controller: password2,
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter full name';
                }
                return null;
              },
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
                hintText: 'Enter Password',
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
              controller: ssid3,
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter full name';
                }
                return null;
              },
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
                hintText: 'SSID 3',
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
              controller: password3,
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter full name';
                }
                return null;
              },
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
                hintText: 'Enter Password',
              ),
            ),
          ),
          _buildSubmit(),
        ],
      ),
    );
  }

  Widget showSSid() {
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
                  Text(ssidModel!.ssid1.toString()),
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
                  Text(ssidModel!.password2.toString()),
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
                  Text(ssidModel!.ssid2.toString()),
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
                  Text(ssidModel!.password2.toString()),
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
                  Text(ssidModel!.ssid3.toString()),
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
                  Text(ssidModel!.password3.toString()),
                ],
              )),
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

           
          await enterSSID_Password();
          

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

  Future enterSSID_Password() async {
    String? token = await getToken();

    final url = api + 'ssidpassword/?d_id=' + widget.deviceId.toString();
    var postData = {
      "d_id": widget.deviceId,
      "ssid1": ssid1.text.toString(),
      "password1": password1.text.toString(),
      "ssid2": ssid2.text.toString(),
      "password2": password2.text.toString(),
      "ssid3": ssid3.text.toString(),
      "password3": password3.text.toString(),
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
      await getSSid();
    } else {
      if (kDebugMode) {
        print("Kuch Bi -->${response.statusCode}    $postData");
      }
                  await updateSSID_Password();
    }
  }

  Future updateSSID_Password() async {
    String? token = await getToken();

    final url = api + 'ssidpassword/?d_id=' + widget.deviceId.toString();
    var postData = {
      "d_id": widget.deviceId,
      "ssid1": ssid1.text.toString(),
      "password1": password1.text.toString(),
      "ssid2": ssid2.text.toString(),
      "password2": password2.text.toString(),
      "ssid3": ssid3.text.toString(),
      "password3": password3.text.toString(),
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
      await getSSid();
    } else {
      if (kDebugMode) {
        print("Kuch Bi -->${response.statusCode}    $postData");
      }
      
    }
  }

  Future getSSid() async {
    String? token = await getToken();
    var url = api + "ssidpassword/?d_id=" + widget.deviceId.toString();
    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Token $token',
    });
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(response.body);
      }
      var ans = jsonDecode(response.body);

      setState(() {
        ssidModel = SsidModel.fromJson(ans);
        checkWidget = true;
      });
    } else {
      if (kDebugMode) {
        print("response.statusCode${response.statusCode}");
      }
    }
  }


}
