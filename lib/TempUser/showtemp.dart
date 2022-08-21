// ignore_for_file: prefer_typing_uninitialized_variables, deprecated_member_use

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:genorion_mac_android/main.dart';
import 'package:http/http.dart' as http;
import '../LocalDatabase/alldb.dart';
import '../Models/tempuser.dart';
import 'addtemp.dart';

class ShowTempUser extends StatefulWidget {
  const ShowTempUser({Key? key}) : super(key: key);

  @override
  _ShowTempUserState createState() => _ShowTempUserState();
}

class _ShowTempUserState extends State<ShowTempUser> {
  final storage = const FlutterSecureStorage();
  List<TempUserDetails> temp = [];
  Future<List<TempUserDetails>>? tempFuture;
  var deletePid;
  var deleteMobile;
  var deleteFid;
  var deleteFltid;
  var deleteRid;
  var deleteDid;
  TextEditingController numberEditing = TextEditingController();
  @override
  void initState() {
    super.initState();
    getTempUser();
  }

  Future<List<TempUserDetails>> getAllTempUserLocal() async {
    List<dynamic> data = await AllDatabase.instance.getAllTemp();
    if (kDebugMode) {
      print(data);
    }
    setState(() {
      temp = data.map((data) => TempUserDetails.fromJson(data)).toList();
    });
    return temp;
  }

  Future<String?> getToken() async {
    final tokenVar = await storage.read(key: "token");
    return tokenVar;
  }

  Future getTempUser() async {
    String? token = await getToken();
    const url = api + "getalldatayouaddedtempuser";
    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Token $token',
    });
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      if (kDebugMode) {
        print(response.body);
      }
      await AllDatabase.instance.deleteAllTempUser();

      for (int i = 0; i < data.length; i++) {
        var temp = TempUserDetails.fromJson(data[i]);
        await AllDatabase.instance.insertTempUserData(temp);
      }
      tempFuture = getAllTempUserLocal();
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
                      Text("Temp User",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(360),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddTempUser()));
                    },
                    child: const SizedBox(
                      height: 35,
                      width: 35,
                      child: Center(
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 35,
            ),
            showTemp(),
          ],
        ),
      ),
    );
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
                          temp[index].name,
                        ),
                        subtitle: Text(temp[index].email),
                        leading: IconButton(
                          icon: const Icon(
                            Icons.delete_forever,
                            color: Colors.black,
                            semanticLabel: 'Delete',
                          ),
                          onPressed: () {
                            _showDialogForDeleteSubUser(index);
                          },
                        ),
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

  _showDialogForDeleteSubUser(int index) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete"),
        content: const Text("Are you sure to delete this user"),
        actions: <Widget>[
          MaterialButton(
              child: const Text("Yes"),
              onPressed: () async {
                deletePid = temp[index].pId.toString();
                deleteFid = temp[index].fId.toString();
                deleteFltid = temp[index].fltId.toString();
                deleteRid = temp[index].rId.toString();
                deleteDid = temp[index].dId.toString();
                deleteMobile = temp[index].mobile.toString();

                if (kDebugMode) {
                  print("deletePid $deletePid");
                  print("deleteFid $deleteFid");
                  print("deleteFltid $deleteFltid");
                  print("deleteRid $deleteRid");
                  print("deleteDid $deleteDid");
                }
                await deleteTempUser();
                Navigator.pop(context);
              }),
          MaterialButton(
              child: const Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              }),
        ],
      ),
    );
  }

  Future deleteTempUser() async {
    String? token = await getToken();
    String? url;
    if (deletePid != null) {
      url = api + 'giveaccesstotempuser/?mobile=$deleteMobile&p_id=$deletePid';
    } else if (deleteFid != null) {
      url = api + 'giveaccesstotempuser/?mobile=$deleteMobile&f_id=$deleteFid';
    } else if (deleteFltid != null) {
      url = api +
          'giveaccesstotempuser/?mobile=$deleteMobile&flt_id=$deleteFltid';
      if (kDebugMode) {
        print("response.statusCode");
      }
    } else if (deleteRid != null) {
      url = api + 'giveaccesstotempuser/?mobile=$deleteMobile&r_id=$deleteRid';
    }
    final response = await http.delete(
      Uri.parse(url!),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Token $token',
      },
    );
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(response.statusCode);
      }
      const snackBar = SnackBar(
        content: Text('User Deleted'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      await getTempUser();
    } else {
      if (kDebugMode) {
        print(response.statusCode);
      }
    }
  }


}
