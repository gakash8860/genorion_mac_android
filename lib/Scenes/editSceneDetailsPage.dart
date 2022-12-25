import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Models/SceneDevice.dart';
import '../ProfilePage/utility.dart';
import '../main.dart';

class EditSceneDetailPage extends StatefulWidget {
  final sceneId;
  final List <String>namesDataList ;
  List<bool> colorFalse;
  var cutDate;
  EditSceneDetailPage({Key? key, required this.sceneId,required this.namesDataList,required this.colorFalse,required this.cutDate}) : super(key: key);

  @override
  State<EditSceneDetailPage> createState() => _EditSceneDetailPageState();
}

class _EditSceneDetailPageState extends State<EditSceneDetailPage> {
  List color = [] ;
  TextEditingController sceneNameController = TextEditingController();
  List<int> value= List.filled(20,0);
  List<SceneDevice> sceneDevice = [];
  Future<bool>? getSceneFuture ;
  DateTime pickedDate = DateTime.now();
  var cutDate;
  var cutTime;
  @override
  void initState() {
    super.initState();
    getSceneFuture = getScene();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff121421),
      appBar: AppBar(
        title: Text("Edit"),

      ),
      body: FutureBuilder(
        future: getSceneFuture,
        builder: (context,snapshot){
          if(snapshot.hasData){
            return SingleChildScrollView(
              child: Column(
                  children: [
                    SizedBox(height: 10,),
                    selectTime(),
                    Container(
                      width: 345,
                      color: Colors.white,
                      child: TextField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: sceneDevice[0].sceneName,
                        ),
                        controller:sceneNameController,
                        style: const TextStyle(fontSize: 18, color: Colors.black54),

                      ),
                    ),
                    ListView.builder(
                      scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: widget.namesDataList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            child: Row(
                              children: [
                                Container(
                                  color: Colors.green,
                                  width:110,
                                  height: 50,
                                  child: Center(child: Text(widget.namesDataList[index],style: TextStyle(color: Colors.black),)),
                                ),
                                SizedBox(width: 10,),
                                MaterialButton(color: color[index]==1?Colors.green:Colors.red ,onPressed: (){
                                  setState(() {
                                    color[index] = 1;
                                  });
                                  // if(color[index]){
                                  //   value[index] = 1;
                                  // }
                                  print( value[index]);
                                }, child: Text("On "),),
                                SizedBox(width: 10,),
                                MaterialButton(color: color[index] == 0?Colors.yellow:Colors.yellow ,onPressed: (){
                                  setState(() {
                                    color[index] = 0;
                                  });
                                  // if( widget.colorFalse[index] == false){
                                  //   value[index] =0;
                                  // }
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
                      await addSceneDetails(color);

                    }, child: Text("Done "),),]
              ),
            );
          }else{
            return Center(
              child: Utility.circularIndicator(),
            );
          }
        },
      ),
    );
  }



  Widget selectTime(){
    return  Container(
        width: MediaQuery.of(context).size.width,

        child: Column(children: [
          SizedBox(height: 45,),
          SizedBox(
            child: GestureDetector(
                child: Text(
                  sceneDevice[0].date.toString().substring(0,10),
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
              await pickTime();
              // setState(() {
              //   _alarmTimeString = cutTime;
              // });
            },
            child: Text(
              sceneDevice[0].timing.toString(),
              style: const TextStyle(
                  fontSize: 32,
                  color: Colors.white
              ),
            ),
          ),
        ]));
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
      sceneDevice[0].date = pickedDate;
    });
  }

  pickTime() async {
    TimeOfDay? timePicked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    // print(time23);
    TimeOfDay? time;
    String time12;
    if (timePicked != null) {
      setState(() {
        time = timePicked;
      });
      time12 = time.toString();
      setState(() {
        sceneDevice[0].timing = time12.substring(10, 15);
        time12 = time.toString();
        cutTime = time12.substring(10, 15);
      });
    }
  }

  Future<bool> getScene() async {
    String? token = await Utility.getToken();
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
        color = [
          sceneDevice[0].status1,
          sceneDevice[0].status2,
          sceneDevice[0].status3,
          sceneDevice[0].status4,
          sceneDevice[0].status5,
          sceneDevice[0].status6,
          sceneDevice[0].status7,
          sceneDevice[0].status8,
          sceneDevice[0].status9,
          sceneDevice[0].status10,
          sceneDevice[0].status11,
          sceneDevice[0].status12,
          sceneDevice[0].status13,
          sceneDevice[0].status14,
          sceneDevice[0].status15,
          sceneDevice[0].status16,
          sceneDevice[0].status17,
          sceneDevice[0].status18,
          sceneDevice[0].status19,
          sceneDevice[0].status20,
        ];
      });
      return true;
    } else {
      print(response.statusCode);
    }
    return false;
  }

  Future<void> addSceneDetails(value) async {
    String? token = await Utility.getToken();
    var url = api + 'scenedevice/';
    Map data = {
      "scene_id": widget.sceneId.toString(),
      "scenedevices_id":sceneDevice[0].scenedevicesId.toString(),
      "d_id": sceneDevice[0].dId.toString(),
      "sceneName":sceneNameController.text.isEmpty?sceneDevice[0].sceneName.toString():sceneNameController.text,
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
    await http.put(Uri.parse(url), body: jsonEncode(data), headers: {
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









}
