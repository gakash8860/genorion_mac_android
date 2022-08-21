// ignore_for_file: prefer_typing_uninitialized_variables, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:genorion_mac_android/HomeUi/homepage.dart';
import 'package:genorion_mac_android/Models/flatmodel.dart';
import 'package:genorion_mac_android/Models/floormodel.dart';
import 'package:genorion_mac_android/Models/roommodel.dart';
import 'package:http/http.dart' as http;
import '../LocalDatabase/alldb.dart';
import '../Models/placemodel.dart';
import '../main.dart';

// ignore: must_be_immutable
class ProcessingData extends StatefulWidget {
  String? placeName;
  String? floorName;
  String? flatName;
  String? roomName;
  ProcessingData(
      {Key? key,
      required this.placeName,
      required this.floorName,
      required this.flatName,
      required this.roomName})
      : super(key: key);

  @override
  _ProcessingDataState createState() => _ProcessingDataState();
}

class _ProcessingDataState extends State<ProcessingData> {

  var tabbarState;
  List placeData = [];

  var storage = const FlutterSecureStorage();
  int? getUidVariable2;
  PlaceType? pt;
  FloorType? fl;
  FlatType? flatType;
  List<RoomType>? rm;

  @override
  void initState() {
    super.initState();
    allAwaitFunc();
  }


  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xff121421),
      body: SafeArea(
          child: Center(
        child: CircularProgressIndicator(
          color: Colors.amber,
        ),
      )),
    );
  }

  Future<String?> getToken() async {
    final token = await storage.read(key: "token");
    return token;
  }

  Future<void> getUid() async {
    const url = api + 'getuid/';
    String? token = await getToken();
    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Token $token',
    });
    if (response.statusCode == 200) {
      var getUidVariable = response.body;
      getUidVariable2 = int.parse(getUidVariable);
      return;
    }else{
      throw new Exception('Something Went Wrong');
    }
  }

  Future<void> placeName() async {
    String? token = await getToken();
    const url = api + 'addyourplace/';
    var postData = {
      "user": getUidVariable2,
      "p_type": widget.placeName.toString()
    };
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(postData),
    );

    if (response.statusCode == 201) {
     var placeResponse = jsonDecode(response.body);
      await sendFloorName(placeResponse);
      if (kDebugMode) {
        print("Place Response $placeResponse");
      }
      setState(() {
        pt=PlaceType(pId: placeResponse.toString(), pType: widget.placeName.toString(), user: getUidVariable2!);
      });
      return ;
    } else {
      return ;
    }
  }

  Future<void> sendFloorName(String placeResponse) async {
    String? token = await getToken();
    const url = api + 'addyourfloor/';
    var postData = {
      "user": getUidVariable2,
      "p_id": placeResponse,
      "f_name": widget.floorName.toString()
    };
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(postData),
    );

    if (response.statusCode == 201) {
     var floorResponse = jsonDecode(response.body);
      setState(() {
        fl = FloorType(fId: floorResponse.toString(), fName: widget.floorName.toString(), user: getUidVariable2!, pId: placeResponse.toString());
      });
      if (kDebugMode) {
        print("floorResponse  $floorResponse");
      }
      await sendFlatName(floorResponse.toString());
      return ;
    } else {
      throw Exception('Failed to create Floor.');
    }
  }

  Future<void> sendFlatName(floorResponse) async {
    String? token = await getToken();
    const url = api + 'addyourflat/';
    var postData = {
      "user": getUidVariable2,
      "f_id": floorResponse,
      "flt_name": widget.flatName.toString()
    };
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(postData),
    );

    if (response.statusCode == 201) {
     var flatResponse = jsonDecode(response.body);
      if (kDebugMode) {
        print("Flat Response $flatResponse");
      }
      setState(() {
        flatType = FlatType(fltId: flatResponse.toString(), fltName: widget.flatName.toString(), user: getUidVariable2!, fId: floorResponse.toString());
      });


      await sendRoomName(flatResponse);
      return ;
    } else {
      throw Exception('Failed to create Floor.');
    }
  }

  Future<void> sendRoomName(flatResponse) async {
    String? token = await getToken();
    const url = api + 'addroom/';
    var postData = {
      "user": getUidVariable2,
      "r_name": widget.roomName.toString(),
      "flt_id": flatResponse,
    };
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(postData),
    );

    if (response.statusCode == 201) {
     var roomResponse = jsonDecode(response.body);
      setState(() {
        rm=List.generate(1, (index) => RoomType(rId: roomResponse.toString(), rName: widget.roomName.toString(), user: getUidVariable2!, fltId: flatResponse.toString()));
      });
      if (kDebugMode) {
        print("Room Response $roomResponse");
      }
      setState(() {
        tabbarState = roomResponse;
      });

      // isVisible=false;

      return ;
    } else {
      throw Exception('Failed to create Room.');
    }
  }

  Future checkUserPlace() async {
    var placeQuery;
    String? token = await getToken();
    const url = api + 'addyourplace/';

    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Token $token',
    });
    if (response.statusCode == 200) {
     List placeData = jsonDecode(response.body);
      if (kDebugMode) {
        print('userplace $placeData');
      }
      if (placeData.isEmpty) {
        return;
      } else {
        await AllDatabase.instance.deletePlaceModel();
        for (int i = 0; i < placeData.length; i++) {
          placeQuery = PlaceType(
              pId: placeData[i]['p_id'],
              pType: placeData[i]['p_type'],
              user: placeData[i]['user']);
          AllDatabase.instance.insertPlaceModelData(placeQuery);
        }

        await getAllFloor();
      }
    }
  }

  Future<void> getAllFloor() async {
    String? token = await getToken();
    var pId;
    List placeData = await AllDatabase.instance.queryPlace();
    List floor = await AllDatabase.instance.queryFloor();
    var floorLst = List.empty(growable: true);
    for (int i = 0; i < placeData.length; i++) {
      pId = placeData[i]['p_id'].toString();
      final url = api + "addyourfloor/?p_id=" + pId.toString();
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Token $token',
      });
      if (response.statusCode == 200) {
       List floorData = jsonDecode(response.body);
        for(int i=0;i<floorData.length;i++){
          floorLst.add(floorData[i]);
        }
        if (kDebugMode) {
          print('floorData12 $floorData    =>   floorlst $floorLst');
        }



      }
    }


    if(floorLst.length != floor.length){
      await AllDatabase.instance.deleteFloorModelAll();

      for (int i = 0; i < floorLst.length; i++) {
        var floorQuery = FloorType(
            fId: floorLst[i]['f_id'],
            fName: floorLst[i]['f_name'].toString(),
            pId: floorLst[i]['p_id'],
            user: floorLst[i]['user']);
        if (kDebugMode) {
          print('floorData12 $floorQuery');
        }
        await AllDatabase.instance.insertFloorModelData(floorQuery);
      }

      await getAllFlat();
    }else{

      await getAllFlat();
    }


  }

  Future<void> getAllFlat() async {
    var fId;
    String? token = await getToken();
    List floorData = await AllDatabase.instance.queryFloor();
    List flatLocal = await AllDatabase.instance.queryFlat();
    var flatList = List.empty(growable: true);
    for (int i = 0; i < floorData.length; i++) {
      fId = floorData[i]['f_id'].toString();
      String url = api + 'addyourflat/?f_id=' + fId.toString();
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Token $token',
      });

      if (response.statusCode == 200) {
       List flatData = jsonDecode(response.body);
         for(int i=0;i<flatData.length;i++){
           flatList.add(flatData[i]);
         }



      }
    }

    if(flatLocal.length != flatList.length){
      await AllDatabase.instance.deleteFlatModelAll();


      for (int i = 0; i < flatList.length; i++) {
        var flatQuery = FlatType(
            fId: flatList[i]['f_id'],
            fltId: flatList[i]['flt_id'],
            fltName: flatList[i]['flt_name'],
            user: flatList[i]['user']);
        await AllDatabase.instance.insertFlatModelData(flatQuery);
      }



      await getAllRoom();
    }else{

      await getAllRoom();
    }






  }

  Future<void> getAllRoom() async {
    var fltId;
    String? token = await getToken();
    List flatData = await AllDatabase.instance.queryFlat();
    List roomLocal = await AllDatabase.instance.queryRoom();
    var roomList = List.empty(growable: true);
    for (int i = 0; i < flatData.length; i++) {
      fltId = flatData[i]['flt_id'];
      String url = api + "addroom/?flt_id=" + fltId.toString();
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Token $token',
      });

      if (response.statusCode == 200) {
       List roomData = jsonDecode(response.body);
          for(int i=0 ;i<roomData.length;i++){
            roomList.add(roomData[i]);
          }



      } else {
        if (kDebugMode) {
          print(response.statusCode);
        }
        return;
      }
    }
      if(roomList.length != roomLocal.length){
        await AllDatabase.instance.deleteRoomModelAll();

        for (int i = 0; i < roomList.length; i++) {
          var roomQuery = RoomType(
              rId: roomList[i]['r_id'],
              rName: roomList[i]['r_name'].toString(),
              fltId: roomList[i]['flt_id'],
              user: roomList[i]['user']);
          await AllDatabase.instance.insertRoomModelData(roomQuery);
        }



      }else{

      }
  }

  Future allAwaitFunc() async {
    await getUid();
    await placeName();

    await checkUserPlace();
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => HomePage(
                  fl: fl,
                  flat: flatType,
                  pt: pt,
                  rm: rm,
                  roomResponse: tabbarState,
                  dv: [],
                )));
  }


}
