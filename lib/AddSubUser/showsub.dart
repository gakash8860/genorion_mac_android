// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:genorion_mac_android/AddSubUser/addsubs.dart';
import 'package:genorion_mac_android/Models/subuser.dart';
import 'package:http/http.dart' as http;
import '../LocalDatabase/alldb.dart';
import '../main.dart';

class ShowAndAddSubUser extends StatefulWidget {
  const ShowAndAddSubUser({Key? key}) : super(key: key);

  @override
  _ShowAndAddSubUserState createState() => _ShowAndAddSubUserState();
}

class _ShowAndAddSubUserState extends State<ShowAndAddSubUser> {
  var storage = const FlutterSecureStorage();
  List<SubUserDetails> subuser = [];
  Future<List<SubUserDetails>>? subFuture;
  @override
  void initState() {
    super.initState();
    getSubUsers();
    subFuture = getLocalDataSubUser();
  }

  Future getSubUsers() async {
    String? token = await getToken();
    const url = api + 'subuserfindall/';
    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Token $token',
    });
    if (response.statusCode == 200) {
      List<dynamic> ans = jsonDecode(response.body);
      await AllDatabase.instance.deleteAllSubUser();

      for (int i = 0; i < ans.length; i++) {
        var query = SubUserDetails(
            id: ans[i]['id'],
            ownerName: ans[i]['owner_name'],
            name: ans[i]['name'],
            user: ans[i]['user'],
            email: ans[i]['email'],
            pId: ans[i]['p_id']);
        await AllDatabase.instance.insertSubUserData(query);
      }
      subFuture = getLocalDataSubUser();
    } else {
      if (kDebugMode) {
        print(response.statusCode);
      }
    }
  }

  Future<List<SubUserDetails>> getLocalDataSubUser() async {
    List<dynamic> data = await AllDatabase.instance.getAllSubUser();
    if (mounted) {
      setState(() {
        subuser = data.map((data) => SubUserDetails.fromJson(data)).toList();
      });
    }
    setState(() {
      subuser = data.map((data) => SubUserDetails.fromJson(data)).toList();
    });
    return subuser;
  }

  Future<String?> getToken() async {
    final token = await storage.read(key: "token");
    return token;
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
                    icon: const Icon(Icons.arrow_back_ios,color: Colors.white)),
                Row(
                  children: const [
                    Text("SubUsers",
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
                            builder: (context) => const AddSubUser()));
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
          showSUb()
        ],
      )),
    );
  }

  Widget showSUb() {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: FutureBuilder<List<SubUserDetails>>(
        future: subFuture,
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
                  itemCount: subuser.length,
                  itemBuilder: (context, index) {
                    return Card(
                      semanticContainer: true,
                      shadowColor: Colors.grey,
                      child: ListTile(
                        title: Text(subuser[index].name),
                        subtitle: Text(subuser[index].email),
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
          ElevatedButton(
              child: const Text("Yes"),
              onPressed: () async {
                await deleteSubUser(subuser[index].email, subuser[index].pId);
                setState(() {
                  subFuture = getLocalDataSubUser();
                });
                Navigator.of(context).pop();
              }),
          ElevatedButton(
              child: const Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              }),
        ],
      ),
    );
  }

  Future deleteSubUser(String email, String pId) async {
    String? token = await getToken();
    final url = api + 'subuseraccess/?email=$email&p_id=' + pId;
    final response = await http.delete(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Token $token',
    });
    if (response.statusCode == 200) {
      await AllDatabase.instance.deleteByEmailSubUser(email.toString());
    }
  }
}
