// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:genorion_mac_android/Models/allpinsscheduled.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../LocalDatabase/alldb.dart';
import '../main.dart';

class ScheduledPinPage extends StatefulWidget {
  const ScheduledPinPage({Key? key}) : super(key: key);

  @override
  _ScheduledPinPageState createState() => _ScheduledPinPageState();
}

class _ScheduledPinPageState extends State<ScheduledPinPage> {
  final storage = const FlutterSecureStorage();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  int? uid;
  List<AllPinScheduled> pinScheduled = [];
  List namesDataList = [];
  Future<List<AllPinScheduled>>? futurePinScheduled;
  final _on = "On";
  final off = "Off";
  ScrollController scrollController = ScrollController();
  var deviceIdScroll;
  
  @override
  void initState() {
    super.initState();
    getUidShared();
    getAllPinScheduled();
    scrollController.addListener(() async {
      if (kDebugMode) {
        print('scrolling ');
      }

      if (scrollController.position.isScrollingNotifier.value) {
        if (kDebugMode) {
          print("Stop !!!!");
        }
        getPinNameByLocal(deviceIdScroll);
        // getAllFuncForScroll();
      }

      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (kDebugMode) {
          print('scrollingeeeeeee');
        }
      }
    });
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
                    Text("Scheduled Pins",
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
        
          pinUi(),
        ],
      )),
    );
  }

  Widget pinUi() {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: Colors.transparent,
      child: FutureBuilder<List<AllPinScheduled>>(
        future: futurePinScheduled,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (pinScheduled.isEmpty) {
              return Column(
                children: const [
                  SizedBox(
                    height: 250,
                  ),
                  Center(
                      child: Text(
                    'Sorry we cannot find any Scheduled please add',
                  )),
                ],
              );
            }
            return Column(
              children: [
                const SizedBox(
                  height: 25,
                ),
                Expanded(
                    child: ListView.builder(
                        itemCount: pinScheduled.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              child: Card(
                                  color: Colors.grey.shade400,
                                  shadowColor: Colors.grey,
                                  child: Column(children: [
                                    ListTile(
                                      title: Text(
                                          pinScheduled[index].dId.toString()),
                                      trailing: Text(pinScheduled[index]
                                          .date
                                          .toString()
                                          .substring(0, 11)),
                                      leading: IconButton(
                                        icon: const Icon(
                                          Icons.delete_forever,
                                          color: Colors.black,
                                          semanticLabel: 'Delete',
                                        ),
                                        onPressed: () async {
                                          if (kDebugMode) {
                                            print(
                                              "delete   ${pinScheduled[index].id}");
                                          }

                                          await deleteDialog(pinScheduled[index]
                                              .id
                                              .toString());
                                          //  await deleteSchedulingUsingId(pinScheduled[index].id.toString());
                                        },
                                      ),
                                      subtitle: Text(pinScheduled[index]
                                          .timing
                                          .toString()
                                          .substring(0, 5)),
                                    ),
                                    Column(
                                      children: [
                                        Container(
                                          height: 54,
                                          // color: Colors.red,
                                          color: Colors.grey.shade400,
                                          child: ListView.builder(
                                              controller: scrollController,
                                              itemCount: 1,
                                              itemBuilder: (context, index) {
                                                deviceIdScroll =
                                                    pinScheduled[index].dId;

                                                return Container(
                                                    child: pinScheduled[index]
                                                                .pin1Status ==
                                                            1
                                                        ? Row(
                                                            children: [
                                                              Text(
                                                                namesDataList[
                                                                            index]
                                                                        [
                                                                        'pin1Name']
                                                                    .toString(),
                                                              ),
                                                              const SizedBox(
                                                                width: 14,
                                                              ),
                                                              Text(
                                                                _on,
                                                              ),
                                                            ],
                                                          )
                                                        : pinScheduled[index]
                                                                    .pin1Status ==
                                                                0
                                                            ? Row(
                                                                children: [
                                                                  Text(
                                                                    namesDataList[index]
                                                                            [
                                                                            'pin1Name']
                                                                        .toString(),
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 14,
                                                                  ),
                                                                  Text(
                                                                    off,
                                                                  ),
                                                                ],
                                                              )
                                                            : pinScheduled[index]
                                                                        .pin2Status ==
                                                                    1
                                                                ? Row(
                                                                    children: [
                                                                      SizedBox(
                                                                        width: MediaQuery.of(context).size.width /
                                                                            7.9,
                                                                      ),
                                                                      Text(
                                                                        namesDataList[index]['pin2Name']
                                                                            .toString(),
                                                                      ),
                                                                      const SizedBox(
                                                                        width:
                                                                            14,
                                                                      ),
                                                                      Text(
                                                                        _on,
                                                                      ),
                                                                    ],
                                                                  )
                                                                : pinScheduled[index]
                                                                            .pin2Status ==
                                                                        0
                                                                    ? Row(
                                                                        children: [
                                                                          SizedBox(
                                                                            width:
                                                                                MediaQuery.of(context).size.width / 7.9,
                                                                          ),
                                                                          Text(
                                                                            namesDataList[index]['pin2Name'].toString(),
                                                                          ),
                                                                          const SizedBox(
                                                                            width:
                                                                                14,
                                                                          ),
                                                                          Text(
                                                                            off,
                                                                          ),
                                                                        ],
                                                                      )
                                                                    : pinScheduled[index].pin3Status ==
                                                                            0
                                                                        ? Row(
                                                                            children: [
                                                                              SizedBox(
                                                                                width: MediaQuery.of(context).size.width / 7.9,
                                                                              ),
                                                                              Text(
                                                                                namesDataList[index]['pin3Name'].toString(),
                                                                              ),
                                                                              const SizedBox(
                                                                                width: 14,
                                                                              ),
                                                                              Text(
                                                                                off,
                                                                              ),
                                                                            ],
                                                                          )
                                                                        : pinScheduled[index].pin3Status ==
                                                                                1
                                                                            ? Row(
                                                                                children: [
                                                                                  SizedBox(
                                                                                    width: MediaQuery.of(context).size.width / 7.9,
                                                                                  ),
                                                                                  Text(
                                                                                    namesDataList[index]['pin3Name'].toString(),
                                                                                  ),
                                                                                  const SizedBox(
                                                                                    width: 14,
                                                                                  ),
                                                                                  Text(
                                                                                    off,
                                                                                  ),
                                                                                ],
                                                                              )
                                                                            : pinScheduled[index].pin4Status == 1
                                                                                ? Row(
                                                                                    children: [
                                                                                      SizedBox(
                                                                                        width: MediaQuery.of(context).size.width / 7.9,
                                                                                      ),
                                                                                      Text(
                                                                                        namesDataList[index]['pin4Name'].toString(),
                                                                                      ),
                                                                                      const SizedBox(
                                                                                        width: 14,
                                                                                      ),
                                                                                      Text(
                                                                                        _on,
                                                                                      ),
                                                                                    ],
                                                                                  )
                                                                                : pinScheduled[index].pin4Status == 0
                                                                                    ? Row(
                                                                                        children: [
                                                                                          SizedBox(
                                                                                            width: MediaQuery.of(context).size.width / 7.9,
                                                                                          ),
                                                                                          Text(
                                                                                            namesDataList[index]['pin4Name'].toString(),
                                                                                          ),
                                                                                          const SizedBox(
                                                                                            width: 14,
                                                                                          ),
                                                                                          Text(
                                                                                            off,
                                                                                          ),
                                                                                        ],
                                                                                      )
                                                                                    : pinScheduled[index].pin5Status == 1
                                                                                        ? Row(
                                                                                            children: [
                                                                                              SizedBox(
                                                                                                width: MediaQuery.of(context).size.width / 7.9,
                                                                                              ),
                                                                                              Text(
                                                                                                namesDataList[index]['pin5Name'].toString(),
                                                                                              ),
                                                                                              const SizedBox(
                                                                                                width: 14,
                                                                                              ),
                                                                                              Text(
                                                                                                _on,
                                                                                              ),
                                                                                            ],
                                                                                          )
                                                                                        : pinScheduled[index].pin5Status == 0
                                                                                            ? Row(
                                                                                                children: [
                                                                                                  SizedBox(
                                                                                                    width: MediaQuery.of(context).size.width / 7.9,
                                                                                                  ),
                                                                                                  Text(
                                                                                                    namesDataList[index]['pin5Name'].toString(),
                                                                                                  ),
                                                                                                  const SizedBox(
                                                                                                    width: 14,
                                                                                                  ),
                                                                                                  Text(
                                                                                                    off,
                                                                                                  ),
                                                                                                ],
                                                                                              )
                                                                                            : pinScheduled[index].pin6Status == 1
                                                                                                ? Row(
                                                                                                    children: [
                                                                                                      SizedBox(
                                                                                                        width: MediaQuery.of(context).size.width / 7.9,
                                                                                                      ),
                                                                                                      Text(
                                                                                                        namesDataList[index]['pin6Name'].toString(),
                                                                                                      ),
                                                                                                      const SizedBox(
                                                                                                        width: 14,
                                                                                                      ),
                                                                                                      Text(
                                                                                                        _on,
                                                                                                      ),
                                                                                                    ],
                                                                                                  )
                                                                                                : pinScheduled[index].pin6Status == 0
                                                                                                    ? Row(
                                                                                                        children: [
                                                                                                          SizedBox(
                                                                                                            width: MediaQuery.of(context).size.width / 7.9,
                                                                                                          ),
                                                                                                          Text(
                                                                                                            namesDataList[index]['pin6Name'].toString(),
                                                                                                          ),
                                                                                                          const SizedBox(
                                                                                                            width: 14,
                                                                                                          ),
                                                                                                          Text(
                                                                                                            off,
                                                                                                          ),
                                                                                                        ],
                                                                                                      )
                                                                                                    : pinScheduled[index].pin7Status == 1
                                                                                                        ? Row(
                                                                                                            children: [
                                                                                                              SizedBox(
                                                                                                                width: MediaQuery.of(context).size.width / 7.9,
                                                                                                              ),
                                                                                                              Text(
                                                                                                                namesDataList[index]['pin7Name'].toString(),
                                                                                                              ),
                                                                                                              const SizedBox(
                                                                                                                width: 14,
                                                                                                              ),
                                                                                                              Text(
                                                                                                                _on,
                                                                                                              ),
                                                                                                            ],
                                                                                                          )
                                                                                                        : pinScheduled[index].pin7Status == 0
                                                                                                            ? Row(
                                                                                                                children: [
                                                                                                                  SizedBox(
                                                                                                                    width: MediaQuery.of(context).size.width / 7.9,
                                                                                                                  ),
                                                                                                                  Text(
                                                                                                                    namesDataList[index]['pin7Name'].toString(),
                                                                                                                  ),
                                                                                                                  const SizedBox(
                                                                                                                    width: 14,
                                                                                                                  ),
                                                                                                                  Text(
                                                                                                                    off,
                                                                                                                  ),
                                                                                                                ],
                                                                                                              )
                                                                                                            : pinScheduled[index].pin8Status == 1
                                                                                                                ? Row(
                                                                                                                    children: [
                                                                                                                      SizedBox(
                                                                                                                        width: MediaQuery.of(context).size.width / 7.9,
                                                                                                                      ),
                                                                                                                      Text(
                                                                                                                        namesDataList[index]['pin8Name'].toString(),
                                                                                                                      ),
                                                                                                                      const SizedBox(
                                                                                                                        width: 14,
                                                                                                                      ),
                                                                                                                      Text(
                                                                                                                        _on,
                                                                                                                      ),
                                                                                                                    ],
                                                                                                                  )
                                                                                                                : pinScheduled[index].pin8Status == 1
                                                                                                                    ? Row(
                                                                                                                        children: [
                                                                                                                          SizedBox(
                                                                                                                            width: MediaQuery.of(context).size.width / 7.9,
                                                                                                                          ),
                                                                                                                          Text(
                                                                                                                            namesDataList[index]['pin8Name'].toString(),
                                                                                                                          ),
                                                                                                                          const SizedBox(
                                                                                                                            width: 14,
                                                                                                                          ),
                                                                                                                          Text(
                                                                                                                            _on,
                                                                                                                          ),
                                                                                                                        ],
                                                                                                                      )
                                                                                                                    : pinScheduled[index].pin8Status == 0
                                                                                                                        ? Row(
                                                                                                                            children: [
                                                                                                                              SizedBox(
                                                                                                                                width: MediaQuery.of(context).size.width / 7.9,
                                                                                                                              ),
                                                                                                                              Text(
                                                                                                                                namesDataList[index]['pin8Name'].toString(),
                                                                                                                              ),
                                                                                                                              const SizedBox(
                                                                                                                                width: 14,
                                                                                                                              ),
                                                                                                                              Text(
                                                                                                                                off,
                                                                                                                              ),
                                                                                                                            ],
                                                                                                                          )
                                                                                                                        : pinScheduled[index].pin9Status == 1
                                                                                                                            ? Row(
                                                                                                                                children: [
                                                                                                                                  SizedBox(
                                                                                                                                    width: MediaQuery.of(context).size.width / 7.9,
                                                                                                                                  ),
                                                                                                                                  Text(
                                                                                                                                    namesDataList[index]['pin9Name'].toString(),
                                                                                                                                  ),
                                                                                                                                  const SizedBox(
                                                                                                                                    width: 14,
                                                                                                                                  ),
                                                                                                                                  Text(
                                                                                                                                    _on,
                                                                                                                                  ),
                                                                                                                                ],
                                                                                                                              )
                                                                                                                            : pinScheduled[index].pin9Status == 0
                                                                                                                                ? Row(
                                                                                                                                    children: [
                                                                                                                                      SizedBox(
                                                                                                                                        width: MediaQuery.of(context).size.width / 7.9,
                                                                                                                                      ),
                                                                                                                                      Text(
                                                                                                                                        namesDataList[index]['pin9Name'].toString(),
                                                                                                                                      ),
                                                                                                                                      const SizedBox(
                                                                                                                                        width: 14,
                                                                                                                                      ),
                                                                                                                                      Text(
                                                                                                                                        off,
                                                                                                                                      ),
                                                                                                                                    ],
                                                                                                                                  )
                                                                                                                                : pinScheduled[index].pin10Status > 0
                                                                                                                                    ? Row(
                                                                                                                                        children: [
                                                                                                                                          SizedBox(
                                                                                                                                            width: MediaQuery.of(context).size.width / 7.9,
                                                                                                                                          ),
                                                                                                                                          Text(
                                                                                                                                            namesDataList[index]['pin10Name'].toString(),
                                                                                                                                          ),
                                                                                                                                          const SizedBox(
                                                                                                                                            width: 14,
                                                                                                                                          ),
                                                                                                                                          Text(
                                                                                                                                            pinScheduled[index].pin10Status.toString(),
                                                                                                                                          ),
                                                                                                                                        ],
                                                                                                                                      )
                                                                                                                                    : pinScheduled[index].pin11Status > 0
                                                                                                                                        ? Row(
                                                                                                                                            children: [
                                                                                                                                              SizedBox(
                                                                                                                                                width: MediaQuery.of(context).size.width / 7.9,
                                                                                                                                              ),
                                                                                                                                              Text(
                                                                                                                                                namesDataList[index]['pin11Name'].toString(),
                                                                                                                                              ),
                                                                                                                                              const SizedBox(
                                                                                                                                                width: 14,
                                                                                                                                              ),
                                                                                                                                              Text(pinScheduled[index].pin11Status.toString()),
                                                                                                                                            ],
                                                                                                                                          )
                                                                                                                                        : pinScheduled[index].pin12Status > 0
                                                                                                                                            ? Row(
                                                                                                                                                children: [
                                                                                                                                                  SizedBox(
                                                                                                                                                    width: MediaQuery.of(context).size.width / 7.9,
                                                                                                                                                  ),
                                                                                                                                                  Text(
                                                                                                                                                    namesDataList[index]['pin12Name'].toString(),
                                                                                                                                                  ),
                                                                                                                                                  const SizedBox(
                                                                                                                                                    width: 14,
                                                                                                                                                  ),
                                                                                                                                                  Text(pinScheduled[index].pin12Status.toString()),
                                                                                                                                                ],
                                                                                                                                              )
                                                                                                                                            : Container());
                                              }),
                                        )
                                      ],
                                    )
                                  ])),
                            ),
                          );
                        }))
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Future<String?> getToken() async {
    final tokenVar = await storage.read(key: "token");

    return tokenVar;
  }

  getUidShared() async {
    final SharedPreferences prefs = await _prefs;
    final a = prefs.getInt("uid");
    if (kDebugMode) {
      print("Get All Pins Scheduld $a");
    }
    setState(() {
      uid = a;
    });
  }

  Future getAllPinScheduled() async {
    String? token = await getToken();
    String url = api + "schedulingpinsalltheway/?user=" + uid.toString();
    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Token $token'
    });
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print("Get All Pins Scheduld ${response.body}");
      }
      List ans = jsonDecode(response.body);
     await AllDatabase.instance.deleteScheduledAll();
      for (int i = 0; i < ans.length; i++) {
        AllPinScheduled allPinScheduled = AllPinScheduled.fromJson(ans[i]);
        await AllDatabase.instance.insertAllDevicePinScheduled(allPinScheduled);
      }
      futurePinScheduled = getAllLocalScheduled();
    }else{
      futurePinScheduled = getAllLocalScheduled();

    }
  }

  Future<List<AllPinScheduled>> getAllLocalScheduled() async {
    List ans = await AllDatabase.instance.queryAllScheduledPin();
    if(ans.isNotEmpty){
    setState(() {
      pinScheduled = ans.map((ans) => AllPinScheduled.fromJson(ans)).toList();
      deviceIdScroll = pinScheduled[0].dId.toString();
    });
    await getPinNameByLocal(deviceIdScroll);
    }
    if(ans.isEmpty){
      pinScheduled = List.empty();
      return  pinScheduled;
    }


    if (kDebugMode) {
      print("PinSSSSSS $ans");
      print("PinSSSSSS $deviceIdScroll");
    }

    return pinScheduled;
  }

  Future<bool> getPinNameByLocal(dId) async {
    List pinName = await AllDatabase.instance.getPinNamesByDeviceId(dId);
    if (kDebugMode) {
      print("getPuinName $dId");
    }
    if (pinName.isNotEmpty) {
      if (kDebugMode) {
        print(
            "getPuinNamepppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp $pinName");
      }
      setState(() {
        namesDataList = [
          pinName[0],
          pinName[0],
          pinName[0],
          pinName[0],
          pinName[0],
          pinName[0],
          pinName[0],
          pinName[0],
          pinName[0],
          pinName[0],
          pinName[0],    
          pinName[0],
          pinName[0]
        ];
      });

      if (kDebugMode) {
        print("Name object $namesDataList");
      }
      return true;
    }
    return false;
  }

  Future deleteSchedulingUsingId(String id) async {
    String? token = await getToken();
    String url = api + 'schedulingpinsalltheway/?user=$uid&id=$id';
    final response = await http.delete(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Token $token',
    });

    if (response.statusCode == 200) {
      await AllDatabase.instance.pinScheduledDeleteById(id);
      List ans = await AllDatabase.instance.queryAllScheduledPin();
      if (kDebugMode) {
        print("ans $ans");
      }
      const snackBar = SnackBar(
        content: Text("Pin Scheduled Deleted"),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      await AllDatabase.instance.pinScheduledDeleteById(id);
      namesDataList = [];
      pinScheduled = [];
      futurePinScheduled = getAllLocalScheduled();
    }
  }

  deleteDialog(id) {
    return AwesomeDialog(
      context: context,
      dialogType: DialogType.QUESTION,
      animType: AnimType.BOTTOMSLIDE,
      title: 'Delete !! ',
      desc: 'Are you sure want to Delete  ??..',
      btnCancelOnPress: () {
        return null;
      },
      btnOkOnPress: () async {
        await deleteSchedulingUsingId(id);
      },
    )..show();
  }
}
