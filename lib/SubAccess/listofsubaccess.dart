// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:genorion_mac_android/Models/subaccessmodel.dart';
import 'package:genorion_mac_android/SubAccess/subaccess.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../LocalDatabase/alldb.dart';

import '../Models/userprofike.dart';
import '../main.dart';

class ListOfSUbAccess extends StatefulWidget {
  const ListOfSUbAccess({Key? key}) : super(key: key);

  @override
  _ListOfSUbAccessState createState() => _ListOfSUbAccessState();
}

class _ListOfSUbAccessState extends State<ListOfSUbAccess> {
  var storage = const FlutterSecureStorage();
  UserProfile? userProfile;
  var email;

  List<SubAccessModel> subAccessModel = [];

  Future<List<SubAccessModel>>? subAcessFuture;

  @override
  void initState() {
    super.initState();
    userPersonalData();
  }

  Future userPersonalData() async {
    List ans = await AllDatabase.instance.queryPersonalData();
    userProfile = UserProfile.fromJson(ans[0]);
    setState(() {
      email = userProfile!.email;
    });
    getSubUsers(email);
    subAcessFuture = getLocalDataSubUser();
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
                    Text("SubUsers",
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
      child: FutureBuilder<List<SubAccessModel>>(
        future: subAcessFuture,
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
                  itemCount: subAccessModel.length,
                  itemBuilder: (context, index) {
                    return Card(
                      semanticContainer: true,
                      shadowColor: Colors.grey,
                      child: ListTile(
                        title: Text(subAccessModel[index].name),
                        subtitle: Text(subAccessModel[index].email),
                        trailing: Column(
                          children: [
                            const Text("Owner Name"),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(subAccessModel[index].ownerName),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => SubAccess(
                                        pId: subAccessModel[index].pId,
                                        ownerName:
                                            subAccessModel[index].ownerName,
                                      ))));
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

  Future<String?> getToken() async {
    final token = await storage.read(key: "token");
    return token;
  }

  Future getSubUsers(email) async {
    String? token = await getToken();
    var url = api + 'subfindsubdata/?email=' + email;
    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Token $token',
    });
    if (response.statusCode == 200) {
      List<dynamic> ans = jsonDecode(response.body);
      if (kDebugMode) {
        print(response.body);
      }
      await AllDatabase.instance.deleteSubAccess();

      for (int i = 0; i < ans.length; i++) {
        var query = SubAccessModel(
            id: ans[i]['id'],
            ownerName: ans[i]['owner_name'],
            name: ans[i]['name'],
            user: ans[i]['user'],
            email: ans[i]['email'],
            pId: ans[i]['p_id']);
        await AllDatabase.instance.insertSubAccess(query);
      }
      setState(() {
        subAcessFuture = getLocalDataSubUser();
      });
    } else {
      if (kDebugMode) {
        print(response.statusCode);
      }
    }
  }

  Future<List<SubAccessModel>> getLocalDataSubUser() async {
    List<dynamic> data = await AllDatabase.instance.getAllSUbAccess();
    setState(() {
      subAccessModel =
          data.map((data) => SubAccessModel.fromJson(data)).toList();
    });
    return subAccessModel;
  }
}
