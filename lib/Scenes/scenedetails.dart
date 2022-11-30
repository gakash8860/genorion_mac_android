import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:genorion_mac_android/Models/devicemodel.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../LocalDatabase/alldb.dart';
import '../Models/SceneDevice.dart';
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
  TextEditingController sceneNameController = TextEditingController();
  PlaceType? pt;
  FloorType? fl;
  FlatType? flt;
  String selectedDeviceId="";
  String selectedPinName="";
  List <String>namesDataList = [];
  bool placeremove = false;
  bool slider = false;
  int sliderValue = 0;
  Future? sceneFuture;
  var pinName = List.empty(growable: true);
  bool showOnOffOption = false ;
  List<SceneDevice> sceneDevice = List.empty(growable: true);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sceneFuture = getScene();
    placeVal = placeQueryFunc();
    _alarmTimeString = DateFormat('HH:mm').format(DateTime.now());
    pickedDate = DateTime.now();
    cutDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff121421),
      appBar: AppBar(
        title: Text(widget.sceneName.toString()),

      ),
      body: Container(
        child: SingleChildScrollView(
          child:  placeBool ? changePlace() : sceneDetails(),
        ),
      ),

      floatingActionButton: placeBool ? Container(): FloatingActionButton(
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
  Future<bool> getScene() async {
    String? token = await Utility.getToken();
    int userId = await Utility.getUidShared();
    var url = api + 'scenedevice/?scene_id=' + widget.sceneId;
    final response =
    await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Token $token',
    });
    if (response.statusCode == 201 || response.statusCode == 200) {
      print("Scene Details : ${response.body}");
      List data = jsonDecode(response.body);
      setState(() {
        sceneDevice = data.map((data) => SceneDevice.fromJson(data)).toList();
      });
      return true;
    } else {
      print(response.statusCode);
    }
    return false;
  }
  Future<List<DeviceType>> deviceQueryFunc(id) async {
    List data = await AllDatabase.instance.getDeviceById(id);
    List<DeviceType> deviceType = [];
    setState(() {
      deviceType = data.map((data) => DeviceType.fromJson(data)).toList();
    });

    return deviceType;
  }


  Widget sceneDetails(){
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width,
      height: MediaQuery
          .of(context)
          .size
          .width,
      child: FutureBuilder(
        future:sceneFuture ,
        builder: (context,snapshot){
          return Column(
            children: [
              ListView.builder(
                  itemCount:sceneDevice.length ,
                  shrinkWrap: true,
                  itemBuilder: (context,index){
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Card(
                        semanticContainer: true,
                        shadowColor: Colors.grey,
                        child: ListTile(

                          trailing: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(sceneDevice[index].timing.toString()),
                                IconButton(onPressed: (){

                                }, icon: Icon(Icons.delete))
                              ],
                            ),
                          ),
                          subtitle: Text(sceneDevice[index].date.toString().substring(0,10)),
                          leading: Text(" ${sceneDevice[index].sceneName.toString()}"),
                      title: Text(" ${sceneDevice[index].dId.toString()}"),
                        ),
                      ),
                    );
                  }),
            ],
          );
        },
      ),
    );
  }




  Future<List<String>> devicePinQueryFunc(dId) async {
     pinName = await AllDatabase.instance.getPinNamesByDeviceId(dId);

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
                                                        selectedDeviceId = selectDevice!.dId.toString();
                                                        devicePinNameVal =
                                                            devicePinQueryFunc(
                                                                selectDevice
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
                                    ? listViewPins()
                                    : Container()
          ],
        ),
      ),
    );
  }
  var cutDate;
  TimeOfDay? time;
  var cutTime;
  int checkSwitch = 0;
  String? _alarmTimeString = "";
  DateTime pickedDate = DateTime.now();
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

    setState(() {
      String date2 = pickedDate.toString();
      cutDate = date2.substring(0, 10);
    });
  }

  pickTime(index) async {
    TimeOfDay? time23 = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    // print(time23);
    String time12;
    if (time23 != null) {
      setState(() {
        time = time23;
      });
      time12 = time.toString();
      cutTime = time12.substring(10, 15);
      setState(() {
        _alarmTimeString = cutTime;
      });
    }
  }
  Widget selectTime(){
    return  Container(
        width: MediaQuery.of(context).size.width,

        child: Column(children: [
          SizedBox(height: 45,),
          SizedBox(
            child: GestureDetector(
                child: Text(
                  cutDate.toString(),
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  pickDate();
                }),
          ),
          SizedBox(height: 15,),
          // ignore: deprecated_member_use
          GestureDetector(
            onTap: () async {
              await pickTime(0);
              setState(() {
                _alarmTimeString = cutTime;
              });
            },
            child: Text(
              _alarmTimeString!,
              style: const TextStyle(
                fontSize: 32,
                color: Colors.white
              ),
            ),
          ),
        ]));
  }

  List<int> value= List.filled(20,0);
  Future<void> addSceneDetails(value) async {
    String? token = await Utility.getToken();
    int userId = await Utility.getUidShared();
    var url = api + 'scenedevice/';
    Map data = {
      "scene_id": widget.sceneId.toString(),
      "d_id": selectedDeviceId.toString(),
      "sceneName":sceneNameController.text,
      "status1": value[0],
      "status2": value[1],
      "status3": value[2],
      "status4": value[3],
      "status5": value[4],
      "status6": value[5],
      "status7": value[6],
      "status8": value[7],
      "status9": value[8],
      "status10": value[9],
      "status11": value[10],
      "status12": value[11],
      "status13": value[12],
      "status14": value[13],
      "status15": value[14],
      "status16": value[15],
      "status17": value[16],
      "status18": value[17],
      "status19": value[18],
      "status20": value[19],
      "date":cutDate,
      "timing":cutTime
    };
    final response =
    await http.post(Uri.parse(url), body: jsonEncode(data), headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Token $token',
    });
    if (response.statusCode == 201 || response.statusCode == 200) {
      print("response.body ${response.body}");
      Navigator.pop(context);

    } else {
      Utility.exitScreen(context, "Please Create Scene for another device", "Scene is already created");
      print(response.statusCode);
      print(response.body);
    }
  }

  List<bool> color = List.filled( 12, false);
  List<bool> colorFalse = List.filled( 12, false);
  Widget listViewPins(){
   return Column(
     children: [
       selectTime(),
       Container(
         width: 345,
         color: Colors.white,
         child: TextField(
           decoration: InputDecoration(
             filled: true,
             fillColor: Colors.white,
             hintText: 'Enter Scene Name',
           ),
           controller:sceneNameController,
           style: const TextStyle(fontSize: 18, color: Colors.black54),

         ),
       ),
       ListView.builder(
         padding: const EdgeInsets.all(4),
         shrinkWrap: true,
         itemCount: namesDataList.length,
         itemBuilder: (BuildContext context, int index) {
           return Card(
             child: Row(
               children: [
                 Container(
                   color: Colors.green,
                   width:110,
                   height: 50,
                   child: Center(child: Text(namesDataList[index],style: TextStyle(color: Colors.black),)),
                 ),
                 SizedBox(width: 10,),
                 MaterialButton(color: color[index]?Colors.green:Colors.red ,onPressed: (){
                   setState(() {
                     color[index] = !color[index];
                   });
                   if(color[index]){
                     value[index] = 1;
                   }
                   print( value[index]);
                 }, child: Text("On "),),
                 SizedBox(width: 10,),
                 MaterialButton(color: colorFalse[index] == false?Colors.red:Colors.yellow ,onPressed: (){
                   setState(() {
                     colorFalse[index] = ! colorFalse[index];
                   });
                   if(colorFalse[index] == false){
                     value[index] =0;
                   }
                 }, child: Text("Off "),),

               ],
             ),
           );
         }
     ),

       MaterialButton(color: Colors.white ,onPressed: ()async{
         setState(() {
           // placeBool = ! placeBool;
           // showOnOffOption = ! showOnOffOption;
         });
         await addSceneDetails(value);

       }, child: Text("Done "),),]
   );
  }


}
