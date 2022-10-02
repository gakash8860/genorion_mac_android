import 'dart:convert';
import 'dart:ffi';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:genorion_mac_android/Models/devicemodel.dart';
import 'package:genorion_mac_android/Models/pinname.dart';
import 'package:http/http.dart' as http;

import '../LocalDatabase/alldb.dart';
import '../Models/flatmodel.dart';
import '../Models/floormodel.dart';
import '../Models/placemodel.dart';
import '../Models/roommodel.dart';
import '../ProfilePage/utility.dart';
import '../main.dart';

class SceneDetails extends StatefulWidget {
  final sceneName;
  final sceneId;

  const SceneDetails({Key? key, this.sceneName, this.sceneId})
      : super(key: key);

  @override
  State<SceneDetails> createState() => _SceneDetailsState();
}

class _SceneDetailsState extends State<SceneDetails> {
  bool placeBool = false;
  bool floorBool = false;
  bool roomBool = false;
  bool deviceBool = false;
  bool pinBoolBool = false;
  bool flatBool = false;
  bool pinNameBool = false;
  Future<List<PlaceType>>? placeVal;
  Future<List<FloorType>>? floorVal;
  Future<List<FlatType>>? flatVal;
  Future<List<RoomType>>? roomVal;
  Future<List<DeviceType>>? deviceVal;
  Future<List<String>>? devicePinNameVal;
  PlaceType? pt;
  FloorType? fl;
  FlatType? flt;
  List <String>pinName = [];
  List <String>namesDataList = [];
  bool placeremove = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    placeVal = placeQueryFunc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.sceneName.toString()),
      ),
      body: placeBool ? changePlace() : Container(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          setState(() {
            placeBool = !placeBool;
            placeremove = true;
          });
        },
      ),
    );
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

  Future<List<FlatType>> flatQueryFunc(id) async {
    List data = await AllDatabase.instance.getFlatByFId(id);
    List<FlatType> flatType = [];
    setState(() {
      flatType = data.map((data) => FlatType.fromJson(data)).toList();
    });

    return flatType;
  }

  Future<List<RoomType>> roomQueryFunc(id) async {
    List data = await AllDatabase.instance.getRoomById(id);
    List<RoomType> roomType = [];
    setState(() {
      roomType = data.map((data) => RoomType.fromJson(data)).toList();
    });

    return roomType;
  }

  Future<List<DeviceType>> deviceQueryFunc(id) async {
    List data = await AllDatabase.instance.getDeviceById(id);
    List<DeviceType> deviceType = [];
    setState(() {
      deviceType = data.map((data) => DeviceType.fromJson(data)).toList();
    });

    return deviceType;
  }

  // Future<List<String>> devicePinQueryFunc(id) async {
  //   List data = await AllDatabase.instance.getPinNamesByDeviceId(id);
  //   List<DevicePinName> deviceType = [];
  //   setState(() {
  //     deviceType = data.map((data) => DevicePinName.fromJson(data)).toList();
  //     pinName = [
  //       deviceType[0].pin1Name,
  //       deviceType[0].pin2Name,
  //       deviceType[0].pin3Name,
  //       deviceType[0].pin4Name,
  //       deviceType[0].pin5Name,
  //       deviceType[0].pin6Name,
  //       deviceType[0].pin7Name,
  //       deviceType[0].pin8Name,
  //       deviceType[0].pin9Name,
  //       deviceType[0].pin10Name,
  //
  //     ];
  //
  //   });
  //   print("pinName[0] ${pinName[0]}");
  //
  //
  //   return pinName;
  // }



  Future<List<String>> devicePinQueryFunc(dId) async {
    List pinName = await AllDatabase.instance.getPinNamesByDeviceId(dId);

    if (pinName.isNotEmpty) {
      setState(() {
        namesDataList = [
          pinName[0]['pin1Name'],
          pinName[0]['pin2Name'],
          pinName[0]['pin3Name'],
          pinName[0]['pin4Name'],
          pinName[0]['pin5Name'],
          pinName[0]['pin6Name'],
          pinName[0]['pin7Name'],
          pinName[0]['pin8Name'],
          pinName[0]['pin9Name'],
          pinName[0]['pin10Name'],
          pinName[0]['pin11Name'],
          pinName[0]['pin12Name'],
        ];
      });


      String pin1 = pinName[0]['pin1Name'];

      var indexOfPin1Name = pin1.indexOf(',');
      var pin1FinalName = pin1.substring(0, indexOfPin1Name);


      String pin2 = pinName[0]['pin2Name'];
      var indexOfPin2Name = pin2.indexOf(',');
      var pin2FinalName = pin2.substring(0, indexOfPin2Name);


      String pin3 = pinName[0]['pin3Name'];
      var indexOfPin3Name = pin3.indexOf(',');
      var pin3FinalName = pin3.substring(0, indexOfPin3Name);


      String pin4 = pinName[0]['pin4Name'];
      var indexOfPin4Name = pin4.indexOf(',');
      var pin4FinalName = pin4.substring(0, indexOfPin4Name);

      String pin5 = pinName[0]['pin5Name'];
      var indexOfPin5Name = pin5.indexOf(',');
      var pin5FinalName = pin5.substring(0, indexOfPin5Name);

      String pin6 = pinName[0]['pin6Name'];
      var indexOfPin6Name = pin6.indexOf(',');
      var pin6FinalName = pin6.substring(0, indexOfPin6Name);

      String pin7 = pinName[0]['pin7Name'];
      var indexOfPin7Name = pin7.indexOf(',');
      var pin7FinalName = pin7.substring(0, indexOfPin7Name);

      String pin8 = pinName[0]['pin8Name'];
      var indexOfPin8Name = pin8.indexOf(',');
      var pin8FinalName = pin8.substring(0, indexOfPin8Name);

      String pin9 = pinName[0]['pin9Name'];
      var indexOfPin9Name = pin9.indexOf(',');
      var pin9FinalName = pin9.substring(0, indexOfPin9Name);

      String pin10 = pinName[0]['pin10Name'];
      var indexOfPin10Name = pin10.indexOf(',');
      var pin10FinalName = pin9.substring(0, indexOfPin10Name);

      String pin11 = pinName[0]['pin11Name'];
      var indexOfPin11Name = pin11.indexOf(',');
      var pin11FinalName = pin11.substring(0, indexOfPin11Name);

      String pin12 = pinName[0]['pin12Name'];
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

      return namesDataList;
    }
  return namesDataList;

  }

  Widget changePlace() {
    return Container(
      margin: const EdgeInsets.only(bottom: 45),
      child: SingleChildScrollView(
        child: Column(
          children: [
            placeremove
                ? Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: FutureBuilder<List<PlaceType>>(
                        future: placeVal,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data!.isEmpty) {
                              return const Center(
                                  child: Text("No Devices on this place"));
                            }
                            return Container(
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
                                        floorVal =
                                            floorQueryFunc(selectPlace!.pId);
                                        pt = selectPlace;
                                        placeremove = false;
                                        floorBool = !floorBool;
                                      });
                                    },
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
                        }),
                  )
                : floorBool
                    ? Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: FutureBuilder<List<FloorType>>(
                            future: floorVal,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                if (snapshot.data!.isEmpty) {
                                  return const Center(
                                      child: Text("No Devices on this place"));
                                }
                                return Container(
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
                                      child: DropdownButtonFormField<FloorType>(
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
                                        hint: const Text('Select Floor'),
                                        isExpanded: true,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        items:
                                            snapshot.data!.map((selectedfloor) {
                                          return DropdownMenuItem<FloorType>(
                                            value: selectedfloor,
                                            child: Text(selectedfloor.fName),
                                          );
                                        }).toList(),
                                        onChanged: (selectFloor) {
                                          setState(() {
                                            flatVal =
                                                flatQueryFunc(selectFloor!.fId);
                                            fl = selectFloor;
                                            floorBool = false;
                                            flatBool = !flatBool;
                                            print("FLAT BOOL $flatBool");
                                          });
                                        },
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
                            }),
                      )
                    : flatBool
                        ? Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: FutureBuilder<List<FlatType>>(
                                future: flatVal,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    if (snapshot.data!.isEmpty) {
                                      return const Center(
                                          child:
                                              Text("No Devices on this place"));
                                    }
                                    return Container(
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
                                              DropdownButtonFormField<FlatType>(
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
                                            hint: const Text('Select Flat'),
                                            isExpanded: true,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            items: snapshot.data!
                                                .map((selectedflat) {
                                              return DropdownMenuItem<FlatType>(
                                                value: selectedflat,
                                                child:
                                                    Text(selectedflat.fltName),
                                              );
                                            }).toList(),
                                            onChanged: (selectFlat) {
                                              setState(() {
                                                flt = selectFlat;
                                                flatBool = false;
                                                roomBool = true;
                                                roomVal = roomQueryFunc(
                                                    selectFlat!.fltId);
                                              });
                                            },
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
                                }),
                          )
                        : roomBool
                            ? Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: FutureBuilder<List<RoomType>>(
                                    future: roomVal,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        if (snapshot.data!.isEmpty) {
                                          return const Center(
                                              child: Text(
                                                  "No Devices on this place"));
                                        }
                                        return Container(
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
                                                  RoomType>(
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
                                                hint: const Text('Select Room'),
                                                isExpanded: true,
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                items: snapshot.data!
                                                    .map((selectedRoom) {
                                                  return DropdownMenuItem<
                                                      RoomType>(
                                                    value: selectedRoom,
                                                    child: Text(
                                                        selectedRoom.rName),
                                                  );
                                                }).toList(),
                                                onChanged: (selectRoom) {
                                                  setState(() {
                                                    roomBool = false;
                                                    deviceVal = deviceQueryFunc(
                                                        selectRoom!.rId
                                                            .toString());
                                                    deviceBool = true;
                                                  });
                                                },
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
                                    }),
                              )
                            : deviceBool
                                ? Padding(
                                    padding: const EdgeInsets.all(18.0),
                                    child: FutureBuilder<List<DeviceType>>(
                                        future: deviceVal,
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            if (snapshot.data!.isEmpty) {
                                              return const Center(
                                                  child: Text(
                                                      "No Devices on this place"));
                                            }
                                            return Container(
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
                                                            offset:
                                                                Offset(20, 20))
                                                      ],
                                                      border: Border.all(
                                                        color: Colors.black,
                                                        width: 0.5,
                                                      )),
                                                  child:
                                                      DropdownButtonFormField<
                                                          DeviceType>(
                                                    decoration: InputDecoration(
                                                      contentPadding:
                                                          const EdgeInsets.all(
                                                              15),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                                color: Colors
                                                                    .white),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      enabledBorder:
                                                          UnderlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                                color: Colors
                                                                    .black),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50),
                                                      ),
                                                    ),
                                                    dropdownColor:
                                                        Colors.white70,
                                                    icon: const Icon(
                                                        Icons.arrow_drop_down),
                                                    iconSize: 28,
                                                    hint: const Text(
                                                        'Select Device'),
                                                    isExpanded: true,
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                                    onChanged: (selectDevice) {
                                                      setState(() {
                                                        deviceBool = false;
                                                        pinBoolBool = true;
                                                        devicePinNameVal =
                                                            devicePinQueryFunc(
                                                                selectDevice!
                                                                    .dId);
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ),
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 10),
                                            );
                                          } else {
                                            return const Center(
                                                child:
                                                    CircularProgressIndicator());
                                          }
                                        }),
                                  )
                                : pinBoolBool
                                    ?  Padding(
              padding: const EdgeInsets.all(18.0),
              child: FutureBuilder<List<String>>(
                  future: devicePinNameVal,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.isEmpty) {
                        return const Center(
                            child: Text(
                                "No Devices on this place"));
                      }
                      return Container(
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
                                      offset:
                                      Offset(20, 20))
                                ],
                                border: Border.all(
                                  color: Colors.black,
                                  width: 0.5,
                                )),
                            child:
                            DropdownButtonFormField<
                                String>(
                              decoration: InputDecoration(
                                contentPadding:
                                const EdgeInsets.all(
                                    15),
                                focusedBorder:
                                OutlineInputBorder(
                                  borderSide:
                                  const BorderSide(
                                      color: Colors
                                          .white),
                                  borderRadius:
                                  BorderRadius
                                      .circular(10),
                                ),
                                enabledBorder:
                                UnderlineInputBorder(
                                  borderSide:
                                  const BorderSide(
                                      color: Colors
                                          .black),
                                  borderRadius:
                                  BorderRadius
                                      .circular(50),
                                ),
                              ),
                              dropdownColor:
                              Colors.white70,
                              icon: const Icon(
                                  Icons.arrow_drop_down),
                              iconSize: 28,
                              hint: const Text(
                                  'Select Device'),
                              isExpanded: true,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight:
                                FontWeight.bold,
                              ),
                              items: namesDataList.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value.trim(),style:TextStyle(color:Colors.black),),
                                );
                              }).toList(),
                              onChanged: (selectDevice) {
                                setState(() {
                                  deviceBool = false;
                                  pinBoolBool = true;

                                });
                              },
                            ),
                          ),
                        ),
                        margin:
                        const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 10),
                      );
                    } else {
                      return const Center(
                          child:
                          CircularProgressIndicator());
                    }
                  }),
            )
                                    : Container()
          ],
        ),
      ),
    );
  }



  Future<void> addSceneDetails(String sceneName) async {
    String? token = await Utility.getToken();
    int userId = await Utility.getUidShared();
    print("TOKEEE $token");
    print("WREQWEDFSE ${userId}");
    var url = api + 'scenedetail/';
    Map data = {
      "scene_id": widget.sceneId,
      "d_id": "fsdaf",
      "scene_device_type": "ddsaf",
      "status": 2
    };

    final response =
    await http.post(Uri.parse(url), body: jsonEncode(data), headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Token $token',
    });
    if (response.statusCode == 201 || response.statusCode == 200) {
      print("response.body ${response.body}");

    } else {
      print(response.statusCode);
    }
  }




}
