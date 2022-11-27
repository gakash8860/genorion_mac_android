// ignore_for_file: unnecessary_null_comparison, prefer_if_null_operators, prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:genorion_mac_android/BillPrediction/totalusage.dart';
import 'package:http/http.dart' as http;
import '../LocalDatabase/alldb.dart';
import '../Models/flatmodel.dart';
import '../Models/floormodel.dart';
import '../Models/placemodel.dart';
import '../Models/roommodel.dart';
import '../main.dart';

class RoomBillPred extends StatefulWidget {
  const RoomBillPred({Key? key}) : super(key: key);

  @override
  _RoomBillPredState createState() => _RoomBillPredState();
}

class _RoomBillPredState extends State<RoomBillPred> {
  Future<List<PlaceType>>? placeVal;
  Future<List<FloorType>>? floorVal;
  Future<List<FlatType>>? flatVal;
  bool completeTask = false;
  bool changeplace = true;
  bool changeFloor = true;
  bool changeFlat = true;
  bool changeroom = true;
  bool changeDevice = true;
  Future<List<RoomType>>? roomVal;
  String? cutDate;
  String? cutDate2;
  var storage = const FlutterSecureStorage();
  double totalAmountInRs = 0.0;
  List minute = [
    '10 minute',
    '20 minute',
    '30 minute',
    '40 minute',
    '50 minute',
    '60 minute'
  ];
  double total = 0.0;
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
  DateTime? date2;
  DateTime? date1;
  String datefinal = "";
  double? _valueHour;
  double finalEnergyValue = 0.0;
  String? chooseValueMinute;
  String? chooseValueHour;
  String? varFinalTotalValue;
  var totalTenMinuteEnergy = List.empty(growable: true);
  var totalHourEnergy = List.empty(growable: true);
  var last10Minute = 'Please Select';
  var pleaseSelect = 'Please Select';
  double? _valueMinute;
  TextEditingController billTotalController = TextEditingController();
  List data = [];
  int currentDifference = 0;
  var difference;
  var onlyDayEnergyList = List.empty(growable: true);
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
                      child: const Text("Room Bill",
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
      )),
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
                                    dropdownColor: Colors.white,
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
                                        dropdownColor: Colors.white,
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
                                            dropdownColor: Colors.white,
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
                                            onChanged: (selectroom) async {
                                              await deviceQuery(
                                                  selectroom!.rId);
                                              setState(() {
                                                completeTask = true;
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
                          : Container(),
          completeTask
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    DropdownButton(
                        value: chooseValueMinute,
                        onChanged: (index) async {
                          setState(() {
                            _valueMinute = 0.0;
                            chooseValueMinute = index.toString();
                            dataMap = {};
                            finalEnergyValue = 0.0;
                            difference = "";
                          });
                          totalTenMinuteEnergy = List.empty(growable: true);
                          await getEnergyTenMinutes(chooseValueMinute);
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
          completeTask
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    DropdownButton(
                        value: chooseValueHour,
                        onChanged: (index) async {
                          setState(() {
                            _valueHour = 0.0;
                            totalHourEnergy = List.empty(growable: true);
                            chooseValueHour = index.toString();
                            dataMap = {};
                            finalEnergyValue = 0.0;
                            difference = "";
                          });
                          await getEnergyHour(chooseValueHour);
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
            height: 10,
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
                        cutDate ?? 'Select Current Date',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        setState(() {
                          finalEnergyValue = 0.0;
                        });

                        await showDatePicker2();
                        // print12();
                      },
                      child: Text(
                        cutDate2 ?? 'Select Past Date ',
                        style: const TextStyle(color: Colors.white),
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
                        if (chooseValueMinute == null &&
                            chooseValueHour == null) {
                          chooseValueMinute = "";
                        }
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TotalUsageBill(
                                      totalEnergy:
                                          finalEnergyValue.toStringAsFixed(2),
                                      deviceId: dataMap,
                                      chooseValueMinute:
                                          chooseValueMinute ?? chooseValueHour,
                                      totalAmountInRs: totalAmountInRs,
                                      totalDays: difference.toString() == null
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

  Future deviceQuery(id) async {
    data = await AllDatabase.instance.getDeviceById(id);
  }

  Future getToken() async {
    final token = await storage.read(key: "token");

    return token;
  }

  Future getEnergyTenMinutes(chooseValueMinute) async {
    String? token = await getToken();
    for (int i = 0; i < data.length; i++) {
      var dId = data[i]['d_id'];
      String url = api + 'pertenminuteenergy?d_id=' + dId;
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Token $token',
      });
      if (response.statusCode == 200) {
        List ans = jsonDecode(response.body);
        if (ans.isEmpty) {
          return thereIsNoData();
        }
        for (int i = 0; i < ans.length; i++) {
          totalTenMinuteEnergy.add(ans[i]);
        }
        if (kDebugMode) {
          print("qwertyuiop ${totalTenMinuteEnergy.length}");
        }
      }
    }
    finalEnergyValue = 0.0;
    for (int i = 0; i < totalTenMinuteEnergy.length; i++) {
      setState(() {
        finalEnergyValue = double.parse(totalTenMinuteEnergy[i]['enrgy10']) +
            double.parse(totalTenMinuteEnergy[i]['enrgy20']) +
            double.parse(totalTenMinuteEnergy[i]['enrgy30']) +
            double.parse(totalTenMinuteEnergy[i]['enrgy40']) +
            double.parse(totalTenMinuteEnergy[i]['enrgy50']) +
            double.parse(totalTenMinuteEnergy[i]['enrgy60']) +
            finalEnergyValue;
      });

      if (chooseValueMinute == "10 minute") {
        if (kDebugMode) {
          print("qwertyuiop $_valueMinute");
        }
        setState(() {
          _valueMinute =
              double.parse(totalTenMinuteEnergy[i]['enrgy10']) + _valueMinute!;
          finalEnergyValue = _valueMinute!;
          varFinalTotalValue = _valueMinute!.toStringAsFixed(2);
        });
        dataMap.putIfAbsent(totalTenMinuteEnergy[i]['d_id'],
            () => double.parse(totalTenMinuteEnergy[i]['enrgy10']));
      }
      if (chooseValueMinute == "20 minute") {
        setState(() {
          _valueMinute = double.parse(totalTenMinuteEnergy[i]['enrgy10']) +
              double.parse(totalTenMinuteEnergy[i]['enrgy20']) +
              _valueMinute!;
          finalEnergyValue = _valueMinute!;
          varFinalTotalValue = _valueMinute!.toStringAsFixed(2);
        });
        dataMap.putIfAbsent(
            totalTenMinuteEnergy[i]['d_id'],
            () =>
                double.parse(totalTenMinuteEnergy[i]['enrgy10']) +
                double.parse(totalTenMinuteEnergy[i]['enrgy20']));
      }
      if (chooseValueMinute == "30 minute") {
        setState(() {
          _valueMinute = double.parse(totalTenMinuteEnergy[i]['enrgy10']) +
              double.parse(totalTenMinuteEnergy[i]['enrgy20']) +
              double.parse(totalTenMinuteEnergy[i]['enrgy30']) +
              _valueMinute!;
          finalEnergyValue = _valueMinute!;
          varFinalTotalValue = _valueMinute!.toStringAsFixed(2);
        });
        dataMap.putIfAbsent(
            totalTenMinuteEnergy[i]['d_id'],
            () =>
                double.parse(totalTenMinuteEnergy[i]['enrgy10']) +
                double.parse(totalTenMinuteEnergy[i]['enrgy20']) +
                double.parse(totalTenMinuteEnergy[i]['enrgy30']));
      }

      if (chooseValueMinute == "40 minute") {
        setState(() {
          _valueMinute = double.parse(totalTenMinuteEnergy[i]['enrgy10']) +
              double.parse(totalTenMinuteEnergy[i]['enrgy20']) +
              double.parse(totalTenMinuteEnergy[i]['enrgy30']) +
              double.parse(totalTenMinuteEnergy[i]['enrgy40']) +
              _valueMinute!;
          finalEnergyValue = _valueMinute!;

          varFinalTotalValue = _valueMinute!.toStringAsFixed(2);
        });
        dataMap.putIfAbsent(
            totalTenMinuteEnergy[i]['d_id'],
            () =>
                double.parse(totalTenMinuteEnergy[i]['enrgy10']) +
                double.parse(totalTenMinuteEnergy[i]['enrgy20']) +
                double.parse(totalTenMinuteEnergy[i]['enrgy30']) +
                double.parse(totalTenMinuteEnergy[i]['enrgy40']));
      }

      if (chooseValueMinute == "50 minute") {
        setState(() {
          _valueMinute = double.parse(totalTenMinuteEnergy[i]['enrgy10']) +
              double.parse(totalTenMinuteEnergy[i]['enrgy20']) +
              double.parse(totalTenMinuteEnergy[i]['enrgy30']) +
              double.parse(totalTenMinuteEnergy[i]['enrgy40']) +
              double.parse(totalTenMinuteEnergy[i]['enrgy50']) +
              _valueMinute!;
          finalEnergyValue = _valueMinute!;
          varFinalTotalValue = _valueMinute!.toStringAsFixed(2);
        });
        dataMap.putIfAbsent(
            totalTenMinuteEnergy[i]['d_id'],
            () =>
                double.parse(totalTenMinuteEnergy[i]['enrgy10']) +
                double.parse(totalTenMinuteEnergy[i]['enrgy20']) +
                double.parse(totalTenMinuteEnergy[i]['enrgy30']) +
                double.parse(totalTenMinuteEnergy[i]['enrgy40']) +
                double.parse(totalTenMinuteEnergy[i]['enrgy50']));
      }
      if (chooseValueMinute == "60 minute") {
        setState(() {
          _valueMinute = double.parse(totalTenMinuteEnergy[i]['enrgy10']) +
              double.parse(totalTenMinuteEnergy[i]['enrgy20']) +
              double.parse(totalTenMinuteEnergy[i]['enrgy30']) +
              double.parse(totalTenMinuteEnergy[i]['enrgy40']) +
              double.parse(totalTenMinuteEnergy[i]['enrgy50']) +
              double.parse(totalTenMinuteEnergy[i]['enrgy60']) +
              _valueMinute!;
          finalEnergyValue = _valueMinute!;
          varFinalTotalValue = _valueMinute!.toStringAsFixed(2);
        });
        dataMap.putIfAbsent(
            totalTenMinuteEnergy[i]['d_id'],
            () =>
                double.parse(totalTenMinuteEnergy[i]['enrgy10']) +
                double.parse(totalTenMinuteEnergy[i]['enrgy20']) +
                double.parse(totalTenMinuteEnergy[i]['enrgy30']) +
                double.parse(totalTenMinuteEnergy[i]['enrgy40']) +
                double.parse(totalTenMinuteEnergy[i]['enrgy50']) +
                double.parse(totalTenMinuteEnergy[i]['enrgy60']));
      }
    }
  }

  Future getEnergyHour(chooseValueHour) async {
    String? token = await getToken();
    for (int i = 0; i < data.length; i++) {
      var dId = data[i]['d_id'];
      String url = api + 'perhourenergy?d_id=' + dId;
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
          return thereIsNoData();
        }

        for (int i = 0; i < data.length; i++) {
          totalHourEnergy.add(data[i]);
        }
      }
    }
    for (int i = 0; i < totalHourEnergy.length; i++) {
      if (chooseValueHour == '1 hour') {
        setState(() {
          _valueHour = double.parse(totalHourEnergy[i]['hour1']) + _valueHour!;
          varFinalTotalValue = _valueHour!.toStringAsFixed(2);
        });
        dataMap.putIfAbsent(totalHourEnergy[i]['d_id'],
            () => double.parse(totalHourEnergy[i]['hour1']));
      }
      if (chooseValueHour == '2 hour') {
        setState(() {
          _valueHour = double.parse(totalHourEnergy[i]['hour1']) +
              double.parse(totalHourEnergy[i]['hour2']) +
              _valueHour!;
          finalEnergyValue = _valueHour!;
          varFinalTotalValue = _valueHour!.toStringAsFixed(2);
        });
        dataMap.putIfAbsent(
            totalHourEnergy[i]['d_id'],
            () =>
                double.parse(totalHourEnergy[i]['hour1']) +
                double.parse(totalHourEnergy[i]['hour2']));
      }
      if (chooseValueHour == '3 hour') {
        setState(() {
          _valueHour = double.parse(totalHourEnergy[i]['hour1']) +
              double.parse(totalHourEnergy[i]['hour2']) +
              double.parse(totalHourEnergy[i]['hour3']) +
              _valueHour!;
          finalEnergyValue = _valueHour!;
          varFinalTotalValue = _valueHour!.toStringAsFixed(2);
        });
        dataMap.putIfAbsent(
            totalHourEnergy[i]['d_id'],
            () =>
                double.parse(totalHourEnergy[i]['hour1']) +
                double.parse(totalHourEnergy[i]['hour2']) +
                double.parse(totalHourEnergy[i]['hour3']));
      }
      if (chooseValueHour == '4 hour') {
        setState(() {
          _valueHour = double.parse(totalHourEnergy[i]['hour1']) +
              double.parse(totalHourEnergy[i]['hour2']) +
              double.parse(totalHourEnergy[i]['hour3']) +
              double.parse(totalHourEnergy[i]['hour4']) +
              _valueHour!;
          finalEnergyValue = _valueHour!;
          varFinalTotalValue = _valueHour!.toStringAsFixed(2);
        });
        dataMap.putIfAbsent(
            totalHourEnergy[i]['d_id'],
            () =>
                double.parse(totalHourEnergy[i]['hour1']) +
                double.parse(totalHourEnergy[i]['hour2']) +
                double.parse(totalHourEnergy[i]['hour3']) +
                double.parse(totalHourEnergy[i]['hour4']));
      }
      if (chooseValueHour == '5 hour') {
        setState(() {
          _valueHour = double.parse(totalHourEnergy[i]['hour1']) +
              double.parse(totalHourEnergy[i]['hour2']) +
              double.parse(totalHourEnergy[i]['hour3']) +
              double.parse(totalHourEnergy[i]['hour4']) +
              double.parse(totalHourEnergy[i]['hour5']) +
              _valueHour!;
          varFinalTotalValue = _valueHour!.toStringAsFixed(2);
          finalEnergyValue = _valueHour!;
        });
        dataMap.putIfAbsent(
            totalHourEnergy[i]['d_id'],
            () =>
                double.parse(totalHourEnergy[i]['hour1']) +
                double.parse(totalHourEnergy[i]['hour2']) +
                double.parse(totalHourEnergy[i]['hour3']) +
                double.parse(totalHourEnergy[i]['hour4']) +
                double.parse(totalHourEnergy[i]['hour5']));
      }
      if (chooseValueHour == '6 hour') {
        setState(() {
          _valueHour = double.parse(totalHourEnergy[i]['hour1']) +
              double.parse(totalHourEnergy[i]['hour2']) +
              double.parse(totalHourEnergy[i]['hour3']) +
              double.parse(totalHourEnergy[i]['hour4']) +
              double.parse(totalHourEnergy[i]['hour5']) +
              double.parse(totalHourEnergy[i]['hour6']) +
              _valueHour!;
          varFinalTotalValue = _valueHour!.toStringAsFixed(2);
          finalEnergyValue = _valueHour!;
        });
        dataMap.putIfAbsent(
            totalHourEnergy[i]['d_id'],
            () =>
                double.parse(totalHourEnergy[i]['hour1']) +
                double.parse(totalHourEnergy[i]['hour2']) +
                double.parse(totalHourEnergy[i]['hour3']) +
                double.parse(totalHourEnergy[i]['hour4']) +
                double.parse(totalHourEnergy[i]['hour5']) +
                double.parse(totalHourEnergy[i]['hour6']));
      }
      if (chooseValueHour == '7 hour') {
        setState(() {
          _valueHour = double.parse(totalHourEnergy[i]['hour1']) +
              double.parse(totalHourEnergy[i]['hour2']) +
              double.parse(totalHourEnergy[i]['hour3']) +
              double.parse(totalHourEnergy[i]['hour4']) +
              double.parse(totalHourEnergy[i]['hour5']) +
              double.parse(totalHourEnergy[i]['hour6']) +
              double.parse(totalHourEnergy[i]['hour7']) +
              _valueHour!;
          varFinalTotalValue = _valueHour!.toStringAsFixed(2);
          finalEnergyValue = _valueHour!;
        });
        dataMap.putIfAbsent(
            totalHourEnergy[i]['d_id'],
            () =>
                double.parse(totalHourEnergy[i]['hour1']) +
                double.parse(totalHourEnergy[i]['hour2']) +
                double.parse(totalHourEnergy[i]['hour3']) +
                double.parse(totalHourEnergy[i]['hour4']) +
                double.parse(totalHourEnergy[i]['hour5']) +
                double.parse(totalHourEnergy[i]['hour6']) +
                double.parse(totalHourEnergy[i]['hour7']));
      }
      if (chooseValueHour == '8 hour') {
        setState(() {
          _valueHour = double.parse(totalHourEnergy[i]['hour1']) +
              double.parse(totalHourEnergy[i]['hour2']) +
              double.parse(totalHourEnergy[i]['hour3']) +
              double.parse(totalHourEnergy[i]['hour4']) +
              double.parse(totalHourEnergy[i]['hour5']) +
              double.parse(totalHourEnergy[i]['hour6']) +
              double.parse(totalHourEnergy[i]['hour7']) +
              double.parse(totalHourEnergy[i]['hour8']) +
              _valueHour!;
          varFinalTotalValue = _valueHour!.toStringAsFixed(2);
          finalEnergyValue = _valueHour!;
        });
        dataMap.putIfAbsent(
            totalHourEnergy[i]['d_id'],
            () =>
                double.parse(totalHourEnergy[i]['hour1']) +
                double.parse(totalHourEnergy[i]['hour2']) +
                double.parse(totalHourEnergy[i]['hour3']) +
                double.parse(totalHourEnergy[i]['hour4']) +
                double.parse(totalHourEnergy[i]['hour5']) +
                double.parse(totalHourEnergy[i]['hour6']) +
                double.parse(totalHourEnergy[i]['hour7']) +
                double.parse(totalHourEnergy[i]['hour8']));
      }
      if (chooseValueHour == '9 hour') {
        setState(() {
          _valueHour = double.parse(totalHourEnergy[i]['hour1']) +
              double.parse(totalHourEnergy[i]['hour2']) +
              double.parse(totalHourEnergy[i]['hour3']) +
              double.parse(totalHourEnergy[i]['hour4']) +
              double.parse(totalHourEnergy[i]['hour5']) +
              double.parse(totalHourEnergy[i]['hour6']) +
              double.parse(totalHourEnergy[i]['hour7']) +
              double.parse(totalHourEnergy[i]['hour8']) +
              double.parse(totalHourEnergy[i]['hour9']) +
              _valueHour!;
          varFinalTotalValue = _valueHour!.toStringAsFixed(2);
          finalEnergyValue = _valueHour!;
        });
        dataMap.putIfAbsent(
            totalHourEnergy[i]['d_id'],
            () =>
                double.parse(totalHourEnergy[i]['hour1']) +
                double.parse(totalHourEnergy[i]['hour2']) +
                double.parse(totalHourEnergy[i]['hour3']) +
                double.parse(totalHourEnergy[i]['hour4']) +
                double.parse(totalHourEnergy[i]['hour5']) +
                double.parse(totalHourEnergy[i]['hour6']) +
                double.parse(totalHourEnergy[i]['hour7']) +
                double.parse(totalHourEnergy[i]['hour8']) +
                double.parse(totalHourEnergy[i]['hour9']));
      }
      if (chooseValueHour == '10 hour') {
        setState(() {
          _valueHour = double.parse(totalHourEnergy[i]['hour1']) +
              double.parse(totalHourEnergy[i]['hour2']) +
              double.parse(totalHourEnergy[i]['hour3']) +
              double.parse(totalHourEnergy[i]['hour4']) +
              double.parse(totalHourEnergy[i]['hour5']) +
              double.parse(totalHourEnergy[i]['hour6']) +
              double.parse(totalHourEnergy[i]['hour7']) +
              double.parse(totalHourEnergy[i]['hour8']) +
              double.parse(totalHourEnergy[i]['hour9']) +
              double.parse(totalHourEnergy[i]['hour10']) +
              _valueHour!;
          varFinalTotalValue = _valueHour!.toStringAsFixed(2);
          finalEnergyValue = _valueHour!;
        });

        dataMap.putIfAbsent(
            totalHourEnergy[i]['d_id'],
            () =>
                double.parse(totalHourEnergy[i]['hour1']) +
                double.parse(totalHourEnergy[i]['hour2']) +
                double.parse(totalHourEnergy[i]['hour3']) +
                double.parse(totalHourEnergy[i]['hour4']) +
                double.parse(totalHourEnergy[i]['hour5']) +
                double.parse(totalHourEnergy[i]['hour6']) +
                double.parse(totalHourEnergy[i]['hour7']) +
                double.parse(totalHourEnergy[i]['hour8']) +
                double.parse(totalHourEnergy[i]['hour9']) +
                double.parse(totalHourEnergy[i]['hour10']));
      }
      if (chooseValueHour == '11 hour') {
        setState(() {
          _valueHour = double.parse(totalHourEnergy[i]['hour1']) +
              double.parse(totalHourEnergy[i]['hour2']) +
              double.parse(totalHourEnergy[i]['hour3']) +
              double.parse(totalHourEnergy[i]['hour4']) +
              double.parse(totalHourEnergy[i]['hour5']) +
              double.parse(totalHourEnergy[i]['hour6']) +
              double.parse(totalHourEnergy[i]['hour7']) +
              double.parse(totalHourEnergy[i]['hour8']) +
              double.parse(totalHourEnergy[i]['hour9']) +
              double.parse(totalHourEnergy[i]['hour10']) +
              double.parse(totalHourEnergy[i]['hour11']) +
              _valueHour!;
          varFinalTotalValue = _valueHour!.toStringAsFixed(2);
          finalEnergyValue = _valueHour!;
        });

        dataMap.putIfAbsent(
            totalHourEnergy[i]['d_id'],
            () =>
                double.parse(totalHourEnergy[i]['hour1']) +
                double.parse(totalHourEnergy[i]['hour2']) +
                double.parse(totalHourEnergy[i]['hour3']) +
                double.parse(totalHourEnergy[i]['hour4']) +
                double.parse(totalHourEnergy[i]['hour5']) +
                double.parse(totalHourEnergy[i]['hour6']) +
                double.parse(totalHourEnergy[i]['hour7']) +
                double.parse(totalHourEnergy[i]['hour8']) +
                double.parse(totalHourEnergy[i]['hour9']) +
                double.parse(totalHourEnergy[i]['hour10']) +
                double.parse(totalHourEnergy[i]['hour11']));
      }
      if (chooseValueHour == '12 hour') {
        setState(() {
          _valueHour = double.parse(totalHourEnergy[i]['hour1']) +
              double.parse(totalHourEnergy[i]['hour2']) +
              double.parse(totalHourEnergy[i]['hour3']) +
              double.parse(totalHourEnergy[i]['hour4']) +
              double.parse(totalHourEnergy[i]['hour5']) +
              double.parse(totalHourEnergy[i]['hour6']) +
              double.parse(totalHourEnergy[i]['hour7']) +
              double.parse(totalHourEnergy[i]['hour8']) +
              double.parse(totalHourEnergy[i]['hour9']) +
              double.parse(totalHourEnergy[i]['hour10']) +
              double.parse(totalHourEnergy[i]['hour11']) +
              double.parse(totalHourEnergy[i]['hour12']) +
              _valueHour!;
          varFinalTotalValue = _valueHour!.toStringAsFixed(2);
          finalEnergyValue = _valueHour!;
        });

        dataMap.putIfAbsent(
            totalHourEnergy[i]['d_id'],
            () =>
                double.parse(totalHourEnergy[i]['hour1']) +
                double.parse(totalHourEnergy[i]['hour2']) +
                double.parse(totalHourEnergy[i]['hour3']) +
                double.parse(totalHourEnergy[i]['hour4']) +
                double.parse(totalHourEnergy[i]['hour5']) +
                double.parse(totalHourEnergy[i]['hour6']) +
                double.parse(totalHourEnergy[i]['hour7']) +
                double.parse(totalHourEnergy[i]['hour8']) +
                double.parse(totalHourEnergy[i]['hour9']) +
                double.parse(totalHourEnergy[i]['hour10']) +
                double.parse(totalHourEnergy[i]['hour11']) +
                double.parse(totalHourEnergy[i]['hour12']));
      }
      if (chooseValueHour == '13 hour') {
        setState(() {
          _valueHour = double.parse(totalHourEnergy[i]['hour1']) +
              double.parse(totalHourEnergy[i]['hour2']) +
              double.parse(totalHourEnergy[i]['hour3']) +
              double.parse(totalHourEnergy[i]['hour4']) +
              double.parse(totalHourEnergy[i]['hour5']) +
              double.parse(totalHourEnergy[i]['hour6']) +
              double.parse(totalHourEnergy[i]['hour7']) +
              double.parse(totalHourEnergy[i]['hour8']) +
              double.parse(totalHourEnergy[i]['hour9']) +
              double.parse(totalHourEnergy[i]['hour10']) +
              double.parse(totalHourEnergy[i]['hour11']) +
              double.parse(totalHourEnergy[i]['hour12']) +
              double.parse(totalHourEnergy[i]['hour13']) +
              _valueHour!;
          varFinalTotalValue = _valueHour!.toStringAsFixed(2);
          finalEnergyValue = _valueHour!;
        });

        dataMap.putIfAbsent(
            totalHourEnergy[i]['d_id'],
            () =>
                double.parse(totalHourEnergy[i]['hour1']) +
                double.parse(totalHourEnergy[i]['hour2']) +
                double.parse(totalHourEnergy[i]['hour3']) +
                double.parse(totalHourEnergy[i]['hour4']) +
                double.parse(totalHourEnergy[i]['hour5']) +
                double.parse(totalHourEnergy[i]['hour6']) +
                double.parse(totalHourEnergy[i]['hour7']) +
                double.parse(totalHourEnergy[i]['hour8']) +
                double.parse(totalHourEnergy[i]['hour9']) +
                double.parse(totalHourEnergy[i]['hour10']) +
                double.parse(totalHourEnergy[i]['hour11']) +
                double.parse(totalHourEnergy[i]['hour12']) +
                double.parse(totalHourEnergy[i]['hour13']));
      }
      if (chooseValueHour == '14 hour') {
        setState(() {
          _valueHour = double.parse(totalHourEnergy[i]['hour1']) +
              double.parse(totalHourEnergy[i]['hour2']) +
              double.parse(totalHourEnergy[i]['hour3']) +
              double.parse(totalHourEnergy[i]['hour4']) +
              double.parse(totalHourEnergy[i]['hour5']) +
              double.parse(totalHourEnergy[i]['hour6']) +
              double.parse(totalHourEnergy[i]['hour7']) +
              double.parse(totalHourEnergy[i]['hour8']) +
              double.parse(totalHourEnergy[i]['hour9']) +
              double.parse(totalHourEnergy[i]['hour10']) +
              double.parse(totalHourEnergy[i]['hour11']) +
              double.parse(totalHourEnergy[i]['hour12']) +
              double.parse(totalHourEnergy[i]['hour13']) +
              double.parse(totalHourEnergy[i]['hour14']) +
              _valueHour!;
          varFinalTotalValue = _valueHour!.toStringAsFixed(2);
          finalEnergyValue = _valueHour!;
        });
        dataMap.putIfAbsent(
            totalHourEnergy[i]['d_id'],
            () =>
                double.parse(totalHourEnergy[i]['hour1']) +
                double.parse(totalHourEnergy[i]['hour2']) +
                double.parse(totalHourEnergy[i]['hour3']) +
                double.parse(totalHourEnergy[i]['hour4']) +
                double.parse(totalHourEnergy[i]['hour5']) +
                double.parse(totalHourEnergy[i]['hour6']) +
                double.parse(totalHourEnergy[i]['hour7']) +
                double.parse(totalHourEnergy[i]['hour8']) +
                double.parse(totalHourEnergy[i]['hour9']) +
                double.parse(totalHourEnergy[i]['hour10']) +
                double.parse(totalHourEnergy[i]['hour11']) +
                double.parse(totalHourEnergy[i]['hour12']) +
                double.parse(totalHourEnergy[i]['hour13']) +
                double.parse(totalHourEnergy[i]['hour14']));
      }
      if (chooseValueHour == '15 hour') {
        setState(() {
          _valueHour = double.parse(totalHourEnergy[i]['hour1']) +
              double.parse(totalHourEnergy[i]['hour2']) +
              double.parse(totalHourEnergy[i]['hour3']) +
              double.parse(totalHourEnergy[i]['hour4']) +
              double.parse(totalHourEnergy[i]['hour5']) +
              double.parse(totalHourEnergy[i]['hour6']) +
              double.parse(totalHourEnergy[i]['hour7']) +
              double.parse(totalHourEnergy[i]['hour8']) +
              double.parse(totalHourEnergy[i]['hour9']) +
              double.parse(totalHourEnergy[i]['hour10']) +
              double.parse(totalHourEnergy[i]['hour11']) +
              double.parse(totalHourEnergy[i]['hour12']) +
              double.parse(totalHourEnergy[i]['hour13']) +
              double.parse(totalHourEnergy[i]['hour14']) +
              double.parse(totalHourEnergy[i]['hour15']) +
              _valueHour!;
          varFinalTotalValue = _valueHour!.toStringAsFixed(2);
          finalEnergyValue = _valueHour!;
        });
        dataMap.putIfAbsent(
            totalHourEnergy[i]['d_id'],
            () =>
                double.parse(totalHourEnergy[i]['hour1']) +
                double.parse(totalHourEnergy[i]['hour2']) +
                double.parse(totalHourEnergy[i]['hour3']) +
                double.parse(totalHourEnergy[i]['hour4']) +
                double.parse(totalHourEnergy[i]['hour5']) +
                double.parse(totalHourEnergy[i]['hour6']) +
                double.parse(totalHourEnergy[i]['hour7']) +
                double.parse(totalHourEnergy[i]['hour8']) +
                double.parse(totalHourEnergy[i]['hour9']) +
                double.parse(totalHourEnergy[i]['hour10']) +
                double.parse(totalHourEnergy[i]['hour11']) +
                double.parse(totalHourEnergy[i]['hour12']) +
                double.parse(totalHourEnergy[i]['hour13']) +
                double.parse(totalHourEnergy[i]['hour14']) +
                double.parse(totalHourEnergy[i]['hour15']));
      }
      if (chooseValueHour == '16 hour') {
        setState(() {
          _valueHour = double.parse(totalHourEnergy[i]['hour1']) +
              double.parse(totalHourEnergy[i]['hour2']) +
              double.parse(totalHourEnergy[i]['hour3']) +
              double.parse(totalHourEnergy[i]['hour4']) +
              double.parse(totalHourEnergy[i]['hour5']) +
              double.parse(totalHourEnergy[i]['hour6']) +
              double.parse(totalHourEnergy[i]['hour7']) +
              double.parse(totalHourEnergy[i]['hour8']) +
              double.parse(totalHourEnergy[i]['hour9']) +
              double.parse(totalHourEnergy[i]['hour10']) +
              double.parse(totalHourEnergy[i]['hour11']) +
              double.parse(totalHourEnergy[i]['hour12']) +
              double.parse(totalHourEnergy[i]['hour13']) +
              double.parse(totalHourEnergy[i]['hour14']) +
              double.parse(totalHourEnergy[i]['hour15']) +
              double.parse(totalHourEnergy[i]['hour16']) +
              _valueHour!;
          varFinalTotalValue = _valueHour!.toStringAsFixed(2);
          finalEnergyValue = _valueHour!;
        });
        dataMap.putIfAbsent(
            totalHourEnergy[i]['d_id'],
            () =>
                double.parse(totalHourEnergy[i]['hour1']) +
                double.parse(totalHourEnergy[i]['hour2']) +
                double.parse(totalHourEnergy[i]['hour3']) +
                double.parse(totalHourEnergy[i]['hour4']) +
                double.parse(totalHourEnergy[i]['hour5']) +
                double.parse(totalHourEnergy[i]['hour6']) +
                double.parse(totalHourEnergy[i]['hour7']) +
                double.parse(totalHourEnergy[i]['hour8']) +
                double.parse(totalHourEnergy[i]['hour9']) +
                double.parse(totalHourEnergy[i]['hour10']) +
                double.parse(totalHourEnergy[i]['hour11']) +
                double.parse(totalHourEnergy[i]['hour12']) +
                double.parse(totalHourEnergy[i]['hour13']) +
                double.parse(totalHourEnergy[i]['hour14']) +
                double.parse(totalHourEnergy[i]['hour15']) +
                double.parse(totalHourEnergy[i]['hour16']));
      }
      if (chooseValueHour == '17 hour') {
        setState(() {
          _valueHour = double.parse(totalHourEnergy[i]['hour1']) +
              double.parse(totalHourEnergy[i]['hour2']) +
              double.parse(totalHourEnergy[i]['hour3']) +
              double.parse(totalHourEnergy[i]['hour4']) +
              double.parse(totalHourEnergy[i]['hour5']) +
              double.parse(totalHourEnergy[i]['hour6']) +
              double.parse(totalHourEnergy[i]['hour7']) +
              double.parse(totalHourEnergy[i]['hour8']) +
              double.parse(totalHourEnergy[i]['hour9']) +
              double.parse(totalHourEnergy[i]['hour10']) +
              double.parse(totalHourEnergy[i]['hour11']) +
              double.parse(totalHourEnergy[i]['hour12']) +
              double.parse(totalHourEnergy[i]['hour13']) +
              double.parse(totalHourEnergy[i]['hour14']) +
              double.parse(totalHourEnergy[i]['hour15']) +
              double.parse(totalHourEnergy[i]['hour16']) +
              double.parse(totalHourEnergy[i]['hour17']) +
              _valueHour!;
          varFinalTotalValue = _valueHour!.toStringAsFixed(2);
          finalEnergyValue = _valueHour!;
        });
        dataMap.putIfAbsent(
            totalHourEnergy[i]['d_id'],
            () =>
                double.parse(totalHourEnergy[i]['hour1']) +
                double.parse(totalHourEnergy[i]['hour2']) +
                double.parse(totalHourEnergy[i]['hour3']) +
                double.parse(totalHourEnergy[i]['hour4']) +
                double.parse(totalHourEnergy[i]['hour5']) +
                double.parse(totalHourEnergy[i]['hour6']) +
                double.parse(totalHourEnergy[i]['hour7']) +
                double.parse(totalHourEnergy[i]['hour8']) +
                double.parse(totalHourEnergy[i]['hour9']) +
                double.parse(totalHourEnergy[i]['hour10']) +
                double.parse(totalHourEnergy[i]['hour11']) +
                double.parse(totalHourEnergy[i]['hour12']) +
                double.parse(totalHourEnergy[i]['hour13']) +
                double.parse(totalHourEnergy[i]['hour14']) +
                double.parse(totalHourEnergy[i]['hour15']) +
                double.parse(totalHourEnergy[i]['hour16']) +
                double.parse(totalHourEnergy[i]['hour17']));
      }
      if (chooseValueHour == '18 hour') {
        setState(() {
          _valueHour = double.parse(totalHourEnergy[i]['hour1']) +
              double.parse(totalHourEnergy[i]['hour2']) +
              double.parse(totalHourEnergy[i]['hour3']) +
              double.parse(totalHourEnergy[i]['hour4']) +
              double.parse(totalHourEnergy[i]['hour5']) +
              double.parse(totalHourEnergy[i]['hour6']) +
              double.parse(totalHourEnergy[i]['hour7']) +
              double.parse(totalHourEnergy[i]['hour8']) +
              double.parse(totalHourEnergy[i]['hour9']) +
              double.parse(totalHourEnergy[i]['hour10']) +
              double.parse(totalHourEnergy[i]['hour11']) +
              double.parse(totalHourEnergy[i]['hour12']) +
              double.parse(totalHourEnergy[i]['hour13']) +
              double.parse(totalHourEnergy[i]['hour14']) +
              double.parse(totalHourEnergy[i]['hour15']) +
              double.parse(totalHourEnergy[i]['hour16']) +
              double.parse(totalHourEnergy[i]['hour17']) +
              double.parse(totalHourEnergy[i]['hour18']) +
              _valueHour!;
          varFinalTotalValue = _valueHour!.toStringAsFixed(2);
          finalEnergyValue = _valueHour!;
        });
        dataMap.putIfAbsent(
            totalHourEnergy[i]['d_id'],
            () =>
                double.parse(totalHourEnergy[i]['hour1']) +
                double.parse(totalHourEnergy[i]['hour2']) +
                double.parse(totalHourEnergy[i]['hour3']) +
                double.parse(totalHourEnergy[i]['hour4']) +
                double.parse(totalHourEnergy[i]['hour5']) +
                double.parse(totalHourEnergy[i]['hour6']) +
                double.parse(totalHourEnergy[i]['hour7']) +
                double.parse(totalHourEnergy[i]['hour8']) +
                double.parse(totalHourEnergy[i]['hour9']) +
                double.parse(totalHourEnergy[i]['hour10']) +
                double.parse(totalHourEnergy[i]['hour11']) +
                double.parse(totalHourEnergy[i]['hour12']) +
                double.parse(totalHourEnergy[i]['hour13']) +
                double.parse(totalHourEnergy[i]['hour14']) +
                double.parse(totalHourEnergy[i]['hour15']) +
                double.parse(totalHourEnergy[i]['hour16']) +
                double.parse(totalHourEnergy[i]['hour17']) +
                double.parse(totalHourEnergy[i]['hour18']));
      }
      if (chooseValueHour == '19 hour') {
        setState(() {
          _valueHour = double.parse(totalHourEnergy[i]['hour1']) +
              double.parse(totalHourEnergy[i]['hour2']) +
              double.parse(totalHourEnergy[i]['hour3']) +
              double.parse(totalHourEnergy[i]['hour4']) +
              double.parse(totalHourEnergy[i]['hour5']) +
              double.parse(totalHourEnergy[i]['hour6']) +
              double.parse(totalHourEnergy[i]['hour7']) +
              double.parse(totalHourEnergy[i]['hour8']) +
              double.parse(totalHourEnergy[i]['hour9']) +
              double.parse(totalHourEnergy[i]['hour10']) +
              double.parse(totalHourEnergy[i]['hour11']) +
              double.parse(totalHourEnergy[i]['hour12']) +
              double.parse(totalHourEnergy[i]['hour13']) +
              double.parse(totalHourEnergy[i]['hour14']) +
              double.parse(totalHourEnergy[i]['hour15']) +
              double.parse(totalHourEnergy[i]['hour16']) +
              double.parse(totalHourEnergy[i]['hour17']) +
              double.parse(totalHourEnergy[i]['hour18']) +
              double.parse(totalHourEnergy[i]['hour19']) +
              _valueHour!;
          varFinalTotalValue = _valueHour!.toStringAsFixed(2);
          finalEnergyValue = _valueHour!;
        });

        dataMap.putIfAbsent(
            totalHourEnergy[i]['d_id'],
            () =>
                double.parse(totalHourEnergy[i]['hour1']) +
                double.parse(totalHourEnergy[i]['hour2']) +
                double.parse(totalHourEnergy[i]['hour3']) +
                double.parse(totalHourEnergy[i]['hour4']) +
                double.parse(totalHourEnergy[i]['hour5']) +
                double.parse(totalHourEnergy[i]['hour6']) +
                double.parse(totalHourEnergy[i]['hour7']) +
                double.parse(totalHourEnergy[i]['hour8']) +
                double.parse(totalHourEnergy[i]['hour9']) +
                double.parse(totalHourEnergy[i]['hour10']) +
                double.parse(totalHourEnergy[i]['hour11']) +
                double.parse(totalHourEnergy[i]['hour12']) +
                double.parse(totalHourEnergy[i]['hour13']) +
                double.parse(totalHourEnergy[i]['hour14']) +
                double.parse(totalHourEnergy[i]['hour15']) +
                double.parse(totalHourEnergy[i]['hour16']) +
                double.parse(totalHourEnergy[i]['hour17']) +
                double.parse(totalHourEnergy[i]['hour18']) +
                double.parse(totalHourEnergy[i]['hour19']));
      }
      if (chooseValueHour == '20 hour') {
        setState(() {
          _valueHour = double.parse(totalHourEnergy[i]['hour1']) +
              double.parse(totalHourEnergy[i]['hour2']) +
              double.parse(totalHourEnergy[i]['hour3']) +
              double.parse(totalHourEnergy[i]['hour4']) +
              double.parse(totalHourEnergy[i]['hour5']) +
              double.parse(totalHourEnergy[i]['hour6']) +
              double.parse(totalHourEnergy[i]['hour7']) +
              double.parse(totalHourEnergy[i]['hour8']) +
              double.parse(totalHourEnergy[i]['hour9']) +
              double.parse(totalHourEnergy[i]['hour10']) +
              double.parse(totalHourEnergy[i]['hour11']) +
              double.parse(totalHourEnergy[i]['hour12']) +
              double.parse(totalHourEnergy[i]['hour13']) +
              double.parse(totalHourEnergy[i]['hour14']) +
              double.parse(totalHourEnergy[i]['hour15']) +
              double.parse(totalHourEnergy[i]['hour16']) +
              double.parse(totalHourEnergy[i]['hour17']) +
              double.parse(totalHourEnergy[i]['hour18']) +
              double.parse(totalHourEnergy[i]['hour19']) +
              double.parse(totalHourEnergy[i]['hour20']) +
              _valueHour!;
          varFinalTotalValue = _valueHour!.toStringAsFixed(2);
          finalEnergyValue = _valueHour!;
        });
        dataMap.putIfAbsent(
            totalHourEnergy[i]['d_id'],
            () =>
                double.parse(totalHourEnergy[i]['hour1']) +
                double.parse(totalHourEnergy[i]['hour2']) +
                double.parse(totalHourEnergy[i]['hour3']) +
                double.parse(totalHourEnergy[i]['hour4']) +
                double.parse(totalHourEnergy[i]['hour5']) +
                double.parse(totalHourEnergy[i]['hour6']) +
                double.parse(totalHourEnergy[i]['hour7']) +
                double.parse(totalHourEnergy[i]['hour8']) +
                double.parse(totalHourEnergy[i]['hour9']) +
                double.parse(totalHourEnergy[i]['hour10']) +
                double.parse(totalHourEnergy[i]['hour11']) +
                double.parse(totalHourEnergy[i]['hour12']) +
                double.parse(totalHourEnergy[i]['hour13']) +
                double.parse(totalHourEnergy[i]['hour14']) +
                double.parse(totalHourEnergy[i]['hour15']) +
                double.parse(totalHourEnergy[i]['hour16']) +
                double.parse(totalHourEnergy[i]['hour17']) +
                double.parse(totalHourEnergy[i]['hour18']) +
                double.parse(totalHourEnergy[i]['hour19']) +
                double.parse(totalHourEnergy[i]['hour20']));
      }
      if (chooseValueHour == '21 hour') {
        setState(() {
          _valueHour = double.parse(totalHourEnergy[i]['hour1']) +
              double.parse(totalHourEnergy[i]['hour2']) +
              double.parse(totalHourEnergy[i]['hour3']) +
              double.parse(totalHourEnergy[i]['hour4']) +
              double.parse(totalHourEnergy[i]['hour5']) +
              double.parse(totalHourEnergy[i]['hour6']) +
              double.parse(totalHourEnergy[i]['hour7']) +
              double.parse(totalHourEnergy[i]['hour8']) +
              double.parse(totalHourEnergy[i]['hour9']) +
              double.parse(totalHourEnergy[i]['hour10']) +
              double.parse(totalHourEnergy[i]['hour11']) +
              double.parse(totalHourEnergy[i]['hour12']) +
              double.parse(totalHourEnergy[i]['hour13']) +
              double.parse(totalHourEnergy[i]['hour14']) +
              double.parse(totalHourEnergy[i]['hour15']) +
              double.parse(totalHourEnergy[i]['hour16']) +
              double.parse(totalHourEnergy[i]['hour17']) +
              double.parse(totalHourEnergy[i]['hour18']) +
              double.parse(totalHourEnergy[i]['hour19']) +
              double.parse(totalHourEnergy[i]['hour20']) +
              double.parse(totalHourEnergy[i]['hour21']) +
              _valueHour!;
          varFinalTotalValue = _valueHour!.toStringAsFixed(2);
          finalEnergyValue = _valueHour!;
        });

        dataMap.putIfAbsent(
            totalHourEnergy[i]['d_id'],
            () =>
                double.parse(totalHourEnergy[i]['hour1']) +
                double.parse(totalHourEnergy[i]['hour2']) +
                double.parse(totalHourEnergy[i]['hour3']) +
                double.parse(totalHourEnergy[i]['hour4']) +
                double.parse(totalHourEnergy[i]['hour5']) +
                double.parse(totalHourEnergy[i]['hour6']) +
                double.parse(totalHourEnergy[i]['hour7']) +
                double.parse(totalHourEnergy[i]['hour8']) +
                double.parse(totalHourEnergy[i]['hour9']) +
                double.parse(totalHourEnergy[i]['hour10']) +
                double.parse(totalHourEnergy[i]['hour11']) +
                double.parse(totalHourEnergy[i]['hour12']) +
                double.parse(totalHourEnergy[i]['hour13']) +
                double.parse(totalHourEnergy[i]['hour14']) +
                double.parse(totalHourEnergy[i]['hour15']) +
                double.parse(totalHourEnergy[i]['hour16']) +
                double.parse(totalHourEnergy[i]['hour17']) +
                double.parse(totalHourEnergy[i]['hour18']) +
                double.parse(totalHourEnergy[i]['hour19']) +
                double.parse(totalHourEnergy[i]['hour20']) +
                double.parse(totalHourEnergy[i]['hour21']));
      }
      if (chooseValueHour == '22 hour') {
        setState(() {
          _valueHour = double.parse(totalHourEnergy[i]['hour1']) +
              double.parse(totalHourEnergy[i]['hour2']) +
              double.parse(totalHourEnergy[i]['hour3']) +
              double.parse(totalHourEnergy[i]['hour4']) +
              double.parse(totalHourEnergy[i]['hour5']) +
              double.parse(totalHourEnergy[i]['hour6']) +
              double.parse(totalHourEnergy[i]['hour7']) +
              double.parse(totalHourEnergy[i]['hour8']) +
              double.parse(totalHourEnergy[i]['hour9']) +
              double.parse(totalHourEnergy[i]['hour10']) +
              double.parse(totalHourEnergy[i]['hour11']) +
              double.parse(totalHourEnergy[i]['hour12']) +
              double.parse(totalHourEnergy[i]['hour13']) +
              double.parse(totalHourEnergy[i]['hour14']) +
              double.parse(totalHourEnergy[i]['hour15']) +
              double.parse(totalHourEnergy[i]['hour16']) +
              double.parse(totalHourEnergy[i]['hour17']) +
              double.parse(totalHourEnergy[i]['hour18']) +
              double.parse(totalHourEnergy[i]['hour19']) +
              double.parse(totalHourEnergy[i]['hour20']) +
              double.parse(totalHourEnergy[i]['hour21']) +
              double.parse(totalHourEnergy[i]['hour22']) +
              _valueHour!;
          varFinalTotalValue = _valueHour!.toStringAsFixed(2);
          finalEnergyValue = _valueHour!;
        });

        dataMap.putIfAbsent(
            totalHourEnergy[i]['d_id'],
            () =>
                double.parse(totalHourEnergy[i]['hour1']) +
                double.parse(totalHourEnergy[i]['hour2']) +
                double.parse(totalHourEnergy[i]['hour3']) +
                double.parse(totalHourEnergy[i]['hour4']) +
                double.parse(totalHourEnergy[i]['hour5']) +
                double.parse(totalHourEnergy[i]['hour6']) +
                double.parse(totalHourEnergy[i]['hour7']) +
                double.parse(totalHourEnergy[i]['hour8']) +
                double.parse(totalHourEnergy[i]['hour9']) +
                double.parse(totalHourEnergy[i]['hour10']) +
                double.parse(totalHourEnergy[i]['hour11']) +
                double.parse(totalHourEnergy[i]['hour12']) +
                double.parse(totalHourEnergy[i]['hour13']) +
                double.parse(totalHourEnergy[i]['hour14']) +
                double.parse(totalHourEnergy[i]['hour15']) +
                double.parse(totalHourEnergy[i]['hour16']) +
                double.parse(totalHourEnergy[i]['hour17']) +
                double.parse(totalHourEnergy[i]['hour18']) +
                double.parse(totalHourEnergy[i]['hour19']) +
                double.parse(totalHourEnergy[i]['hour20']) +
                double.parse(totalHourEnergy[i]['hour21']) +
                double.parse(totalHourEnergy[i]['hour22']));
      }
      if (chooseValueHour == '23 hour') {
        setState(() {
          _valueHour = double.parse(totalHourEnergy[i]['hour1']) +
              double.parse(totalHourEnergy[i]['hour2']) +
              double.parse(totalHourEnergy[i]['hour3']) +
              double.parse(totalHourEnergy[i]['hour4']) +
              double.parse(totalHourEnergy[i]['hour5']) +
              double.parse(totalHourEnergy[i]['hour6']) +
              double.parse(totalHourEnergy[i]['hour7']) +
              double.parse(totalHourEnergy[i]['hour8']) +
              double.parse(totalHourEnergy[i]['hour9']) +
              double.parse(totalHourEnergy[i]['hour10']) +
              double.parse(totalHourEnergy[i]['hour11']) +
              double.parse(totalHourEnergy[i]['hour12']) +
              double.parse(totalHourEnergy[i]['hour13']) +
              double.parse(totalHourEnergy[i]['hour14']) +
              double.parse(totalHourEnergy[i]['hour15']) +
              double.parse(totalHourEnergy[i]['hour16']) +
              double.parse(totalHourEnergy[i]['hour17']) +
              double.parse(totalHourEnergy[i]['hour18']) +
              double.parse(totalHourEnergy[i]['hour19']) +
              double.parse(totalHourEnergy[i]['hour20']) +
              double.parse(totalHourEnergy[i]['hour21']) +
              double.parse(totalHourEnergy[i]['hour22']) +
              double.parse(totalHourEnergy[i]['hour23']) +
              _valueHour!;
          varFinalTotalValue = _valueHour!.toStringAsFixed(2);
          finalEnergyValue = _valueHour!;
        });

        dataMap.putIfAbsent(
            totalHourEnergy[i]['d_id'],
            () =>
                double.parse(totalHourEnergy[i]['hour1']) +
                double.parse(totalHourEnergy[i]['hour2']) +
                double.parse(totalHourEnergy[i]['hour3']) +
                double.parse(totalHourEnergy[i]['hour4']) +
                double.parse(totalHourEnergy[i]['hour5']) +
                double.parse(totalHourEnergy[i]['hour6']) +
                double.parse(totalHourEnergy[i]['hour7']) +
                double.parse(totalHourEnergy[i]['hour8']) +
                double.parse(totalHourEnergy[i]['hour9']) +
                double.parse(totalHourEnergy[i]['hour10']) +
                double.parse(totalHourEnergy[i]['hour11']) +
                double.parse(totalHourEnergy[i]['hour12']) +
                double.parse(totalHourEnergy[i]['hour13']) +
                double.parse(totalHourEnergy[i]['hour14']) +
                double.parse(totalHourEnergy[i]['hour15']) +
                double.parse(totalHourEnergy[i]['hour16']) +
                double.parse(totalHourEnergy[i]['hour17']) +
                double.parse(totalHourEnergy[i]['hour18']) +
                double.parse(totalHourEnergy[i]['hour19']) +
                double.parse(totalHourEnergy[i]['hour20']) +
                double.parse(totalHourEnergy[i]['hour21']) +
                double.parse(totalHourEnergy[i]['hour22']) +
                double.parse(totalHourEnergy[i]['hour23']));
      }
      if (chooseValueHour == '24 hour') {
        setState(() {
          _valueHour = double.parse(totalHourEnergy[i]['hour1']) +
              double.parse(totalHourEnergy[i]['hour2']) +
              double.parse(totalHourEnergy[i]['hour3']) +
              double.parse(totalHourEnergy[i]['hour4']) +
              double.parse(totalHourEnergy[i]['hour5']) +
              double.parse(totalHourEnergy[i]['hour6']) +
              double.parse(totalHourEnergy[i]['hour7']) +
              double.parse(totalHourEnergy[i]['hour8']) +
              double.parse(totalHourEnergy[i]['hour9']) +
              double.parse(totalHourEnergy[i]['hour10']) +
              double.parse(totalHourEnergy[i]['hour11']) +
              double.parse(totalHourEnergy[i]['hour12']) +
              double.parse(totalHourEnergy[i]['hour13']) +
              double.parse(totalHourEnergy[i]['hour14']) +
              double.parse(totalHourEnergy[i]['hour15']) +
              double.parse(totalHourEnergy[i]['hour16']) +
              double.parse(totalHourEnergy[i]['hour17']) +
              double.parse(totalHourEnergy[i]['hour18']) +
              double.parse(totalHourEnergy[i]['hour19']) +
              double.parse(totalHourEnergy[i]['hour20']) +
              double.parse(totalHourEnergy[i]['hour21']) +
              double.parse(totalHourEnergy[i]['hour22']) +
              double.parse(totalHourEnergy[i]['hour23']) +
              double.parse(totalHourEnergy[i]['hour24']) +
              _valueHour!;
          varFinalTotalValue = _valueHour!.toStringAsFixed(2);
          finalEnergyValue = _valueHour!;
        });

        dataMap.putIfAbsent(
            totalHourEnergy[i]['d_id'],
            () =>
                double.parse(totalHourEnergy[i]['hour1']) +
                double.parse(totalHourEnergy[i]['hour2']) +
                double.parse(totalHourEnergy[i]['hour3']) +
                double.parse(totalHourEnergy[i]['hour4']) +
                double.parse(totalHourEnergy[i]['hour5']) +
                double.parse(totalHourEnergy[i]['hour6']) +
                double.parse(totalHourEnergy[i]['hour7']) +
                double.parse(totalHourEnergy[i]['hour8']) +
                double.parse(totalHourEnergy[i]['hour9']) +
                double.parse(totalHourEnergy[i]['hour10']) +
                double.parse(totalHourEnergy[i]['hour11']) +
                double.parse(totalHourEnergy[i]['hour12']) +
                double.parse(totalHourEnergy[i]['hour13']) +
                double.parse(totalHourEnergy[i]['hour14']) +
                double.parse(totalHourEnergy[i]['hour15']) +
                double.parse(totalHourEnergy[i]['hour16']) +
                double.parse(totalHourEnergy[i]['hour17']) +
                double.parse(totalHourEnergy[i]['hour18']) +
                double.parse(totalHourEnergy[i]['hour19']) +
                double.parse(totalHourEnergy[i]['hour20']) +
                double.parse(totalHourEnergy[i]['hour21']) +
                double.parse(totalHourEnergy[i]['hour22']) +
                double.parse(totalHourEnergy[i]['hour23']) +
                double.parse(totalHourEnergy[i]['hour24']));
      }
    }
  }

  thereIsNoData() {
    return AwesomeDialog(
      context: context,
      dialogType: DialogType.ERROR,
      animType: AnimType.BOTTOMSLIDE,
      title: 'Empty',
      desc: 'There is No Data....',
      btnCancelOnPress: () {
        Navigator.of(context).pop();
      },
      btnOkOnPress: () async {
        Navigator.of(context).pop();
      },
    )..show();
  }

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

  Future showDatePicker2() async {
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

  allFindFunc() async {
    setState(() {
      finalEnergyValue = 0.0;
      total = 0.0;
      dataMap = {};
      onlyDayEnergyList = List.empty(growable: true);
    });
    await differenceCurrentDateToSelectedDate();
    await findDifferenceBetweenDates();
    await getEnergyDay();
  }

  Future getEnergyDay() async {
    String? token = await getToken();
    for (int j = 0; j < data.length; j++) {
      var dId = data[j]['d_id'];
      String url = api + 'perdaysenergy?d_id=' + dId;
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Token $token',
      });
      if (response.statusCode == 200) {
        List<dynamic> ans = jsonDecode(response.body);

        if (ans.isEmpty) {
          setState(() {
            pleaseSelect = 'There is not Data';
          });
          return thereIsNoData();
        }
        for (int i = 0; i < ans.length; i++) {
          onlyDayEnergyList.add(ans[i]);
        }
      }
    }
    await sumYearData();
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
      dataMap.putIfAbsent(onlyDayEnergyList[i]['d_id'], () => finalEnergyValue);

      i++;
    }

    total = 0.0;
  }





}
