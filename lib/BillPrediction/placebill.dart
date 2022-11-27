// ignore_for_file: prefer_if_null_operators, unnecessary_null_comparison, prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:genorion_mac_android/BillPrediction/totalusage.dart';

import '../LocalDatabase/alldb.dart';
import '../Models/floormodel.dart';
import '../Models/placemodel.dart';
import '../main.dart';
import 'package:http/http.dart' as http;

class PlaceBill extends StatefulWidget {
  const PlaceBill({Key? key}) : super(key: key);

  @override
  _PlaceBillState createState() => _PlaceBillState();
}

class _PlaceBillState extends State<PlaceBill> {
  Future<List<PlaceType>>? placeVal;
  bool completeTask = false;
  bool changeplace = true;
  bool changeFloor = true;
  bool changeFlat = true;
  bool changeroom = true;
  bool changeDevice = true;
  var deviceData = List.empty(growable: true);

  List minute = [
    '10 minute',
    '20 minute',
    '30 minute',
    '40 minute',
    '50 minute',
    '60 minute'
  ];
  DateTime? date2;
  DateTime? date1;
  String datefinal = "";
  double? _valueHour;
  String? cutDate;
  String? cutDate2;
  var storage = const FlutterSecureStorage();
  String? chooseValueMinute;
  var last10Minute = 'Please Select';
  var pleaseSelect = 'Please Select';
  double? _valueMinute;
  var totalTenMinuteEnergy = List.empty(growable: true);
  double? finalEnergyValue;
  String? varFinalTotalValue;
  String? chooseValueHour;
  int currentDifference = 0;
  var difference;
  double total = 0.0;
  var onlyDayEnergyList = List.empty(growable: true);
  var totalHourEnergy = List.empty(growable: true);
  var totalValueOfEnergy = List.empty(growable: true);
  double totalAmountInRs = 0.0;
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
  TextEditingController billTotalController = TextEditingController();
  var flt = List.empty(growable: true);
  List<FloorType> floorType = [];
  var placeId;
  Map<String, double> dataMap = {};
  var allRoom = List.empty(growable: true);

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
                        child: const Text("Place Bill",
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
            changePlace()
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
                                    completeTask = true;
                                    placeId = selectPlace!.pId;
                                    floorQueryFunc(placeId);
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
                            total = 0.0;
                            totalTenMinuteEnergy = List.empty(growable: true);
                            allRoom = List.empty(growable: true);
                            deviceData = List.empty(growable: true);
                            flt = List.empty(growable: true);
                            totalValueOfEnergy = List.empty(growable: true);
                            dataMap = {};
                          });

                          await floorQueryFunc2(placeId);
                          // await getEnergyTenMinutes(chooseValueMinute);
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
                          : _valueMinute!.toStringAsFixed(2),
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
                            flt = List.empty(growable: true);
                            allRoom = List.empty(growable: true);

                            total = 0.0;
                            totalTenMinuteEnergy = List.empty(growable: true);
                            allRoom = List.empty(growable: true);
                            deviceData = List.empty(growable: true);
                            flt = List.empty(growable: true);
                            totalValueOfEnergy = List.empty(growable: true);
                            dataMap = {};
                          });
                          await floorQueryFuncForHourEnergy(placeId);
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
                        varFinalTotalValue.toString() == null
                            ? "Total Value"
                            : varFinalTotalValue.toString(),
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
                                      totalEnergy:
                                          varFinalTotalValue.toString(),
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
    setState(() {
      int rsConversion = int.parse(rsValue);
      double conversion = double.parse(varFinalTotalValue.toString());
      totalAmountInRs = (conversion / 1000) * rsConversion;
    });
  }

  Future<List<PlaceType>> placeQueryFunc() async {
    List data = await AllDatabase.instance.queryPlace();
    List<PlaceType> placeType = [];
    setState(() {
      placeType = data.map((data) => PlaceType.fromJson(data)).toList();
    });

    return placeType;
  }

  Future floorQueryFunc(id) async {
    List data = await AllDatabase.instance.getFloorById(id);
    setState(() {
      floorType = data.map((data) => FloorType.fromJson(data)).toList();
    });
    await flatQuery();
  }

  Future floorQueryFunc2(id) async {
    List data = await AllDatabase.instance.getFloorById(id);
    List<FloorType> floorType = [];
    setState(() {
      floorType = data.map((data) => FloorType.fromJson(data)).toList();
      totalValueOfEnergy = List.filled(floorType.length, 0);
    });
    await flatQueryFunc2(floorType);
  }

  Future floorQueryFuncForHourEnergy(id) async {
    List data = await AllDatabase.instance.getFloorById(id);
    List<FloorType> floorType = [];
    setState(() {
      floorType = data.map((data) => FloorType.fromJson(data)).toList();
      totalValueOfEnergy = List.filled(floorType.length, 0);
    });
    await flatQueryFuncForHourEnergy(floorType);
  }

  Future floorQueryFuncForDayEnergy(id) async {
    List data = await AllDatabase.instance.getFloorById(id);
    List<FloorType> floorType = [];
    setState(() {
      floorType = data.map((data) => FloorType.fromJson(data)).toList();
      totalValueOfEnergy = List.filled(floorType.length, 0);
    });
    await flatQueryFuncForDayEnergy(floorType);
  }

  Future flatQueryFunc2(List<FloorType> floorType) async {
    for (int i = 0; i < floorType.length; i++) {
      List data = await AllDatabase.instance.getFlatByFId(floorType[i].fId);
      for (int j = 0; j < data.length; j++) {
        flt.add(data[i]);
        if (kDebugMode) {
          print(flt[i]);
        }
      }
      await roomQueryFunc2(flt);

      if (chooseValueMinute == '10 minute' ||
          chooseValueMinute == '20 minute' ||
          chooseValueMinute == '30 minute' ||
          chooseValueMinute == '40 minute' ||
          chooseValueMinute == '50 minute' ||
          chooseValueMinute == '60 minute') {
        if (kDebugMode) {
          print("object $chooseValueMinute");
        }
        setState(() {
          // tenMinuteTotalUsage=total14;
          _valueMinute = _valueMinute! + total;
          varFinalTotalValue = _valueMinute!.toStringAsFixed(2);
          totalValueOfEnergy[i] = total;
          dataMap.putIfAbsent(floorType[i].fName,
              () => double.parse(totalValueOfEnergy[i].toString()));
        });

        // total = 0.0;

        if (kDebugMode) {
          print('totalValueOfEnergy $totalValueOfEnergy');
          print('dataMapTotalValueOfEnergy $dataMap');
        }
      }
    }
  }

  Future flatQueryFuncForHourEnergy(List<FloorType> floorType) async {
    for (int i = 0; i < floorType.length; i++) {
      List data = await AllDatabase.instance.getFlatByFId(floorType[i].fId);
      for (int j = 0; j < data.length; j++) {
        flt.add(data[i]);
      }
      await roomQueryFuncForHourEnergy(flt);

      // if (chooseValueHour == chooseValueHour) {

      setState(() {
        // tenMinuteTotalUsage=total14;
        _valueHour = _valueHour! + total;
        varFinalTotalValue = _valueHour!.toStringAsFixed(2);
        totalValueOfEnergy[i] = total;
        dataMap.putIfAbsent(floorType[i].fName,
            () => double.parse(totalValueOfEnergy[i].toString()));
      });

      // total = 0.0;

      if (kDebugMode) {
        print('totalValueOfEnergy $varFinalTotalValue');
        print('totalValueOfEnergy $totalValueOfEnergy');
        print('dataMapTotalValueOfEnergy $dataMap');
      }
    }
  }

  double finalTotalValue = 0.0;

  Future flatQueryFuncForDayEnergy(List<FloorType> floorType) async {
    for (int i = 0; i < floorType.length; i++) {
      List data = await AllDatabase.instance.getFlatByFId(floorType[i].fId);
      for (int j = 0; j < data.length; j++) {
        flt.add(data[i]);
      }
      await roomQueryFuncForDayEnergy(flt);

      // if (chooseValueHour == chooseValueHour) {

      setState(() {
        // tenMinuteTotalUsage=total14;
        dataMap.putIfAbsent(floorType[i].fName, () => total);

        setState(() {
          finalTotalValue = total + finalTotalValue;
          finalEnergyValue = finalTotalValue;
          varFinalTotalValue = finalTotalValue.toStringAsFixed(2);
        });
      });

      // total = 0.0;

      if (kDebugMode) {
        print('dataMapTotalValueOfEnergy $dataMap');
        print('dataMapTotalValueOfEnergy $finalTotalValue');
      }
    }
  }

  Future roomQueryFunc2(List flt) async {
    for (int i = 0; i < flt.length; i++) {
      List data =
          await AllDatabase.instance.getRoomById(flt[i]['flt_id'].toString());
      for (int j = 0; j < data.length; j++) {
        allRoom.add(data[i]);
      }
      await deviceQuery2(allRoom);
    }
    // await deviceQuery();
  }

  Future roomQueryFuncForHourEnergy(List flt) async {
    for (int i = 0; i < flt.length; i++) {
      List data =
          await AllDatabase.instance.getRoomById(flt[i]['flt_id'].toString());
      for (int j = 0; j < data.length; j++) {
        allRoom.add(data[j]);
      }
      await deviceQueryForHourEnergy(allRoom);
    }
    // await deviceQuery();
  }

  Future roomQueryFuncForDayEnergy(List flt) async {
    for (int i = 0; i < flt.length; i++) {
      List data =
          await AllDatabase.instance.getRoomById(flt[i]['flt_id'].toString());

      for (int j = 0; j < data.length; j++) {
        allRoom.add(data[j]);
      }
      await deviceQueryForDayEnergy(allRoom);
    }
    // await deviceQuery();
  }

  Future deviceQuery2(List allRoom) async {
    for (int i = 0; i < allRoom.length; i++) {
      List data = await AllDatabase.instance
          .getDeviceById(allRoom[i]['r_id'].toString());
      if (data.isEmpty) {
        return;
      }
      if (kDebugMode) {
        print("${data[i]}   $i   device2");
      }

      for (int j = 0; j < data.length; j++) {
        deviceData.add(data[j]);
      }
      await totalEnergyAccordingRoom();
    }
  }

  Future deviceQueryForHourEnergy(List allRoom) async {
    for (int i = 0; i < allRoom.length; i++) {
      List data = await AllDatabase.instance
          .getDeviceById(allRoom[i]['r_id'].toString());
      if (data.isEmpty) {}
      if (kDebugMode) {
        print("${data[i]}   $i   device2");
      }

      for (int j = 0; j < data.length; j++) {
        deviceData.add(data[j]);
      }
      await totalHourEnergyAccordingRoom(deviceData);
    }
  }

  Future deviceQueryForDayEnergy(List allRoom) async {
    for (int i = 0; i < allRoom.length; i++) {
      List data = await AllDatabase.instance
          .getDeviceById(allRoom[i]['r_id'].toString());

      for (int j = 0; j < data.length; j++) {
        deviceData.add(data[j]);

      }
      await getEnergyDay(deviceData);
    }
  }

  Future flatQuery() async {
    for (int i = 0; i < floorType.length; i++) {
      List data = await AllDatabase.instance.getFlatByFId(floorType[i].fId);
      for (int j = 0; j < data.length; j++) {
        flt.add(data[i]);
      }
    }

    await roomQuery();
  }

  Future roomQuery() async {
    for (int i = 0; i < flt.length; i++) {
      List data =
          await AllDatabase.instance.getRoomById(flt[i]['flt_id'].toString());
      for (int j = 0; j < data.length; j++) {
        allRoom.add(data[i]);
      }
    }
    await deviceQuery();
  }

  Future deviceQuery() async {
    for (int i = 0; i < allRoom.length; i++) {
      List data = await AllDatabase.instance
          .getDeviceById(allRoom[i]['r_id'].toString());
      for (int j = 0; j < data.length; j++) {
        deviceData.add(data[j]);
      }
    }
    setState(() {
      completeTask = true;
    });
  }

  Future getToken() async {
    final token = await storage.read(key: "token");

    return token;
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

  Future getEnergyTenMinutes(chooseValueMinute) async {
    String? token = await getToken();
    for (int i = 0; i < deviceData.length; i++) {
      var dId = deviceData[i]['d_id'];
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
            finalEnergyValue!;
      });

      if (chooseValueMinute == "10 minute") {
        if (kDebugMode) {
          print("qwertyuiop $_valueMinute");
        }
        setState(() {
          _valueMinute =
              double.parse(totalTenMinuteEnergy[i]['enrgy10']) + _valueMinute!;
          varFinalTotalValue = _valueMinute!.toStringAsFixed(2);
        });
      }
      if (chooseValueMinute == "20 minute") {
        setState(() {
          _valueMinute = double.parse(totalTenMinuteEnergy[i]['enrgy10']) +
              double.parse(totalTenMinuteEnergy[i]['enrgy20']) +
              _valueMinute!;
          varFinalTotalValue = _valueMinute!.toStringAsFixed(2);
        });
      }
      if (chooseValueMinute == "30 minute") {
        setState(() {
          _valueMinute = double.parse(totalTenMinuteEnergy[i]['enrgy10']) +
              double.parse(totalTenMinuteEnergy[i]['enrgy20']) +
              double.parse(totalTenMinuteEnergy[i]['enrgy30']) +
              _valueMinute!;
          varFinalTotalValue = _valueMinute!.toStringAsFixed(2);
        });
      }
      if (chooseValueMinute == "40 minute") {
        setState(() {
          _valueMinute = double.parse(totalTenMinuteEnergy[i]['enrgy10']) +
              double.parse(totalTenMinuteEnergy[i]['enrgy20']) +
              double.parse(totalTenMinuteEnergy[i]['enrgy30']) +
              double.parse(totalTenMinuteEnergy[i]['enrgy40']) +
              _valueMinute!;
          varFinalTotalValue = _valueMinute!.toStringAsFixed(2);
        });
      }

      if (chooseValueMinute == "50 minute") {
        setState(() {
          _valueMinute = double.parse(totalTenMinuteEnergy[i]['enrgy10']) +
              double.parse(totalTenMinuteEnergy[i]['enrgy20']) +
              double.parse(totalTenMinuteEnergy[i]['enrgy30']) +
              double.parse(totalTenMinuteEnergy[i]['enrgy40']) +
              double.parse(totalTenMinuteEnergy[i]['enrgy50']) +
              _valueMinute!;
          varFinalTotalValue = _valueMinute!.toStringAsFixed(2);
        });
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
          varFinalTotalValue = _valueMinute!.toStringAsFixed(2);
        });
      }
    }
  }

  Future getEnergyHour(chooseValueHour) async {
    String? token = await getToken();
    for (int i = 0; i < deviceData.length; i++) {
      var dId = deviceData[i]['d_id'];
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
      total = 0.0;
      totalTenMinuteEnergy = List.empty(growable: true);
      allRoom = List.empty(growable: true);
      deviceData = List.empty(growable: true);
      flt = List.empty(growable: true);
      totalValueOfEnergy = List.empty(growable: true);
      dataMap = {};
      allRoom = List.empty(growable: true);
      deviceData = List.empty(growable: true);
    });

    await differenceCurrentDateToSelectedDate();
    await findDifferenceBetweenDates();
    await floorQueryFuncForDayEnergy(placeId);
  }

  Future getEnergyDay(deviceData) async {
    String? token = await getToken();
    for (int j = 0; j < deviceData.length; j++) {
      var dId = deviceData[j]['d_id'];
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

      i++;
    }
    // total = 0.0;
  }

  Future totalEnergyAccordingRoom() async {
    String token = await getToken();

    for (int j = 0; j < deviceData.length; j++) {
      String url = api + 'pertenminuteenergy?d_id=' + deviceData[j]['d_id'];
      final response1 = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Token $token',
      });
      if (response1.statusCode == 200) {
        List<dynamic> data = jsonDecode(response1.body);

        if (chooseValueMinute == '10 minute') {
          for (int k = 0; k < data.length; k++) {
            setState(() {
              total = total + double.parse(data[k]['enrgy10']);
              // _valueMinute =_valueMinute+total14;
            });
          }
        } else if (chooseValueMinute == '20 minute') {
          for (int k = 0; k < data.length; k++) {
            setState(() {
              total = total +
                  double.parse(data[k]['enrgy10']) +
                  double.parse(data[k]['enrgy20']);
            });

            // dataMap.putIfAbsent(allRoomId[j]['r_name'], () => total14);
          }
        } else if (chooseValueMinute == '30 minute') {
          for (int k = 0; k < data.length; k++) {
            setState(() {
              total = total +
                  double.parse(data[k]['enrgy10']) +
                  double.parse(data[k]['enrgy20']) +
                  double.parse(data[k]['enrgy30']);

              // _valueMinute =_valueMinute+total14;
            });
          }
        } else if (chooseValueMinute == '40 minute') {
          for (int k = 0; k < data.length; k++) {
            total = total +
                double.parse(data[k]['enrgy10']) +
                double.parse(data[k]['enrgy20']) +
                double.parse(data[k]['enrgy30']) +
                double.parse(data[k]['enrgy40']);

            // _valueMinute =_valueMinute+total14;
            // dataMap.putIfAbsent(allRoomId[j]['r_name'], () => total14);
          }
        } else if (chooseValueMinute == '50 minute') {
          for (int k = 0; k < data.length; k++) {
            total = total +
                double.parse(data[k]['enrgy10']) +
                double.parse(data[k]['enrgy20']) +
                double.parse(data[k]['enrgy30']) +
                double.parse(data[k]['enrgy40']) +
                double.parse(data[k]['enrgy50']);

            // _valueMinute =_valueMinute+total14;
            // dataMap.putIfAbsent(allRoomId[j]['r_name'], () => total14);
          }
        } else if (chooseValueMinute == '60 minute') {
          for (int k = 0; k < data.length; k++) {
            total = total +
                double.parse(data[k]['enrgy10']) +
                double.parse(data[k]['enrgy20']) +
                double.parse(data[k]['enrgy30']) +
                double.parse(data[k]['enrgy40']) +
                double.parse(data[k]['enrgy50']) +
                double.parse(data[k]['enrgy60']);

            // _valueMinute =_valueMinute+total14;
            // dataMap.putIfAbsent(allRoomId[j]['r_name'], () => total14);
          }
        } else {
          for (int k = 0; k < data.length; k++) {
            total = total +
                double.parse(data[k]['enrgy10']) +
                double.parse(data[k]['enrgy20']) +
                double.parse(data[k]['enrgy30']) +
                double.parse(data[k]['enrgy40']) +
                double.parse(data[k]['enrgy50']) +
                double.parse(data[k]['enrgy60']);

            // dataMap.putIfAbsent(allRoomId[j]['r_name'], () => total14);
          }
          // int ko=0;
          // while(ko<j){
          //   dataMap.putIfAbsent(allRoomId[ko]['r_name'], () => total14);
          //   ko+1;
          // }

          // total14=0.0;

        }
      }
    }
  }

  Future totalHourEnergyAccordingRoom(deviceData) async {
    total = 0.0;
    String token = await getToken();
    for (int j = 0; j < deviceData.length; j++) {
      String url = api + 'perhourenergy?d_id=' + deviceData[j]['d_id'];
      final response1 = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Token $token',
      });
      if (response1.statusCode == 200) {
        List<dynamic> data = jsonDecode(response1.body);

        if (chooseValueHour == '1 hour') {
          for (int k = 0; k < data.length; k++) {
            setState(() {
              total = total + double.parse(data[k]['hour1']);
            });
          }
        }
        if (chooseValueHour == '2 hour') {
          for (int k = 0; k < data.length; k++) {
            setState(() {
              total = total +
                  double.parse(data[k]['hour1']) +
                  double.parse(data[k]['hour2']);
            });
          }
        }
        if (chooseValueHour == '3 hour') {
          for (int k = 0; k < data.length; k++) {
            setState(() {
              total = total +
                  double.parse(data[k]['hour1']) +
                  double.parse(data[k]['hour2']) +
                  double.parse(data[k]['hour3']);
            });
          }
        }
        if (chooseValueHour == '4 hour') {
          for (int k = 0; k < data.length; k++) {
            setState(() {
              total = total +
                  double.parse(data[k]['hour1']) +
                  double.parse(data[k]['hour2']) +
                  double.parse(data[k]['hour3']) +
                  double.parse(data[k]['hour4']);
            });
          }
        }
        if (chooseValueHour == '5 hour') {
          for (int k = 0; k < data.length; k++) {
            setState(() {
              total = total +
                  double.parse(data[k]['hour1']) +
                  double.parse(data[k]['hour2']) +
                  double.parse(data[k]['hour3']) +
                  double.parse(data[k]['hour4']) +
                  double.parse(data[k]['hour5']);
            });
          }
        }
        if (chooseValueHour == '6 hour') {
          for (int k = 0; k < data.length; k++) {
            setState(() {
              total = total +
                  double.parse(data[k]['hour1']) +
                  double.parse(data[k]['hour2']) +
                  double.parse(data[k]['hour3']) +
                  double.parse(data[k]['hour4']) +
                  double.parse(data[k]['hour5']) +
                  double.parse(data[k]['hour6']);
            });
          }
        }
        if (chooseValueHour == '7 hour') {
          for (int k = 0; k < data.length; k++) {
            setState(() {
              total = total +
                  double.parse(data[k]['hour1']) +
                  double.parse(data[k]['hour2']) +
                  double.parse(data[k]['hour3']) +
                  double.parse(data[k]['hour4']) +
                  double.parse(data[k]['hour5']) +
                  double.parse(data[k]['hour6']) +
                  double.parse(data[k]['hour7']);
            });
          }
        }
        if (chooseValueHour == '8 hour') {
          for (int k = 0; k < data.length; k++) {
            setState(() {
              total = total +
                  double.parse(data[k]['hour1']) +
                  double.parse(data[k]['hour2']) +
                  double.parse(data[k]['hour3']) +
                  double.parse(data[k]['hour4']) +
                  double.parse(data[k]['hour5']) +
                  double.parse(data[k]['hour6']) +
                  double.parse(data[k]['hour7']) +
                  double.parse(data[k]['hour8']);
            });
          }
        }
        if (chooseValueHour == '9 hour') {
          for (int k = 0; k < data.length; k++) {
            setState(() {
              total = total +
                  double.parse(data[k]['hour1']) +
                  double.parse(data[k]['hour2']) +
                  double.parse(data[k]['hour3']) +
                  double.parse(data[k]['hour4']) +
                  double.parse(data[k]['hour5']) +
                  double.parse(data[k]['hour6']) +
                  double.parse(data[k]['hour7']) +
                  double.parse(data[k]['hour8']) +
                  double.parse(data[k]['hour9']);
            });
          }
        }

        if (chooseValueHour == '10 hour') {
          for (int k = 0; k < data.length; k++) {
            setState(() {
              total = total +
                  double.parse(data[k]['hour1']) +
                  double.parse(data[k]['hour2']) +
                  double.parse(data[k]['hour3']) +
                  double.parse(data[k]['hour4']) +
                  double.parse(data[k]['hour5']) +
                  double.parse(data[k]['hour6']) +
                  double.parse(data[k]['hour7']) +
                  double.parse(data[k]['hour8']) +
                  double.parse(data[k]['hour9']) +
                  double.parse(data[k]['hour10']);
            });
          }
        }

        if (chooseValueHour == '11 hour') {
          for (int k = 0; k < data.length; k++) {
            setState(() {
              total = total +
                  double.parse(data[k]['hour1']) +
                  double.parse(data[k]['hour2']) +
                  double.parse(data[k]['hour3']) +
                  double.parse(data[k]['hour4']) +
                  double.parse(data[k]['hour5']) +
                  double.parse(data[k]['hour6']) +
                  double.parse(data[k]['hour7']) +
                  double.parse(data[k]['hour8']) +
                  double.parse(data[k]['hour9']) +
                  double.parse(data[k]['hour10']) +
                  double.parse(data[k]['hour11']);
            });
          }
        }

        if (chooseValueHour == '12 hour') {
          for (int k = 0; k < data.length; k++) {
            setState(() {
              total = total +
                  double.parse(data[k]['hour1']) +
                  double.parse(data[k]['hour2']) +
                  double.parse(data[k]['hour3']) +
                  double.parse(data[k]['hour4']) +
                  double.parse(data[k]['hour5']) +
                  double.parse(data[k]['hour6']) +
                  double.parse(data[k]['hour7']) +
                  double.parse(data[k]['hour8']) +
                  double.parse(data[k]['hour9']) +
                  double.parse(data[k]['hour10']) +
                  double.parse(data[k]['hour11']) +
                  double.parse(data[k]['hour12']);
            });
          }
        }

        if (chooseValueHour == '13 hour') {
          for (int k = 0; k < data.length; k++) {
            setState(() {
              total = total +
                  double.parse(data[k]['hour1']) +
                  double.parse(data[k]['hour2']) +
                  double.parse(data[k]['hour3']) +
                  double.parse(data[k]['hour4']) +
                  double.parse(data[k]['hour5']) +
                  double.parse(data[k]['hour6']) +
                  double.parse(data[k]['hour7']) +
                  double.parse(data[k]['hour8']) +
                  double.parse(data[k]['hour9']) +
                  double.parse(data[k]['hour10']) +
                  double.parse(data[k]['hour11']) +
                  double.parse(data[k]['hour12']) +
                  double.parse(data[k]['hour13']);
            });
          }
        }

        if (chooseValueHour == '14 hour') {
          for (int k = 0; k < data.length; k++) {
            setState(() {
              total = total +
                  double.parse(data[k]['hour1']) +
                  double.parse(data[k]['hour2']) +
                  double.parse(data[k]['hour3']) +
                  double.parse(data[k]['hour4']) +
                  double.parse(data[k]['hour5']) +
                  double.parse(data[k]['hour6']) +
                  double.parse(data[k]['hour7']) +
                  double.parse(data[k]['hour8']) +
                  double.parse(data[k]['hour9']) +
                  double.parse(data[k]['hour10']) +
                  double.parse(data[k]['hour11']) +
                  double.parse(data[k]['hour12']) +
                  double.parse(data[k]['hour13']) +
                  double.parse(data[k]['hour14']);
            });
          }
        }

        if (chooseValueHour == '15 hour') {
          for (int k = 0; k < data.length; k++) {
            setState(() {
              total = total +
                  double.parse(data[k]['hour1']) +
                  double.parse(data[k]['hour2']) +
                  double.parse(data[k]['hour3']) +
                  double.parse(data[k]['hour4']) +
                  double.parse(data[k]['hour5']) +
                  double.parse(data[k]['hour6']) +
                  double.parse(data[k]['hour7']) +
                  double.parse(data[k]['hour8']) +
                  double.parse(data[k]['hour9']) +
                  double.parse(data[k]['hour10']) +
                  double.parse(data[k]['hour11']) +
                  double.parse(data[k]['hour12']) +
                  double.parse(data[k]['hour13']) +
                  double.parse(data[k]['hour14']) +
                  double.parse(data[k]['hour15']);
            });
          }
        }

        if (chooseValueHour == '16 hour') {
          for (int k = 0; k < data.length; k++) {
            setState(() {
              total = total +
                  double.parse(data[k]['hour1']) +
                  double.parse(data[k]['hour2']) +
                  double.parse(data[k]['hour3']) +
                  double.parse(data[k]['hour4']) +
                  double.parse(data[k]['hour5']) +
                  double.parse(data[k]['hour6']) +
                  double.parse(data[k]['hour7']) +
                  double.parse(data[k]['hour8']) +
                  double.parse(data[k]['hour9']) +
                  double.parse(data[k]['hour10']) +
                  double.parse(data[k]['hour11']) +
                  double.parse(data[k]['hour12']) +
                  double.parse(data[k]['hour13']) +
                  double.parse(data[k]['hour14']) +
                  double.parse(data[k]['hour15']) +
                  double.parse(data[k]['hour16']);
            });
          }
        }

        if (chooseValueHour == '17 hour') {
          for (int k = 0; k < data.length; k++) {
            setState(() {
              total = total +
                  double.parse(data[k]['hour1']) +
                  double.parse(data[k]['hour2']) +
                  double.parse(data[k]['hour3']) +
                  double.parse(data[k]['hour4']) +
                  double.parse(data[k]['hour5']) +
                  double.parse(data[k]['hour6']) +
                  double.parse(data[k]['hour7']) +
                  double.parse(data[k]['hour8']) +
                  double.parse(data[k]['hour9']) +
                  double.parse(data[k]['hour10']) +
                  double.parse(data[k]['hour11']) +
                  double.parse(data[k]['hour12']) +
                  double.parse(data[k]['hour13']) +
                  double.parse(data[k]['hour14']) +
                  double.parse(data[k]['hour15']) +
                  double.parse(data[k]['hour16']) +
                  double.parse(data[k]['hour17']);
            });
          }
        }

        if (chooseValueHour == '18 hour') {
          for (int k = 0; k < data.length; k++) {
            setState(() {
              total = total +
                  double.parse(data[k]['hour1']) +
                  double.parse(data[k]['hour2']) +
                  double.parse(data[k]['hour3']) +
                  double.parse(data[k]['hour4']) +
                  double.parse(data[k]['hour5']) +
                  double.parse(data[k]['hour6']) +
                  double.parse(data[k]['hour7']) +
                  double.parse(data[k]['hour8']) +
                  double.parse(data[k]['hour9']) +
                  double.parse(data[k]['hour10']) +
                  double.parse(data[k]['hour11']) +
                  double.parse(data[k]['hour12']) +
                  double.parse(data[k]['hour13']) +
                  double.parse(data[k]['hour14']) +
                  double.parse(data[k]['hour15']) +
                  double.parse(data[k]['hour16']) +
                  double.parse(data[k]['hour17']) +
                  double.parse(data[k]['hour18']);
            });
          }
        }

        if (chooseValueHour == '19 hour') {
          for (int k = 0; k < data.length; k++) {
            setState(() {
              total = total +
                  double.parse(data[k]['hour1']) +
                  double.parse(data[k]['hour2']) +
                  double.parse(data[k]['hour3']) +
                  double.parse(data[k]['hour4']) +
                  double.parse(data[k]['hour5']) +
                  double.parse(data[k]['hour6']) +
                  double.parse(data[k]['hour7']) +
                  double.parse(data[k]['hour8']) +
                  double.parse(data[k]['hour9']) +
                  double.parse(data[k]['hour10']) +
                  double.parse(data[k]['hour11']) +
                  double.parse(data[k]['hour12']) +
                  double.parse(data[k]['hour13']) +
                  double.parse(data[k]['hour14']) +
                  double.parse(data[k]['hour15']) +
                  double.parse(data[k]['hour16']) +
                  double.parse(data[k]['hour17']) +
                  double.parse(data[k]['hour18']) +
                  double.parse(data[k]['hour19']);
            });
          }
        }

        if (chooseValueHour == '20 hour') {
          for (int k = 0; k < data.length; k++) {
            setState(() {
              total = total +
                  double.parse(data[k]['hour1']) +
                  double.parse(data[k]['hour2']) +
                  double.parse(data[k]['hour3']) +
                  double.parse(data[k]['hour4']) +
                  double.parse(data[k]['hour5']) +
                  double.parse(data[k]['hour6']) +
                  double.parse(data[k]['hour7']) +
                  double.parse(data[k]['hour8']) +
                  double.parse(data[k]['hour9']) +
                  double.parse(data[k]['hour10']) +
                  double.parse(data[k]['hour11']) +
                  double.parse(data[k]['hour12']) +
                  double.parse(data[k]['hour13']) +
                  double.parse(data[k]['hour14']) +
                  double.parse(data[k]['hour15']) +
                  double.parse(data[k]['hour16']) +
                  double.parse(data[k]['hour17']) +
                  double.parse(data[k]['hour18']) +
                  double.parse(data[k]['hour19']) +
                  double.parse(data[k]['hour20']);
            });
          }
        }

        if (chooseValueHour == '21 hour') {
          for (int k = 0; k < data.length; k++) {
            setState(() {
              total = total +
                  double.parse(data[k]['hour1']) +
                  double.parse(data[k]['hour2']) +
                  double.parse(data[k]['hour3']) +
                  double.parse(data[k]['hour4']) +
                  double.parse(data[k]['hour5']) +
                  double.parse(data[k]['hour6']) +
                  double.parse(data[k]['hour7']) +
                  double.parse(data[k]['hour8']) +
                  double.parse(data[k]['hour9']) +
                  double.parse(data[k]['hour10']) +
                  double.parse(data[k]['hour11']) +
                  double.parse(data[k]['hour12']) +
                  double.parse(data[k]['hour13']) +
                  double.parse(data[k]['hour14']) +
                  double.parse(data[k]['hour15']) +
                  double.parse(data[k]['hour16']) +
                  double.parse(data[k]['hour17']) +
                  double.parse(data[k]['hour18']) +
                  double.parse(data[k]['hour19']) +
                  double.parse(data[k]['hour20']) +
                  double.parse(data[k]['hour21']);
            });
          }
        }

        if (chooseValueHour == '22 hour') {
          for (int k = 0; k < data.length; k++) {
            setState(() {
              total = total +
                  double.parse(data[k]['hour1']) +
                  double.parse(data[k]['hour2']) +
                  double.parse(data[k]['hour3']) +
                  double.parse(data[k]['hour4']) +
                  double.parse(data[k]['hour5']) +
                  double.parse(data[k]['hour6']) +
                  double.parse(data[k]['hour7']) +
                  double.parse(data[k]['hour8']) +
                  double.parse(data[k]['hour9']) +
                  double.parse(data[k]['hour10']) +
                  double.parse(data[k]['hour11']) +
                  double.parse(data[k]['hour12']) +
                  double.parse(data[k]['hour13']) +
                  double.parse(data[k]['hour14']) +
                  double.parse(data[k]['hour15']) +
                  double.parse(data[k]['hour16']) +
                  double.parse(data[k]['hour17']) +
                  double.parse(data[k]['hour18']) +
                  double.parse(data[k]['hour19']) +
                  double.parse(data[k]['hour20']) +
                  double.parse(data[k]['hour21']) +
                  double.parse(data[k]['hour22']);
            });
          }
        }

        if (chooseValueHour == '23 hour') {
          for (int k = 0; k < data.length; k++) {
            setState(() {
              total = total +
                  double.parse(data[k]['hour1']) +
                  double.parse(data[k]['hour2']) +
                  double.parse(data[k]['hour3']) +
                  double.parse(data[k]['hour4']) +
                  double.parse(data[k]['hour5']) +
                  double.parse(data[k]['hour6']) +
                  double.parse(data[k]['hour7']) +
                  double.parse(data[k]['hour8']) +
                  double.parse(data[k]['hour9']) +
                  double.parse(data[k]['hour10']) +
                  double.parse(data[k]['hour11']) +
                  double.parse(data[k]['hour12']) +
                  double.parse(data[k]['hour13']) +
                  double.parse(data[k]['hour14']) +
                  double.parse(data[k]['hour15']) +
                  double.parse(data[k]['hour16']) +
                  double.parse(data[k]['hour17']) +
                  double.parse(data[k]['hour18']) +
                  double.parse(data[k]['hour19']) +
                  double.parse(data[k]['hour20']) +
                  double.parse(data[k]['hour21']) +
                  double.parse(data[k]['hour22']) +
                  double.parse(data[k]['hour23']);
            });
          }
        }

        if (chooseValueHour == '24 hour') {
          for (int k = 0; k < data.length; k++) {
            setState(() {
              total = total +
                  double.parse(data[k]['hour1']) +
                  double.parse(data[k]['hour2']) +
                  double.parse(data[k]['hour3']) +
                  double.parse(data[k]['hour4']) +
                  double.parse(data[k]['hour5']) +
                  double.parse(data[k]['hour6']) +
                  double.parse(data[k]['hour7']) +
                  double.parse(data[k]['hour8']) +
                  double.parse(data[k]['hour9']) +
                  double.parse(data[k]['hour10']) +
                  double.parse(data[k]['hour11']) +
                  double.parse(data[k]['hour12']) +
                  double.parse(data[k]['hour13']) +
                  double.parse(data[k]['hour14']) +
                  double.parse(data[k]['hour15']) +
                  double.parse(data[k]['hour16']) +
                  double.parse(data[k]['hour17']) +
                  double.parse(data[k]['hour18']) +
                  double.parse(data[k]['hour19']) +
                  double.parse(data[k]['hour20']) +
                  double.parse(data[k]['hour21']) +
                  double.parse(data[k]['hour22']) +
                  double.parse(data[k]['hour23']) +
                  double.parse(data[k]['hour24']);
            });
          }
        }
      }
    }
  }
}
