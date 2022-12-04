// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables, unused_local_variable
import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:genorion_mac_android/Models/subaccessmodel.dart';
import 'package:genorion_mac_android/SubAccessModels/subaccessfloor.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:genorion_mac_android/SubAccessModels/subaccessroom.dart';
import 'package:intl/intl.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../LocalDatabase/alldb.dart';
import '../Models/pinstatus.dart';
import '../Models/userprofike.dart';
import '../SubAccessModels/subaccesflat.dart';
import '../SubAccessModels/subaccessdevice.dart';
import '../SubAccessModels/subaccessplace.dart';
import '../main.dart';

class SubAccess extends StatefulWidget {
  SubAccessPlace? place;
  SubAccessFloor? floor;
  SubAccessFlat? flat;
  List<SubAccessRoom>? rm;
  var pId;
  var ownerName;

  SubAccess(
      {Key? key,
      required this.pId,
      required this.ownerName,
      this.place,
      this.floor,
      this.flat,
      this.rm
      })
      : super(key: key);

  @override
  _SubAccessState createState() => _SubAccessState();
}

class _SubAccessState extends State<SubAccess> with TickerProviderStateMixin {
  var storage = const FlutterSecureStorage();
  UserProfile? userProfile;
  var email;
  Future? subAcessFuture;
  List<SubAccessModel> subAccessModel = [];
  SubAccessPlace? subAccessplace;
  SubAccessFloor? subAccessFloor;
  SubAccessFlat? subAccessFlat;
  List<SubAccessRoom> subAcessRoom = [];
  List<SubAccessDevice> subAcessDevice = [];
  var flatId;
  TimeOfDay? time;
  var cutTime;
  int checkSwitch = 0;
  bool placeBool = false;
  bool changeFloorBool = false;
  String? _alarmTimeString = "";
  DateTime pickedDate = DateTime.now();
  var cutDate;
  Future? switchFuture;
  Future? nameFuture;
  TabController? tabC;
  List namesDataList = [];
  List responseGetData = [];
  List sensorData =[];
  Future<List<SubAccessPlace>>? placeVal;
  Future<List<SubAccessFloor>>? floorVal;
  Future<List<SubAccessFlat>>? flatVal;
  List changeIcon = List.filled(9, null);
  var icon1 = Icons.ac_unit;
  var icon2 = FontAwesomeIcons.iceCream;
  var icon3 = FontAwesomeIcons.lightbulb;
  var icon4 = FontAwesomeIcons.fan;
  var icon5 = Icons.wash_sharp;
  var icon6 = FontAwesomeIcons.fire;
  var icon7 = FontAwesomeIcons.lightbulb;
  var icon8 = FontAwesomeIcons.lightbulb;
  var icon9 = FontAwesomeIcons.lightbulb;
  var icon10 = FontAwesomeIcons.lightbulb;
  var icon11 = FontAwesomeIcons.lightbulb;
  var icon12 = FontAwesomeIcons.lightbulb;
  List<String> iconCode = [
    '001',
    '002',
    '003',
    '004',
    '005',
    '006',
    '007',
    '008',
    '009',
    '010',
    '011'
  ];
  SubAccessFlat? flt;

  SubAccessPlace? pt;

  SubAccessFloor? fl;
  @override
  void initState() {
    super.initState();
    userPersonalData();
    placeVal = placeQueryFunc(widget.pId);
    floorVal = floorQueryFunc(widget.pId);
  }

  Future userPersonalData() async {
    subAcessFuture = getPlace(widget.pId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff121421),
      body: SafeArea(
        child: FutureBuilder(
            future: subAcessFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView(
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
                              child: Text(subAccessplace!.pType,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold)),
                              onTap: () {
                                setState(() {
                                  setState(() {
                                    placeBool = !placeBool;
                                  });
                                });
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 35,
                          width: 65,
                          child: Center(
                              child: Text(
                            widget.ownerName.toString(),
                            style: const TextStyle(color: Colors.white),
                          )),
                        ),
                      ],
                    ),
                  ),
                  changeFloorBool
                      ? changeFloor()
                      : SizedBox(
                          height: MediaQuery.of(context).size.height / 0.5,
                          child: DefaultTabController(
                            length: subAcessRoom.length,
                            child: CustomScrollView(
                              slivers: [
                                SliverToBoxAdapter(
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.41,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: const BoxDecoration(
                                          gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                Color(0xff669df4),
                                                Color(0xff4e80f3)
                                              ]),
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(30),
                                            topRight: Radius.circular(30),
                                            bottomLeft: Radius.circular(30),
                                            bottomRight: Radius.circular(30),
                                          ),
                                        ),
                                        padding: const EdgeInsets.only(
                                          top: 40,
                                          bottom: 10,
                                          left: 28,
                                          right: 30,
                                        ),
                                        // alignment: Alignment.topLeft,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Column(
                                                  children: <Widget>[
                                                    Row(
                                                      children: [
                                                        GestureDetector(
                                                          onLongPress: () {},
                                                          child: Row(
                                                            children: [
                                                              const Text(
                                                                'Floor -> ',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 22,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  // fontStyle: FontStyle
                                                                  //     .italic
                                                                ),
                                                              ),
                                                              Text(
                                                                subAccessFloor!
                                                                    .fName,
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        22,
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .italic),
                                                              ),
                                                              // const Icon(Icons
                                                              // //     .arrow_drop_down),
                                                              // const SizedBox(
                                                              //   width: 10,
                                                              // ),
                                                            ],
                                                          ),
                                                          onTap: () {
                                                            setState(() {
                                                              changeFloorBool =
                                                                  !changeFloorBool;
                                                            });
                                                            if (kDebugMode) {
                                                              print(
                                                                "ddsa $changeFloorBool");
                                                            }
                                                          },
                                                        ),
                                                     
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 12,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Row(
                                                          children: <Widget>[
                                                            GestureDetector(
                                                              onLongPress:
                                                                  () {},
                                                              child: Row(
                                                                children: [
                                                                  const Text(
                                                                    'Flat -> ',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            22),
                                                                  ),
                                                                  Text(
                                                                    subAccessFlat!
                                                                        .fltName,
                                                                    style: const TextStyle(
                                                                        color: Colors.white,
                                                                        // fontWeight: FontWeight.bold,
                                                                        fontStyle: FontStyle.italic,
                                                                        fontSize: 22),
                                                                  ),
                                                                  // const Icon(Icons
                                                                  //     .arrow_drop_down),
                                                                  // const SizedBox(
                                                                  //   width: 10,
                                                                  // ),
                                                                ],
                                                              ),
                                                              onTap: () {},
                                                            ),
                                                            // const SizedBox(width: 28),
                                                            // GestureDetector(
                                                            //   onTap: () async {},
                                                            //   child: const Icon(
                                                            //   Icons.settings,
                                                            //     size: 18,
                                                            //   ),
                                                            // ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 45,
                                            ),
                                            SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                // mainAxisAlignment: MainAxisAlignment.start,
                                                children: <Widget>[
                                                  FutureBuilder(
                                                    future: switchFuture,
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot.hasData) {
                                                        return Column(
                                                          children: <Widget>[
                                                            Row(
                                                              children: <
                                                                  Widget>[
                                                                // Text(
                                                                //   'Sensors- ',
                                                                //   style: TextStyle(

                                                                //       // backgroundColor: _switchValue?Colors.white:Colors.blueAccent,
                                                                //       fontSize: 14,
                                                                //       fontWeight:
                                                                //           FontWeight
                                                                //               .bold,
                                                                //       color: Colors
                                                                //           .white),
                                                                // ),
                                                                const SizedBox(
                                                                  width: 8,
                                                                ),
                                                                Column(
                                                                    children: <
                                                                        Widget>[
                                                                      const Icon(
                                                                        FontAwesomeIcons
                                                                            .fire,
                                                                        color: Colors
                                                                            .yellow,
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            25,
                                                                      ),
                                                                      Row(
                                                                        children: <
                                                                            Widget>[
                                                                          Text(
                                                                              sensorData[0].toString(),
                                                                              style: const TextStyle(fontSize: 14, color: Colors.white70)),
                                                                        ],
                                                                      ),
                                                                    ]),
                                                                const SizedBox(
                                                                  width: 35,
                                                                ),
                                                                Column(
                                                                    children: <
                                                                        Widget>[
                                                                      const Icon(
                                                                        FontAwesomeIcons
                                                                            .temperatureLow,
                                                                        color: Colors
                                                                            .orange,
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            30,
                                                                      ),
                                                                      Row(
                                                                        children: <
                                                                            Widget>[
                                                                          Text(
                                                                              sensorData[1].toString(),
                                                                              style: const TextStyle(fontSize: 14, color: Colors.white70)),
                                                                        ],
                                                                      ),
                                                                    ]),
                                                                const SizedBox(
                                                                  width: 45,
                                                                ),
                                                                Column(
                                                                    children: <
                                                                        Widget>[
                                                                      const Icon(
                                                                        FontAwesomeIcons
                                                                            .wind,
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            30,
                                                                      ),
                                                                      Row(
                                                                        children: <
                                                                            Widget>[
                                                                          Text(
                                                                              sensorData[2].toString(),
                                                                              style: const TextStyle(fontSize: 14, color: Colors.white70)),
                                                                        ],
                                                                      ),
                                                                    ]),
                                                                const SizedBox(
                                                                  width: 42,
                                                                ),
                                                                Column(
                                                                    children: <
                                                                        Widget>[
                                                                      const Icon(
                                                                        FontAwesomeIcons
                                                                            .cloud,
                                                                        color: Colors
                                                                            .orange,
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            30,
                                                                      ),
                                                                      Row(
                                                                        children: <
                                                                            Widget>[
                                                                          Text(
                                                                            sensorData[3].toString(),
                                                                            style:
                                                                                const TextStyle(color: Colors.white70),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ]),
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                              height: 12,
                                                            ),
                                                            Text(
                                                              sensorData[7]
                                                                  .toString(),
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .white70),
                                                            ),
                                                          ],
                                                        );
                                                      } else {
                                                        return const Center(
                                                          child: Text(
                                                              'Loading...'),
                                                        );
                                                      }
                                                    },
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),

                                //Room Tabs
                                SliverAppBar(
                                  automaticallyImplyLeading: false,
                                  // centerTitle: true,
                                  floating: true,
                                  pinned: true,
                                  backgroundColor: Colors.white,

                                  title: Container(
                                    alignment: Alignment.bottomLeft,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: [
                                              TabBar(
                                                indicatorColor:
                                                    Colors.blueAccent,
                                                controller: tabC,
                                                labelColor: Colors.blueAccent,
                                                indicatorWeight: 2.0,
                                                isScrollable: true,
                                                tabs: subAcessRoom.map<Widget>(
                                                    (SubAccessRoom rm) {
                                                  return Tab(
                                                    text: rm.rName,
                                                  );
                                                }).toList(),
                                                onTap: (index) async {
                                                  List deviceList =
                                                      await AllDatabase.instance
                                                          .getAllDeviceByRIdSubAccess(
                                                              subAcessRoom[
                                                                      index]
                                                                  .rId);

                                                  setState(() {
                                                    subAcessDevice = List.generate(
                                                        deviceList.length,
                                                        (index) => SubAccessDevice(
                                                            id: deviceList[index]
                                                                ['id'],
                                                            dateInstalled:
                                                                DateTime.parse(
                                                                    deviceList[index]
                                                                        [
                                                                        'date_installed']),
                                                            user: deviceList[
                                                                index]['user'],
                                                            rId:
                                                                deviceList[index]
                                                                        ['r_id']
                                                                    .toString(),
                                                            dId:
                                                                deviceList[index]
                                                                    ['d_id']));
                                                  });
                                                  if (subAcessDevice
                                                      .isNotEmpty) {
                                                    switchFuture =
                                                        getPinStatusByDidLocal(
                                                            subAcessDevice[
                                                                    index]
                                                                .dId,
                                                            index);

                                                    nameFuture =
                                                        getPinNameByLocal(
                                                            subAcessDevice[
                                                                    index]
                                                                .dId,
                                                            index);
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                      (context, index) {
                                    if (index < subAcessDevice.length) {
                                      if (subAcessDevice.isEmpty) {
                                        return Container();
                                      }
                                      return deviceContainer2(
                                          subAcessDevice[index].dId, index);
                                      // return Container();
                                    } else {
                                      return null;
                                    }
                                  }),
                                )
                              ],
                            ),
                          ),
                        )
                ]);
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ),
    );
  }

  _showDialog(String dId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Alert"),
        content: const Text("Would to like to turn off all the appliances ?"),
        actions: <Widget>[
          // ignore: deprecated_member_use
          ElevatedButton(
              child: const Text("Yes"),
              onPressed: () async {
                var result = await Connectivity().checkConnectivity();
                if (result == ConnectivityResult.wifi) {
                  responseGetData.replaceRange(0, responseGetData.length,
                      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]);
                  await dataUpdate(dId);
                  await dataUpdate(dId);
                  await getPinStatusData(dId);
                  await getPinStatusByDidLocal(dId, 0);
                } else if (result == ConnectivityResult.mobile) {
                  responseGetData.replaceRange(0, responseGetData.length,
                      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]);
                  await dataUpdate(dId);
                  await getPinStatusData(dId);
                  await getPinStatusByDidLocal(dId, 0);
                } else {
                  // messageSms(context, dId);
                }

                Navigator.of(context).pop();
              }),
          // ignore: deprecated_member_use
          ElevatedButton(
              child: const Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              }),
        ],
      ),
    );
  }

  Widget deviceContainer2(did, index) {
    return Container(
      color: Colors.transparent,
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18.0),
                  child: Text(
                    'Turn Off All Appliances',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 14,
                ),
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: GestureDetector(
                    child: const Icon(
                      Icons.update,
                      color: Colors.white,
                    ),
                    onTap: () async {
                      // deviceSensorVal = getSensorById(did);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: GestureDetector(
                    child: const Icon(
                      Icons.schedule,
                      color: Colors.white,
                    ),
                    onTap: () async {},
                  ),
                ),
                Container(
                  width: 14,
                  height: 14,

                  decoration: const BoxDecoration(
                      color: Colors.green, shape: BoxShape.circle),
                  // child: ...
                ),
                Switch(
                  value: responseGetData.contains(1) ? true : false,
                  //boolean value
                  onChanged: (val) async {
                    _showDialog(did);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: GestureDetector(
                    child: const Icon(
                      Icons.settings_remote,
                      color: Colors.white,
                    ),
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: Colors.transparent,
            height: MediaQuery.of(context).size.height * 1.1,
            child: GridView.count(
              crossAxisSpacing: 8,
              childAspectRatio: 2 / 1.8,
              mainAxisSpacing: 4,
              crossAxisCount: 2,
              scrollDirection: Axis.vertical,
              physics: const NeverScrollableScrollPhysics(),
              children: List.generate(9, (index) {
                return SizedBox(
                  child: InkWell(
                    onLongPress: () {
                      _alarmTimeString =
                          DateFormat('HH:mm').format(DateTime.now());

                      showModalBottomSheet(
                          useRootNavigator: true,
                          context: context,
                          clipBehavior: Clip.antiAlias,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(24),
                            ),
                          ),
                          builder: (context) {
                            return StatefulBuilder(
                                builder: (context, setModalState) {
                              return Container(
                                  padding: const EdgeInsets.all(32),
                                  child: Column(children: [
                                    SizedBox(
                                      width: 145,
                                      child: GestureDetector(
                                          child: Text(
                                            cutDate.toString(),
                                          ),
                                          onTap: () {
                                            pickDate();
                                          }),
                                    ),

                                    // ignore: deprecated_member_use
                                    ElevatedButton(
                                      onPressed: () async {
                                        pickTime(index);
                                      },
                                      child: Text(
                                        _alarmTimeString!,
                                        style: const TextStyle(
                                          fontSize: 32,
                                        ),
                                      ),
                                    ),
                                    const ListTile(
                                      title: Text(
                                        'What Do You Want ??',
                                      ),
                                      trailing: Icon(Icons.timer),
                                    ),
                                    ListTile(
                                      title: ToggleSwitch(
                                        initialLabelIndex: 0,
                                        labels: const ['Off', 'On'],
                                        onToggle: (index) {
                                          checkSwitch = index!;
                                        },
                                        totalSwitches: 2,
                                      ),
                                    ),
                                    FloatingActionButton.extended(
                                      onPressed: () async {
                                        // await schedulingDevicePin(dId, index);
                                        Navigator.pop(context);
                                        // await getAndUpdateScheduledPins(dId);
                                      },
                                      icon: const Icon(Icons.alarm),
                                      label: const Text('Save'),
                                    ),
                                  ]));
                            });
                          });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                          alignment: const FractionalOffset(1.0, 0.0),
                          // alignment: Alignment.bottomRight,
                          height: 120,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 1, vertical: 10),
                          margin: index % 2 == 0
                              ? const EdgeInsets.fromLTRB(15, 7.5, 7.5, 7.5)
                              : const EdgeInsets.fromLTRB(7.5, 7.5, 15, 7.5),
                          // margin: EdgeInsets.fromLTRB(15, 7.5, 7.5, 7.5),
                          decoration: BoxDecoration(
                              boxShadow: const <BoxShadow>[
                                BoxShadow(
                                    blurRadius: 10,
                                    offset: Offset(8, 10),
                                    color: Colors.black)
                              ],
                              color: Colors.white,
                              border: Border.all(
                                  width: 1,
                                  style: BorderStyle.solid,
                                  color: const Color(0xffa3a3a3)),
                              borderRadius: BorderRadius.circular(20)),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: FutureBuilder(
                                      future: nameFuture,
                                      builder: (context, snapshot) {
                                        if (snapshot.data != null) {
                                          return TextButton(
                                            child: Text(
                                              '${namesDataList[index].toString()} ',
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: const TextStyle(
                                                fontSize: 10,
                                              ),
                                            ),
                                            onPressed: () async {
                                              // _createAlertDialogForNameDeviceBox(
                                              //     context, index, dId);
                                            },
                                          );
                                        } else {
                                          return Container();
                                        }
                                      },
                                    ),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 4.5,
                                      ),
                                      child: FutureBuilder(
                                          future: switchFuture,
                                          builder: (context, snapshot) {
                                            if (snapshot.data != null) {
                                              return Switch(
                                                  value:
                                                      responseGetData[index] ==
                                                              0
                                                          ? false
                                                          : true,
                                                  onChanged: (value) async {
                                                    if (responseGetData[
                                                            index] ==
                                                        0) {
                                                      setState(() {
                                                        responseGetData[index] =
                                                            1;
                                                      });
                                                      await dataUpdate(did);

                                                      await getPinStatusData(
                                                          did);
                                                      await getPinStatusByDidLocal(
                                                          did, index);
                                                    } else {
                                                      setState(() {
                                                        responseGetData[index] =
                                                            0;
                                                      });
                                                      await dataUpdate(did).then(
                                                          (value) => getPinStatusData(
                                                                  did)
                                                              .then((value) =>
                                                                  getPinStatusByDidLocal(
                                                                      did,
                                                                      index)));
                                                    }
                                                  });
                                            } else {
                                              return Container();
                                            }
                                          })),
                                ],
                              ),
                              GestureDetector(
                                  onTap: () {}, child: Icon(changeIcon[index]))
                            ],
                          )),
                    ),
                  ),
                );
              }),
            ),
          ),
          Column(
            children: [
              Container(
                color: Colors.transparent,
                height: MediaQuery.of(context).size.height * 1.85,
                child: GridView.count(
                  crossAxisSpacing: 8,
                  childAspectRatio: 2 / 1.8,
                  mainAxisSpacing: 4,
                  crossAxisCount: 2,
                  scrollDirection: Axis.vertical,
                  physics: const NeverScrollableScrollPhysics(),
                  children: List.generate(3, (index) {
                    return SizedBox(
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                            alignment: const FractionalOffset(1.0, 0.0),
                            // alignment: Alignment.bottomRight,
                            height: 120,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 1, vertical: 10),
                            margin: index % 2 == 0
                                ? const EdgeInsets.fromLTRB(15, 7.5, 7.5, 7.5)
                                : const EdgeInsets.fromLTRB(7.5, 7.5, 15, 7.5),
                            // margin: EdgeInsets.fromLTRB(15, 7.5, 7.5, 7.5),
                            decoration: BoxDecoration(
                                boxShadow: const <BoxShadow>[
                                  BoxShadow(
                                      blurRadius: 10,
                                      offset: Offset(8, 10),
                                      color: Colors.black)
                                ],
                                color: Colors.white,
                                border: Border.all(
                                    width: 1,
                                    style: BorderStyle.solid,
                                    color: const Color(0xffa3a3a3)),
                                borderRadius: BorderRadius.circular(20)),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: FutureBuilder(
                                        future: nameFuture,
                                        builder: (context, snapshot) {
                                          if (snapshot.data != null) {
                                            return TextButton(
                                              child: Text(
                                                // '$index',
                                                namesDataList[index + 9]
                                                    .toString(),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: const TextStyle(
                                                  fontSize: 10,
                                                ),
                                              ),
                                              onPressed: () async {
                                                int newIndex = index + 9;
                                                // _createAlertDialogForNameDeviceBox(
                                                //     context, newIndex, dId);
                                              },
                                            );
                                          } else {
                                            return Container();
                                          }
                                        },
                                      ),
                                    ),
                                    FutureBuilder(
                                        future: switchFuture,
                                        builder: (context, snapshot) {
                                          if (snapshot.data != null) {
                                            return SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  3.9,
                                              child: Slider(
                                                  value: double.parse(
                                                      responseGetData[index + 9]
                                                          .toString()),
                                                  min: 0,
                                                  max: 10,
                                                  label:
                                                      '${double.parse(responseGetData[index + 9].toString())}',
                                                  onChanged: (onChanged) async {
                                                    setState(() {
                                                      responseGetData[
                                                              index + 9] =
                                                          onChanged.round();
                                                    });
                                                    await dataUpdate(did);
                                                    await getPinStatusData(did);
                                                  }),
                                            );
                                          } else {
                                            return Container();
                                          }
                                        }),
                                  ],
                                ),
                                // GestureDetector(
                                //     onTap: () {}, child: const Icon(Icons.add))
                              ],
                            )),
                      ),
                    );
                  }),
                ),
              ),
              GestureDetector(
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: subAcessDevice[index].dId,
                        style:
                            const TextStyle(fontSize: 15, color: Colors.white)),
                    const TextSpan(text: "   "),
                    const WidgetSpan(
                        child: Icon(
                      Icons.settings,
                      color: Colors.white,
                      size: 18,
                    ))
                  ]),
                ),
                onTap: () {},
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget changePlace() {
    return Container(
      margin: const EdgeInsets.only(bottom: 45),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                const SizedBox(
                  width: 15,
                ),
                InkWell(
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onTap: () {
                    setState(() {
                      placeBool = !placeBool;
                    });
                  },
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: FutureBuilder<List<SubAccessPlace>>(
                  future: placeVal,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.isEmpty) {
                        return const Center(
                            child: Text(
                          "No Devices on this place",
                          style: TextStyle(color: Colors.white),
                        ));
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
                            child: DropdownButtonFormField<SubAccessPlace>(
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
                                return DropdownMenuItem<SubAccessPlace>(
                                  value: selectedPlace,
                                  child: Text(selectedPlace.pType),
                                );
                              }).toList(),
                              onChanged: (selectPlace) {
                                setState(() {
                                  floorVal = floorQueryFunc(selectPlace!.pId);
                                  pt = selectPlace;
                                });
                              },
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
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: FutureBuilder<List<SubAccessFloor>>(
                  future: floorVal,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.isEmpty) {
                        return const Center(
                            child: Text(
                          "No Devices on this place",
                          style: TextStyle(color: Colors.white),
                        ));
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
                            child: DropdownButtonFormField<SubAccessFloor>(
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
                              hint: const Text('Select Floor'),
                              isExpanded: true,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              items: snapshot.data!.map((selectedfloor) {
                                return DropdownMenuItem<SubAccessFloor>(
                                  value: selectedfloor,
                                  child: Text(selectedfloor.fName),
                                );
                              }).toList(),
                              onChanged: (selectFloor) {
                                setState(() {
                                  flatVal = flatQueryFunc(selectFloor!.fId);
                                  fl = selectFloor;
                                });
                              },
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
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: FutureBuilder<List<SubAccessFlat>>(
                  future: flatVal,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.isEmpty) {
                        return const Center(
                            child: Text(
                          "No Devices on this place",
                          style: TextStyle(color: Colors.white),
                        ));
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
                            child: DropdownButtonFormField<SubAccessFlat>(
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
                              hint: const Text('Select Flat'),
                              isExpanded: true,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              items: snapshot.data!.map((selectedflat) {
                                return DropdownMenuItem<SubAccessFlat>(
                                  value: selectedflat,
                                  child: Text(selectedflat.fltName),
                                );
                              }).toList(),
                              onChanged: (selectFlat) {
                                setState(() {
                                  flt = selectFlat;
                                });
                              },
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
            ),
            Container(
              height: 50.0,
              width: 150.0,
              color: Colors.transparent,
              child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  child: Center(
                    child: InkWell(
                      child: const Text(
                        "Submit",
                        style: TextStyle(color: Colors.white, fontSize: 22),
                        textAlign: TextAlign.center,
                      ),
                      onTap: () async {
                        // List<RoomType> rm = [];

                        // List data =
                        //     await AllDatabase.instance.getRoomById(flt!.fltId);
                        // setState(() {
                        //   rm = data
                        //       .map((data) => RoomType.fromJson(data))
                        //       .toList();
                        // });

                        // Navigator.pushReplacement(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => HomePage(
                        //             fl: fl,
                        //             flat: flt,
                        //             pt: pt,
                        //             rm: rm,
                        //             dv: const [])));
                      },
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget changeFloor() {
    return Container(
      margin: const EdgeInsets.only(bottom: 45),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                const SizedBox(
                  width: 15,
                ),
                InkWell(
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onTap: () {
                    setState(() {
                      changeFloorBool = !changeFloorBool;
                    });
                  },
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: FutureBuilder<List<SubAccessFloor>>(
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
                            child: DropdownButtonFormField<SubAccessFloor>(
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
                              hint: const Text('Select Floor'),
                              isExpanded: true,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              items: snapshot.data!.map((selectedfloor) {
                                return DropdownMenuItem<SubAccessFloor>(
                                  value: selectedfloor,
                                  child: Text(selectedfloor.fName),
                                );
                              }).toList(),
                              onChanged: (selectFloor) {
                                setState(() {
                                  flatVal = flatQueryFunc(selectFloor!.fId);
                                  fl = selectFloor;
                                });
                              },
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
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: FutureBuilder<List<SubAccessFlat>>(
                  future: flatVal,
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
                            child: DropdownButtonFormField<SubAccessFlat>(
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
                              hint: const Text('Select Flat'),
                              isExpanded: true,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              items: snapshot.data!.map((selectedflat) {
                                return DropdownMenuItem<SubAccessFlat>(
                                  value: selectedflat,
                                  child: Text(selectedflat.fltName),
                                );
                              }).toList(),
                              onChanged: (selectFlat) {
                                setState(() {
                                  flt = selectFlat;
                                });
                              },
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
            ),
            Container(
              height: 50.0,
              width: 150.0,
              color: Colors.transparent,
              child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  child: Center(
                    child: InkWell(
                      child: const Text(
                        "Submit",
                        style: TextStyle(color: Colors.white, fontSize: 22),
                        textAlign: TextAlign.center,
                      ),
                      onTap: () async {
                        List<SubAccessRoom> rm = [];

                        List data = await AllDatabase.instance
                            .getAllRoomByIdSubAccess(flt!.fltId);
                        setState(() {
                          rm = data
                              .map((data) => SubAccessRoom.fromJson(data))
                              .toList();
                        });
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SubAccess(
                                      ownerName: widget.ownerName,
                                      pId: widget.pId,
                                      floor: fl,
                                      flat: flt,
                                      rm: rm,
                                    )));
                      },
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
 
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
   
    String time12;
    if (time23 != null) {
      setState(() {
        time = time23;
      });
      time12 = time.toString();
      cutTime = time12.substring(10, 15);
    }
  }

  Future<SubAccessPlace?> getPlace(id) async {
    if (widget.floor != null && widget.flat != null) {
      await getFloorDropDown(widget.floor!.fId.toString());
    }else{

      List data = await AllDatabase.instance.getAllPlacesByIdSubAccess(id);

      setState(() {
        subAccessplace = SubAccessPlace.fromJson(data[0]);
      });

      await getFloorById(widget.pId);
    }

    return subAccessplace;
  }

  Future getFloorDropDown(id) async {
    List data = await AllDatabase.instance.getSingleFloorByIdSubAccess(id);
    setState(() {
      subAccessFloor = SubAccessFloor.fromJson(data[0]);
    });
    await getFlatById(subAccessFloor!.fId);
  }

  Future getFloorById(id) async {
    List data = await AllDatabase.instance.getAllFloorByIdSubAccess(id);
    setState(() {
      subAccessFloor = SubAccessFloor.fromJson(data[0]);
    });
    print("FLOOR DATA LOCAL ${subAccessFloor}");

    await getFlatById(subAccessFloor!.fId);
  }

  Future getFlatDropDown(id) async {
    List data = await AllDatabase.instance.getSingleFlatByIdSubAccess(id);
    setState(() {
      subAccessFlat = SubAccessFlat.fromJson(data[0]);
      flatId = subAccessFlat!.fltId;
    });
    await getRoomById(flatId);
  }

  Future getFlatById(id) async {
    List data = await AllDatabase.instance.getAllFlatByIdSubAccess(id);
    setState(() {
      subAccessFlat = SubAccessFlat.fromJson(data[0]);
      flatId = subAccessFlat!.fltId;
    });
    print("FLAT DATA LOCAL ${subAccessFlat}");
    await getRoomById(flatId);
  }

  Future getRoomById(id) async {
    List data = await AllDatabase.instance.getAllRoomByIdSubAccess(id);

    setState(() {
      subAcessRoom = data.map((data) => SubAccessRoom.fromJson(data)).toList();
      tabC = TabController(length: subAcessRoom.length, vsync: this);
    });

    await getDeviceById(subAcessRoom[0].rId);

    switchFuture = getPinStatusByDidLocal(subAcessDevice[0].dId, 0);
    nameFuture = getPinNameByLocal(subAcessDevice[0].dId, 0);
  }

  Future<List<SubAccessDevice>> getDeviceById(id) async {
    List data = await AllDatabase.instance.getAllDeviceByRIdSubAccess(id);

    setState(() {
      subAcessDevice =
          data.map((data) => SubAccessDevice.fromJson(data)).toList();
    });
    await getPinStatusData(subAcessDevice[0].dId);
    return subAcessDevice;
  }

  Future<bool> getPinStatusByDidLocal(did, index) async {
    List data = await AllDatabase.instance.getDevicePinStatusByIdSubAccess(did);

    setState(() {
      responseGetData = [
        data[0]['pin1Status'],
        data[0]['pin2Status'],
        data[0]['pin3Status'],
        data[0]['pin4Status'],
        data[0]['pin5Status'],
        data[0]['pin6Status'],
        data[0]['pin7Status'],
        data[0]['pin8Status'],
        data[0]['pin9Status'],
        data[0]['pin10Status'],
        data[0]['pin11Status'],
        data[0]['pin12Status'],
      ];

      sensorData=[
        data[0]['sensor1'],
        data[0]['sensor2'],
        data[0]['sensor3'],
        data[0]['sensor4'],
        data[0]['sensor5'],
        data[0]['sensor6'],
        data[0]['sensor7'],
        data[0]['d_id'],
      ];
    });
    if (kDebugMode) {
      print(responseGetData);
    }

    if (data.isNotEmpty) {
      return true;
    }
    return false;
  }

  Future<bool> getPinNameByLocal(dId, index) async {
    List pinName = await AllDatabase.instance.getPinNamesByDeviceId(dId);
    if (kDebugMode) {
      print("getPuinName $pinName");
    }
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

      if (kDebugMode) {
        print("Name object $namesDataList");
      }

      String pin1 = pinName[0]['pin1Name'];

      var indexOfPin1Name = pin1.indexOf(',');
      var pin1FinalName = pin1.substring(0, indexOfPin1Name);

      if (kDebugMode) {
        print('indexofpppp $namesDataList');
      }

      String pin2 = pinName[0]['pin2Name'];
      var indexOfPin2Name = pin2.indexOf(',');
      var pin2FinalName = pin2.substring(0, indexOfPin2Name);
      if (kDebugMode) {
        print('indexofpppppin2 $pin2');
      }

      String pin3 = pinName[0]['pin3Name'];
      var indexOfPin3Name = pin3.indexOf(',');
      var pin3FinalName = pin3.substring(0, indexOfPin3Name);
      if (kDebugMode) {
        print('indexofpppppin2 $pin3');
      }

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
      for (int i = 0; i < namesDataList.length; i++) {
        if (pin1.contains('001') ||
            pin1.contains('002') ||
            pin1.contains('003') ||
            pin1.contains('004') ||
            pin1.contains('005') ||
            pin1.contains('006') ||
            pin1.contains('007') ||
            pin1.contains('008') ||
            pin1.contains('009') ||
            pin1.contains('0010') ||
            pin1.contains('0011')) {
          // icon1=Icons.ac_unit;
          if (pin1.contains('001')) {
            setState(() {
              changeIcon[index] = icon1;
            });
          }
          if (pin1.contains('002')) {
            changeIcon[index] = icon2;
          }
          if (pin1.contains('003')) {
            // changeIcon[index]=icon3;
            setState(() {
              changeIcon[index] = icon3;
            });
          }
          if (pin1.contains('004')) {
            changeIcon[index] = icon4;
          }
          if (pin1.contains('005')) {
            changeIcon[index] = icon5;
          }
          if (pin1.contains('007')) {
            changeIcon[index] = icon6;
          }
          if (pin1.contains('008')) {
            changeIcon[index] = icon7;
          }
          if (pin1.contains('009')) {
            changeIcon[index] = icon8;
          }
          if (pin1.contains('0010')) {
            changeIcon[index] = icon9;
          }
          if (pin1.contains('0011')) {
            changeIcon[index] = icon10;
          }
          if (pin1.contains('0012')) {
            changeIcon[index] = icon12;
          }
        }

        if (pin2.contains('001') ||
            pin2.contains('002') ||
            pin2.contains('003') ||
            pin2.contains('004') ||
            pin2.contains('005') ||
            pin2.contains('006') ||
            pin2.contains('007') ||
            pin2.contains('008') ||
            pin2.contains('009') ||
            pin2.contains('0010') ||
            pin2.contains('0011')) {
          // icon2=Icons.ac_unit;
          // changeIcon[index+1]=icon2;
          if (pin2.contains('001')) {
            changeIcon[index + 1] = icon1;
          }
          if (pin2.contains('002')) {
            changeIcon[index + 1] = icon2;
          }
          if (pin2.contains('003')) {
            changeIcon[index + 1] = icon3;
          }
          if (pin2.contains('004')) {
            changeIcon[index + 1] = icon5;
          }
          if (pin2.contains('005')) {
            changeIcon[index + 1] = icon6;
          }
          if (pin2.contains('007')) {
            changeIcon[index + 1] = icon6;
          }
          if (pin2.contains('008')) {
            changeIcon[index + 1] = icon7;
          }
          if (pin2.contains('009')) {
            changeIcon[index] = icon8;
          }
          if (pin2.contains('0010')) {
            changeIcon[index + 1] = icon9;
          }
          if (pin2.contains('0011')) {
            changeIcon[index + 1] = icon10;
          }
          if (pin2.contains('0012')) {
            changeIcon[index + 1] = icon12;
          }
        }

        if (pin3.contains('001') ||
            pin3.contains('002') ||
            pin3.contains('003') ||
            pin3.contains('004') ||
            pin3.contains('005') ||
            pin3.contains('006') ||
            pin3.contains('007') ||
            pin3.contains('008') ||
            pin3.contains('009') ||
            pin3.contains('0010') ||
            pin3.contains('0011')) {
          // icon2=Icons.ac_unit;
          // changeIcon[index+1]=icon2;
          if (pin3.contains('001')) {
            changeIcon[index + 2] = icon1;
          }
          if (pin3.contains('002')) {
            changeIcon[index + 2] = icon2;
          }
          if (pin3.contains('003')) {
            changeIcon[index + 2] = icon3;
          }
          if (pin3.contains('004')) {
            changeIcon[index + 2] = icon5;
          }
          if (pin3.contains('005')) {
            changeIcon[index + 2] = icon6;
          }
          if (pin3.contains('007')) {
            changeIcon[index + 2] = icon6;
          }
          if (pin3.contains('008')) {
            changeIcon[index + 2] = icon7;
          }
          if (pin3.contains('009')) {
            changeIcon[index + 2] = icon8;
          }
          if (pin3.contains('0010')) {
            changeIcon[index + 2] = icon9;
          }
          if (pin3.contains('0011')) {
            changeIcon[index + 2] = icon10;
          }
          if (pin3.contains('0012')) {
            changeIcon[index + 2] = icon12;
          }
        }

        if (pin4.contains('001') ||
            pin4.contains('002') ||
            pin4.contains('003') ||
            pin4.contains('004') ||
            pin4.contains('005') ||
            pin4.contains('006') ||
            pin4.contains('007') ||
            pin4.contains('008') ||
            pin4.contains('009') ||
            pin4.contains('0010') ||
            pin4.contains('0011')) {
          // icon2=Icons.ac_unit;
          // changeIcon[index+1]=icon2;
          if (pin4.contains('001')) {
            changeIcon[index + 3] = icon1;
          }
          if (pin4.contains('002')) {
            changeIcon[index + 3] = icon2;
          }
          if (pin4.contains('003')) {
            changeIcon[index + 3] = icon3;
          }
          if (pin4.contains('004')) {
            changeIcon[index + 3] = icon5;
          }
          if (pin4.contains('005')) {
            changeIcon[index + 3] = icon6;
          }
          if (pin4.contains('007')) {
            changeIcon[index + 3] = icon6;
          }
          if (pin4.contains('008')) {
            changeIcon[index + 3] = icon7;
          }
          if (pin4.contains('009')) {
            changeIcon[index + 3] = icon8;
          }
          if (pin4.contains('0010')) {
            changeIcon[index + 3] = icon9;
          }
          if (pin4.contains('0011')) {
            changeIcon[index + 3] = icon10;
          }
          if (pin4.contains('0012')) {
            changeIcon[index + 3] = icon12;
          }
        }
        if (pin5.contains('001') ||
            pin5.contains('002') ||
            pin5.contains('003') ||
            pin5.contains('004') ||
            pin5.contains('005') ||
            pin5.contains('006') ||
            pin5.contains('007') ||
            pin5.contains('008') ||
            pin5.contains('009') ||
            pin5.contains('0010') ||
            pin5.contains('0011')) {
          // icon2=Icons.ac_unit;
          // changeIcon[index+1]=icon2;
          if (pin5.contains('001')) {
            changeIcon[index + 4] = icon1;
          }
          if (pin5.contains('002')) {
            changeIcon[index + 4] = icon2;
          }
          if (pin5.contains('003')) {
            changeIcon[index + 4] = icon3;
          }
          if (pin5.contains('004')) {
            changeIcon[index + 4] = icon5;
          }
          if (pin5.contains('005')) {
            changeIcon[index + 4] = icon6;
          }
          if (pin5.contains('007')) {
            changeIcon[index + 4] = icon6;
          }
          if (pin5.contains('008')) {
            changeIcon[index + 4] = icon7;
          }
          if (pin5.contains('009')) {
            changeIcon[index + 4] = icon8;
          }
          if (pin5.contains('0010')) {
            changeIcon[index + 4] = icon9;
          }
          if (pin5.contains('0011')) {
            changeIcon[index + 4] = icon10;
          }
          if (pin5.contains('0012')) {
            changeIcon[index + 4] = icon12;
          }
        }
        if (pin6.contains('001') ||
            pin6.contains('002') ||
            pin6.contains('003') ||
            pin6.contains('004') ||
            pin6.contains('005') ||
            pin6.contains('006') ||
            pin6.contains('007') ||
            pin6.contains('008') ||
            pin6.contains('009') ||
            pin6.contains('0010') ||
            pin6.contains('0011')) {
          // icon2=Icons.ac_unit;
          // changeIcon[index+1]=icon2;
          if (pin6.contains('001')) {
            changeIcon[index + 5] = icon1;
          }
          if (pin6.contains('002')) {
            changeIcon[index + 5] = icon2;
          }
          if (pin6.contains('003')) {
            changeIcon[index + 5] = icon3;
          }
          if (pin6.contains('004')) {
            changeIcon[index + 5] = icon5;
          }
          if (pin6.contains('005')) {
            changeIcon[index + 5] = icon6;
          }
          if (pin6.contains('007')) {
            changeIcon[index + 5] = icon6;
          }
          if (pin6.contains('008')) {
            changeIcon[index + 5] = icon7;
          }
          if (pin6.contains('009')) {
            changeIcon[index + 5] = icon8;
          }
          if (pin6.contains('0010')) {
            changeIcon[index + 5] = icon9;
          }
          if (pin6.contains('0011')) {
            changeIcon[index + 5] = icon10;
          }
          if (pin6.contains('0012')) {
            changeIcon[index + 5] = icon12;
          }
        }
        if (pin7.contains('001') ||
            pin7.contains('002') ||
            pin7.contains('003') ||
            pin7.contains('004') ||
            pin7.contains('005') ||
            pin7.contains('006') ||
            pin7.contains('007') ||
            pin7.contains('008') ||
            pin7.contains('009') ||
            pin7.contains('0010') ||
            pin7.contains('0011')) {
          // icon2=Icons.ac_unit;
          // changeIcon[index+1]=icon2;
          if (pin7.contains('001')) {
            changeIcon[index + 6] = icon1;
          }
          if (pin7.contains('002')) {
            changeIcon[index + 6] = icon2;
          }
          if (pin7.contains('003')) {
            changeIcon[index + 6] = icon3;
          }
          if (pin7.contains('004')) {
            changeIcon[index + 6] = icon5;
          }
          if (pin7.contains('005')) {
            changeIcon[index + 6] = icon6;
          }
          if (pin7.contains('007')) {
            changeIcon[index + 6] = icon6;
          }
          if (pin7.contains('008')) {
            changeIcon[index + 6] = icon7;
          }
          if (pin7.contains('009')) {
            changeIcon[index + 6] = icon8;
          }
          if (pin7.contains('0010')) {
            changeIcon[index + 6] = icon9;
          }
          if (pin7.contains('0011')) {
            changeIcon[index + 6] = icon10;
          }
          if (pin7.contains('0012')) {
            changeIcon[index + 6] = icon12;
          }
        }
        if (pin8.contains('001') ||
            pin8.contains('002') ||
            pin8.contains('003') ||
            pin8.contains('004') ||
            pin8.contains('005') ||
            pin8.contains('006') ||
            pin8.contains('007') ||
            pin8.contains('008') ||
            pin8.contains('009') ||
            pin8.contains('0010') ||
            pin8.contains('0011')) {
          // icon2=Icons.ac_unit;
          // changeIcon[index+1]=icon2;
          if (pin8.contains('001')) {
            changeIcon[index + 7] = icon1;
          }
          if (pin8.contains('002')) {
            changeIcon[index + 7] = icon2;
          }
          if (pin8.contains('003')) {
            changeIcon[index + 7] = icon3;
          }
          if (pin8.contains('004')) {
            changeIcon[index + 7] = icon5;
          }
          if (pin8.contains('005')) {
            changeIcon[index + 7] = icon6;
          }
          if (pin8.contains('007')) {
            changeIcon[index + 7] = icon6;
          }
          if (pin8.contains('008')) {
            changeIcon[index + 7] = icon7;
          }
          if (pin8.contains('009')) {
            changeIcon[index + 7] = icon8;
          }
          if (pin8.contains('0010')) {
            changeIcon[index + 7] = icon9;
          }
          if (pin8.contains('0011')) {
            changeIcon[index + 7] = icon10;
          }
          if (pin8.contains('0012')) {
            changeIcon[index + 7] = icon12;
          }
        }
        if (pin9.contains('001') ||
            pin9.contains('002') ||
            pin9.contains('003') ||
            pin9.contains('004') ||
            pin9.contains('005') ||
            pin9.contains('006') ||
            pin9.contains('007') ||
            pin9.contains('008') ||
            pin9.contains('009') ||
            pin9.contains('0010') ||
            pin9.contains('0011')) {
          // icon2=Icons.ac_unit;
          // changeIcon[index+1]=icon2;
          if (pin9.contains('001')) {
            changeIcon[index + 8] = icon1;
          }
          if (pin9.contains('002')) {
            changeIcon[index + 8] = icon2;
          }
          if (pin9.contains('003')) {
            changeIcon[index + 8] = icon3;
          }
          if (pin9.contains('004')) {
            changeIcon[index + 8] = icon5;
          }
          if (pin9.contains('005')) {
            changeIcon[index + 8] = icon6;
          }
          if (pin9.contains('007')) {
            changeIcon[index + 8] = icon6;
          }
          if (pin9.contains('008')) {
            changeIcon[index + 8] = icon7;
          }
          if (pin9.contains('009')) {
            changeIcon[index + 8] = icon8;
          }
          if (pin9.contains('0010')) {
            changeIcon[index + 8] = icon9;
          }
          if (pin9.contains('0011')) {
            changeIcon[index + 8] = icon10;
          }
          if (pin9.contains('0012')) {
            changeIcon[index + 8] = icon12;
          }
        }

        // if(namesDataList[index+2].contains('003')){
        //   // icon2=Icons.ac_unit;
        //   changeIcon[index+2]=icon3;
        // }
        // if(namesDataList[index+3].contains('004')){
        //   print('qwertyhgf $index');
        //   // icon2=Icons.ac_unit;
        //   changeIcon[index+3]=icon4;
        // }
      }
      return true;
    }
    return false;
  }



  Future<String?> getToken() async {
    final tokenVar = await storage.read(key: "token");

    return tokenVar;
  }

  Future<void> dataUpdate(dId) async {
    String? token = await getToken();
    var url = api + 'getpostdevicePinStatus/?d_id=' + dId;
    Map data = {
      'put': 'yes',
      "d_id": dId,
      'pin1Status': responseGetData[0],
      'pin2Status': responseGetData[1],
      'pin3Status': responseGetData[2],
      'pin4Status': responseGetData[3],
      'pin5Status': responseGetData[4],
      'pin6Status': responseGetData[5],
      'pin7Status': responseGetData[6],
      'pin8Status': responseGetData[7],
      'pin9Status': responseGetData[8],
      'pin10Status': responseGetData[9],
      'pin11Status': responseGetData[10],
      'pin12Status': responseGetData[11],
    };

    final response =
        await http.post(Uri.parse(url), body: jsonEncode(data), headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Token $token',
    });
    if (response.statusCode == 201 || response.statusCode == 200) {
      await getPinStatusData(dId);
      return;
    } else {}
  }

  Future getPinStatusData(did) async {
    var token = await getToken();

    var url = api + "getpostdevicePinStatus/?d_id=" + did;
    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Token $token',
    });
    if (response.statusCode == 200) {
      var ans = jsonDecode(response.body);
      List a = await AllDatabase.instance.getDevicePinStatusByIdSubAccess(did);
      if (a.isEmpty) {
        setState(() {
          DevicePinStatus pinStatus = DevicePinStatus.fromJson(ans);
          AllDatabase.instance.insertAllDevicePinStatusSubAccess(pinStatus);
        });
      } else {
        setState(() {
          DevicePinStatus pinStatus = DevicePinStatus.fromJson(ans);
          AllDatabase.instance.subAcessUpdatePinStatusData(pinStatus);
        });
        return;
      }
    }
  }

  Future<List<SubAccessPlace>> placeQueryFunc(id) async {
    List data =
        await AllDatabase.instance.getAllPlacesByIdSubAccess(id.toString());
    List<SubAccessPlace> placeType = [];
    setState(() {
      placeType = data.map((data) => SubAccessPlace.fromJson(data)).toList();
    });

    return placeType;
  }

  Future<List<SubAccessFloor>> floorQueryFunc(id) async {
    List data =
        await AllDatabase.instance.getAllFloorByIdSubAccess(id.toString());

    List<SubAccessFloor> floorType = [];
    setState(() {
      floorType = data.map((data) => SubAccessFloor.fromJson(data)).toList();
    });

    return floorType;
  }

  Future<List<SubAccessFlat>> flatQueryFunc(id) async {
    List data =
        await AllDatabase.instance.getAllFlatByIdSubAccess(id.toString());
    List<SubAccessFlat> flatType = [];
    setState(() {
      flatType = data.map((data) => SubAccessFlat.fromJson(data)).toList();
    });

    return flatType;
  }

  Future<List<SubAccessRoom>> roomQueryFunc(id) async {
    List data =
        await AllDatabase.instance.getAllRoomByIdSubAccess(id.toString());
    List<SubAccessRoom> roomType = [];
    setState(() {
      roomType = data.map((data) => SubAccessRoom.fromJson(data)).toList();
    });

    return roomType;
  }
}
