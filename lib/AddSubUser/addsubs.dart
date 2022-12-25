// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:genorion_mac_android/AddSubUser/showsub.dart';
import 'package:genorion_mac_android/Models/userprofike.dart';
import 'package:genorion_mac_android/ProfilePage/utility.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../LocalDatabase/alldb.dart';
import '../Models/placemodel.dart';
import '../Models/subuser.dart';
import '../main.dart';

class AddSubUser extends StatefulWidget {
  const AddSubUser({Key? key}) : super(key: key);

  @override
  _AddSubUserState createState() => _AddSubUserState();
}

class _AddSubUserState extends State<AddSubUser> {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  var storage = const FlutterSecureStorage();
  List<PlaceType> placeType = [];
  Future<List<PlaceType>>? placeVal;
  bool changeWidget = false;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  UserProfile? userProfile;
  int getUidVariable2 = 0;

  var assignedPlace;
  @override
  void initState() {
    super.initState();
    getToken();
    getUidShared();
    placeVal = placeQueryFunc();
    userPersonalData();
  }

  Future<String?> getToken() async {
    final token = await storage.read(key: "token");
    return token;
  }

  userPersonalData() async {
    List ans = await AllDatabase.instance.queryPersonalData();
    userProfile = UserProfile.fromJson(ans[0]);
  }

  Future addSubUser(String data) async {
    String? token = await getToken();
    const url = api + 'subuseraccess/';
    var postData = {
      "emailtest": data, 
      
      "email": data
      
      };
    final response =
        await http.post(Uri.parse(url), body: jsonEncode(postData), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Token $token',
    });

    if (response.statusCode == 201) {

      setState(() {
        loader = !loader;
        changeWidget = true;
      });

      const snackBar = SnackBar(
        content: Text('SubUser Added'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      var res = jsonDecode(response.body);
      if (res
          .toString()
          .contains("subuseraccess with this email already exists.")) {
        _showDialog(context);
      }
      if (kDebugMode) {
        print(response.statusCode);
        print(response.body);
      }
    }
  }

  Future<List<PlaceType>> placeQueryFunc() async {
    List data = await AllDatabase.instance.queryPlace();

    setState(() {
      placeType = data.map((data) => PlaceType.fromJson(data)).toList();
    });

    return placeType;
  }

  getUidShared() async {
    final SharedPreferences prefs = await _prefs;
    final a = prefs.getInt("uid");
    setState(() {
      getUidVariable2 = a!;
    });
  }

  Future _assignPlace() async {
    String? token = await getToken();
    const url = api + 'subuserpalceaccess/';
    var postData = {

      "user": getUidVariable2,

      "email": emailController.text,
      "p_id": assignedPlace,
      "name": nameController.text,
      
      "owner_name": userProfile!.firstName + " " + userProfile!.lastName
    };
    final response = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Token $token',
        },
        body: jsonEncode(postData));
    if (response.statusCode == 201) {
      setState(() {
        loader = !loader;
      });
      const snackBar = SnackBar(
        content: Text('Place Assigned'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ShowAndAddSubUser()));
      await getSubUsers();
    } else {
      setState(() {
        loader = !loader;
      });
    }
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
      if (ans.isNotEmpty) {
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
      }
      if (kDebugMode) {
        print(response.body);
      }
    } else {
      if (kDebugMode) {
        print(response.statusCode);
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
              top: 26,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  child: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                  onTap: () {
                    Navigator.of(context);
                  },
                ),
                Row(
                  children: const [
                    Text("Add SubUser",
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
          changeWidget ? assignPlace() : emailSend()
        ],
      )),
    );
  }
  bool loader = false;
  Widget emailSend() {

    return Column(
      children: [
        const SizedBox(
          height: 135,
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 28,
            right: 18,
            top: 56,
          ),
          child: TextFormField(
            autofocus: true,
            textInputAction: TextInputAction.next,

            autovalidateMode: AutovalidateMode.onUserInteraction,
            // validator: nameValid,
            keyboardType: TextInputType.emailAddress,
            controller: emailController,

            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: 'Enter Email for SubUser',
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
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 28,
            right: 18,
            top: 26,
          ),
          child: TextFormField(
            autofocus: true,
            textInputAction: TextInputAction.next,

            autovalidateMode: AutovalidateMode.onUserInteraction,
            // validator: nameValid,
            keyboardType: TextInputType.text,
            controller: nameController,

            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: 'Enter Name for SubUser',
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
        ),
        const SizedBox(
          height: 35,
        ),
        // ignore: deprecated_member_use
        loader?Utility.circularIndicator(): ElevatedButton(
            child: const Text(
              'Submit',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            onPressed: () async {
              setState(() {
                loader = !loader;
              });
              await addSubUser(emailController.text);

            }),
      ],
    );
  }

  Widget assignPlace() {
    return SizedBox(
      child: Center(
        child: Column(
          children: [
            FutureBuilder<List<PlaceType>>(
                future: placeVal,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.isEmpty) {
                      return const Center(child: Text("No  place"));
                    }
                    return Container(
                      child: Padding(
                        padding: const EdgeInsets.all(41.0),
                        child: SizedBox(
                          width: double.infinity,
                          height: 50.0,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 2,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: const [
                                  BoxShadow(
                                      color: Colors.black,
                                      blurRadius: 30,
                                      offset: Offset(20, 20))
                                ],
                                border: Border.all(
                                  color: Colors.black,
                                  width: 0.5,
                                )),
                            child: DropdownButtonFormField<PlaceType>(
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(15),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                              dropdownColor: dropDownColor,
                              icon: const Icon(Icons.arrow_drop_down),
                              iconSize: 28,
                              hint: const Text('Select Place'),
                              isExpanded: true,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              items: snapshot.data!.map((selectedPlace) {
                                return DropdownMenuItem<PlaceType>(
                                  value: selectedPlace,
                                  child: Text(selectedPlace.pType),
                                );
                              }).toList(),
                              onChanged: (selectPlace) {
                                setState(() {
                                  assignedPlace = selectPlace!.pId;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                }),
            // ignore: deprecated_member_use
            loader?Utility.circularIndicator():ElevatedButton(
                child: const Text(
                  'Submit',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                // shape: OutlineInputBorder(
                //   borderSide: const BorderSide(color: Colors.white, width: 2),
                //   borderRadius: BorderRadius.circular(90),
                // ),
                // padding: const EdgeInsets.all(15),
                // textColor: Colors.white,
                onPressed: () async {
                  setState(() {
                    loader = !loader;
                  });
                  await _assignPlace();
                }),
          ],
        ),
      ),
    );
  
  }

  _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Alert"),
        content: const Text("subuseraccess with this email already exists."),
        actions: <Widget>[
          // ignore: deprecated_member_use
          ElevatedButton(
              child: const Text("Ok"),
              onPressed: () {
                setState(() {
                    loader = !loader;

                  changeWidget = true;
                });
                Navigator.of(context).pop();
              }),
        ],
      ),
    );
  }


}
