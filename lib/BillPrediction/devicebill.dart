// ignore_for_file: prefer_typing_uninitialized_variables, unnecessary_null_comparison

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:genorion_mac_android/BillPrediction/totalusage.dart';
import 'package:http/http.dart' as http;
import '../LocalDatabase/alldb.dart';
import '../Models/devicemodel.dart';
import '../Models/flatmodel.dart';
import '../Models/floormodel.dart';
import '../Models/placemodel.dart';
import '../Models/roommodel.dart';
import '../ProfilePage/utility.dart';
import '../main.dart';

class DeviceBillPred extends StatefulWidget {
  const DeviceBillPred({Key? key}) : super(key: key);

  @override
  _DeviceBillPredState createState() => _DeviceBillPredState();
}

class _DeviceBillPredState extends State<DeviceBillPred> {
  Future<List<PlaceType>>? placeVal;
  Future<List<FloorType>>? floorVal;
  Future<List<FlatType>>? flatVal;
  bool changeplace = true;
  bool changeFloor = true;
  bool changeFlat = true;
  bool changeroom = true;
  bool changeDevice = true;
  Future<List<RoomType>>? roomVal;
  Future<List<DeviceType>>? deviceVal;
  bool completeTask = false;
  String? chooseValueMinute;
  var storage = const FlutterSecureStorage();
  List<dynamic> tenMinuteEnergy = [];
  List<dynamic> hourEnergy = [];
  List minute = [
    '10 minute',
    '20 minute',
    '30 minute',
    '40 minute',
    '50 minute',
    '60 minute'
  ];
  String selecteddeviceId = "";
  var last10Minute = 'Please Select';
  var pleaseSelect = 'Please Select';
  double? _valueMinute;
  String? chooseValueHour;
  var onlyDayEnergyList = List.empty(growable: true);
  TextEditingController billTotalController = TextEditingController();
  List hour = [
    '1 hour',
    '2 hour',
    '3 hour',
    '4 hour',
    '5 hour',
    '6 hour',
    '7 hour',
    '8 hour',
    '9 hour',
    '10 hour',
    '11 hour',
    '12 hour',
    '13 hour',
    '14 hour',
    '15 hour',
    '16 hour',
    '17 hour',
    '18 hour',
    '19 hour',
    '20 hour',
    '21 hour',
    '22 hour',
    '23 hour',
    '24 hour'
  ];
  Map<String, double> dataMap = {};
  double? _valueHour;
  DateTime? date2;
  DateTime? date1;
  String datefinal = "";
  String? cutDate;
  String? cutDate2;
  int currentDifference = 0;
  var difference;
  double finalEnergyValue = 0.0;
  double total = 0.0;
  String? varFinalTotalValue;
  double totalAmountInRs = 0.0;
  @override
  void initState() {
    super.initState();
    placeVal = placeQueryFunc();
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
                    children: [
                      InkWell(
                        child: const Text("Device Bill",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold)),
                        onTap: () {},
                      ),
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
                          //   Icons.notifications,
                          //   color: Colors.white,
                          // ),
                          ),
                    ),
                  ),
                ],
              ),
            ),
        
            changePlace(),
          ],
        ),
      ),
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
                                dropdownColor: Colors.white,
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
                                    floorVal = floorQueryFunc(selectPlace!.pId);
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

                                        flatVal = flatQuery(selectPlace!.fId);
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

                                            roomVal =
                                                roomQuery(selectedflat!.fltId);
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
                                                deviceVal = deviceQuery(
                                                    selectroom!.rId);
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
                                                onChanged: (selectDevice) {
                                                  setState(() {
                                                    completeTask = true;
                                                    selecteddeviceId =
                                                        selectDevice!.dId;
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
                              : const Center(
                                  child: CircularProgressIndicator(),
                                ),
          completeTask
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    DropdownButton(
                        value: chooseValueMinute,
                        onChanged: (index) async {
                          setState(() {
                            chooseValueMinute = index.toString();
                            dataMap = {};
                            finalEnergyValue = 0.0;
                            chooseValueHour = null;
                            difference = "";
                          });
                          await getEnergyTenMinutes(selecteddeviceId);
                        },
                        items: minute.map((valueItem) {
                          return DropdownMenuItem(
                            value: valueItem,
                            child: Text(
                              valueItem,
                              style: const TextStyle(color: Colors.red),
                            ),
                          );
                        }).toList()),
                    Text(
                      _valueMinute == null
                          ? pleaseSelect
                          : _valueMinute.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                )
              : const Text(
                  'Wait',
                  style: TextStyle(color: Colors.white),
                ),
          const SizedBox(
            height: 15,
          ),
          completeTask
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    DropdownButton(
                        value: chooseValueHour,
                        onChanged: (index) async {
                          setState(() {
                            chooseValueHour = index.toString();
                            finalEnergyValue = 0.0;
                            dataMap = {};
                            chooseValueMinute = null;
                            difference = "";
                          });

                          await getEnergyHour(selecteddeviceId);
                        },
                        items: hour.map((valueItem) {
                          return DropdownMenuItem(
                            value: valueItem,
                            child: Text(
                              valueItem,
                              style: const TextStyle(color: Colors.red),
                            ),
                          );
                        }).toList()),
                    Text(
                      _valueHour == null ? pleaseSelect : _valueHour.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                )
              : const Text(
                  "Wait",
                  style: TextStyle(color: Colors.white),
                ),
          const SizedBox(
            height: 15,
          ),
          completeTask
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    InkWell(
                      onTap: () async {
                        await showDatePicker1();
                      },
                      child: Text(
                        cutDate ?? 'Select First Date',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        await showDatePicker2();
                        // print12();
                      },
                      child: Text(
                        cutDate2 ?? 'Select Second Date',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                )
              : const Text("Wait"),
          const SizedBox(
            height: 15,
          ),
          completeTask
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    InkWell(
                      onTap: () async {},
                      child: Text(
                        finalEnergyValue.toString() == null
                            ? "Total Value"
                            : finalEnergyValue.toStringAsFixed(2),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      height: 28,
                      width: 75,
                      child: Center(
                        child: TextField(
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          controller: billTotalController,
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.rtl,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            hintStyle: TextStyle(color: Colors.white),
                            hintText: 'Enter a rs per unit',
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : const Text(
                  "Please Wait",
                  style: TextStyle(color: Colors.white),
                ),
          const SizedBox(
            height: 25,
          ),
          completeTask
              ? SizedBox(
                  child: Center(
                    // ignore: deprecated_member_use
                    child: ElevatedButton(
                      // color: Colors.lightBlue,
                      // shape: RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.circular(6.0)),
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 60),
                        child: Text(
                          'Total Usage',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      onPressed: () async {
                        await totalAmount(billTotalController.text);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TotalUsageBill(
                                      totalEnergy: finalEnergyValue.toString(),
                                      deviceId: dataMap,
                                      chooseValueMinute:
                                          chooseValueMinute ?? chooseValueHour,
                                      totalAmountInRs: totalAmountInRs,
                                      totalDays: difference == null
                                          ? "0"
                                          : difference.toString(),
                                    )));
                        // Navigator.of(context)
                        //     .pushReplacementNamed(TotalUsage.routeName);
                      },
                    ),
                  ),
                )
              : Container(),
        
        ],
      ),
    );
  }

  totalAmount(String rsValue) {
    int rsConversion = int.parse(rsValue);
    double conversion = double.parse(finalEnergyValue.toString());
    totalAmountInRs = (conversion / 1000) * rsConversion;
  }

  differenceCurrentDateToSelectedDate() {
    currentDifference = DateTime.now().difference(date1!).inDays;
    if (kDebugMode) {
      print('currentDifference $currentDifference');
    }
  }

  findDifferenceBetweenDates() {
    if (kDebugMode) {
      print(date1);
      print(date2);
    }

    setState(() {
      difference = date1?.difference(date2!).inDays;
    });

    if (kDebugMode) {
      print('difference $difference');
    }
  }

  showDatePicker2() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2080))
        .then((date) => {
              setState(() {
                date2 = date;
                datefinal = date.toString();
                cutDate2 = datefinal.substring(0, 10);
              })
            })
        .then((value) => allFindFunc());
  }
  // m-1*30+d date

  showDatePicker1() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2080))
        .then((date) => {
              setState(() {
                date1 = date;
                datefinal = date.toString();
                cutDate = datefinal.substring(0, 10);
              })
            });
  }

  allFindFunc() async {
    setState(() {
      
    });
    await differenceCurrentDateToSelectedDate();
    await findDifferenceBetweenDates();
    await getEnergyDay(selecteddeviceId);
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

  Future getToken() async {
    final token = await storage.read(key: "token");

    return token;
  }

  Future getEnergyTenMinutes(dId) async {
    String token = await getToken();
    String url = api + 'pertenminuteenergy?d_id=' + dId;
    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Token $token',
    });
    if (response.statusCode == 200) {
      tenMinuteEnergy = jsonDecode(response.body);
      if (tenMinuteEnergy.isEmpty) {
        setState(() {
          pleaseSelect = 'There is not Data';
        });
        return Utility.thereIsNoData(context);
      }
      if (chooseValueMinute == '10 minute') {
        setState(() {
          double changeValue = double.parse(tenMinuteEnergy[0]['enrgy10']);
          _valueMinute = changeValue;
          finalEnergyValue = _valueMinute!;
          dataMap.putIfAbsent(dId, () => finalEnergyValue);
        });
      } else if (chooseValueMinute == '20 minute') {
        setState(() {
          double op1 = double.parse(tenMinuteEnergy[0]['enrgy10']);
          double op2 = double.parse(tenMinuteEnergy[0]['enrgy20']);
          _valueMinute = op1 + op2;
          finalEnergyValue = _valueMinute!;
          dataMap.putIfAbsent(dId, () => finalEnergyValue);
        });
      } else if (chooseValueMinute == '30 minute') {
        setState(() {
          double op1 = double.parse(tenMinuteEnergy[0]['enrgy10']);
          double op2 = double.parse(tenMinuteEnergy[0]['enrgy20']);
          double op3 = double.parse(tenMinuteEnergy[0]['enrgy30']);
          _valueMinute = op1 + op2 + op3;
          finalEnergyValue = _valueMinute!;
          dataMap.putIfAbsent(dId, () => finalEnergyValue);
        });
      } else if (chooseValueMinute == '40 minute') {
        setState(() {
          double op1 = double.parse(tenMinuteEnergy[0]['enrgy10']);
          double op2 = double.parse(tenMinuteEnergy[0]['enrgy20']);
          double op3 = double.parse(tenMinuteEnergy[0]['enrgy30']);
          double op4 = double.parse(tenMinuteEnergy[0]['enrgy40']);
          _valueMinute = op1 + op2 + op3 + op4;
          finalEnergyValue = _valueMinute!;
          dataMap.putIfAbsent(dId, () => finalEnergyValue);
        });
      } else if (chooseValueMinute == '50 minute') {
        setState(() {
          double op1 = double.parse(tenMinuteEnergy[0]['enrgy10']);
          double op2 = double.parse(tenMinuteEnergy[0]['enrgy20']);
          double op3 = double.parse(tenMinuteEnergy[0]['enrgy30']);
          double op4 = double.parse(tenMinuteEnergy[0]['enrgy40']);
          double op5 = double.parse(tenMinuteEnergy[0]['enrgy50']);
          _valueMinute = op1 + op2 + op3 + op4 + op5;
          finalEnergyValue = _valueMinute!;
          dataMap.putIfAbsent(dId, () => finalEnergyValue);
        });
      } else if (chooseValueMinute == '60 minute') {
        setState(() {
          double op1 = double.parse(tenMinuteEnergy[0]['enrgy10']);
          double op2 = double.parse(tenMinuteEnergy[0]['enrgy20']);
          double op3 = double.parse(tenMinuteEnergy[0]['enrgy30']);
          double op4 = double.parse(tenMinuteEnergy[0]['enrgy40']);
          double op5 = double.parse(tenMinuteEnergy[0]['enrgy50']);
          double op6 = double.parse(tenMinuteEnergy[0]['enrgy60']);
          _valueMinute = op1 + op2 + op3 + op4 + op5 + op6;
          finalEnergyValue = _valueMinute!;
          dataMap.putIfAbsent(dId, () => finalEnergyValue);
        });
      }
    }
  }

  Future getEnergyHour(dId) async {
    String? token = await getToken();
    String url = api + 'perhourenergy?d_id=' + dId;
    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Token $token',
    });
    if (response.statusCode == 200) {
      hourEnergy = jsonDecode(response.body);

      if (hourEnergy.isEmpty) {
        setState(() {
          pleaseSelect = 'There is not Data';
        });
        return Utility.thereIsNoData(context);
      }
      if (chooseValueHour == '1 hour') {
        setState(() {
          var last10Minute = hourEnergy[0]['hour1'];
          double changeValue = double.parse(last10Minute);
          _valueHour = changeValue;
          finalEnergyValue = _valueHour!;
          dataMap.putIfAbsent(dId, () => finalEnergyValue);
        });
      } else if (chooseValueHour == '2 hour') {
        setState(() {
          double op1 = double.parse(hourEnergy[0]['hour1']);
          double op2 = double.parse(hourEnergy[0]['hour2']);
          _valueHour = op1 + op2;
          finalEnergyValue = _valueHour!;
          dataMap.putIfAbsent(dId, () => finalEnergyValue);
        });
      } else if (chooseValueHour == '3 hour') {
        setState(() {
          double op1 = double.parse(hourEnergy[0]['hour1']);
          double op2 = double.parse(hourEnergy[0]['hour2']);
          double op3 = double.parse(hourEnergy[0]['hour3']);
          _valueHour = op1 + op2 + op3;
          finalEnergyValue = _valueHour!;
          dataMap.putIfAbsent(dId, () => finalEnergyValue);
        });
      } else if (chooseValueHour == '4 hour') {
        setState(() {
          double op1 = double.parse(hourEnergy[0]['hour1']);
          double op2 = double.parse(hourEnergy[0]['hour2']);
          double op3 = double.parse(hourEnergy[0]['hour3']);
          double op4 = double.parse(hourEnergy[0]['hour4']);
          _valueHour = op1 + op2 + op3 + op4;
          finalEnergyValue = _valueHour!;
          dataMap.putIfAbsent(dId, () => finalEnergyValue);
        });
      } else if (chooseValueHour == '5 hour') {
        setState(() {
          double op1 = double.parse(hourEnergy[0]['hour1']);
          double op2 = double.parse(hourEnergy[0]['hour2']);
          double op3 = double.parse(hourEnergy[0]['hour3']);
          double op4 = double.parse(hourEnergy[0]['hour4']);
          double op5 = double.parse(hourEnergy[0]['hour5']);
          _valueHour = op1 + op2 + op3 + op4 + op5;
          finalEnergyValue = _valueHour!;
          dataMap.putIfAbsent(dId, () => finalEnergyValue);
        });
      } else if (chooseValueHour == '6 hour') {
        setState(() {
          double op1 = double.parse(hourEnergy[0]['hour1']);
          double op2 = double.parse(hourEnergy[0]['hour2']);
          double op3 = double.parse(hourEnergy[0]['hour3']);
          double op4 = double.parse(hourEnergy[0]['hour4']);
          double op5 = double.parse(hourEnergy[0]['hour5']);
          double op6 = double.parse(hourEnergy[0]['hour6']);
          _valueHour = op1 + op2 + op3 + op4 + op5 + op6;
          finalEnergyValue = _valueHour!;
          dataMap.putIfAbsent(dId, () => finalEnergyValue);
        });
      } else if (chooseValueHour == '7 hour') {
        setState(() {
          double op1 = double.parse(hourEnergy[0]['hour1']);
          double op2 = double.parse(hourEnergy[0]['hour2']);
          double op3 = double.parse(hourEnergy[0]['hour3']);
          double op4 = double.parse(hourEnergy[0]['hour4']);
          double op5 = double.parse(hourEnergy[0]['hour5']);
          double op6 = double.parse(hourEnergy[0]['hour6']);
          double op7 = double.parse(hourEnergy[0]['hour7']);
          _valueHour = op1 + op2 + op3 + op4 + op5 + op6 + op7;
          finalEnergyValue = _valueHour!;
          dataMap.putIfAbsent(dId, () => finalEnergyValue);
        });
      } else if (chooseValueHour == '8 hour') {
        setState(() {
          double op1 = double.parse(hourEnergy[0]['hour1']);
          double op2 = double.parse(hourEnergy[0]['hour2']);
          double op3 = double.parse(hourEnergy[0]['hour3']);
          double op4 = double.parse(hourEnergy[0]['hour4']);
          double op5 = double.parse(hourEnergy[0]['hour5']);
          double op6 = double.parse(hourEnergy[0]['hour6']);
          double op7 = double.parse(hourEnergy[0]['hour7']);
          double op8 = double.parse(hourEnergy[0]['hour8']);
          _valueHour = op1 + op2 + op3 + op4 + op5 + op6 + op7 + op8;
          finalEnergyValue = _valueHour!;
          dataMap.putIfAbsent(dId, () => finalEnergyValue);
        });
      } else if (chooseValueHour == '9 hour') {
        setState(() {
          double op1 = double.parse(hourEnergy[0]['hour1']);
          double op2 = double.parse(hourEnergy[0]['hour2']);
          double op3 = double.parse(hourEnergy[0]['hour3']);
          double op4 = double.parse(hourEnergy[0]['hour4']);
          double op5 = double.parse(hourEnergy[0]['hour5']);
          double op6 = double.parse(hourEnergy[0]['hour6']);
          double op7 = double.parse(hourEnergy[0]['hour7']);
          double op8 = double.parse(hourEnergy[0]['hour8']);
          double op9 = double.parse(hourEnergy[0]['hour9']);
          _valueHour = op1 + op2 + op3 + op4 + op5 + op6 + op7 + op8 + op9;
          finalEnergyValue = _valueHour!;
          dataMap.putIfAbsent(dId, () => finalEnergyValue);
        });
      } else if (chooseValueHour == '10 hour') {
        setState(() {
          double op1 = double.parse(hourEnergy[0]['hour1']);
          double op2 = double.parse(hourEnergy[0]['hour2']);
          double op3 = double.parse(hourEnergy[0]['hour3']);
          double op4 = double.parse(hourEnergy[0]['hour4']);
          double op5 = double.parse(hourEnergy[0]['hour5']);
          double op6 = double.parse(hourEnergy[0]['hour6']);
          double op7 = double.parse(hourEnergy[0]['hour7']);
          double op8 = double.parse(hourEnergy[0]['hour8']);
          double op9 = double.parse(hourEnergy[0]['hour9']);
          double op10 = double.parse(hourEnergy[0]['hour10']);
          _valueHour =
              op1 + op2 + op3 + op4 + op5 + op6 + op7 + op8 + op9 + op10;
          finalEnergyValue = _valueHour!;
          dataMap.putIfAbsent(dId, () => finalEnergyValue);
        });
      } else if (chooseValueHour == '11 hour') {
        setState(() {
          double op1 = double.parse(hourEnergy[0]['hour1']);
          double op2 = double.parse(hourEnergy[0]['hour2']);
          double op3 = double.parse(hourEnergy[0]['hour3']);
          double op4 = double.parse(hourEnergy[0]['hour4']);
          double op5 = double.parse(hourEnergy[0]['hour5']);
          double op6 = double.parse(hourEnergy[0]['hour6']);
          double op7 = double.parse(hourEnergy[0]['hour7']);
          double op8 = double.parse(hourEnergy[0]['hour8']);
          double op9 = double.parse(hourEnergy[0]['hour9']);
          double op10 = double.parse(hourEnergy[0]['hour10']);
          double op11 = double.parse(hourEnergy[0]['hour11']);
          _valueHour =
              op1 + op2 + op3 + op4 + op5 + op6 + op7 + op8 + op9 + op10 + op11;
          finalEnergyValue = _valueHour!;
          dataMap.putIfAbsent(dId, () => finalEnergyValue);
        });
      } else if (chooseValueHour == '12 hour') {
        setState(() {
          double op1 = double.parse(hourEnergy[0]['hour1']);
          double op2 = double.parse(hourEnergy[0]['hour2']);
          double op3 = double.parse(hourEnergy[0]['hour3']);
          double op4 = double.parse(hourEnergy[0]['hour4']);
          double op5 = double.parse(hourEnergy[0]['hour5']);
          double op6 = double.parse(hourEnergy[0]['hour6']);
          double op7 = double.parse(hourEnergy[0]['hour7']);
          double op8 = double.parse(hourEnergy[0]['hour8']);
          double op9 = double.parse(hourEnergy[0]['hour9']);
          double op10 = double.parse(hourEnergy[0]['hour10']);
          double op11 = double.parse(hourEnergy[0]['hour11']);
          double op12 = double.parse(hourEnergy[0]['hour12']);
          _valueHour = op1 +
              op2 +
              op3 +
              op4 +
              op5 +
              op6 +
              op7 +
              op8 +
              op9 +
              op10 +
              op11 +
              op12;
          finalEnergyValue = _valueHour!;
          dataMap.putIfAbsent(dId, () => finalEnergyValue);
        });
      } else if (chooseValueHour == '13 hour') {
        setState(() {
          double op1 = double.parse(hourEnergy[0]['hour1']);
          double op2 = double.parse(hourEnergy[0]['hour2']);
          double op3 = double.parse(hourEnergy[0]['hour3']);
          double op4 = double.parse(hourEnergy[0]['hour4']);
          double op5 = double.parse(hourEnergy[0]['hour5']);
          double op6 = double.parse(hourEnergy[0]['hour6']);
          double op7 = double.parse(hourEnergy[0]['hour7']);
          double op8 = double.parse(hourEnergy[0]['hour8']);
          double op9 = double.parse(hourEnergy[0]['hour9']);
          double op10 = double.parse(hourEnergy[0]['hour10']);
          double op11 = double.parse(hourEnergy[0]['hour11']);
          double op12 = double.parse(hourEnergy[0]['hour12']);
          double op13 = double.parse(hourEnergy[0]['hour13']);
          _valueHour = op1 +
              op2 +
              op3 +
              op4 +
              op5 +
              op6 +
              op7 +
              op8 +
              op9 +
              op10 +
              op11 +
              op12 +
              op13;
          finalEnergyValue = _valueHour!;
          dataMap.putIfAbsent(dId, () => finalEnergyValue);
        });
      } else if (chooseValueHour == '14 hour') {
        setState(() {
          double op1 = double.parse(hourEnergy[0]['hour1']);
          double op2 = double.parse(hourEnergy[0]['hour2']);
          double op3 = double.parse(hourEnergy[0]['hour3']);
          double op4 = double.parse(hourEnergy[0]['hour4']);
          double op5 = double.parse(hourEnergy[0]['hour5']);
          double op6 = double.parse(hourEnergy[0]['hour6']);
          double op7 = double.parse(hourEnergy[0]['hour7']);
          double op8 = double.parse(hourEnergy[0]['hour8']);
          double op9 = double.parse(hourEnergy[0]['hour9']);
          double op10 = double.parse(hourEnergy[0]['hour10']);
          double op11 = double.parse(hourEnergy[0]['hour11']);
          double op12 = double.parse(hourEnergy[0]['hour12']);
          double op13 = double.parse(hourEnergy[0]['hour13']);
          double op14 = double.parse(hourEnergy[0]['hour14']);
          _valueHour = op1 +
              op2 +
              op3 +
              op4 +
              op5 +
              op6 +
              op7 +
              op8 +
              op9 +
              op10 +
              op11 +
              op12 +
              op13 +
              op14;
          finalEnergyValue = _valueHour!;
          dataMap.putIfAbsent(dId, () => finalEnergyValue);
        });
      } else if (chooseValueHour == '15 hour') {
        setState(() {
          double op1 = double.parse(hourEnergy[0]['hour1']);
          double op2 = double.parse(hourEnergy[0]['hour2']);
          double op3 = double.parse(hourEnergy[0]['hour3']);
          double op4 = double.parse(hourEnergy[0]['hour4']);
          double op5 = double.parse(hourEnergy[0]['hour5']);
          double op6 = double.parse(hourEnergy[0]['hour6']);
          double op7 = double.parse(hourEnergy[0]['hour7']);
          double op8 = double.parse(hourEnergy[0]['hour8']);
          double op9 = double.parse(hourEnergy[0]['hour9']);
          double op10 = double.parse(hourEnergy[0]['hour10']);
          double op11 = double.parse(hourEnergy[0]['hour11']);
          double op12 = double.parse(hourEnergy[0]['hour12']);
          double op13 = double.parse(hourEnergy[0]['hour13']);
          double op14 = double.parse(hourEnergy[0]['hour14']);
          double op15 = double.parse(hourEnergy[0]['hour15']);
          _valueHour = op1 +
              op2 +
              op3 +
              op4 +
              op5 +
              op6 +
              op7 +
              op8 +
              op9 +
              op10 +
              op11 +
              op12 +
              op13 +
              op14 +
              op15;
          finalEnergyValue = _valueHour!;
          dataMap.putIfAbsent(dId, () => finalEnergyValue);
        });
      } else if (chooseValueHour == '16 hour') {
        setState(() {
          double op1 = double.parse(hourEnergy[0]['hour1']);
          double op2 = double.parse(hourEnergy[0]['hour2']);
          double op3 = double.parse(hourEnergy[0]['hour3']);
          double op4 = double.parse(hourEnergy[0]['hour4']);
          double op5 = double.parse(hourEnergy[0]['hour5']);
          double op6 = double.parse(hourEnergy[0]['hour6']);
          double op7 = double.parse(hourEnergy[0]['hour7']);
          double op8 = double.parse(hourEnergy[0]['hour8']);
          double op9 = double.parse(hourEnergy[0]['hour9']);
          double op10 = double.parse(hourEnergy[0]['hour10']);
          double op11 = double.parse(hourEnergy[0]['hour11']);
          double op12 = double.parse(hourEnergy[0]['hour12']);
          double op13 = double.parse(hourEnergy[0]['hour13']);
          double op14 = double.parse(hourEnergy[0]['hour14']);
          double op15 = double.parse(hourEnergy[0]['hour15']);
          double op16 = double.parse(hourEnergy[0]['hour16']);
          _valueHour = op1 +
              op2 +
              op3 +
              op4 +
              op5 +
              op6 +
              op7 +
              op8 +
              op9 +
              op10 +
              op11 +
              op12 +
              op13 +
              op14 +
              op15 +
              op16;
          finalEnergyValue = _valueHour!;
          dataMap.putIfAbsent(dId, () => finalEnergyValue);
        });
      } else if (chooseValueHour == '17 hour') {
        setState(() {
          double op1 = double.parse(hourEnergy[0]['hour1']);
          double op2 = double.parse(hourEnergy[0]['hour2']);
          double op3 = double.parse(hourEnergy[0]['hour3']);
          double op4 = double.parse(hourEnergy[0]['hour4']);
          double op5 = double.parse(hourEnergy[0]['hour5']);
          double op6 = double.parse(hourEnergy[0]['hour6']);
          double op7 = double.parse(hourEnergy[0]['hour7']);
          double op8 = double.parse(hourEnergy[0]['hour8']);
          double op9 = double.parse(hourEnergy[0]['hour9']);
          double op10 = double.parse(hourEnergy[0]['hour10']);
          double op11 = double.parse(hourEnergy[0]['hour11']);
          double op12 = double.parse(hourEnergy[0]['hour12']);
          double op13 = double.parse(hourEnergy[0]['hour13']);
          double op14 = double.parse(hourEnergy[0]['hour14']);
          double op15 = double.parse(hourEnergy[0]['hour15']);
          double op16 = double.parse(hourEnergy[0]['hour16']);
          double op17 = double.parse(hourEnergy[0]['hour17']);
          _valueHour = op1 +
              op2 +
              op3 +
              op4 +
              op5 +
              op6 +
              op7 +
              op8 +
              op9 +
              op10 +
              op11 +
              op12 +
              op13 +
              op14 +
              op15 +
              op16 +
              op17;
          finalEnergyValue = _valueHour!;
          dataMap.putIfAbsent(dId, () => finalEnergyValue);
        });
      } else if (chooseValueHour == '18 hour') {
        setState(() {
          double op1 = double.parse(hourEnergy[0]['hour1']);
          double op2 = double.parse(hourEnergy[0]['hour2']);
          double op3 = double.parse(hourEnergy[0]['hour3']);
          double op4 = double.parse(hourEnergy[0]['hour4']);
          double op5 = double.parse(hourEnergy[0]['hour5']);
          double op6 = double.parse(hourEnergy[0]['hour6']);
          double op7 = double.parse(hourEnergy[0]['hour7']);
          double op8 = double.parse(hourEnergy[0]['hour8']);
          double op9 = double.parse(hourEnergy[0]['hour9']);
          double op10 = double.parse(hourEnergy[0]['hour10']);
          double op11 = double.parse(hourEnergy[0]['hour11']);
          double op12 = double.parse(hourEnergy[0]['hour12']);
          double op13 = double.parse(hourEnergy[0]['hour13']);
          double op14 = double.parse(hourEnergy[0]['hour14']);
          double op15 = double.parse(hourEnergy[0]['hour15']);
          double op16 = double.parse(hourEnergy[0]['hour16']);
          double op17 = double.parse(hourEnergy[0]['hour17']);
          double op18 = double.parse(hourEnergy[0]['hour18']);
          _valueHour = op1 +
              op2 +
              op3 +
              op4 +
              op5 +
              op6 +
              op7 +
              op8 +
              op9 +
              op10 +
              op11 +
              op12 +
              op13 +
              op14 +
              op15 +
              op16 +
              op17 +
              op18;
          finalEnergyValue = _valueHour!;
          dataMap.putIfAbsent(dId, () => finalEnergyValue);
        });
      } else if (chooseValueHour == '19 hour') {
        setState(() {
          double op1 = double.parse(hourEnergy[0]['hour1']);
          double op2 = double.parse(hourEnergy[0]['hour2']);
          double op3 = double.parse(hourEnergy[0]['hour3']);
          double op4 = double.parse(hourEnergy[0]['hour4']);
          double op5 = double.parse(hourEnergy[0]['hour5']);
          double op6 = double.parse(hourEnergy[0]['hour6']);
          double op7 = double.parse(hourEnergy[0]['hour7']);
          double op8 = double.parse(hourEnergy[0]['hour8']);
          double op9 = double.parse(hourEnergy[0]['hour9']);
          double op10 = double.parse(hourEnergy[0]['hour10']);
          double op11 = double.parse(hourEnergy[0]['hour11']);
          double op12 = double.parse(hourEnergy[0]['hour12']);
          double op13 = double.parse(hourEnergy[0]['hour13']);
          double op14 = double.parse(hourEnergy[0]['hour14']);
          double op15 = double.parse(hourEnergy[0]['hour15']);
          double op16 = double.parse(hourEnergy[0]['hour16']);
          double op17 = double.parse(hourEnergy[0]['hour17']);
          double op18 = double.parse(hourEnergy[0]['hour18']);
          double op19 = double.parse(hourEnergy[0]['hour19']);
          _valueHour = op1 +
              op2 +
              op3 +
              op4 +
              op5 +
              op6 +
              op7 +
              op8 +
              op9 +
              op10 +
              op11 +
              op12 +
              op13 +
              op14 +
              op15 +
              op16 +
              op17 +
              op18 +
              op19;
          finalEnergyValue = _valueHour!;
          dataMap.putIfAbsent(dId, () => finalEnergyValue);
        });
      } else if (chooseValueHour == '20 hour') {
        setState(() {
          double op1 = double.parse(hourEnergy[0]['hour1']);
          double op2 = double.parse(hourEnergy[0]['hour2']);
          double op3 = double.parse(hourEnergy[0]['hour3']);
          double op4 = double.parse(hourEnergy[0]['hour4']);
          double op5 = double.parse(hourEnergy[0]['hour5']);
          double op6 = double.parse(hourEnergy[0]['hour6']);
          double op7 = double.parse(hourEnergy[0]['hour7']);
          double op8 = double.parse(hourEnergy[0]['hour8']);
          double op9 = double.parse(hourEnergy[0]['hour9']);
          double op10 = double.parse(hourEnergy[0]['hour10']);
          double op11 = double.parse(hourEnergy[0]['hour11']);
          double op12 = double.parse(hourEnergy[0]['hour12']);
          double op13 = double.parse(hourEnergy[0]['hour13']);
          double op14 = double.parse(hourEnergy[0]['hour14']);
          double op15 = double.parse(hourEnergy[0]['hour15']);
          double op16 = double.parse(hourEnergy[0]['hour16']);
          double op17 = double.parse(hourEnergy[0]['hour17']);
          double op18 = double.parse(hourEnergy[0]['hour18']);
          double op19 = double.parse(hourEnergy[0]['hour19']);
          double op20 = double.parse(hourEnergy[0]['hour20']);
          _valueHour = op1 +
              op2 +
              op3 +
              op4 +
              op5 +
              op6 +
              op7 +
              op8 +
              op9 +
              op10 +
              op11 +
              op12 +
              op13 +
              op14 +
              op15 +
              op16 +
              op17 +
              op18 +
              op19 +
              op20;
          finalEnergyValue = _valueHour!;
          dataMap.putIfAbsent(dId, () => finalEnergyValue);
        });
      } else if (chooseValueHour == '21 hour') {
        setState(() {
          double op1 = double.parse(hourEnergy[0]['hour1']);
          double op2 = double.parse(hourEnergy[0]['hour2']);
          double op3 = double.parse(hourEnergy[0]['hour3']);
          double op4 = double.parse(hourEnergy[0]['hour4']);
          double op5 = double.parse(hourEnergy[0]['hour5']);
          double op6 = double.parse(hourEnergy[0]['hour6']);
          double op7 = double.parse(hourEnergy[0]['hour7']);
          double op8 = double.parse(hourEnergy[0]['hour8']);
          double op9 = double.parse(hourEnergy[0]['hour9']);
          double op10 = double.parse(hourEnergy[0]['hour10']);
          double op11 = double.parse(hourEnergy[0]['hour11']);
          double op12 = double.parse(hourEnergy[0]['hour12']);
          double op13 = double.parse(hourEnergy[0]['hour13']);
          double op14 = double.parse(hourEnergy[0]['hour14']);
          double op15 = double.parse(hourEnergy[0]['hour15']);
          double op16 = double.parse(hourEnergy[0]['hour16']);
          double op17 = double.parse(hourEnergy[0]['hour17']);
          double op18 = double.parse(hourEnergy[0]['hour18']);
          double op19 = double.parse(hourEnergy[0]['hour19']);
          double op20 = double.parse(hourEnergy[0]['hour20']);
          double op21 = double.parse(hourEnergy[0]['hour21']);
          _valueHour = op1 +
              op2 +
              op3 +
              op4 +
              op5 +
              op6 +
              op7 +
              op8 +
              op9 +
              op10 +
              op11 +
              op12 +
              op13 +
              op14 +
              op15 +
              op16 +
              op17 +
              op18 +
              op19 +
              op20 +
              op21;
          finalEnergyValue = _valueHour!;
          dataMap.putIfAbsent(dId, () => finalEnergyValue);
        });
      } else if (chooseValueHour == '22 hour') {
        setState(() {
          double op1 = double.parse(hourEnergy[0]['hour1']);
          double op2 = double.parse(hourEnergy[0]['hour2']);
          double op3 = double.parse(hourEnergy[0]['hour3']);
          double op4 = double.parse(hourEnergy[0]['hour4']);
          double op5 = double.parse(hourEnergy[0]['hour5']);
          double op6 = double.parse(hourEnergy[0]['hour6']);
          double op7 = double.parse(hourEnergy[0]['hour7']);
          double op8 = double.parse(hourEnergy[0]['hour8']);
          double op9 = double.parse(hourEnergy[0]['hour9']);
          double op10 = double.parse(hourEnergy[0]['hour10']);
          double op11 = double.parse(hourEnergy[0]['hour11']);
          double op12 = double.parse(hourEnergy[0]['hour12']);
          double op13 = double.parse(hourEnergy[0]['hour13']);
          double op14 = double.parse(hourEnergy[0]['hour14']);
          double op15 = double.parse(hourEnergy[0]['hour15']);
          double op16 = double.parse(hourEnergy[0]['hour16']);
          double op17 = double.parse(hourEnergy[0]['hour17']);
          double op18 = double.parse(hourEnergy[0]['hour18']);
          double op19 = double.parse(hourEnergy[0]['hour19']);
          double op20 = double.parse(hourEnergy[0]['hour20']);
          double op21 = double.parse(hourEnergy[0]['hour21']);
          double op22 = double.parse(hourEnergy[0]['hour22']);
          _valueHour = op1 +
              op2 +
              op3 +
              op4 +
              op5 +
              op6 +
              op7 +
              op8 +
              op9 +
              op10 +
              op11 +
              op12 +
              op13 +
              op14 +
              op15 +
              op16 +
              op17 +
              op18 +
              op19 +
              op20 +
              op21 +
              op22;
          finalEnergyValue = _valueHour!;
          dataMap.putIfAbsent(dId, () => finalEnergyValue);
        });
      } else if (chooseValueHour == '23 hour') {
        setState(() {
          double op1 = double.parse(hourEnergy[0]['hour1']);
          double op2 = double.parse(hourEnergy[0]['hour2']);
          double op3 = double.parse(hourEnergy[0]['hour3']);
          double op4 = double.parse(hourEnergy[0]['hour4']);
          double op5 = double.parse(hourEnergy[0]['hour5']);
          double op6 = double.parse(hourEnergy[0]['hour6']);
          double op7 = double.parse(hourEnergy[0]['hour7']);
          double op8 = double.parse(hourEnergy[0]['hour8']);
          double op9 = double.parse(hourEnergy[0]['hour9']);
          double op10 = double.parse(hourEnergy[0]['hour10']);
          double op11 = double.parse(hourEnergy[0]['hour11']);
          double op12 = double.parse(hourEnergy[0]['hour12']);
          double op13 = double.parse(hourEnergy[0]['hour13']);
          double op14 = double.parse(hourEnergy[0]['hour14']);
          double op15 = double.parse(hourEnergy[0]['hour15']);
          double op16 = double.parse(hourEnergy[0]['hour16']);
          double op17 = double.parse(hourEnergy[0]['hour17']);
          double op18 = double.parse(hourEnergy[0]['hour18']);
          double op19 = double.parse(hourEnergy[0]['hour19']);
          double op20 = double.parse(hourEnergy[0]['hour20']);
          double op21 = double.parse(hourEnergy[0]['hour21']);
          double op22 = double.parse(hourEnergy[0]['hour22']);
          double op23 = double.parse(hourEnergy[0]['hour23']);
          _valueHour = op1 +
              op2 +
              op3 +
              op4 +
              op5 +
              op6 +
              op7 +
              op8 +
              op9 +
              op10 +
              op11 +
              op12 +
              op13 +
              op14 +
              op15 +
              op16 +
              op17 +
              op18 +
              op19 +
              op20 +
              op21 +
              op22 +
              op23;
          finalEnergyValue = _valueHour!;
          dataMap.putIfAbsent(dId, () => finalEnergyValue);
        });
      } else if (chooseValueHour == '24 hour') {
        setState(() {
          double op1 = double.parse(hourEnergy[0]['hour1']);
          double op2 = double.parse(hourEnergy[0]['hour2']);
          double op3 = double.parse(hourEnergy[0]['hour3']);
          double op4 = double.parse(hourEnergy[0]['hour4']);
          double op5 = double.parse(hourEnergy[0]['hour5']);
          double op6 = double.parse(hourEnergy[0]['hour6']);
          double op7 = double.parse(hourEnergy[0]['hour7']);
          double op8 = double.parse(hourEnergy[0]['hour8']);
          double op9 = double.parse(hourEnergy[0]['hour9']);
          double op10 = double.parse(hourEnergy[0]['hour10']);
          double op11 = double.parse(hourEnergy[0]['hour11']);
          double op12 = double.parse(hourEnergy[0]['hour12']);
          double op13 = double.parse(hourEnergy[0]['hour13']);
          double op14 = double.parse(hourEnergy[0]['hour14']);
          double op15 = double.parse(hourEnergy[0]['hour15']);
          double op16 = double.parse(hourEnergy[0]['hour16']);
          double op17 = double.parse(hourEnergy[0]['hour17']);
          double op18 = double.parse(hourEnergy[0]['hour18']);
          double op19 = double.parse(hourEnergy[0]['hour19']);
          double op20 = double.parse(hourEnergy[0]['hour20']);
          double op21 = double.parse(hourEnergy[0]['hour21']);
          double op22 = double.parse(hourEnergy[0]['hour22']);
          double op23 = double.parse(hourEnergy[0]['hour23']);
          double op24 = double.parse(hourEnergy[0]['hour24']);
          _valueHour = op1 +
              op2 +
              op3 +
              op4 +
              op5 +
              op6 +
              op7 +
              op8 +
              op9 +
              op10 +
              op11 +
              op12 +
              op13 +
              op14 +
              op15 +
              op16 +
              op17 +
              op18 +
              op19 +
              op20 +
              op21 +
              op22 +
              op23 +
              op24;
          finalEnergyValue = _valueHour!;
          dataMap.putIfAbsent(dId, () => finalEnergyValue);
        });
      }
    }
  }

  Future getEnergyDay(dId) async {
    String? token = await getToken();
    String url = api + 'perdaysenergy?d_id=' + dId;
    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Token $token',
    });
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);

      if (data.isEmpty) {
        setState(() {
          pleaseSelect = 'There is not Data';
        });
        return Utility.thereIsNoData(context);
      }

      for (int i = 0; i < data.length; i++) {
        onlyDayEnergyList.add(data[i]);
      }
      if (kDebugMode) {
        print('sumData $onlyDayEnergyList}');
      }
      await sumYearData();
    }
  }

  sumYearData() {
    int i = 0;

    while (i < onlyDayEnergyList.length) {
      for (int j = 1; j <= difference; j++) {
        setState(() {
          total = total + onlyDayEnergyList[i]['day${j + currentDifference}'];
          finalEnergyValue = total;
        });
      }

      i++;
    }
    dataMap.putIfAbsent(selecteddeviceId, () => finalEnergyValue);
    total = 0.0;
  }


}
