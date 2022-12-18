// ignore_for_file: prefer_typing_uninitialized_variables, deprecated_member_use

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:genorion_mac_android/Models/devicemodel.dart';
import 'package:genorion_mac_android/Models/flatmodel.dart';
import 'package:genorion_mac_android/Models/floormodel.dart';
import 'package:genorion_mac_android/Models/roommodel.dart';
import 'package:genorion_mac_android/Models/tempuser.dart';
import 'package:genorion_mac_android/Models/userprofike.dart';
import 'package:genorion_mac_android/ProfilePage/utility.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../LocalDatabase/alldb.dart';
import '../Models/placemodel.dart';
import '../main.dart';

class AddTempUser extends StatefulWidget {
  const AddTempUser({Key? key}) : super(key: key);

  @override
  _AddTempUserState createState() => _AddTempUserState();
}

class _AddTempUserState extends State<AddTempUser> {
  DateTime pickedDate = DateTime.now();
  TimeOfDay pickedTime = TimeOfDay.now();
  var cutDate;
  var cutTime;
  Future<List<PlaceType>>? placeVal;
  Future<List<FloorType>>? floorVal;
  Future<List<FlatType>>? flatVal;
  Future<List<RoomType>>? roomVal;
  Future<List<DeviceType>>? deviceVal;
  final storage = const FlutterSecureStorage();
  bool changeplace = true;
  bool changeFloor = true;
  bool changeFlat = true;
  bool changeroom = true;
  bool changeDevice = true;
  bool loader = false;
  var assignFloorId;
  var assignFlatId;
  var assignRoomId;
  var assignDeviceId;
  var assignTempUserPlaceId;
  UserProfile? userProfile;
  int getUidVariable2 = 0;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    pickedDate = DateTime.now();
    pickedTime = TimeOfDay.now();
    placeVal = placeQueryFunc();
    getUidShared();
    userPersonalData();
  }



  Future<String?> getToken() async {
    final tokenVar = await storage.read(key: "token");

    return tokenVar;
  }

  pickDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: pickedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      setState(() {
        pickedDate = date;
      });
    }
    String date2 = pickedDate.toString();
    cutDate = date2.substring(0, 10);
  }

  pickTime() async {
    TimeOfDay? time =
        await showTimePicker(context: context, initialTime: pickedTime);
    if (time != null) {
      setState(() {
        pickedTime = time;
      });
    }
    String se = pickedTime.toString();
    cutTime = se.substring(10, 15);
  }

  Future<List<PlaceType>> placeQueryFunc() async {
    List data = await AllDatabase.instance.queryPlace();
    List<PlaceType> placeType = [];
    setState(() {
      placeType = data.map((data) => PlaceType.fromJson(data)).toList();
    });

    return placeType;
  }

  Future<List<FloorType>> floorQueryFunc(id) async {
    List data = await AllDatabase.instance.getFloorById(id);
    List<FloorType> floorType = [];
    setState(() {
      floorType = data.map((data) => FloorType.fromJson(data)).toList();
    });
    return floorType;
  }

  Future<List<FlatType>> flatQuery(id) async {
    List data = await AllDatabase.instance.getFlatByFId(id);
    List<FlatType> flt = [];
    setState(() {
      flt = data.map((data) => FlatType.fromJson(data)).toList();
    });
    return flt;
  }

  Future<List<RoomType>> roomQuery(id) async {
    List data = await AllDatabase.instance.getRoomById(id);
    List<RoomType> rm = [];
    setState(() {
      rm = data.map((data) => RoomType.fromJson(data)).toList();
    });
    return rm;
  }

  Future<List<DeviceType>> deviceQuery(id) async {
    List data = await AllDatabase.instance.getDeviceById(id);
    List<DeviceType> device = [];
    setState(() {
      device = data.map((data) => DeviceType.fromJson(data)).toList();
    });
    return device;
  }

  userPersonalData() async {
    List ans = await AllDatabase.instance.queryPersonalData();
    userProfile = UserProfile.fromJson(ans[0]);
  }

  getUidShared() async {
    final SharedPreferences prefs = await _prefs;
    final a = prefs.getInt("uid");
    setState(() {
      getUidVariable2 = a!;
    });
  }

  Future addTempUser() async {
    String? token = await getToken();
    const url = api + 'giveaccesstotempuser/';

    var postData;
    if (assignTempUserPlaceId != null) {
      postData = {
        "owner_name": userProfile!.firstName + " " + userProfile!.lastName,
        "user": getUidVariable2,
        "p_id": assignTempUserPlaceId.toString(),
        "name": nameController.text,
        "email": emailController.text,
        "mobile": phoneController.text,
        "timing": cutTime.toString(),
        "date": cutDate.toString(),
      };
    } else if (assignFloorId != null) {
      postData = {
        "name": nameController.text,
        "email": emailController.text,
        "mobile": phoneController.text,
        "user": getUidVariable2,
        "owner_name": userProfile!.firstName + " " + userProfile!.lastName,
        "timing": cutTime.toString(),
        "date": cutDate.toString(),
        "f_id": assignFloorId.toString(),
      };
    } else if (assignFlatId != null) {
      postData = {
        "user": getUidVariable2,
        "owner_name": userProfile!.firstName + " " + userProfile!.lastName,
        "name": nameController.text,
        "email": emailController.text,
        "mobile": phoneController.text,
        "timing": cutTime.toString(),
        "date": cutDate.toString(),
        "flt_id": assignFlatId.toString(),
      };
    } else if (assignRoomId != null) {
      postData = {
        "user": getUidVariable2,
        "owner_name": userProfile!.firstName + " " + userProfile!.lastName,
        "name": nameController.text,
        "email": emailController.text,
        "mobile": phoneController.text,
        "timing": cutTime.toString(),
        "date": cutDate.toString(),
        "r_id": assignRoomId.toString(),
        // "d_id":""
      };
    }

    final response =
        await http.post(Uri.parse(url), body: jsonEncode(postData), headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Token $token',
    });

    if (response.statusCode == 200 || response.statusCode == 201) {
      setState(() {
        loader = ! loader;
      });
      await getTempUser();
      const snackBar = SnackBar(
        content: Text('Temp User Added'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.pop(context);
    } else {
      setState(() {
        loader = ! loader;
      });
      if (kDebugMode) {
        print(response.statusCode);
        print(response.body);
      }
    }
  }

  Future getTempUser() async {
    String? token = await getToken();
    const url = api + "getalldatayouaddedtempuser/";
    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Token $token',
    });
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      await AllDatabase.instance.deleteAllTempUser();
      for (int i = 0; i < data.length; i++) {
        TempUserDetails temp = TempUserDetails.fromJson(data[i]);
        await AllDatabase.instance.insertTempUserData(temp);
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

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
                        setState(() {
                          loader = false;
                        });
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      )),
                  Row(
                    children: const [
                      Text("Add Temp User",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(
                    height: 35,
                    width: 35,
                    child: Center(
                        // child: Icon(
                        //   Icons.add,
                        //   color: Colors.white,
                        // ),
                        ),
                  ),
                ],
              ),
            ),
     
            emailSend(),
            const SizedBox(
              height: 12,
            ),
            Container(
                margin: const EdgeInsets.only(left: 35, right: 25),
                height: MediaQuery.of(context).size.height / 15,
                width: 44,
                child: Card(
                  child: GestureDetector(
                    onTap: pickDate,
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(45),
                          ),
                          child: Text(
                            "Date:${pickedDate.day}/${pickedDate.month}/${pickedDate.year}",
                            textAlign: TextAlign.start,
                          ),
                        )),
                  ),
                )),
            Container(
                margin: const EdgeInsets.only(left: 35, right: 25),
                height: MediaQuery.of(context).size.height / 15,
                width: 44,
                child: Card(
                  child: GestureDetector(
                    onTap: pickTime,
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(45),
                            ),
                            child: Text(
                              "Time :${pickedTime.hour}:${pickedTime.minute}",
                            ))),
                  ),
                )),
           
            changePlace()
          ],
        ),
      ),
    );
  }

  Widget emailSend() {
    return Column(
      children: [
        const SizedBox(
          height: 2,
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 28,
            right: 18,
            top: 36,
          ),
          child: TextFormField(
            autofocus: true,
            textInputAction: TextInputAction.next,
            controller: nameController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: 'Enter Name for Temp User',
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
            top: 16,
          ),
          child: TextFormField(
            autofocus: true,
            textInputAction: TextInputAction.next,
            controller: emailController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            // validator: nameValid,
            keyboardType: TextInputType.emailAddress,

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
            top: 16,
          ),
          child: TextFormField(
            autofocus: true,
            controller: phoneController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: 'Enter Phone for Temp User',
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
      ],
    );
  }

  Widget changePlace() {
    return Container(
      margin: const EdgeInsets.only(bottom: 45),
      child: Column(
        children: [
          changeplace
              ? FutureBuilder<List<PlaceType>>(
                  future: placeVal,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.isEmpty) {
                        return const Center(
                            child: Text("No Devices on this place"));
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
                                dropdownColor: Colors.white70,
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
                                    changeplace = false;
                                    assignTempUserPlaceId = selectPlace!.pId;
                                    floorVal = floorQueryFunc(selectPlace.pId);
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
                  })
              : changeFloor
                  ? FutureBuilder<List<FloorType>>(
                      future: floorVal,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data!.isEmpty) {
                            return const Center(
                                child: Text("No Devices on this place"));
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
                                  child: DropdownButtonFormField<FloorType>(
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.all(15),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.white),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.black),
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                    ),
                                    dropdownColor: Colors.white70,
                                    icon: const Icon(Icons.arrow_drop_down),
                                    iconSize: 28,
                                    hint: const Text('Select Floor'),
                                    isExpanded: true,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    items: snapshot.data!.map((selectedPlace) {
                                      return DropdownMenuItem<FloorType>(
                                        value: selectedPlace,
                                        child: Text(selectedPlace.fName),
                                      );
                                    }).toList(),
                                    onChanged: (selectPlace) {
                                      setState(() {
                                        changeFloor = false;
                                        assignTempUserPlaceId = null;
                                        assignFloorId = selectPlace!.fId;
                                        flatVal = flatQuery(selectPlace.fId);
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
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      })
                  : changeFlat
                      ? FutureBuilder<List<FlatType>>(
                          future: flatVal,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              if (snapshot.data!.isEmpty) {
                                return const Center(
                                    child: Text("No Devices on this place"));
                              }
                              return Container(
                                child: Padding(
                                  padding: const EdgeInsets.all(41.0),
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: 50.0,
                                    child: Container(
                                      width:
                                          MediaQuery.of(context).size.width * 2,
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
                                      child: DropdownButtonFormField<FlatType>(
                                        decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.all(15),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.white),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.black),
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                        ),
                                        dropdownColor: Colors.white70,
                                        icon: const Icon(Icons.arrow_drop_down),
                                        iconSize: 28,
                                        hint: const Text('Select Flat'),
                                        isExpanded: true,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        items:
                                            snapshot.data!.map((selectedFlat) {
                                          return DropdownMenuItem<FlatType>(
                                            value: selectedFlat,
                                            child: Text(selectedFlat.fltName),
                                          );
                                        }).toList(),
                                        onChanged: (selectedflat) {
                                          setState(() {
                                            changeFlat = false;
                                            assignTempUserPlaceId = null;
                                            assignFloorId = null;
                                            assignFlatId = selectedflat!.fltId;
                                            roomVal =
                                                roomQuery(selectedflat.fltId);
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
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                          })
                      : changeroom
                          ? FutureBuilder<List<RoomType>>(
                              future: roomVal,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  if (snapshot.data!.isEmpty) {
                                    return const Center(
                                        child:
                                            Text("No Devices on this place"));
                                  }
                                  return Container(
                                    child: Padding(
                                      padding: const EdgeInsets.all(41.0),
                                      child: SizedBox(
                                        width: double.infinity,
                                        height: 50.0,
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              2,
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
                                          child:
                                              DropdownButtonFormField<RoomType>(
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.all(15),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.white),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.black),
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                              ),
                                            ),
                                            dropdownColor: Colors.white70,
                                            icon: const Icon(
                                                Icons.arrow_drop_down),
                                            iconSize: 28,
                                            hint: const Text('Select Room'),
                                            isExpanded: true,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            items: snapshot.data!
                                                .map((selectedRoom) {
                                              return DropdownMenuItem<RoomType>(
                                                value: selectedRoom,
                                                child: Text(selectedRoom.rName),
                                              );
                                            }).toList(),
                                            onChanged: (selectroom) {
                                              setState(() {
                                                changeroom = false;
                                                assignTempUserPlaceId = null;
                                                assignFloorId = null;
                                                assignFlatId = null;
                                                assignRoomId = selectroom!.rId;
                                                deviceVal =
                                                    deviceQuery(selectroom.rId);
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
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                              })
                          : changeDevice
                              ? FutureBuilder<List<DeviceType>>(
                                  future: deviceVal,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      if (snapshot.data!.isEmpty) {
                                        return const Center(
                                            child: Text(
                                                "No Devices on this place"));
                                      }
                                      return Container(
                                        child: Padding(
                                          padding: const EdgeInsets.all(41.0),
                                          child: SizedBox(
                                            width: double.infinity,
                                            height: 50.0,
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  2,
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
                                              child: DropdownButtonFormField<
                                                  DeviceType>(
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      const EdgeInsets.all(15),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            color:
                                                                Colors.white),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  enabledBorder:
                                                      UnderlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            color:
                                                                Colors.black),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                  ),
                                                ),
                                                dropdownColor: Colors.white70,
                                                icon: const Icon(
                                                    Icons.arrow_drop_down),
                                                iconSize: 28,
                                                hint:
                                                    const Text('Select Device'),
                                                isExpanded: true,
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                items: snapshot.data!
                                                    .map((selectedDevice) {
                                                  return DropdownMenuItem<
                                                      DeviceType>(
                                                    value: selectedDevice,
                                                    child: Text(
                                                        selectedDevice.dId),
                                                  );
                                                }).toList(),
                                                onChanged: (selectroom) {
                                                  setState(() {});
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 10),
                                      );
                                    } else {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    }
                                  })
                              : const Center(
                                  child: CircularProgressIndicator(),
                                ),
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
                  loader = ! loader;
                });
                await addTempUser();
              }),
        ],
      ),
    );
  }



}
