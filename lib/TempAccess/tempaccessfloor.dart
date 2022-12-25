// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables, unused_local_variable

import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:genorion_mac_android/Models/sensor.dart';
import 'package:http/http.dart' as http;

import '../SubAccessModels/subaccesflat.dart';
import '../SubAccessModels/subaccessdevice.dart';
import '../SubAccessModels/subaccessroom.dart';
import '../main.dart';

class TempAccessFloor extends StatefulWidget {
  var ownerName;
  var floorId;
  SubAccessFlat? subAccessFlat;
  TempAccessFloor(
      {Key? key,
      required this.floorId,
      required this.ownerName,
      this.subAccessFlat})
      : super(key: key);

  @override
  _TempAccessFloorState createState() => _TempAccessFloorState();
}

class _TempAccessFloorState extends State<TempAccessFloor>
    with TickerProviderStateMixin {
  final storage = const FlutterSecureStorage();
  List floorName = [];
  Future<bool>? floorFuture;
  SubAccessFlat? flat;
  List<SubAccessRoom> rm = [];
  Future? nameFuture;
  List<SubAccessDevice> dv = [];
  Future? switchFuture;
  List devicePinStatus = [];
  Future? pinScheduledFuture;
  List namesDataList = [];
  TabController? tabC;
  Future<List<SubAccessFlat>>? flatVal;
  SubAccessFlat? flt;
  Future? deviceSensorVal;
  bool remoteBool = false;
  SensorData? sensorData;
  ScrollController scrollController = ScrollController();
  var deviceIdForScroll;
  @override
  void initState() {
    super.initState();

    floorFuture = getFloorName(widget.floorId.toString());
    scrollController.addListener(() async {
      if (kDebugMode) {
        print('scrolling $deviceIdForScroll');
      }

      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (kDebugMode) {
          print('scrollingeeeeeee');
        }
      }
      if (scrollController.position.isScrollingNotifier.value) {
        if (kDebugMode) {
          print("stop");
        }
        switchFuture = getPinStatusData(deviceIdForScroll)
            .then((value) => nameFuture = getPinNames(deviceIdForScroll));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff121421),
      body: remoteBool
          ? remoteUi()
          : SafeArea(
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
                          Text("Temp Floor",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(360),
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
                FutureBuilder(
                    future: floorFuture,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height / 0.5,
                          child: DefaultTabController(
                            length: rm.length,
                            child: CustomScrollView(
                              controller: scrollController,
                              slivers: [
                                SliverToBoxAdapter(
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.40,
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
                                                                floorName[0][
                                                                        'f_name']
                                                                    .toString(),
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
                                                              //     .arrow_drop_down),
                                                              const SizedBox(
                                                                width: 10,
                                                              ),
                                                            ],
                                                          ),
                                                          onTap: () {
                                                            setState(() {});
                                                          },
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        // GestureDetector(
                                                        //   child: const Icon(
                                                        //     SettingIcon.params,
                                                        //     size: 18,
                                                        //   ),
                                                        //   onTap: () async {},
                                                        // )
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
                                                                    flat!
                                                                        .fltName
                                                                        .toString(),
                                                                    style: const TextStyle(
                                                                        color: Colors.white,
                                                                        // fontWeight: FontWeight.bold,
                                                                        fontStyle: FontStyle.italic,
                                                                        fontSize: 22),
                                                                  ),
                                                                  // const Icon(Icons
                                                                  //     .arrow_drop_down),
                                                                  const SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                ],
                                                              ),
                                                              onTap: () {
                                                                _creatDialogChangeFlat();
                                                              },
                                                            ),
                                                            const SizedBox(
                                                                width: 28),
                                                            // GestureDetector(
                                                            //   onTap:
                                                            //       () async {},
                                                            //   child: const Icon(
                                                            //     SettingIcon
                                                            //         .params,
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
                                                    future: deviceSensorVal,
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot.hasData) {
                                                        return Column(
                                                          children: <Widget>[
                                                            Row(
                                                              children: <
                                                                  Widget>[
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
                                                                              sensorData!.sensor1.toString(),
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
                                                                              sensorData!.sensor2.toString(),
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
                                                                              sensorData!.sensor3.toString(),
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
                                                                            sensorData!.sensor4.toString(),
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
                                                              sensorData!.dId
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
                                                tabs: rm.map<Widget>(
                                                    (SubAccessRoom rm) {
                                                  return Tab(
                                                    text: rm.rName,
                                                  );
                                                }).toList(),
                                                onTap: (index) async {
                                                  await getDevice(
                                                      rm[index].rId);
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
                                    if (index < dv.length) {
                                      if (dv.isEmpty) {
                                        return Container();
                                      }
                                      return deviceContainer(
                                          dv[index].dId, index);
                                    } else {
                                      return null;
                                    }
                                  }),
                                )
                              ],
                            ),
                          ),
                        );
                      } else {
                        return const Center(
                            child: CircularProgressIndicator(
                          color: Colors.red,
                        ));
                      }
                    })
              ],
            )),
    );
  }

  _creatDialogChangeFlat() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Change Flat'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: FutureBuilder<List<SubAccessFlat>>(
                          future: flatVal,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              if (snapshot.data!.isEmpty) {
                                return const Center(
                                    child: Text("No Devices on this place"));
                              }
                              return Column(
                                children: [
                                  Container(
                                    child: SizedBox(
                                      width: double.infinity,
                                      height: 50.0,
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
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
                                            SubAccessFlat>(
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
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
                                          dropdownColor: dropDownColor,
                                          icon:
                                              const Icon(Icons.arrow_drop_down),
                                          iconSize: 28,
                                          hint: const Text('Select Flat'),
                                          isExpanded: true,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          items: snapshot.data!
                                              .map((selectedflat) {
                                            return DropdownMenuItem<
                                                SubAccessFlat>(
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
                                  ),
                                ],
                              );
                            } else {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                          }),
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MaterialButton(
                  elevation: 5.0,
                  child: const Text('Submit'),
                  onPressed: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TempAccessFloor(
                                  floorId: widget.floorId,
                                  ownerName: widget.ownerName,
                                  subAccessFlat: flt,
                                )));
                  },
                ),
              )
            ],
          );
        });
  }

  Widget deviceContainer(dId, index) {
    deviceIdForScroll = dId;
    return Container(
      height: MediaQuery.of(context).size.height * 2.9,
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
                      deviceSensorVal = getSensorData(dId);
                    },
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.all(8),
                //   child: GestureDetector(
                //     child: const Icon(
                //       Icons.schedule,
                //       color: Colors.white,
                //     ),
                //     onTap: () async {},
                //   ),
                // ),

                Container(
                  width: 14,
                  height: 14,

                  decoration: const BoxDecoration(
                      color: Colors.green, shape: BoxShape.circle),
                  // child: ...
                ),
                Switch(
                  value: devicePinStatus.contains(1) ? true : false,
                  //boolean value
                  onChanged: (val) async {
                    _showDialog(dId);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: GestureDetector(
                    child: const Icon(
                      Icons.settings_remote,
                      color: Colors.white,
                    ),
                    onTap: () {
                      setState(() {
                        remoteBool = !remoteBool;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: Colors.transparent,
            height: MediaQuery.of(context).size.height / 0.9,
            child: GridView.count(
              crossAxisSpacing: 8,
              childAspectRatio: 2 / 1.7,
              mainAxisSpacing: 4,
              crossAxisCount: 2,
              scrollDirection: Axis.vertical,
              physics: const NeverScrollableScrollPhysics(),
              children: List.generate(9, (index) {
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
                                            '${namesDataList[index].toString()} ',
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: const TextStyle(
                                              fontSize: 10,
                                            ),
                                          ),
                                          onPressed: () async {},
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
                                              value: devicePinStatus[index] == 0
                                                  ? false
                                                  : true,
                                              onChanged: (value) async {
                                                if (devicePinStatus[index] ==
                                                    0) {
                                                  setState(() {
                                                    devicePinStatus[index] = 1;
                                                  });
                                                  await dataUpdate(dId);
                                                  switchFuture =
                                                      getPinStatusData(dId);
                                                } else {
                                                  setState(() {
                                                    devicePinStatus[index] = 0;
                                                  });
                                                  await dataUpdate(dId);
                                                  await getPinStatusData(dId);
                                                }
                                              },
                                            );
                                          } else {
                                            return Container();
                                          }
                                        })),
                              ],
                            ),
                          ],
                        )),
                  ),
                );
              }),
            ),
          ),
          Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 2.2,
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
                                                      devicePinStatus[index + 9]
                                                          .toString()),
                                                  min: 0,
                                                  max: 10,
                                                  label:
                                                      '${double.parse(devicePinStatus[index + 9].toString())}',
                                                  onChanged: (onChanged) async {
                                                    setState(() {
                                                      devicePinStatus[
                                                              index + 9] =
                                                          onChanged.round();
                                                    });
                                                    // await dataUpdate(dId);
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
            ],
          ),
        ],
      ),
    );
  }

  Widget remoteUi() {
    return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
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
                    remoteBool = !remoteBool;
                  });
                },
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                child: ClipOval(
                  child: Material(
                    child: InkWell(
                      splashColor: Colors.white24,
                      child: const SizedBox(
                        height: 56,
                        width: 56,
                        child: Icon(Icons.dialpad),
                      ),
                      onTap: () {},
                    ),
                  ),
                ),
              ),
              SizedBox(
                child: ClipOval(
                  child: Material(
                    color: Colors.red,
                    child: InkWell(
                      splashColor: Colors.white24,
                      child: const SizedBox(
                        height: 56,
                        width: 56,
                        child: Icon(Icons.power_settings_new),
                      ),
                      onTap: () {},
                    ),
                  ),
                ),
              ),
              SizedBox(
                child: ClipOval(
                  child: Material(
                    child: InkWell(
                      splashColor: Colors.white24,
                      child: const SizedBox(
                        height: 56,
                        width: 56,
                        child: Icon(Icons.bubble_chart),
                      ),
                      onTap: () {},
                    ),
                  ),
                ),
              ),
            ],
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 156,
                  width: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      Icon(Icons.arrow_drop_up),
                      Text(
                        'VOL',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 14,
                ),
                // JoystickView(
                //   innerCircleColor: Colors.grey,
                //   backgroundColor: Colors.grey.shade400,
                //   iconsColor: Colors.white,
                //   showArrows: true,
                //   size: 200.0,
                // ),
                const SizedBox(
                  width: 14,
                ),
                Container(
                  height: 156,
                  width: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      Icon(Icons.arrow_drop_up),
                      Text(
                        'CH',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: 40,
                width: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(18.0),
                  // color: Colors.white,
                ),
                child: const Padding(
                  padding: EdgeInsets.all(2.0),
                  // child: Image.asset('assets/netflix.png'),
                ),
              ),
              Container(
                height: 40,
                width: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(18.0),
                  // color: Colors.white,
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  // child: Image.asset('assets/prime.png'),
                ),
              ),
            ],
          ),
        ],
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
                  devicePinStatus.replaceRange(0, devicePinStatus.length,
                      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]);
                  await dataUpdate(dId);

                  await getPinStatusData(dId);
                } else if (result == ConnectivityResult.mobile) {
                  devicePinStatus.replaceRange(0, devicePinStatus.length,
                      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]);
                  await dataUpdate(dId);
                  await getPinStatusData(dId);
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

  Future<String?> getToken() async {
    final tokenVar = await storage.read(key: "token");

    return tokenVar;
  }

  Future<bool> getFloorName(id) async {
    String? token = await getToken();
    String url = api + 'getyoufloorname/?f_id=' + id;
    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Token $token',
    });
    if (response.statusCode == 200) {
      print("FLoor ${response.body}");
      setState(() {
        floorName = jsonDecode(response.body);
      });
      await getAllFlat(floorName[0]['f_id'].toString());
      return true;
    } else {
      if (kDebugMode) {
        print(response.statusCode);
      }
    }
    return false;
  }

  Future getAllFlat(id) async {
    String? token = await getToken();
    var url = api + "getallflatbyonlyflooridf_id/?f_id=$id";
    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Token $token',
    });
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      print("FLoor ${data}");
      setState(() {
        flat = SubAccessFlat.fromJson(data[0]);
      });
      await getRooms(flat!.fltId);
    }
  }

  Future getRooms(fltId) async {
    String? token = await getToken();
    String url =
        api + 'getallroomsbyonlyflooridf_id/?flt_id=' + fltId.toString();
    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Token $token',
    });
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      print("FLoor ${data}");
      setState(() {
        rm = data.map((data) => SubAccessRoom.fromJson(data)).toList();
        tabC = TabController(length: rm.length, vsync: this);
      });
      await getDevice(rm[0].rId);
      return true;
    } else {
      if (kDebugMode) {
        print(response.body);
      }
      return false;
    }
  }

  Future getDevice(rId) async {
    String? token = await getToken();
    var url = api + 'getalldevicesbyonlyroomidr_id/?r_id=' + rId;
    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Token $token',
    });
    if (response.statusCode == 200) {
      List<dynamic> deviceData = jsonDecode(response.body);
      setState(() {
        dv = deviceData.map((e) => SubAccessDevice.fromJson(e)).toList();
        switchFuture = getPinStatusData(deviceData[0]['d_id']);
        nameFuture = getPinNames(deviceData[0]['d_id']);
      });
    }
  }

  Future<void> dataUpdate(dId) async {
    String? token = await getToken();
    var url = api + 'getpostdevicePinStatus/?d_id=' + dId;
    Map data = {
      'put': 'yes',
      "d_id": dId,
      'pin1Status': devicePinStatus[0],
      'pin2Status': devicePinStatus[1],
      'pin3Status': devicePinStatus[2],
      'pin4Status': devicePinStatus[3],
      'pin5Status': devicePinStatus[4],
      'pin6Status': devicePinStatus[5],
      'pin7Status': devicePinStatus[6],
      'pin8Status': devicePinStatus[7],
      'pin9Status': devicePinStatus[8],
      'pin10Status': devicePinStatus[9],
      'pin11Status': devicePinStatus[10],
      'pin12Status': devicePinStatus[11],
    };

    final response =
        await http.post(Uri.parse(url), body: jsonEncode(data), headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Token $token',
    });
    if (response.statusCode == 201 || response.statusCode == 200) {
      if (kDebugMode) {
        print(response.body);
      }
      return;
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  Future<bool> getPinStatusData(did) async {
    var token = await getToken();

    var url = api + "getpostdevicePinStatus/?d_id=" + did;
    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Token $token',
    });
    if (response.statusCode == 200) {
      var ans = jsonDecode(response.body);
      setState(() {
        devicePinStatus = [
          ans['pin1Status'],
          ans['pin2Status'],
          ans['pin3Status'],
          ans['pin4Status'],
          ans['pin5Status'],
          ans['pin6Status'],
          ans['pin7Status'],
          ans['pin8Status'],
          ans['pin9Status'],
          ans['pin10Status'],
          ans['pin11Status'],
          ans['pin12Status'],
        ];
      });
      if (kDebugMode) {
        print(devicePinStatus);
      }
      return true;
    } else {
      return false;
    }
  }

  Future<bool> getPinNames(did) async {
    String? token = await getToken();
    var url = api + "editpinnames/?d_id=" + did;
    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Token $token',
    });
    if (response.statusCode == 200) {
      var pinName = jsonDecode(response.body);
      setState(() {
        namesDataList = [
          pinName['pin1Name'],
          pinName['pin2Name'],
          pinName['pin3Name'],
          pinName['pin4Name'],
          pinName['pin5Name'],
          pinName['pin6Name'],
          pinName['pin7Name'],
          pinName['pin8Name'],
          pinName['pin9Name'],
          pinName['pin10Name'],
          pinName['pin11Name'],
          pinName['pin12Name'],
        ];
      });

      return true;
    } else {
      return false;
    }
  }

  Future getSensorData(dId) async {
    String? token = await getToken();
    String url = api + "tensensorsdata/?d_id=" + dId;
    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Token $token',
    });
    if (response.statusCode == 200) {
      setState(() {
        sensorData = SensorData.fromJson(jsonDecode(response.body));
      });
      return true;
    } else {}
  }
}
