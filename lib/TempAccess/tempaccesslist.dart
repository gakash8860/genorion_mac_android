// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:genorion_mac_android/TempAccess/tempaccessfloor.dart';
import 'package:genorion_mac_android/TempAccess/tempaccessplace.dart';
import 'package:genorion_mac_android/TempAccess/tempdevice.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../Models/tempuser.dart';
import '../main.dart';
import 'tempaccessflat.dart';
import 'tempaccessroom.dart';

class ListOfTempAccessPage extends StatefulWidget {
  var mobileNumber;
  ListOfTempAccessPage({Key? key, required this.mobileNumber})
      : super(key: key);

  @override
  _ListOfTempAccessPageState createState() => _ListOfTempAccessPageState();
}

class _ListOfTempAccessPageState extends State<ListOfTempAccessPage> {
  final storage = const FlutterSecureStorage();
  TextEditingController numberEditing = TextEditingController();
  List<TempUserDetails> temp = [];
  Future<List<TempUserDetails>>? tempFuture;

  Future<String?> getToken() async {
    final tokenVar = await storage.read(key: "token");

    return tokenVar;
  }

  @override
  void initState() {
    super.initState();
    tempFuture = getTempAccess();
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
                    Text("Temp Access",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(
                  height: 35,
                  width: 35,
                  child: Center(
                      child: IconButton(
                          onPressed: () {
                            _createAlertDialogForEditNumber();
                          },
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.white,
                          ))),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 35,
          ),
          showTemp(),
        ],
      )),
    );
  }

  Future<List<TempUserDetails>> getTempAccess() async {
    String? token = await getToken();
    String url = api + "giveaccesstotempuser/?mobile=" + widget.mobileNumber;
    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Token $token',
    });
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print("dsds ${response.body}");
      }
      List data = jsonDecode(response.body);
      setState(() {
        temp = data.map((data) => TempUserDetails.fromJson(data)).toList();
      });
      return temp;
    } else {
      if (kDebugMode) {
        print(response.statusCode);
      }
      const snackBar = SnackBar(
        content: Text('SomeThing Went Wrong'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return temp;
    }
  }

  Widget showTemp() {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: FutureBuilder<List<TempUserDetails>>(
        future: tempFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return const Center(
                  child: Text(
                "Empty",
                style: TextStyle(color: Colors.white),
              ));
            } else {
              return ListView.builder(
                  itemCount: temp.length,
                  itemBuilder: (context, index) {
                    return Card(
                      semanticContainer: true,
                      shadowColor: Colors.grey,
                      child: ListTile(
                        title: Text(
                          temp[index].ownerName.toString(),
                        ),
                        subtitle: Text(temp[index].email.toString()),
                        onTap: () {
                          if (temp[index].pId != null) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TempPlace(
                                          ownerName: temp[index].ownerName.toString(),
                                          placeId: temp[index].pId.toString(),
                                        )));
                          }

                          if (temp[index].dId != null) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TempAccessDevice(
                                          ownerName: temp[index].ownerName,
                                          dId: temp[index].dId,
                                        )));
                          }

                          if (temp[index].rId != null) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TempAccessRoom(
                                          ownerName: temp[index].ownerName,
                                          rId: temp[index].rId,
                                        )));
                          }

                          if (temp[index].fltId != null) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TempAccessFlat(
                                          ownerName: temp[index].ownerName,
                                          flatId: temp[index].fltId,
                                        )));
                          }
                          if (temp[index].fId != null) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TempAccessFloor(
                                          ownerName: temp[index].ownerName,
                                          floorId: temp[index].fId,
                                        )));
                          }
                        },
                      ),
                    );
                  });
            }
          } else {
            return const Center(
                child: CircularProgressIndicator(
              color: Colors.red,
            ));
          }
        },
      ),
    );
  }

  _createAlertDialogForEditNumber() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Enter the Name of Room'),
            content: TextFormField(
              autofocus: true,
              controller: numberEditing,
              keyboardType: TextInputType.phone,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              style: const TextStyle(fontSize: 18, color: Colors.black54),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.place),
                filled: true,
                fillColor: Colors.white,
                hintText: 'Enter Mobile Number',
                contentPadding: const EdgeInsets.all(15),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(50),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MaterialButton(
                  elevation: 5.0,
                  child: const Text('Submit'),
                  onPressed: () async {
                    await _removeTempNumber();
                    await _setTempNumber(numberEditing.text);
                    tempFuture = getTempAccess();
                    Navigator.of(context).pop();
                  },
                ),
              )
            ],
          );
        });
  }

  _removeTempNumber() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();

    pref.remove('mobileNumber');
  }

  Future _setTempNumber(mobile) async {
    final pref = await SharedPreferences.getInstance();
    pref.setString('mobileNumber', mobile);
  }
}
