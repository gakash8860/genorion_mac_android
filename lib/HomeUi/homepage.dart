// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables, deprecated_member_use, duplicate_ignore, import_of_legacy_library_into_null_safe, unused_local_variable

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/foundation.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:genorion_mac_android/AddPlace/addplace.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:genorion_mac_android/BillPrediction/roomdevicebill.dart';
import 'package:genorion_mac_android/DrawerPages/contact.dart';
import 'package:genorion_mac_android/Models/flatmodel.dart';
import 'package:genorion_mac_android/Models/floormodel.dart';
import 'package:genorion_mac_android/Models/pinname.dart';
import 'package:genorion_mac_android/Models/pinstatus.dart';
import 'package:genorion_mac_android/Models/placemodel.dart';
import 'package:genorion_mac_android/Models/roommodel.dart';
import 'package:genorion_mac_android/DrawerPages/setting.dart';
import 'package:genorion_mac_android/SubAccessModels/subaccesflat.dart';
import 'package:genorion_mac_android/SubAccessModels/subaccessdevice.dart';
import 'package:genorion_mac_android/SubAccessModels/subaccessplace.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:toggle_switch/toggle_switch.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:assets_audio_player/assets_audio_player.dart';

import '../AddSubUser/showsub.dart';
import '../BillPrediction/devicebill.dart';
import '../BillPrediction/faltbill.dart';
import '../BillPrediction/floorbill.dart';
import '../BillPrediction/placebill.dart';

import '../DrawerPages/pinschedulepage.dart';
import '../EmergencyNumber/emergencynumber.dart';
import '../LocalDatabase/alldb.dart';
import '../Models/devicemodel.dart';

import '../Models/ip.dart';
import '../Models/pinschedule.dart';
import '../Models/sensor.dart';
import '../Models/subaccessmodel.dart';
import '../Models/userprofike.dart';
import '../ProfilePage/photo.dart';
import '../ProfilePage/profile.dart';
import '../ProfilePage/utility.dart';
import '../SSID/showssid.dart';
import '../StartingScreen/frontscreen.dart';
import '../Styles/flushdep.dart';
import '../SubAccess/listofsubaccess.dart';

import '../SubAccessModels/subaccessfloor.dart';
import '../SubAccessModels/subaccessroom.dart';
import '../TempAccess/tempaccesslist.dart';
import '../TempUser/showtemp.dart';
import '../main.dart';
import '../speech/speechtext.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/main';
  PlaceType? pt;
  FloorType? fl;
  FlatType? flat;
  List<RoomType>? rm;
  List<DeviceType> dv = [];
  dynamic roomResponse;

  HomePage(
      {Key? key,
      required this.fl,
      required this.flat,
      required this.pt,
      required this.rm,
      required this.dv,
      this.roomResponse})
      : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  TabController? tabC;
  Future? deviceSensorVal;
  final storage = const FlutterSecureStorage();
  TextEditingController roomEditing = TextEditingController();
  TextEditingController roomEditingWithFloor = TextEditingController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  int getUidVariable2 = 0;
  String tabbarState = " ";

  int _currentIndex = 0;
  bool isListening = false;
  TextEditingController addDeviceController = TextEditingController();
  bool placeBool = false;
  List<PlaceType> placeType = [];
  List<DevicePinStatus> devicePinStatus = [];
  List responseGetData = [];
  Future? switchFuture;
  Future? nameFuture;
  Future? pinScheduledFuture;
  List namesDataList = [];
  int sliderValue = 0;
  double valueSlider = 0.0;
  TextEditingController pinNameController = TextEditingController();
  String? _chosenValue;
  Map? postDataPinName;
  List listOfAllFloor = [];
  List listOfAllFlat = [];
  List listofAllRoomId = [];
  TextEditingController floorEditing = TextEditingController();
  TextEditingController flatEditing = TextEditingController();
  var rIdForName;
  var floorResponse;
  var deletedFlatId;
  var flatResponse;
  List placeData = [];
  List sensorData = [];
  List deviceData = [];
  bool changeFloorBool = false;
  bool changeFlatBool = false;
  bool submitClicked = false;
  TextEditingController floorNameEditing = TextEditingController();
  TextEditingController flatNameEditing = TextEditingController();
  ScrollController scrollController = ScrollController();
  TextEditingController roomNameEditing = TextEditingController();
  var allFloorList = List.empty(growable: true);
  var allFlatList = List.empty(growable: true);
  var allRoomList = List.empty(growable: true);
  var allDeviceList = List.empty(growable: true);
  var allDevicePinStatusList = List.empty(growable: true);
  var allDevicePinNameList = List.empty(growable: true);
  var allSensorListMainUser = List.empty(growable: true);
  var pinScheduledList = List.empty(growable: true);
  int deleteRoomIndex = 0;
  int startTime = 0;
  int endTime = 0;
  Timer? timer;
  TimeOfDay? time23;
  TimeOfDay? picked;
  Future<List<PlaceType>>? placeVal;
  Future<List<FloorType>>? floorVal;
  Future<List<FlatType>>? flatVal;
  TimeOfDay? time;
  var cutTime;
  int checkSwitch = 0;
  String? _alarmTimeString = "";
  DateTime pickedDate = DateTime.now();
  var cutDate;
  UserProfile? userProfile;
  List<ScheduledPin> schedulePin = [];
  List<DevicePinName> devicePin = [];
  PlaceType? pt;
  FloorType? fl;
  FlatType? flt;
  var allgetSubUsers = List.empty(growable: true);
  var allPlacegetSubUsers = List.empty(growable: true);
  var allFloorgetSubUsers = List.empty(growable: true);
  var allFlatgetSubUsers = List.empty(growable: true);
  var allRoomgetSubUsers = List.empty(growable: true);
  var allDevicegetSubUsers = List.empty(growable: true);
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController phoneController = TextEditingController();
  var deviceIdForScroll;
  List<RoomType> rm = [];
  List<DeviceType> dv = [];
  String name = "";
  // AudioPlayer audioPlayer = AudioPlayer();
  var email;
  List<bool> loading = List.filled(9, false);
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

  PhotoModel? photo;
  bool isAllFunctionRunningBackground = true;

  @override
  void dispose() {
  
    super.dispose();
    // timer!.cancel();
    scrollController.dispose();
    fetchPlace.call();
    refreshImages();

  }
 

  @override
  void initState() {
    super.initState();

    timer =  Timer.periodic(Duration(seconds: 3), (timer) {
      // You can also call here any function.
      setState(() {
       getAllPinStatusData(widget.dv[0].dId.toString());
      });
    });


    setState(() {
      _alarmTimeString = DateFormat('HH:mm').format(DateTime.now());

      tabbarState = widget.rm![0].rId;
    });

    tabC = TabController(length: widget.rm!.length, vsync: this);
    refreshImages();
    pickedDate = DateTime.now();
    cutDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
    userPersonalData();

    // fetchPlace();

    scrollController.addListener(() async {
      if (kDebugMode) {
        print('scrolling $deviceIdForScroll');
      }

      if (scrollController.position.isScrollingNotifier.value) {
        if (kDebugMode) {
          print("Stop !!!!");
        }

        getAllFuncForScroll();
      }

      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (kDebugMode) {
          print('scrollingeeeeeee');
        }
      }
    });

    getUidShared();
    placeVal = placeQueryFunc();
    if (widget.dv.isNotEmpty) {
      getPinStatusData(widget.dv[0].dId.toString());
      switchFuture = getPinStatusByDidLocal(widget.dv[0].dId);
      updatePinNamesGet(widget.dv[0].dId);
      nameFuture = getPinNameByLocal(widget.dv[0].dId, 0);

    }
  }

  void periodicFun() {
    if (isAllFunctionRunningBackground) {
      //write your periodic logic
      fetchPlace();
    }
  }

  userPersonalData() async {
    List ans = await AllDatabase.instance.queryPersonalData();
    userProfile = UserProfile.fromJson(ans[0]);
    email = userProfile!.email;
    setState(() {
      name = userProfile!.firstName;
    });
  }

  refreshImages() async {
    getImage();
    List data = await AllDatabase.instance.getPhoto();
    if (data.isEmpty) {
      print("Image Not Empty $data");
      return;
    }
    print("Image Not Empty $data");

    setState(() {
      photo = PhotoModel.fromMap(data[0]);
      setImage = Utility.imageFrom64BaseString(photo!.file);
    });
  }
  getImage() async {
    String? token = await getToken();

    final url = api + 'testimages123/?user=' + getUidVariable2.toString();
    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Token $token',
    });
    if (response.statusCode == 200) {
      setImage = null;
      var ans = jsonDecode(response.body);
      await AllDatabase.instance.deletePhoto();
      if(!mounted){
        return;
      }
      setState(() {
        photo = PhotoModel.fromMap(ans);


        setImage = Utility.imageFrom64BaseString(photo!.file);

        AllDatabase.instance.savePhoto(photo!);
        checkPutPostImage(true);
      });

      // refreshImages();
    } else {
      if (kDebugMode) {
        print("Image Get Response ${response.statusCode}");
      }
    }
  }

  checkPutPostImage(value) async {
    final pref = await SharedPreferences.getInstance();
    pref.setBool("checkimage", value);
  }

  // play() async {
  //   AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();
  //   assetsAudioPlayer.open(Audio("assets/sound/notfound.mp3"));
  // }

  getAllFuncForScroll() async {
    // await getPinStatusData(deviceIdForScroll);

    switchFuture = getPinStatusByDidLocal(deviceIdForScroll);
    await getAllLocalPinNameFunc();
    return;
  }

  getAllLocalPinNameFunc() async {
    // await updatePinNamesGet(deviceIdForScroll);
    nameFuture = getPinNameByLocal(deviceIdForScroll, 0);
    return;
  }

  Future<void> fetchPlace() async {
    startTime = DateTime.now().microsecondsSinceEpoch;

    String? token = await getToken();
    const url = api + 'addyourplace/';
    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Token $token',
    });
    if (response.statusCode == 200) {
      placeData = jsonDecode(response.body);

      List placeRows = await AllDatabase.instance.queryPlace();

      if (placeData.length == placeRows.length) {
        if (kDebugMode) {
          print("update place ${placeData.length == placeRows.length}");
        }
        await getAllFloor();
      } else {
        if (kDebugMode) {
          print("insert place ${placeData.length == placeRows.length}");
        }
        await AllDatabase.instance.deletePlaceModel();
        for (int i = 0; i < placeData.length; i++) {
          var placeQuery = PlaceType.fromJson(placeData[i]);
          await AllDatabase.instance.insertPlaceModelData(placeQuery);
        }
        await getAllFloor();
      }
    } else {}
  }

  Future<void> getAllFloor() async {
    List floor = await AllDatabase.instance.queryFloor();
    String? token = await getToken();
    for (int i = 0; i < placeData.length; i++) {
      var url = api + "addyourfloor/?p_id=" + placeData[i]['p_id'].toString();
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Token $token',
      });
      if (response.statusCode == 200) {
        List a = jsonDecode(response.body);
        for (int i = 0; i < a.length; i++) {
          allFloorList.add(a[i]);
        }
      }
    }
    if (kDebugMode) {
      print("object $allFloorList");
      print("object $floor");
    }

    if (allFloorList.length == floor.length) {
      if (kDebugMode) {
        print("update floor ${allFloorList.length == floor.length}");
      }
      // for (int i = 0; i < allFloorList.length; i++) {
      //   var floorQuery = FloorType.fromJson(allFloorList[i]);
      //   await AllDatabase.instance.updateFloorModelData(floorQuery);
      // }
      await getAllFlat();
    } else {
      if (kDebugMode) {
        print("insert floor ${allFloorList.length == floor.length}");
      }
      await AllDatabase.instance.deleteFloorModelAll();
      for (int i = 0; i < allFloorList.length; i++) {
        var floorQuery = FloorType.fromJson(allFloorList[i]);
        await AllDatabase.instance.insertFloorModelData(floorQuery);
      }

      await getAllFlat();
    }
  }

  Future<void> getAllFlat() async {
    String? token = await getToken();
    List flatQueryRows = await AllDatabase.instance.queryFlat();
    for (int i = 0; i < allFloorList.length; i++) {
      var fId = allFloorList[i]['f_id'].toString();
      String url = api + 'addyourflat/?f_id=' + fId;
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Token $token',
      });
      if (response.statusCode == 200) {
        List ans = jsonDecode(response.body);
        for (int i = 0; i < ans.length; i++) {
          allFlatList.add(ans[i]);
        }
      }
    }
    if (flatQueryRows.length == allFlatList.length) {
      if (kDebugMode) {
        print("update flat ${flatQueryRows.length == allFlatList.length}");
      }
      // for (int i = 0; i < allFlatList.length; i++) {
      //   var flatQuery = FlatType.fromJson(allFlatList[i]);
      //   await AllDatabase.instance.updateFlatModelData(flatQuery);
      // }
      await getAllRoom();
    } else {
      if (kDebugMode) {
        print("insert flat ${flatQueryRows.length == allFlatList.length}");
      }
      await AllDatabase.instance.deleteFlatModelAll();
      for (int i = 0; i < allFlatList.length; i++) {
        var flatQuery = FlatType.fromJson(allFlatList[i]);
        await AllDatabase.instance.insertFlatModelData(flatQuery);
      }
      await getAllRoom();
    }
  }

  Future<void> getAllRoom() async {
    String? token = await getToken();
    List roomQueryRows = await AllDatabase.instance.queryRoom();
    for (int i = 0; i < allFlatList.length; i++) {
      var flatId = allFlatList[i]['flt_id'].toString();
      String url = api + "addroom/?flt_id=" + flatId;
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Token $token',
      });
      if (response.statusCode == 200) {
        List a = jsonDecode(response.body);
        for (int i = 0; i < a.length; i++) {
          allRoomList.add(a[i]);
        }
      } else {
        if (kDebugMode) {
          print(response.body);
        }
      }
    }

    if (allRoomList.length == roomQueryRows.length) {
      await getAllDevice();
    } else {
      await AllDatabase.instance.deleteRoomModelAll();
      for (int i = 0; i < allRoomList.length; i++) {
        var roomQuery = RoomType.fromJson(allRoomList[i]);
        await AllDatabase.instance.insertRoomModelData(roomQuery);
      }
      await getAllDevice();
    }
  }

  Future<void> getAllDevice() async {
    String? token = await getToken();
    List deviceAll = await AllDatabase.instance.queryDevice();
    for (int i = 0; i < allRoomList.length; i++) {
      var roomId = allRoomList[i]['r_id'];
      String url = api + "addyourdevice/?r_id=" + roomId;
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Token $token',
      });
      if (response.statusCode == 200) {
        List ans = jsonDecode(response.body);

        for (int i = 0; i < ans.length; i++) {
          allDeviceList.add(ans[i]);
        }
      } else {
        if (kDebugMode) {
          print(response.body);
        }
      }
    }

    if (allDeviceList.length == deviceAll.length) {
      await getAllPinStatus();
    } else {
      await AllDatabase.instance.deleteDeviceModelAll();
      for (int i = 0; i < allDeviceList.length; i++) {
        var deviceQuery = DeviceType.fromJson(allDeviceList[i]);

        await AllDatabase.instance.insertDeviceModelData(deviceQuery);
      }
      await getAllPinStatus();
    }
  }

  Future getAllPinStatus() async {
    String? token = await getToken();
    List deviceAllPinStatus = await AllDatabase.instance.queryDevicePinStatus();

    for (int i = 0; i < allDeviceList.length; i++) {
      var dId = allDeviceList[i]['d_id'];

      String url = api + "getpostdevicePinStatus/?d_id=" + dId.toString();
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Token $token',
      });
      if (response.statusCode == 200) {
        var a = jsonDecode(response.body);
        allDevicePinStatusList.add(a);
      } else {
        if (kDebugMode) {
          FlushUtil.showSnackBar(context, text: jsonDecode(response.body));
          print(response.statusCode);
        }
      }
    }
    if (allDevicePinStatusList.length == deviceAllPinStatus.length) {
      for (int i = 0; i < allDevicePinStatusList.length; i++) {
        var pinQuery = DevicePinStatus.fromJson(allDevicePinStatusList[i]);
        await AllDatabase.instance.updatePinStatusData(pinQuery);
      }
      await getAllPinName();
    } else {
      await AllDatabase.instance.deleteDevicePinStatusAllModel();
      for (int i = 0; i < allDevicePinStatusList.length; i++) {
        var pinQuery = DevicePinStatus.fromJson(allDevicePinStatusList[i]);
        await AllDatabase.instance.insertPinStatusData(pinQuery);
      }
      await getAllPinName();
    }
  }

  Future getAllPinName() async {
    String? token = await getToken();
    List allPinName = await AllDatabase.instance.queryDevicePinName();
    for (int i = 0; i < allDeviceList.length; i++) {
      var did = allDeviceList[i]['d_id'];
      String url = api + "editpinnames/?d_id=" + did;
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Token $token',
      });
      if (response.statusCode == 200) {
        var ans = jsonDecode(response.body);
        allDevicePinNameList.add(ans);
      } else {
        if (kDebugMode) {
          print(response.body);
        }
      }
    }
    if (allDevicePinNameList.length == allPinName.length) {
      for (int i = 0; i < allDevicePinNameList.length; i++) {
        var devicePinNamesQuery =
            DevicePinName.fromJson(allDevicePinNameList[i]);
        await AllDatabase.instance.updateDevicePinNames(devicePinNamesQuery);
      }
      await getAllSensorData();
    } else {
      await AllDatabase.instance.deleteDevicePinNameModelAll();
      for (int i = 0; i < allDevicePinNameList.length; i++) {
        var devicePinNamesQuery =
            DevicePinName.fromJson(allDevicePinNameList[i]);
        await AllDatabase.instance.insertDevicePinNames(devicePinNamesQuery);
      }
      await getAllSensorData();
    }
  }

  Future getAllSensorData() async {
    String? token = await getToken();
    // List allSensor = await AllDatabase.instance.querySensor();
    List allSensor =[];
    for (int i = 0; i < allDeviceList.length; i++) {
      var did = allDeviceList[i]['d_id'];
      String url = api + "tensensorsdata/?d_id=" + did;
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Token $token',
      });
      if (response.statusCode == 200) {
        var ans = jsonDecode(response.body);
        allSensorListMainUser.add(ans);
      } else {
        if (kDebugMode) {
          print(response.statusCode);
        }
      }
    }
    if (allSensorListMainUser.length == allSensor.length) {
      endTime = DateTime.now().microsecondsSinceEpoch;
      int ans = endTime - startTime;
      if (kDebugMode) {
        print("update  $ans");
      }
      for (int i = 0; i < allSensorListMainUser.length; i++) {
        var sensor = SensorData.fromJson(allSensorListMainUser[i]);
        // await AllDatabase.instance.updateSensorData(sensor);
      }

      await getAllPinScheduled();
    } else {
      // await AllDatabase.instance.deleteSensor();
      for (int i = 0; i < allSensorListMainUser.length; i++) {
        var sensorQuery = SensorData.fromJson(allSensorListMainUser[i]);
        // await AllDatabase.instance.insertSensorData(sensorQuery);
      }
      await getAllPinScheduled();
      endTime = DateTime.now().microsecondsSinceEpoch;
      int ans = endTime - startTime;
      if (kDebugMode) {
        print(ans);
      }
    }
  }

  Future<void> getAllPinScheduled() async {
    List allScheduled = await AllDatabase.instance.queryScheduledPin();
    String? token = await getToken();
    for (int i = 0; i < allDeviceList.length; i++) {
      var did = allDeviceList[i]['d_id'];
      var url = api + "scheduledatagetbyid/?d_id=" + did;
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Token $token',
      });
      if (response.statusCode == 200) {
        List<dynamic> ans = jsonDecode(response.body);
        if (kDebugMode) {
          print("All Pin Scheduled $ans");
        }
        for (int i = 0; i < ans.length; i++) {
          pinScheduledList.add(ans[i]);
        }
      }
    }
    if (pinScheduledList.length == allScheduled.length) {
      allFloorList = List.empty(growable: true);
      allFlatList = List.empty(growable: true);
      allRoomList = List.empty(growable: true);
      allDeviceList = List.empty(growable: true);
      allDevicePinNameList = List.empty(growable: true);
      allDevicePinStatusList = List.empty(growable: true);
      pinScheduledList = List.empty(growable: true);
      placeData = [];

      await getSubUsers(email);
    } else {
      await AllDatabase.instance.deleteScheduledAll();
      for (int i = 0; i < pinScheduledList.length; i++) {
        var schedule = ScheduledPin.fromJson(pinScheduledList[i]);
        await AllDatabase.instance.insertDevicePinSchedule(schedule);
      }
      allFloorList = List.empty(growable: true);
      allFlatList = List.empty(growable: true);
      allRoomList = List.empty(growable: true);
      allDeviceList = List.empty(growable: true);
      allDevicePinNameList = List.empty(growable: true);
      allDevicePinStatusList = List.empty(growable: true);
      allDevicePinStatusList = List.empty(growable: true);
      placeData = [];
      await getSubUsers(email);
    }
  }

  bool remoteBool = false;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return _exitScreen();
      },
      child: Scaffold(
          key: scaffoldKey,
          backgroundColor: const Color(0xff121421),
          drawer: Drawer(
            child: Container(
              height: MediaQuery.of(context).size.height,
              color: const Color(0xff121421),
              child: ListView(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0xff669df4), Color(0xff4e80f3)]),
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(30),
                          bottomLeft: Radius.circular(30),
                        )),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(top: 10, bottom: 10),
                          ),
                          CircularProfileAvatar(
                            '',
                            child: setImage ??
                                Image.asset('assets/images/blank.png'),
                            radius: 60,
                            elevation: 5,
                            onTap: () {
                              // timer!.cancel();

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ProfilePage()));
                            },
                            cacheImage: true,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            'Hello $name',
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                
                  ListTile(
                    leading: const Icon(
                      Icons.home_work_rounded,
                      color: Colors.white,
                    ),
                    title: const Text(
                      'Add Place',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      // timer!.cancel();

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddPlace()));
                    },
                  ),
              
                  ListTile(
                    leading: const Icon(
                      Icons.supervised_user_circle,
                      color: Colors.white,
                    ),
                    title: const Text(
                      'Sub Access',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () async {
                      // timer!.cancel();

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ListOfSUbAccess()));
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.supervised_user_circle,
                        color: Colors.white),
                    title: const Text(
                      'Temp Access',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onTap: () async {
                      var result = await Connectivity().checkConnectivity();
                      if (result == ConnectivityResult.none) {
                        noInternet();
                      } else {
                        final number = await _getTempNumber();
                        if (number == null) {
                          _showDialogForTempAccessPge();
                        } else {
                          // timer!.cancel();

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ListOfTempAccessPage(
                                      mobileNumber: number,
                                    )),
                          );
                        }
                      }
                    },
                  ),
                  ListTile(
                      leading:
                          const Icon(Icons.perm_identity, color: Colors.white),
                      title: const Text(
                        'Add Members',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {
                        _createAlertDialogForAddMembers(context);
                      }),
                  ListTile(
                      leading:
                          const Icon(Icons.power_rounded, color: Colors.white),
                      title: const Text('Bill Prediction',
                          style: TextStyle(
                            color: Colors.white,
                          )),
                      onTap: () {
                        _billPredictionNavigation(context);
                      }),
                  ListTile(
                      leading: const Icon(Icons.schedule, color: Colors.white),
                      title: const Text('Scheduled device /pins ',
                          style: TextStyle(
                            color: Colors.white,
                          )),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ScheduledPinPage()));
                      }),
                  ListTile(
                    leading: const Icon(Icons.settings, color: Colors.white),
                    title: const Text(
                      'Setting',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onTap: () {
                      // timer!.cancel();

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SettingPage()));
                    },
                  ),

                  ListTile(
                    leading: const Icon(Icons.info, color: Colors.white),
                    title: const Text(
                      'About GenOrion',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      Utility.launchURL('https://genorion.com');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.quick_contacts_dialer_sharp,
                        color: Colors.white),
                    title: const Text(
                      'Contact ',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onTap: () {
                      // timer!.cancel();

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ContactPage()));
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.white),
                    title: const Text(
                      'Logout',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onTap: () {
                      _logout();
                    },
                  ),
                ],
              ),
            ),
          ),
          body: SafeArea(
              child: remoteBool
                  ? remoteUi()
                  : ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 28,
                            right: 18,
                            top: 6,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                child: const Icon(
                                  Icons.menu_rounded,
                                  color: Colors.white,
                                ),
                                onTap: () =>
                                    scaffoldKey.currentState!.openDrawer(),
                              ),
                              Row(
                                children: [
                                  InkWell(
                                    child: Text(widget.pt!.pType.toString(),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold)),
                                    onTap: () {
                                      setState(() {
                                        placeBool = !placeBool;
                                      });
                                    },
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
                        placeBool
                            ? changePlace()
                            : changeFloorBool
                                ? changeFloor()
                        :changeFlatBool? changeFlat()
                                : SizedBox(
                                    height: MediaQuery.of(context).size.height /
                                        0.5,
                                    child: DefaultTabController(
                                      length: widget.rm!.length,
                                      child: CustomScrollView(
                                        controller: scrollController,
                                        slivers: [
                                          SliverToBoxAdapter(
                                            child: Column(
                                              children: <Widget>[
                                                Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.39,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  decoration:
                                                      const BoxDecoration(
                                                    gradient: LinearGradient(
                                                        begin:
                                                            Alignment.topCenter,
                                                        end: Alignment
                                                            .bottomCenter,
                                                        colors: [
                                                          Color(0xff669df4),
                                                          Color(0xff4e80f3)
                                                        ]),
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(30),
                                                      topRight:
                                                          Radius.circular(30),
                                                      bottomLeft:
                                                          Radius.circular(30),
                                                      bottomRight:
                                                          Radius.circular(30),
                                                    ),
                                                  ),
                                                  padding:
                                                      const EdgeInsets.only(
                                                    top: 40,
                                                    bottom: 10,
                                                    left: 28,
                                                    right: 30,
                                                  ),
                                                  // alignment: Alignment.topLeft,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
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
                                                                    child: Row(
                                                                      children: [
                                                                        const Text(
                                                                          'Floor  ',
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize:
                                                                                22,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            // fontStyle: FontStyle
                                                                            //     .italic
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          widget
                                                                              .fl!
                                                                              .fName,
                                                                          style: const TextStyle(
                                                                              color: Colors.white,
                                                                              fontSize: 22,
                                                                              fontStyle: FontStyle.italic),
                                                                        ),
                                                                        const Icon(
                                                                            Icons.arrow_drop_down),
                                                                        const SizedBox(
                                                                          width:
                                                                              10,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    onTap: () {
                                                                      setState(
                                                                          () {
                                                                        changeFloorBool =
                                                                            !changeFloorBool;
                                                                        floorVal = null;
                                                                        floorVal = floorQueryFunc(widget
                                                                            .pt!
                                                                            .pId);
                                                                      });
                                                                    },
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  GestureDetector(
                                                                    child:
                                                                        const Icon(
                                                                      Icons
                                                                          .settings,
                                                                      size: 18,
                                                                    ),
                                                                    onTap:
                                                                        () async {
                                                                      listOfAllFloor = await AllDatabase
                                                                          .instance
                                                                          .getFloorById(widget
                                                                              .pt!
                                                                              .pId);
                                                                      _createAlertDialogForDeleteFloorAndAddFloor(
                                                                          context);
                                                                    },
                                                                  )
                                                                ],
                                                              ),
                                                              const SizedBox(
                                                                height: 12,
                                                              ),
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: <
                                                                    Widget>[
                                                                  Row(
                                                                    children: <
                                                                        Widget>[
                                                                      GestureDetector(
                                                                        onLongPress:
                                                                            () {},
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            const Text(
                                                                              'Flat  ',
                                                                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
                                                                            ),
                                                                            Text(
                                                                              widget.flat!.fltName,
                                                                              style: const TextStyle(
                                                                                  color: Colors.white,
                                                                                  // fontWeight: FontWeight.bold,
                                                                                  fontStyle: FontStyle.italic,
                                                                                  fontSize: 22),
                                                                            ),
                                                                            const Icon(Icons.arrow_drop_down),
                                                                            const SizedBox(
                                                                              width: 10,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        onTap:
                                                                            () {
                                                                          setState(
                                                                              () {
                                                                            flatVal =
                                                                                flatQueryFunc(widget.fl!.fId);
                                                                          });
                                                                          _creatDialogChangeFlat();
                                                                        },
                                                                      ),
                                                                      const SizedBox(
                                                                          width:
                                                                              28),
                                                                      GestureDetector(
                                                                        onTap:
                                                                            () async {
                                                                          listOfAllFlat = await AllDatabase
                                                                              .instance
                                                                              .getFlatByFId(widget.fl!.fId);
                                                                          _createAlertDialogForDeleteFlatAndAddFlat(
                                                                              context);
                                                                        },
                                                                        child:
                                                                            const Icon(
                                                                          Icons
                                                                              .settings,
                                                                          size:
                                                                              18,
                                                                        ),
                                                                      ),
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
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        child: Row(
                                                          // mainAxisAlignment: MainAxisAlignment.start,
                                                          children: <Widget>[
                                                            FutureBuilder(
                                                              future:
                                                              switchFuture,
                                                              builder: (context,
                                                                  snapshot) {
                                                                if (snapshot
                                                                    .hasData) {
                                                                  return Column(
                                                                    children: <
                                                                        Widget>[
                                                                      Row(
                                                                        children: <
                                                                            Widget>[
                                                                          const SizedBox(
                                                                            width:
                                                                                8,
                                                                          ),
                                                                          Column(
                                                                              children: <
                                                                              Widget>[
                                                                            const Icon(
                                                                              FontAwesomeIcons.fire,
                                                                              color: Colors.yellow,
                                                                            ),
                                                                            const SizedBox(
                                                                              height: 25,
                                                                            ),
                                                                            Row(
                                                                              children: <Widget>[
                                                                                Text(sensorData[0].toString(), style: const TextStyle(fontSize: 14, color: Colors.white70)),
                                                                              ],
                                                                            ),
                                                                          ]),
                                                                          const SizedBox(
                                                                            width:
                                                                                35,
                                                                          ),
                                                                          Column(children: <
                                                                              Widget>[
                                                                            const Icon(
                                                                              FontAwesomeIcons.temperatureLow,
                                                                              color: Colors.orange,
                                                                            ),
                                                                            const SizedBox(
                                                                              height: 30,
                                                                            ),
                                                                            Row(
                                                                              children: <Widget>[
                                                                                Text(sensorData[1].toString(), style: const TextStyle(fontSize: 14, color: Colors.white70)),
                                                                              ],
                                                                            ),
                                                                          ]),
                                                                          const SizedBox(
                                                                            width:
                                                                                45,
                                                                          ),
                                                                          Column(children: <
                                                                              Widget>[
                                                                            const Icon(
                                                                              FontAwesomeIcons.wind,
                                                                              color: Colors.white,
                                                                            ),
                                                                            const SizedBox(
                                                                              height: 30,
                                                                            ),
                                                                            Row(
                                                                              children: <Widget>[
                                                                                Text(sensorData[2].toString(), style: const TextStyle(fontSize: 14, color: Colors.white70)),
                                                                              ],
                                                                            ),
                                                                          ]),
                                                                          const SizedBox(
                                                                            width:
                                                                                42,
                                                                          ),
                                                                          Column(children: <
                                                                              Widget>[
                                                                            const Icon(
                                                                              FontAwesomeIcons.cloud,
                                                                              color: Colors.orange,
                                                                            ),
                                                                            const SizedBox(
                                                                              height: 30,
                                                                            ),
                                                                            Row(
                                                                              children: <Widget>[
                                                                                Text(
                                                                                  sensorData[3].toString(),
                                                                                  style: const TextStyle(color: Colors.white70),
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ]),
                                                                          const SizedBox(
                                                                            width:
                                                                            42,
                                                                          ),
                                                                          Column(children: <
                                                                              Widget>[
                                                                            const Icon(
                                                                              FontAwesomeIcons.cloud,
                                                                              color: Colors.orange,
                                                                            ),
                                                                            const SizedBox(
                                                                              height: 30,
                                                                            ),
                                                                            Row(
                                                                              children: <Widget>[
                                                                                Text(
                                                                                  sensorData[4].toString(),
                                                                                  style: const TextStyle(color: Colors.white70),
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ]),
                                                                          const SizedBox(
                                                                            width:
                                                                            42,
                                                                          ),
                                                                          Column(children: <
                                                                              Widget>[
                                                                            const Icon(
                                                                              FontAwesomeIcons.warehouse,
                                                                              color: Colors.brown,
                                                                            ),
                                                                            const SizedBox(
                                                                              height: 30,
                                                                            ),
                                                                            Row(
                                                                              children: <Widget>[
                                                                                Text(
                                                                                  sensorData[5].toString(),
                                                                                  style: const TextStyle(color: Colors.white70),
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ]),
                                                                          const SizedBox(
                                                                            width:
                                                                            42,
                                                                          ),
                                                                          Column(children: <
                                                                              Widget>[
                                                                            const Icon(
                                                                              FontAwesomeIcons.warehouse,
                                                                              color: Colors.brown,
                                                                            ),
                                                                            const SizedBox(
                                                                              height: 30,
                                                                            ),
                                                                            Row(
                                                                              children: <Widget>[
                                                                                Text(
                                                                                  sensorData[6].toString(),
                                                                                  style: const TextStyle(color: Colors.white70),
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ]),
                                                                          const SizedBox(
                                                                            width:
                                                                            42,
                                                                          ),
                                                                          Column(children: <
                                                                              Widget>[
                                                                            const Icon(
                                                                              FontAwesomeIcons.warehouse,
                                                                              color: Colors.brown,
                                                                            ),
                                                                            const SizedBox(
                                                                              height: 30,
                                                                            ),
                                                                            Row(
                                                                              children: <Widget>[
                                                                                Text(
                                                                                  sensorData[7].toString(),
                                                                                  style: const TextStyle(color: Colors.white70),
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ]),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            12,
                                                                      ),
                                                                      Text(
                                                                        sensorData[10]
                                                                            .toString(),
                                                                        style: const TextStyle(
                                                                            color:
                                                                                Colors.white70),
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
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    child: Row(
                                                      children: [
                                                        Column(
                                                          children: <Widget>[
                                                            Column(
                                                              children: [
                                                                InkWell(
                                                                    onTap:
                                                                        () async {
                                                                      _createAlertDialogForAddRoom();
                                                                    },
                                                                    child: Row(
                                                                      children: const [
                                                                        Icon(
                                                                          Icons
                                                                              .add,
                                                                          color:
                                                                              Colors.black,
                                                                        ),
                                                                      ],
                                                                    )),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        GestureDetector(
                                                          onLongPress: () {
                                                            _createAlertDialogForAddRoomDeleteDevices(
                                                                context,
                                                                tabbarState,
                                                                deleteRoomIndex);
                                                          },
                                                          child: TabBar(
                                                            indicatorColor:
                                                                Colors
                                                                    .blueAccent,
                                                            controller: tabC,
                                                            labelColor: Colors
                                                                .blueAccent,
                                                            indicatorWeight:
                                                                2.0,
                                                            isScrollable: true,
                                                            tabs: widget.rm!
                                                                .map<Widget>(
                                                                    (RoomType
                                                                        rm) {
                                                              return Tab(
                                                                text: rm.rName,
                                                              );
                                                            }).toList(),
                                                            onTap:
                                                                (index) async {
                                                              setState(() {
                                                                tabbarState =
                                                                    widget
                                                                        .rm![
                                                                            index]
                                                                        .rId;
                                                              });
                                                              if (widget
                                                                      .roomResponse !=
                                                                  null) {
                                                                setState(() {
                                                                  tabbarState =
                                                                      widget
                                                                          .rm![
                                                                              index]
                                                                          .rId;
                                                                });
                                                              }
                                                              setState(() {
                                                                tabbarState =
                                                                    widget
                                                                        .rm![
                                                                            index]
                                                                        .rId;
                                                                deleteRoomIndex =
                                                                    index;
                                                              });
                                                              List deviceList =
                                                                  await AllDatabase
                                                                      .instance
                                                                      .getDeviceById(widget
                                                                          .rm![
                                                                              index]
                                                                          .rId);
                                                              int deviceIndex =
                                                                  0;
                                                              setState(() {
                                                                widget.dv = List.generate(
                                                                    deviceList
                                                                        .length,
                                                                    (index) => DeviceType(
                                                                        id: deviceList[index]
                                                                            [
                                                                            'id'],
                                                                        dateInstalled:
                                                                            DateTime.parse(deviceList[index][
                                                                                'date_installed']),
                                                                        user: deviceList[index]
                                                                            [
                                                                            'user'],
                                                                        rId: deviceList[index]['r_id']
                                                                            .toString(),
                                                                        dId: deviceList[index]
                                                                            ['d_id']));
                                                              });
                                                              if (widget.dv
                                                                  .isNotEmpty) {
                                                                switchFuture =
                                                                    getPinStatusByDidLocal(
                                                                        widget
                                                                            .dv[0]
                                                                            .dId.toString(),
                                                                        );

                                                                nameFuture =
                                                                    getPinNameByLocal(
                                                                        widget
                                                                            .dv[0]
                                                                            .dId,
                                                                        index);
                                                              } else {
                                                                return;
                                                              }
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),

                                          SliverList(
                                            delegate:
                                                SliverChildBuilderDelegate(
                                                    (context, index) {
                                              if (index < widget.dv.length) {
                                                if (widget.dv.isEmpty) {
                                                  return Container();
                                                }
    // return Container();
                                                return deviceContainer(
                                                    widget.dv[index].dId,
                                                    index);
                                              } else {
                                                return null;
                                              }
                                            }),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                      ],
                    )),
       
          bottomNavigationBar: BottomNavyBar(
            backgroundColor: Colors.white38,
            selectedIndex: _currentIndex,
            animationDuration: const Duration(milliseconds: 500),
            curve: Curves.easeInOutCirc,
            items: [
              BottomNavyBarItem(
                  icon: Icon(
                    isListening ? Icons.mic : Icons.mic_none,
                  ),
                  // activeColor: Colors.blue,
                  title: Text(isListening ? "Listening.." : " ")),
              BottomNavyBarItem(
                title: const Text(''),
                icon: const Icon(Icons.add),
                // activeColor: Colors.blue,
              ),
              BottomNavyBarItem(
                title: const Text(''),
                icon: const Icon(Icons.settings),
                // activeColor: Colors.blue,
              ),
            ],
            onItemSelected: (int value) {
              setState(() {
                _currentIndex = value;
              });

              if (_currentIndex == 0) {
                toggleRecording();
                if (kDebugMode) {
                  print("TabbarState -- > $isListening");
                }
              }

              if (_currentIndex == 1) {
                _createAlertDialogForAddDevice(context);
                if (kDebugMode) {
                  print("TabbarState -- > $tabbarState");
                }
              }
              if(_currentIndex == 2){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const SettingPage()));
              }
            },
          )),
  
    );
  }

  Future<String?> getToken() async {
    final tokenVar = await storage.read(key: "token");

    return tokenVar;
  }

  getUidShared() async {
    final SharedPreferences prefs = await _prefs;
    final a = prefs.getInt("uid");
    setState(() {
      getUidVariable2 = a!;
    });
  }

  Future<void> getrooms(String fltid) async {
    final url = api + 'addroom/?flt_id=' + fltid;
    String? token = await getToken();
    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Token $token',
    });
    if (response.statusCode == 200) {
      List<dynamic> roomData = jsonDecode(response.body);
      for (int i = 0; i < roomData.length; i++) {
        var roomQuery = RoomType(
            rId: roomData[i]['r_id'],
            rName: roomData[i]['r_name'].toString(),
            fltId: roomData[i]['flt_id'],
            user: roomData[i]['user']);
        await AllDatabase.instance.insertRoomModelData(roomQuery);
      }
    } else {
      return;
    }
  }

  String text = "";
  String ob = "";
  int indexForSpeech = 0;

  Future toggleRecording() async {
    SpeechApi.toggleRecording(
      onResult: (text) => setState(() => this.text = text),
      onListening: (isListening) async {
        setState(() => this.isListening = isListening);
        if (text.contains("All") || text.contains("all")) {
          responseGetData.replaceRange(
              0, responseGetData.length, [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]);

          await dataUpdate(deviceIdForScroll);
        }
        for (int i = 0; i < namesDataList.length; i++) {
          if (text.contains(namesDataList[i])) {
            ob = namesDataList[i];
            indexForSpeech = i;

            if (text.contains("on")) {
              if (responseGetData[indexForSpeech] == 0) {
                setState(() {
                  responseGetData[indexForSpeech] = 1;
                });
                await dataUpdate(deviceIdForScroll);

                break;
                // getStatus();
              }
            }
            if (text.contains("off")) {
              if (responseGetData[indexForSpeech] == 1) {
                setState(() {
                  responseGetData[indexForSpeech] = 0;
                });
                await dataUpdate(deviceIdForScroll);

                break;
                // getStatus();
              }
            }
          } else {
            if (kDebugMode) {
              print("Not Present -> $text");
            }
          }
        }

        // for(int i=0;i<nameDataList.length;i++){
        //   if(ob == nameDataList[i]){
        //       index = i;
        //       print("POPO $ob");
        //       if(text.contains("on")){
        //         if(responseGetData[index] == 0){
        //           print("00po $index");
        //           setState(() {
        //             responseGetData[index] = 1;
        //           });
        //           await dataUpdateForPin19();
        //           await getStatus();
        //         }
        //       }
        //       if(text.contains("off")){
        //         if(responseGetData[index] == 1){
        //           print("00po $index");
        //           setState(() {
        //             responseGetData[index] = 0;
        //           });
        //           await dataUpdateForPin19();
        //           await getStatus();
        //         }
        //       }
        //
        //       break;
        //   }
        //
        // }
      },
    );
    // check();
  }

  Future roomQueryFunc(flatId) async {
    List roomList = await AllDatabase.instance.getRoomById(flatId);
    setState(() {
      widget.rm = List.generate(
          roomList.length,
          (index) => RoomType(
                rId: roomList[index]['r_id'].toString(),
                fltId: roomList[index]['flt_id'].toString(),
                rName: roomList[index]['r_name'].toString(),
                user: roomList[index]['user'],
              ));
      tabC = TabController(length: widget.rm!.length, vsync: this);
    });
  }

  _createAlertDialogForAddRoom() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Enter the Name of Room'),
            content: TextFormField(
              autofocus: true,
              controller: roomEditing,
              textInputAction: TextInputAction.next,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              style: const TextStyle(fontSize: 18, color: Colors.black54),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.place),
                filled: true,
                fillColor: Colors.white,
                hintText: 'Enter Room Name',
                contentPadding: const EdgeInsets.all(15),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(50),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MaterialButton(
                  elevation: 5.0,
                  child: const Text('Submit'),
                  onPressed: () async {
                    await addRoom(roomEditing.text);
                    await getrooms(widget.flat!.fltId);
                    await roomQueryFunc(widget.flat!.fltId);
                    Navigator.of(context).pop();
                  },
                ),
              )
            ],
          );
        });
  }

  Future<void> addRoom(String data) async {
    const url = api + 'addroom/';
    String? token = await getToken();
    var postData = {
      "user": getUidVariable2,
      "r_name": data,
      "flt_id": widget.flat!.fltId,
    };
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(postData),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      setState(() {
        tabbarState = jsonDecode(response.body);
      });
      const snackBar = SnackBar(
        content: Text('Room Added'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    } else {
      throw Exception('Failed to create Room.');
    }
  }

  Future<void> sendDeviceId(String data) async {
    String? token = await getToken();
    const url = api + 'addyourdevice/';
    var postData = {"user": getUidVariable2, "r_id": tabbarState, "d_id": data};
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(postData),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return;
    } else {
      throw Exception('Failed to create Device.');
    }
  }

  _createAlertDialogForAddDevice(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Enter the Device Id'),
            content: TextField(
              controller: addDeviceController,
            ),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MaterialButton(
                  elevation: 5.0,
                  child: const Text('Submit'),
                  onPressed: () async {
                    await sendDeviceId(addDeviceController.text);
                    await getDevice(tabbarState);
                    await deviceQueryFunc(tabbarState);
                    await getPinStatusData(addDeviceController.text)
                        .then((value) => getPinNames(addDeviceController.text));
                    nameFuture = getPinNameByLocal(
                        addDeviceController.text.toString(), 0);
                    Navigator.pop(context);
                  },
                ),
              )
            ],
          );
        });
  }

  Future getDevice(rId) async {
    String? token = await getToken();
    var url = api + 'addyourdevice/?r_id=' + rId;
    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Token $token',
    });
    if (response.statusCode == 200) {
      List<dynamic> deviceData = jsonDecode(response.body);
      await AllDatabase.instance.deleteDeviceModel(rId);
      for (int i = 0; i < deviceData.length; i++) {
        var deviceQuery = DeviceType.fromJson(deviceData[i]);

        await AllDatabase.instance.insertDeviceModelData(deviceQuery);
      }
    }
  }

  Future deviceQueryFunc(rId) async {
    List deviceList = await AllDatabase.instance.getDeviceById(rId);
    setState(() {
      widget.dv = List.generate(
          deviceList.length,
          (index) => DeviceType(
              id: deviceList[index]['id'],
              dateInstalled:
                  DateTime.parse(deviceList[index]['date_installed']),
              user: deviceList[index]['user'],
              rId: deviceList[index]['r_id'].toString(),
              dId: deviceList[index]['d_id']));
    });
    
  }

  Future<List<PlaceType>> placeQueryFunc() async {
    List data = await AllDatabase.instance.queryPlace();

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
                                return DropdownMenuItem<PlaceType>(
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
                                return DropdownMenuItem<FloorType>(
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
              child: FutureBuilder<List<FlatType>>(
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
                            child: DropdownButtonFormField<FlatType>(
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
                                return DropdownMenuItem<FlatType>(
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
                        List<RoomType> rm = [];

                        List data =
                            await AllDatabase.instance.getRoomById(flt!.fltId);
                        setState(() {
                          rm = data
                              .map((data) => RoomType.fromJson(data))
                              .toList();
                        });
                        // timer!.cancel();

                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomePage(
                                    fl: fl,
                                    flat: flt,
                                    pt: pt,
                                    rm: rm,
                                    dv: const [])));
                      },
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  _billPredictionNavigation(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Please Select'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    // timer!.cancel();

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PlaceBill()));
                  },
                  child: const Text("Place "),
                ),
                const SizedBox(
                  height: 9,
                ),
                InkWell(
                  onTap: () {
                    // timer!.cancel();

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FloorBillPred()));
                  },
                  child: const Text("Floor "),
                ),
                const SizedBox(
                  height: 9,
                ),
                InkWell(
                  onTap: () {
                    // timer!.cancel();

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FlatBillPred()));
                  },
                  child: const Text("Flat  "),
                ),
                const SizedBox(
                  height: 9,
                ),
                InkWell(
                  onTap: () {
                    // timer!.cancel();

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RoomBillPred()));
                  },
                  child: const Text("Room "),
                ),
                const SizedBox(
                  height: 9,
                ),
                InkWell(
                  onTap: () {
                    // timer!.cancel();

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const DeviceBillPred()));
                  },
                  child: const Text("Device "),
                ),
              ],
            ),
          );
        });
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
                                return DropdownMenuItem<FloorType>(
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
              child: FutureBuilder<List<FlatType>>(
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
                            child: DropdownButtonFormField<FlatType>(
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
                                return DropdownMenuItem<FlatType>(
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
                        List<RoomType> rm = [];

                        List data =
                            await AllDatabase.instance.getRoomById(flt!.fltId);
                        setState(() {
                          rm = data
                              .map((data) => RoomType.fromJson(data))
                              .toList();
                        });
                        // timer!.cancel();

                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomePage(
                                    fl: fl,
                                    flat: flt,
                                    pt: widget.pt,
                                    rm: rm,
                                    dv: const [])));
                      },
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget changeFlat(){
    return Container(
        margin: const EdgeInsets.only(bottom: 45),
   child:SingleChildScrollView(
    child:Column(
      children:[
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
                      changeFlatBool = !changeFlatBool;
                    });
                  },
                )
              ],
            ),
            Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: FutureBuilder<List<FlatType>>(
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
                                        return DropdownMenuItem<FlatType>(
                                          value: selectedflat,
                                          child: Text(selectedflat.fltName),
                                        );
                                      }).toList(),
                                      onChanged: (selectFlat) async {
                                        setState(() {
                                          flt = selectFlat;
                                        });

                                        List roomList = await AllDatabase
                                            .instance
                                            .getRoomById(flt!.fltId);

                                        setState(() {
                                          rm = List.generate(
                                              roomList.length,
                                              (index) => RoomType(
                                                    rId: roomList[index]['r_id']
                                                        .toString(),
                                                    fltId: roomList[index]
                                                            ['flt_id']
                                                        .toString(),
                                                    rName: roomList[index]
                                                            ['r_name']
                                                        .toString(),
                                                    user: roomList[index]
                                                        ['user'],
                                                  ));
                                        });

                                        List device = await AllDatabase.instance
                                            .getDeviceById(rm[0].rId);
                                        dv = device
                                            .map((e) => DeviceType.fromJson(e))
                                            .toList();
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
            ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: MaterialButton(
            elevation: 5.0,
            child: const Text('Submit'),
            onPressed: () async {
              // timer!.cancel();

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomePage(
                          fl: widget.fl,
                          flat: flt,
                          pt: widget.pt,
                          rm: rm,
                          dv: dv)));
            },
          ),
        )
      ]
    )
   )
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
                      child: FutureBuilder<List<FlatType>>(
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
                                        return DropdownMenuItem<FlatType>(
                                          value: selectedflat,
                                          child: Text(selectedflat.fltName),
                                        );
                                      }).toList(),
                                      onChanged: (selectFlat) async {
                                        setState(() {
                                          flt = selectFlat;
                                        });

                                        List roomList = await AllDatabase
                                            .instance
                                            .getRoomById(flt!.fltId);

                                        setState(() {
                                          rm = List.generate(
                                              roomList.length,
                                              (index) => RoomType(
                                                    rId: roomList[index]['r_id']
                                                        .toString(),
                                                    fltId: roomList[index]
                                                            ['flt_id']
                                                        .toString(),
                                                    rName: roomList[index]
                                                            ['r_name']
                                                        .toString(),
                                                    user: roomList[index]
                                                        ['user'],
                                                  ));
                                        });

                                        List device = await AllDatabase.instance
                                            .getDeviceById(rm[0].rId);
                                        dv = device
                                            .map((e) => DeviceType.fromJson(e))
                                            .toList();
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
                    ),
                  )
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
                    // timer!.cancel();

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomePage(
                                fl: widget.fl,
                                flat: flt,
                                pt: widget.pt,
                                rm: rm,
                                dv: dv)));
                  },
                ),
              )
            ],
          );
        });
  }

  bool statusOfDevice = false;

  Future getPinStatusData(did) async {
    DevicePinStatus? pinStatus;
    var token = await getToken();

    var url = api + "getpostdevicePinStatus/?d_id=" + did;
    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Token $token',
    });
    if (response.statusCode == 200) {
      var ans = jsonDecode(response.body);
      List a = await AllDatabase.instance.getPinStatusByDeviceId(did);
      if (a.isEmpty) {
        setState(() {
          pinStatus = DevicePinStatus.fromJson(ans);
          AllDatabase.instance.insertPinStatusData(pinStatus!);
          switchFuture = getPinStatusByDidLocal(did.toString());
        });
        String a = pinStatus!.pin20Status.toString();
        if (kDebugMode) {
          print('ForLoop123 $a}');
        }
        int aa = int.parse(a);
        if (kDebugMode) {
          print('double $aa');
        }

        int ms =
            // ((DateTime.now().millisecondsSinceEpoch) / 1000).round() + 19700;
            ((DateTime.now().millisecondsSinceEpoch) / 1000).round() -
                100; // -100 for checking a difference for 100 seconds in current time
        if (kDebugMode) {
          print('CheckMs $ms');
        }
        // print('Checkaa ${aa}');
        if (aa >= ms) {
          if (kDebugMode) {
            print('ifelse');
          }
          setState(() {
            statusOfDevice = true;
          });
        } else {
          if (kDebugMode) {
            print('ifelse2');
          }
          setState(() {
            statusOfDevice = false;
          });
        }
      } else {
        setState(() {
          pinStatus = DevicePinStatus.fromJson(ans);
          AllDatabase.instance.updatePinStatusData(pinStatus!);
          switchFuture = getPinStatusByDidLocal(deviceIdForScroll.toString());
        });
        String a = pinStatus!.pin20Status.toString();
        if (kDebugMode) {
          print('ForLoop123 $a');
        }
        int aa = int.parse(a);
        if (kDebugMode) {
          print('double $aa');
        }

        int ms =
            // ((DateTime.now().millisecondsSinceEpoch) / 1000).round() + 19700;
            ((DateTime.now().millisecondsSinceEpoch) / 1000).round() -
                100; // -100 for checking a difference for 100 seconds in current time
        if (kDebugMode) {
          print('CheckMs $ms');
        }
        // print('Checkaa ${aa}');
        if (aa >= ms) {
          if (kDebugMode) {
            print('ifelse');
          }
          setState(() {
            statusOfDevice = true;
          });
        } else {
          if (kDebugMode) {
            print('ifelse2');
          }
          setState(() {
            statusOfDevice = false;
          });
        }
        return;
      }
    }
  }

  Future getAllPinStatusData(String dId)async{
    var token = await getToken();
      var url = api + "getpostdevicePinStatus/?d_id=" + dId;
     final response = await http.get(Uri.parse(url), headers: {
       'Content-Type': 'application/json',
       'Accept': 'application/json',
       'Authorization': 'Token $token',
     });
     if(response.statusCode == 200){
       var ans = jsonDecode(response.body);
       DevicePinStatus pinStatus = DevicePinStatus.fromJson(ans);
       AllDatabase.instance.updatePinStatusData(pinStatus);
       switchFuture = getPinStatusByDidLocal(deviceIdForScroll.toString());

     }
    }




  Future getPinNames(did) async {
    String? token = await getToken();
    var url = api + "editpinnames/?d_id=" + did;
    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Token $token',
    });
    if (response.statusCode == 200) {
      var ans = jsonDecode(response.body);

      List a = await AllDatabase.instance.getPinNamesByDeviceId(did);

      if (a.isEmpty) {
        DevicePinName pinName = DevicePinName.fromJson(ans);
        await AllDatabase.instance.insertDevicePinNames(pinName);
      } else {
        setState(() {
          DevicePinName pinName = DevicePinName.fromJson(ans);
          AllDatabase.instance.updatePinNameData(pinName);
        });
      }
    } else {
      return;
    }
  }

  Future getAndUpdateScheduledPins(dId) async {
    String? token = await getToken();
    var url = api + "scheduledatagetbyid/?d_id=" + dId;
    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Token $token',
    });
    if (response.statusCode == 200) {
      List<dynamic> ans = jsonDecode(response.body);
      await AllDatabase.instance.deleteScheduledAll();
      for (int i = 0; i < ans.length; i++) {
        var schedule = ScheduledPin.fromJson(ans[i]);

        await AllDatabase.instance.insertDevicePinSchedule(schedule);
      }
      List an = await AllDatabase.instance.getScheduledByDeviceId(dId);
      if (kDebugMode) {
        print(an);
      }
    }
  }

  Future updatePinNamesGet(did) async {
    String? token = await getToken();
    var url = api + "editpinnames/?d_id=" + did;
    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Token $token',
    });
    if (response.statusCode == 200) {
      var ans = jsonDecode(response.body);
      if (kDebugMode) {
        print("sa $ans");
      }
      List a = await AllDatabase.instance.getPinNamesByDeviceId(did);

      if (a.isEmpty) {
        if (kDebugMode) {
          print("empty");
        }
        DevicePinName pinName = DevicePinName.fromJson(ans);
        await AllDatabase.instance.insertDevicePinNames(pinName);
      } else {
        if (kDebugMode) {
          print("update");
        }
        setState(() {
          DevicePinName pinName = DevicePinName.fromJson(ans);
          AllDatabase.instance.updatePinNameData(pinName);
        });
      }
    } else {
      return;
    }
  }

  Future<bool> getPinStatusByDidLocal(did) async {
    print("DID $did");
    List data = await AllDatabase.instance.getPinStatusByDeviceId(did.toString());
    if (kDebugMode) {
      print("All Status $data");
    }
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
        data[0]['sensor8'],
        data[0]['sensor9'],
        data[0]['sensor10'],
        data[0]['d_id'],
      ];
    });
    if (kDebugMode) {
      print("objectAndSensor $responseGetData  => ${sensorData[1]  } => ${sensorData[7]}  ");
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
        devicePin =
            pinName.map((data) => DevicePinName.fromJson(data)).toList();
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

  Future getPinScheduledOnline(did) async {
    String? token = await getToken();
    var url = api + "scheduledatagetbyid/?d_id=" + did;
    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Token $token',
    });
    if (response.statusCode == 200) {
      List ans = jsonDecode(response.body);

      for (int i = 0; i < ans.length; i++) {
        var schedule = ScheduledPin.fromJson(ans[i]);

        await AllDatabase.instance.updateScheduleData(schedule);
      }
    }
  }

  Future<bool> getScheduledDataLocal(dId) async {
    List data = await AllDatabase.instance.getScheduledByDeviceId(dId);
    setState(() {
      schedulePin = [];
      schedulePin = data.map((data) => ScheduledPin.fromJson(data)).toList();
    });
    if (kDebugMode) {
      print("Total Lenght -> ${schedulePin.length}");
    }

    if (schedulePin.isNotEmpty) {
      return true;
    } else {
      return false;
    }
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
      return;
    } else {}
  }

  Future updatePinName(int index, String data, String deviceId) async {
    String? token = await getToken();
    const uri = api + 'editpinnames/';

    if (index == 0) {
      postDataPinName = {"d_id": deviceId, "pin1Name": data};
    } else if (index == 1) {
      postDataPinName = {
        "d_id": deviceId,
        "pin2Name": data,
      };
    } else if (index == 2) {
      postDataPinName = {
        "d_id": deviceId,
        "pin3Name": data,
      };
    } else if (index == 3) {
      postDataPinName = {
        "d_id": deviceId,
        "pin4Name": data,
      };
    } else if (index == 4) {
      postDataPinName = {
        "d_id": deviceId,
        "pin5Name": data,
      };
    } else if (index == 5) {
      postDataPinName = {
        "d_id": deviceId,
        "pin6Name": data,
      };
    } else if (index == 6) {
      postDataPinName = {
        "d_id": deviceId,
        "pin7Name": data,
      };
    } else if (index == 7) {
      postDataPinName = {
        "d_id": deviceId,
        "pin8Name": data,
      };
    } else if (index == 8) {
      postDataPinName = {
        "d_id": deviceId,
        "pin9Name": data,
      };
    } else if (index == 9) {
      postDataPinName = {
        "d_id": deviceId,
        "pin10Name": data,
      };
    } else if (index == 10) {
      postDataPinName = {
        "d_id": deviceId,
        "pin11Name": data,
      };
    } else if (index == 11) {
      postDataPinName = {
        "d_id": deviceId,
        "pin12Name": data,
      };
    } else {
      return;
    }
    final response = await http.put(
      Uri.parse(uri),
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(postDataPinName),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      setState(() {
        namesDataList[index] = data;
      });
    } else {}
  }

  _createAlertDialogForNameDeviceBox(context, index, dId) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Column(
              children: [
                DropdownButton<String>(
                  value: _chosenValue,
                  //elevation: 5,
                  style: const TextStyle(color: Colors.black),

                  items: <String>[
                    'Air Conditioner',
                    'Refrigerator',
                    'Bulb',
                    'Fan',
                    'Washing Machine',
                    'Heater',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  hint: const Text(
                    "Please choose a Icon",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _chosenValue = value;
                    });
                  },
                ),
                const Text('Enter the Name of Device'),
              ],
            ),
            content: TextField(
              controller: pinNameController,
            ),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MaterialButton(
                  elevation: 5.0,
                  child: const Text('Submit'),
                  onPressed: () async {
                    if (_chosenValue == "Air Conditioner") {
                      setState(() {
                        iconCode[index] = "001";
                      });
                    }
                    if (_chosenValue == "Refrigerator") {
                      setState(() {
                        iconCode[index] = "002";
                      });
                    }
                    if (_chosenValue == "Bulb") {
                      setState(() {
                        iconCode[index] = "003";
                      });
                    }

                    if (_chosenValue == "Fan") {
                      setState(() {
                        iconCode[index] = "004";
                      });
                    }
                    if (_chosenValue == "Washing Machine") {
                      setState(() {
                        iconCode[index] = "005";
                      });
                    }
                    if (_chosenValue == "Heater") {
                      setState(() {
                        iconCode[index] = "006";
                      });
                    }

                    String finaName =
                        pinNameController.text + "," + iconCode[index];
                    await updatePinName(index, finaName, dId);
                    Navigator.pop(context);
                    await getPinNames(dId);
                    await getPinNameByLocal(dId, index);
                  },
                ),
              )
            ],
          );
        });
  }

  _createAlertDialogForDeleteFloorAndAddFloor(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              'Choose One For Floor',
              style: TextStyle(fontSize: 20),
            ),
            content: SingleChildScrollView(
              child: SizedBox(
                height: 155,
                child: Column(
                  children: [
                    TextButton(
                      child: Row(
                        children: const [
                          Icon(Icons.add),
                          SizedBox(
                            width: 54,
                          ),
                          Text(
                            'Add Floor',
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                      onPressed: () async {
                        await allFloor();
                        _createAlertDialogForAddFloor(context);
                      },
                    ),
                    TextButton(
                      child: Row(
                        children: const [
                          Icon(Icons.delete),
                          SizedBox(
                            width: 54,
                          ),
                          Text(
                            'Delete Floor',
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                      onPressed: () async {
                        deleteFloorOption(context);
                      },
                    ),
                    TextButton(
                      child: Row(
                        children: const [
                          Icon(Icons.edit),
                          SizedBox(
                            width: 54,
                          ),
                          Text(
                            'Edit Floor Name',
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                      onPressed: () {
                        _editFloorNameAlertDialog(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: const <Widget>[],
          );
        });
  }

  Future<void> addFloor(String data) async {
    String? token = await getToken();
    const url = api + 'addyourfloor/';
    var postData = {
      "user": getUidVariable2,
      "p_id": widget.pt!.pId,
      "f_name": data
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
      floorResponse = jsonDecode(response.body);
    } else {
      throw Exception('Failed to create Floor.');
    }
  }

  Future<void> addFlat2(String data) async {
    const url = api + 'addyourflat/';
    String? token = await getToken();
    var postData = {
      "user": getUidVariable2,
      "flt_name": data,
      "f_id": floorResponse,
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
      setState(() {
        flatResponse = jsonDecode(response.body);
      });
      await addRoom2(flatResponse, roomEditingWithFloor.text);
    } else {
      throw Exception('Failed to create Room.');
    }
  }

  Future<void> addRoom2(flatResponse, String data) async {
    const url = api + 'addroom/';
    String? token = await getToken();
    var postData = {
      "user": getUidVariable2,
      "r_name": data,
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
      if (kDebugMode) {
        print("object ${response.statusCode}");
        print("object ${response.body}");
      }

      return;
    } else {
      if (kDebugMode) {
        print("object ${response.statusCode}");
        print("object ${response.body}");
      }

      throw Exception('Failed to create Room.');
    }
  }

  Future getAllCurrentFloor() async {
    String? token = await getToken();
    var url = api + "addyourfloor/?p_id=" + widget.pt!.pId;
    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Token $token',
    });
    if (response.statusCode == 200) {
      List data = await AllDatabase.instance.getFloorById(widget.pt!.pId);
      for (int i = 0; i < data.length; i++) {
        await AllDatabase.instance.deleteFloorModel(data[i]['f_id']);
      }
      List<dynamic> res = jsonDecode(response.body);
      for (int i = 0; i < res.length; i++) {
        var floorQuery = FloorType(
            fId: res[i]['f_id'],
            fName: res[i]['f_name'],
            user: res[i]['user'],
            pId: res[i]['p_id']);
        AllDatabase.instance.insertFloorModelData(floorQuery);
      }
    }
  }

  Future getAllFlatByAddedFloor() async {
    String? token = await getToken();
    var url = api + "addyourflat/?f_id=$floorResponse";
    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Token $token',
    });
    if (response.statusCode == 200) {
      List allFlat = await AllDatabase.instance.getFlatByFId(floorResponse);
      for (int i = 0; i < allFlat.length; i++) {
        await AllDatabase.instance.deleteFlatModel(floorResponse);
      }
      List<dynamic> res = jsonDecode(response.body);
      for (int i = 0; i < res.length; i++) {
        var flatQuery = FlatType(
          fId: res[i]['f_id'],
          fltId: res[i]['flt_id'],
          user: res[i]['user'],
          fltName: res[i]['flt_name'],
        );
        AllDatabase.instance.insertFlatModelData(flatQuery);
      }
    }
  }

  Future getAllRoomByAddedFlat() async {
    String? token = await getToken();
    var url = api + "addroom/?flt_id=$flatResponse";
    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Token $token',
    });
    if (response.statusCode == 200) {
      List allRoom = await AllDatabase.instance.getRoomById(flatResponse);
      if (allRoom.isNotEmpty) {
        for (int i = 0; i < allRoom.length; i++) {
          await AllDatabase.instance.deleteRoomModel(allRoom[i]['flt_id']);
        }
      }
      List<dynamic> res = jsonDecode(response.body);
      for (int i = 0; i < res.length; i++) {
        var roomQuery = RoomType(
          fltId: res[i]['flt_id'],
          user: res[i]['user'],
          rId: res[i]['r_id'],
          rName: res[i]['r_name'],
        );
        AllDatabase.instance.insertRoomModelData(roomQuery);
      }
    }
  }

  _createAlertDialogForAddFloor(BuildContext context) {
    return submitClicked
        ? const Center(child: CircularProgressIndicator())
        : showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Enter the Name of Floor'),
                content: SizedBox(
                  height: 320,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        autofocus: true,
                        controller: floorEditing,
                        textInputAction: TextInputAction.next,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        style: const TextStyle(
                            fontSize: 18, color: Colors.black54),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.place),
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Enter Floor Name',
                          contentPadding: const EdgeInsets.all(15),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        autofocus: true,
                        controller: flatEditing,
                        textInputAction: TextInputAction.next,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        style: const TextStyle(
                            fontSize: 18, color: Colors.black54),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.place),
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Enter Flat Name',
                          contentPadding: const EdgeInsets.all(15),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        autofocus: true,
                        controller: roomEditingWithFloor,
                        textInputAction: TextInputAction.next,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        style: const TextStyle(
                            fontSize: 18, color: Colors.black54),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.place),
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Enter Room Name',
                          contentPadding: const EdgeInsets.all(15),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MaterialButton(
                          elevation: 5.0,
                          child: const Text('Submit'),
                          onPressed: () async {
                            setState(() {
                              submitClicked = true;
                            });
                            await addFloor(floorEditing.text);
                            await addFlat2(flatEditing.text);
                            Navigator.of(context).pop();
                            await getAllCurrentFloor();
                            await getAllFlatByAddedFloor();
                            await getAllRoomByAddedFlat();
                            setState(() {
                              submitClicked = true;
                            });
                          },
                        ),
                      )
                    ],
                  ),
                ),
              );
            });
  }

  allFloor() async {
    listOfAllFloor = await AllDatabase.instance.queryFloor();
    if (kDebugMode) {
      print(listOfAllFloor);
    }
  }

  Future<void> deleteFloor(String fId) async {
    String? token = await getToken();
    final url = api + 'addyourfloor/?f_id=' + fId;
    final response = await http.delete(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Token $token',
    });
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print('deleteFloor ${response.body}');
      }
      await AllDatabase.instance.deleteFloorModel(fId);
      listOfAllFloor = await AllDatabase.instance.getFloorById(fId);

      const snackBar = SnackBar(
        content: Text('Floor Deleted'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      await deleteDatabaseLocalFlatAndRoomByFloor(fId);
    } else {
      const snackBar = SnackBar(
        content: Text('Something went wrong'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  deleteDatabaseLocalFlatAndRoomByFloor(fId) async {
    List flatByFloor = await AllDatabase.instance.getFlatByFId(fId);
    List roomByFlat = [];
    List roomDevice = [];
    if (flatByFloor.isNotEmpty) {
      for (int i = 0; i < flatByFloor.length; i++) {
        roomByFlat = await AllDatabase.instance
            .getRoomById(flatByFloor[i]['flt_id'].toString());
        await AllDatabase.instance.deleteFlatModel(fId);
      }
    }
    if (roomByFlat.isNotEmpty) {
      for (int i = 0; i < roomByFlat.length; i++) {
        await AllDatabase.instance.deleteRoomModel(roomByFlat[i]['flt_id']);
      }
      for (int i = 0; i < roomByFlat.length; i++) {
        roomDevice = await AllDatabase.instance
            .getDeviceById(roomByFlat[i]['r_id'].toString());
      }
      if (roomDevice.isNotEmpty) {
        for (int i = 0; i < roomDevice.length; i++) {
          await AllDatabase.instance.deleteDeviceModel(roomDevice[i]['d_id']);
          await AllDatabase.instance
              .deleteDevicePinNameModel(roomDevice[i]['d_id']);
          await AllDatabase.instance
              .deleteDevicePinStatusModel(roomDevice[i]['d_id']);
        }
      } else {
        return;
      }
    }
  }

  Future<void> addFloorName(String data) async {
    String? token = await getToken();
    const url = api + 'addyourfloor/';
    var postDataFloorName = {
      "f_id": widget.fl!.fId,
      "f_name": data,
      "user": getUidVariable2,
    };
    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(postDataFloorName),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (kDebugMode) {
        print(response.statusCode);
        print(response.body);
      }
      setState(() {
        widget.fl!.fName = data;
      });
      await AllDatabase.instance.updateFloorDataForName(widget.fl!);

      return;
    } else {
      if (kDebugMode) {
        print(response.statusCode);
        print(response.body);
      }

      throw Exception('Failed to create Floor.');
    }
  }

  _editFloorNameAlertDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Enter Floor Name"),
            content: TextField(
              controller: floorNameEditing,
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MaterialButton(
                  // elevation: 5.0,
                  child: const Text('Submit'),
                  onPressed: () async {
                    await addFloorName(floorNameEditing.text);
                    Navigator.of(context).pop();
                  },
                ),
              )
            ],
          );
        });
  }

  deleteFloorOption(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Select Floor'),
            content: Container(
              color: Colors.amber,
              width: 78,
              child: ListView.builder(
                  itemCount: listOfAllFloor.length,
                  itemBuilder: (context, index) {
                    return Container(
                      color: Colors.blueGrey,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          semanticContainer: true,
                          shadowColor: Colors.grey,
                          child: Column(
                            children: <Widget>[
                              ListTile(
                                title: Text(listOfAllFloor[index]['f_name']),
                              ),
                              // ignore: deprecated_member_use
                              ElevatedButton(
                                child: const Text('Delete Floor'),
                                onPressed: () async {
                                  var deleteFloorId;
                                  if (widget.fl!.fId.contains(
                                      listOfAllFloor[index]['f_id']
                                          .toString())) {
                                    oops();
                                  } else {
                                    setState(() {
                                      deleteFloorId = listOfAllFloor[index]
                                              ['f_id']
                                          .toString();
                                    });
                                    await deleteFloor(deleteFloorId);

                                    Navigator.of(context).pop();
                                  }
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          );
        });
  }


  var recipents = "9911757588";
  var message = "d_id:";
  var messageIOS = "This_is%20time";

  void messageSms(BuildContext context, String dId) {
    if (Platform.isAndroid) {
      launch("sms:" +
          recipents +
          "?body=" +
          message +
          dId +
          ":" +
          responseGetData[0].toString() +
          responseGetData[1].toString() +
          responseGetData[2].toString() +
          responseGetData[3].toString() +
          responseGetData[4].toString() +
          responseGetData[5].toString() +
          responseGetData[6].toString() +
          responseGetData[7].toString() +
          responseGetData[8].toString() +
          responseGetData[9].toString() +
          responseGetData[10].toString() +
          responseGetData[11].toString() +
          ":");
    } else if (Platform.isIOS) {
      // launch("sms:" + recipents + "&body=" + messageIOS);
      launch("sms:" +
          recipents +
          "?body=" +
          message +
          dId +
          ":" +
          responseGetData[0].toString() +
          responseGetData[1].toString() +
          responseGetData[2].toString() +
          responseGetData[3].toString() +
          responseGetData[4].toString() +
          responseGetData[5].toString() +
          responseGetData[6].toString() +
          responseGetData[7].toString() +
          responseGetData[8].toString() +
          responseGetData[9].toString() +
          responseGetData[10].toString() +
          responseGetData[11].toString() +
          ":");
    }
  }

  var recipentEmail = "contact@genorion.com";
  var emailSubject = "hey";
  var emailBody = "hello how are you%20plugin";
  var emailBodyIOS = "hello_how_are_you%20plugin";
  IpAddress? ip;

  void emailMessage(BuildContext context) {
    if (Platform.isAndroid) {
      launch("mailto:" +
          recipentEmail +
          "?subject=" +
          emailSubject +
          "&body=" +
          emailBody);
    } else if (Platform.isIOS) {
      launch("mailto:" +
          recipentEmail +
          "?subject=" +
          emailSubject +
          "&body=" +
          emailBodyIOS);
    }
  }

  Future<IpAddress?> fetchIp(String dId) async {
    String? token = await getToken();
    String url = api + 'addipaddress/?d_id=' + dId;
    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Token $token',
    });

    if (response.statusCode == 200) {
      var ans = jsonDecode(response.body);
      ip = IpAddress.fromJson(ans);
      return ip;
    }
    return null;
  }

  Widget deviceContainer(dId, index) {
    deviceIdForScroll = dId;

    return Container(
      color: Colors.transparent,
      height: MediaQuery.of(context).size.height * 2.9,
      child: SingleChildScrollView(
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
                        if (kDebugMode) {
                          print("hit");
                        }
                    switchFuture = getPinStatusByDidLocal(dId.toString());
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
                      onTap: () async {
                        // await getPinScheduledOnline(dId);
                        pinScheduledFuture = getScheduledDataLocal(dId);
                        _createAlertDialogForPinSchedule(context, dId);
                      },
                    ),
                  ),
                  Container(
                    width: 14,
                    height: 14,

                    decoration: BoxDecoration(
                        color: statusOfDevice ? Colors.green : Colors.grey,
                        shape: BoxShape.circle),
                    // child: ...
                  ),
                  Switch(
                    value: responseGetData.contains(1) ? true : false,
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
                          remoteBool = true;
                        });
                      },
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        _createAlertDialogForSSIDAndEmergencyNumber(
                            context, dId);
                      },
                      icon: const Icon(
                        Icons.settings,
                        color: Colors.white,
                      )),
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
                  return InkWell(
                    onLongPress: () {
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
                                        await pickTime(index);
                                        setState(() {
                                          _alarmTimeString = cutTime;
                                        });
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
                                    Center(
                                      child: ListTile(
                                        title: ToggleSwitch(
                                          minWidth: 100,
                                          initialLabelIndex: 0,
                                          labels: const ['Off', 'On'],
                                          onToggle: (index) {
                                            checkSwitch = index!;
                                          },
                                          totalSwitches: 2,
                                        ),
                                      ),
                                    ),
                                    FloatingActionButton.extended(
                                      onPressed: () async {
                                        await schedulingDevicePin(dId, index);
                                        Navigator.pop(context);
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
                                            child: AutoSizeText(
                                              '${namesDataList[index].toString()} ',
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: const TextStyle(
                                                fontSize: 10,
                                              ),
                                            ),
                                            onPressed: () async {
                                              _createAlertDialogForNameDeviceBox(
                                                  context, index, dId);
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
                                              return loading[index]
                                                  ? loadingContainer()
                                                  : FlutterSwitch(
                                                      activeText: "On",
                                                      inactiveText: "Off",
                                                      value: responseGetData[
                                                                  index] ==
                                                              0
                                                          ? false
                                                          : true,
                                                      onToggle: (value) async {
                                                        setState(() {
                                                          loading[index] = true;
                                                        });

                                                        // if Internet is not available then _checkInternetConnectivity = true
                                                        var result =
                                                            await Connectivity()
                                                                .checkConnectivity();
                                                        if (result ==
                                                            ConnectivityResult
                                                                .none) {
                                                          messageSms(
                                                              context, dId);
                                                        }

                                                        if (responseGetData[
                                                                index] ==
                                                            0) {
                                                          setState(() {
                                                            responseGetData[
                                                                index] = 1;
                                                          });
                                                          await dataUpdate(dId);

                                                          await getPinStatusData(
                                                              dId);
                                                          await getPinStatusByDidLocal(
                                                              dId.toString());
                                                          setState(() {
                                                            loading[index] =
                                                                false;
                                                          });
                                                        } else {
                                                          setState(() {
                                                            responseGetData[
                                                                index] = 0;
                                                          });
                                                          await dataUpdate(dId).then((value) =>
                                                              getPinStatusData(
                                                                      dId)
                                                                  .then((value) =>
                                                                      getPinStatusByDidLocal(
                                                                          dId
                                                                          )));
                                                          setState(() {
                                                            loading[index] =
                                                                false;
                                                          });
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
                  );
                }),
              ),
            ),
   
            Container(
              height: MediaQuery.of(context).size.height * 1.4,
              padding: const EdgeInsets.only(bottom: 776),
              color: Colors.transparent,
              child: GridView.count(
                crossAxisSpacing: 8,
                childAspectRatio: 2 / 1.7,
                mainAxisSpacing: 4,
                crossAxisCount: 2,
                scrollDirection: Axis.vertical,
                physics: const NeverScrollableScrollPhysics(),
                children: List.generate(3, (index) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                        alignment: const FractionalOffset(1.0, 0.0),
                        // alignment: Alignment.bottomRight,
                        height: 120,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 1, vertical: 10),
                        margin: index % 2 == 0
                            ? const EdgeInsets.fromLTRB(15, 7.5, 7.5, 7.5)
                            : const EdgeInsets.fromLTRB(
                                7.5, 7.5, 15, 7.5),
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
                                          child: AutoSizeText(
                                            // '$index',
                                            namesDataList[index + 9]
                                                .toString(),
                                            overflow:
                                                TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: const TextStyle(
                                              fontSize: 10,
                                            ),
                                          ),
                                          onPressed: () async {
                                            int newIndex = index + 9;
                                            _createAlertDialogForNameDeviceBox(
                                                context, newIndex, dId);
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
                                                  responseGetData[
                                                          index + 9]
                                                      .toString()),
                                              min: 0,
                                              max: 10,
                                              label:
                                                  '${double.parse(responseGetData[index + 9].toString())}',
                                              onChanged:
                                                  (onChanged) async {
                                                setState(() {
                                                  responseGetData[
                                                          index + 9] =
                                                      onChanged.round();
                                                });
                                                await dataUpdate(dId);
                                              }),
                                        );
                                      } else {
                                        return Container();
                                      }
                                    }),
                              ],
                            ),
                            GestureDetector(
                                onTap: () {},
                                child:
                                    Icon(changeIcon[index] ?? Icons.add))
                          ],
                        )),
                  );
                }),
              ),
            ),
      
            const Divider()
          ],
        ),
      ),
    );
  }

  _createAlertDialogForSSIDAndEmergencyNumber(context, String dId) async {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text(dId.toString()),
          children: [
            SimpleDialogOption(
              onPressed: () {
                // timer!.cancel();

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ShowSSid(
                              deviceId: dId,
                            )));
              },
              child: const Text(
                'Set SSID and Password',
                style: TextStyle(color: Colors.blue),
              ),
            ),
           
            SimpleDialogOption(
              onPressed: () {
                // timer!.cancel();

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EmergencyNumber(
                              deviceId: dId,
                            )));
              },
              child: const Text(
                'Emergency Number',
                style: TextStyle(color: Colors.blue),
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                _showDialogForDeleteSingleDevices(tabbarState, dId);
              },
              child: const Text(
                'Delete Device',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        );
      },
    );
  }

  _showDialogForDeleteSingleDevices(String rId, String dId) {
    // dialog implementation
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Alert"),
        content: const Text("Are your sure to delete this devices"),
        actions: <Widget>[
          // ignore: deprecated_member_use
          ElevatedButton(
              child: const Text("Yes"),
              onPressed: () async {
                await deleteDevice(rId, dId);
                await getDevice(rId);
                await deviceQueryFunc(tabbarState);

                Navigator.pop(context);
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

  Future deleteDevice(String rId, String dId) async {
    String? token = await getToken();
    final url = api + 'addyourdevice/?r_id=$rId&d_id=$dId';
    final response = await http.delete(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Token $token',
    });
    if (response.statusCode == 200) {
      await AllDatabase.instance.deleteDeviceModel(rId.toString());
      await AllDatabase.instance.deleteDevicePinNameModel(dId);
      await AllDatabase.instance.deleteDevicePinStatusModel(dId);
      // await AllDatabase.instance.deleteSensorUsingDeviceId(dId);

      const snackBar = SnackBar(
        content: Text('Device Deleted'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      const snackBar = SnackBar(
        content: Text('Something went wrong'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  // _createAlertDialogForSSIDAndEmergencyNumber(context, String dId) {
  //   return showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           content: SizedBox(
  //             height: MediaQuery.of(context).size.height / 2.49,
  //             child: Column(
  //               children: [
  //                 TextButton(
  //                     onPressed: () {
  //                       Navigator.push(
  //                           context,
  //                           MaterialPageRoute(
  //                               builder: (context) => ShowSSid(
  //                                     deviceId: dId,
  //                                   )));
  //                     },
  //                     child: const Text(
  //                       'Set SSID and Password',
  //                       style: TextStyle(fontSize: 20),
  //                     )),
  //                 TextButton(
  //                     onPressed: () {
  //                       Navigator.push(
  //                           context,
  //                           MaterialPageRoute(
  //                               builder: (context) => EmergencyNumber(
  //                                     deviceId: dId,
  //                                   )));
  //                     },
  //                     child: const Text(
  //                       'Emergency Number',
  //                       style: TextStyle(fontSize: 20),
  //                     )),
  //                 // TextButton(
  //                 //     onPressed: () {
  //                 //       // _createAlertDialogForPin17(context, dId);
  //                 //       // Navigator.push(
  //                 //       //     context,
  //                 //       //     MaterialPageRoute(
  //                 //       //         builder: (context) =>
  //                 //       //             ShowEmergencyNumber(
  //                 //       //               deviceId: widget.dv[index].dId,
  //                 //       //             )));
  //                 //     },
  //                 //     child: const Text(
  //                 //       'Add Cell Number',
  //                 //       style: TextStyle(fontSize: 20),
  //                 //     )),
  //                 TextButton(
  //                     onPressed: () {
  //                       // _showDialogForDeleteSingleDevices(tabbarState, dId);
  //                       // Navigator.push(
  //                       //     context,
  //                       //     MaterialPageRoute(
  //                       //         builder: (context) =>
  //                       //             ShowEmergencyNumber(
  //                       //               deviceId: widget.dv[index].dId,
  //                       //             )));
  //                     },
  //                     child: const Text(
  //                       'Delete Device',
  //                       style: TextStyle(fontSize: 20),
  //                     )),
  //               ],
  //             ),
  //           ),
  //           actions: const <Widget>[],
  //         );
  //       });
  // }

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

  Future schedulingDevicePin(String dId, index) async {
    const url = api + 'schedulingpinsalltheway/';
    String? token = await getToken();
    var postData;
    if (index == 0) {
      postData = {
        "user": getUidVariable2,
        "date1": cutDate.toString(),
        "timing1": cutTime.toString(),
        "pin1Status": checkSwitch,
        "d_id": dId,
      };
    } else if (index == 1) {
      postData = {
        "user": getUidVariable2,
        "date1": cutDate.toString(),
        "timing1": _alarmTimeString.toString(),
        "pin2Status": checkSwitch,
        "d_id": dId,
      };
    } else if (index == 2) {
      postData = {
        "user": getUidVariable2,
        "date1": cutDate.toString(),
        "timing1": _alarmTimeString,
        "pin2Status": checkSwitch,
        "d_id": dId.toString(),
      };
    } else if (index == 3) {
      postData = {
        "user": getUidVariable2,
        "date1": cutDate,
        "timing1": _alarmTimeString,
        "pin4Status": checkSwitch,
        "d_id": dId,
      };
    } else if (index == 4) {
      postData = {
        "user": getUidVariable2,
        "date1": cutDate,
        "timing1": _alarmTimeString,
        "pin5Status": checkSwitch,
        "d_id": dId,
      };
    } else if (index == 5) {
      postData = {
        "user": getUidVariable2,
        "date1": cutDate,
        "timing1": _alarmTimeString,
        "pin6Status": checkSwitch,
        "d_id": dId,
      };
    } else if (index == 6) {
      postData = {
        "user": getUidVariable2,
        "date1": cutDate,
        "timing1": _alarmTimeString,
        "pin7Status": checkSwitch,
        "d_id": dId,
      };
    } else if (index == 7) {
      postData = {
        "user": getUidVariable2,
        "date1": cutDate,
        "timing1": _alarmTimeString,
        "pin8Status": checkSwitch,
        "d_id": dId,
      };
    } else if (index == 8) {
      postData = {
        "user": getUidVariable2,
        "date1": cutDate,
        "timing1": _alarmTimeString,
        "pin9Status": checkSwitch,
        "d_id": dId,
      };
    } else if (index == 9) {
      postData = {
        "user": getUidVariable2,
        "date1": cutDate,
        "timing1": _alarmTimeString,
        "pin10Status": sliderValue,
        "d_id": dId,
      };
    } else if (index == 10) {
      postData = {
        "user": getUidVariable2,
        "date1": cutDate,
        "timing1": _alarmTimeString,
        "pin11Status": sliderValue,
        "d_id": dId,
      };
    } else if (index == 11) {
      postData = {
        "user": getUidVariable2,
        "date1": cutDate,
        "timing1": _alarmTimeString,
        "pin12Status": sliderValue,
        "d_id": dId,
      };
    }
    final response =
        await http.post(Uri.parse(url), body: jsonEncode(postData), headers: {
      'Authorization': 'Token $token',
      'Content-Type': 'application/json; charset=UTF-8',
    });
    if (response.statusCode == 200 || response.statusCode == 201) {
      const snackBar = SnackBar(content: Text("Scheduled"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      await getAndUpdateScheduledPins(dId);
    }
  }

  _createAlertDialogForPinSchedule(BuildContext context, String dId) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Device Id $dId',
            ),
            content: Container(
              color: Colors.red,
              width: MediaQuery.of(context).size.width,
              child: FutureBuilder(
                  future: pinScheduledFuture,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          itemCount: schedulePin.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Card(
                                semanticContainer: true,
                                shadowColor: Colors.grey,
                                child: Column(
                                  children: [
                                    ListTile(
                                        title: Text(
                                          schedulePin[index].dId,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                        trailing: Text(schedulePin[index]
                                            .date1
                                            .toString()
                                            .substring(0, 10)),
                                        subtitle: Text(schedulePin[index]
                                            .timing1
                                            .toString()),
                                        onTap: () {}),
                                    Column(
                                      children: [
                                        SizedBox(
                                          height: 54,
                                          child: ListView.builder(
                                              itemCount: 1,
                                              itemBuilder: (context, index) {
                                                if (schedulePin[index]
                                                            .pin1Status ==
                                                        0 ||
                                                    schedulePin[index]
                                                            .pin1Status ==
                                                        1) {
                                                  return Row(
                                                    children: [
                                                      Text(schedulePin[index]
                                                                  .pin1Status ==
                                                              0
                                                          ? devicePin[index]
                                                                  .pin1Name +
                                                              " Off "
                                                          : devicePin[index]
                                                                  .pin1Name +
                                                              " On ")
                                                    ],
                                                  );
                                                } else if (schedulePin[index]
                                                            .pin2Status ==
                                                        0 ||
                                                    schedulePin[index]
                                                            .pin2Status ==
                                                        1) {
                                                  return Row(
                                                    children: [
                                                      Text(schedulePin[index]
                                                                  .pin2Status ==
                                                              0
                                                          ? devicePin[index]
                                                                  .pin2Name +
                                                              " Off "
                                                          : devicePin[index]
                                                                  .pin2Name +
                                                              " On ")
                                                    ],
                                                  );
                                                } else if (schedulePin[index]
                                                            .pin3Status ==
                                                        0 ||
                                                    schedulePin[index]
                                                            .pin3Status ==
                                                        1) {
                                                  return Row(
                                                    children: [
                                                      Text(schedulePin[index]
                                                                  .pin3Status ==
                                                              0
                                                          ? devicePin[index]
                                                                  .pin3Name +
                                                              " Off "
                                                          : devicePin[index]
                                                                  .pin3Name +
                                                              " On ")
                                                    ],
                                                  );
                                                } else if (schedulePin[index]
                                                            .pin4Status ==
                                                        0 ||
                                                    schedulePin[index]
                                                            .pin4Status ==
                                                        1) {
                                                  return Row(
                                                    children: [
                                                      Text(schedulePin[index]
                                                                  .pin4Status ==
                                                              0
                                                          ? devicePin[index]
                                                                  .pin4Name +
                                                              " Off "
                                                          : devicePin[index]
                                                                  .pin4Name +
                                                              " On ")
                                                    ],
                                                  );
                                                } else if (schedulePin[index]
                                                            .pin5Status ==
                                                        0 ||
                                                    schedulePin[index]
                                                            .pin5Status ==
                                                        1) {
                                                  return Row(
                                                    children: [
                                                      Text(schedulePin[index]
                                                                  .pin5Status ==
                                                              0
                                                          ? devicePin[index]
                                                                  .pin5Name +
                                                              " Off "
                                                          : devicePin[index]
                                                                  .pin5Name +
                                                              " On ")
                                                    ],
                                                  );
                                                } else if (schedulePin[index]
                                                            .pin6Status ==
                                                        0 ||
                                                    schedulePin[index]
                                                            .pin6Status ==
                                                        1) {
                                                  return Row(
                                                    children: [
                                                      Text(schedulePin[index]
                                                                  .pin6Status ==
                                                              0
                                                          ? devicePin[index]
                                                                  .pin6Name +
                                                              " Off "
                                                          : devicePin[index]
                                                                  .pin6Name +
                                                              " On ")
                                                    ],
                                                  );
                                                } else if (schedulePin[index]
                                                            .pin7Status ==
                                                        0 ||
                                                    schedulePin[index]
                                                            .pin7Status ==
                                                        1) {
                                                  return Row(
                                                    children: [
                                                      Text(schedulePin[index]
                                                                  .pin7Status ==
                                                              0
                                                          ? devicePin[index]
                                                                  .pin7Name +
                                                              " Off "
                                                          : devicePin[index]
                                                                  .pin7Name +
                                                              " On ")
                                                    ],
                                                  );
                                                } else if (schedulePin[index]
                                                            .pin8Status ==
                                                        0 ||
                                                    schedulePin[index]
                                                            .pin8Status ==
                                                        1) {
                                                  return Row(
                                                    children: [
                                                      Text(schedulePin[index]
                                                                  .pin8Status ==
                                                              0
                                                          ? devicePin[index]
                                                                  .pin8Name +
                                                              " Off "
                                                          : devicePin[index]
                                                                  .pin8Name +
                                                              " On ")
                                                    ],
                                                  );
                                                } else if (schedulePin[index]
                                                            .pin9Status ==
                                                        0 ||
                                                    schedulePin[index]
                                                            .pin9Status ==
                                                        1) {
                                                  return Row(
                                                    children: [
                                                      Text(schedulePin[index]
                                                                  .pin9Status ==
                                                              0
                                                          ? devicePin[index]
                                                                  .pin9Name +
                                                              " Off "
                                                          : devicePin[index]
                                                                  .pin9Name +
                                                              " On ")
                                                    ],
                                                  );
                                                } else if (schedulePin[index]
                                                            .pin10Status ==
                                                        0 ||
                                                    schedulePin[index]
                                                            .pin10Status ==
                                                        1) {
                                                  return Row(
                                                    children: [
                                                      Text(schedulePin[index]
                                                                  .pin10Status ==
                                                              0
                                                          ? devicePin[index]
                                                                  .pin10Name +
                                                              " Off "
                                                          : devicePin[index]
                                                                  .pin10Name +
                                                              " On ")
                                                    ],
                                                  );
                                                } else if (schedulePin[index]
                                                            .pin11Status ==
                                                        0 ||
                                                    schedulePin[index]
                                                            .pin11Status ==
                                                        1) {
                                                  return Row(
                                                    children: [
                                                      Text(schedulePin[index]
                                                                  .pin11Status ==
                                                              0
                                                          ? devicePin[index]
                                                                  .pin11Name +
                                                              " Off "
                                                          : devicePin[index]
                                                                  .pin11Name +
                                                              " On ")
                                                    ],
                                                  );
                                                } else if (schedulePin[index]
                                                            .pin12Status ==
                                                        0 ||
                                                    schedulePin[index]
                                                            .pin12Status ==
                                                        1) {
                                                  return Row(
                                                    children: [
                                                      Text(schedulePin[index]
                                                                  .pin12Status ==
                                                              0
                                                          ? devicePin[index]
                                                                  .pin12Name +
                                                              " Off "
                                                          : devicePin[index]
                                                                  .pin12Name +
                                                              " On ")
                                                    ],
                                                  );
                                                }
                                                return Container();
                                              }),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          });
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  }),
            ),
            actions: const <Widget>[],
          );
        });
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

                  await getPinStatusData(dId);
                  await getPinStatusByDidLocal(dId.toString());
                } else if (result == ConnectivityResult.mobile) {
                  responseGetData.replaceRange(0, responseGetData.length,
                      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]);
                  await dataUpdate(dId);
                  await getPinStatusData(dId);
                  await getPinStatusByDidLocal(dId.toString());
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

  _createAlertDialogForAddRoomDeleteDevices(context, String rId, int index) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              'Choose One',
              style: TextStyle(fontSize: 20),
            ),
            content: SizedBox(
              height: 120,
              child: Column(
                children: [
                  TextButton(
                    child: const Text(
                      'Edit Room Name',
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      _editRoomNameAlertDialog(context, index);
                    },
                  ),
                  TextButton(
                    child: const Text(
                      'Delete Room',
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      _showDialogForDeleteRoomWithAllDevices(rId);
                    },
                  ),
                ],
              ),
            ),
            actions: const <Widget>[],
          );
        });
  }

  _editRoomNameAlertDialog(BuildContext context, index) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Enter Room Name"),
            content: TextField(
              controller: roomNameEditing,
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MaterialButton(
                  // elevation: 5.0,
                  child: const Text('Submit'),
                  onPressed: () async {
                    await addRoomName(roomNameEditing.text, index);
                    Navigator.of(context).pop();
                  },
                ),
              )
            ],
          );
        });
  }

  Future<void> addRoomName(String data, int index) async {
    String? token = await getToken();

    var url = api + 'addroom/?r_id=' + tabbarState;
    var postDataRoomName = {
      "r_id": tabbarState,
      "flt_id": widget.flat!.fltId,
      "r_name": data,
      "user": getUidVariable2,
    };
    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(postDataRoomName),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (kDebugMode) {
        print(jsonDecode(response.body));
      }
      setState(() {
        widget.rm![index].rName = data;
      });
      await AllDatabase.instance.updateRoomDataForName(widget.rm![index]);
      return;
    } else {
      if (kDebugMode) {
        print(response.statusCode);
        print(response.body);
      }
      return;
    }
  }

  _showDialogForDeleteRoomWithAllDevices(String rId) {
    // dialog implementation
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Alert"),
        content: const Text("Are your sure to delete room with all devices"),
        actions: <Widget>[
          // ignore: deprecated_member_use
          ElevatedButton(
              child: const Text("Yes"),
              onPressed: () async {
                await deleteRoomWithAllDevice(rId);
                Navigator.pop(context);
                // await getRoomAfterDeletingRoom();
                await roomQueryFunc(widget.flat!.fltId);

                // await getAllDevice();
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

  Future<void> deleteRoomWithAllDevice(String rId) async {
    String? token = await getToken();
    final url = api + 'addroom/?r_id=' + rId;
    final response = await http.delete(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Token $token',
    });
    if (response.statusCode == 200) {
      await AllDatabase.instance.deleteRoomModel(rId);

      await deleteDatabaseLocalDeviceAll(rId);
      const snackBar = SnackBar(
        content: Text('Device Deleted'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      if (kDebugMode) {
        print(response.statusCode);
      }
      const snackBar = SnackBar(
        content: Text('Something went wrong'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  deleteDatabaseLocalDeviceAll(rId) async {
    List deviceByRoom = await AllDatabase.instance.getDeviceById(rId);

    if (deviceByRoom.isNotEmpty) {
      for (int i = 0; i < deviceByRoom.length; i++) {
        await AllDatabase.instance.deleteDeviceModel(rId);
        await AllDatabase.instance
            .deleteDevicePinStatusModel(deviceByRoom[i]['d_id']);
        await AllDatabase.instance
            .deleteDevicePinNameModel(deviceByRoom[i]['d_id']);
      }
    }
  }

  _logout() {
    return AwesomeDialog(
      context: context,
      dialogType: DialogType.QUESTION,
      animType: AnimType.BOTTOMSLIDE,
      title: 'Log Out',
      desc: 'Are you sure want to logout ??..',
      btnCancelOnPress: () {
        return null;
      },
      btnOkOnPress: () async {
        await storage.delete(key: "token");
        await AllDatabase.instance.deleteDatabase();
        // timer!.cancel();

        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const GettingStartedScreen()));
      },
    )..show();
  }

  exitScreen() {
    // dialog implementation
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: const Text("Are you sure to want exit ??"),
        actions: <Widget>[
          ElevatedButton(onPressed: () {}, child: const Text("Yes")),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("No")),
        ],
      ),
    );
  }

  _exitScreen() {
    return AwesomeDialog(
      context: context,
      dialogType: DialogType.QUESTION,
      animType: AnimType.BOTTOMSLIDE,
      title: 'Exit !!',
      desc: 'Are you sure want to Exit ??..',
      btnCancelOnPress: () {
        return null;
      },
      btnOkOnPress: () async {
        exit(0);
      },
    )..show();
  }

  oops() {
    return AwesomeDialog(
      context: context,
      dialogType: DialogType.ERROR,
      animType: AnimType.BOTTOMSLIDE,
      title: 'Oops !!',
      desc: 'Access Denied',
      btnCancelOnPress: () {
        Navigator.of(context).pop();
      },
    )..show();
  }

  noInternet() {
    return AwesomeDialog(
      context: context,
      dialogType: DialogType.ERROR,
      animType: AnimType.BOTTOMSLIDE,
      title: 'Oops !!',
      desc: 'No Connection',
      btnCancelOnPress: () {
        return null;
      },
    )..show();
  }

  loadingContainer() {
    return CircularProgressIndicator(
      color: changeColor ?? Colors.blue,
    );
  }

  _getTempNumber() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('mobileNumber');
  }

  _createAlertDialogForDeleteFlatAndAddFlat(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              'Choose One',
              style: TextStyle(fontSize: 20),
            ),
            content: SizedBox(
              height: MediaQuery.of(context).size.height / 4.9,
              child: Column(
                children: [
                  TextButton(
                    child: const Text(
                      'Add Flat',
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      _createAlertDialogForFlat(context);
                    },
                  ),
                  TextButton(
                    child: const Text(
                      'Delete Flat',
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () async {
                      deleteFlatOption(context);
                    },
                  ),
                  TextButton(
                    child: const Text(
                      'Edit Flat Name',
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      _editFlatNameAlertDialog(context);
                    },
                  ),
                ],
              ),
            ),
            actions: const <Widget>[],
          );
        });
  }

  _editFlatNameAlertDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Enter Flat Name"),
            content: TextField(
              controller: flatNameEditing,
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MaterialButton(
                  // elevation: 5.0,
                  child: const Text('Submit'),
                  onPressed: () async {
                    await addFlatName(flatNameEditing.text);
                    Navigator.of(context).pop();
                  },
                ),
              )
            ],
          );
        });
  }

  Future<void> addFlatName(String data) async {
    String? token = await getToken();
    const url = api + 'addyourflat/';
    var postDataFlatName = {
      "flt_id": widget.flat!.fltId,
      "flt_name": data,
      "user": getUidVariable2,
    };
    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(postDataFlatName),
    );

    if (response.statusCode == 201) {
      if (kDebugMode) {
        print(response.body);
      }

      setState(() {
        widget.flat!.fltName = flatNameEditing.text;
      });
      await AllDatabase.instance.updateFlatDataForName(widget.flat!);

      return;
    } else {
      if (kDebugMode) {
        print('FlatResposne ${response.statusCode}');
      }
    }
  }

  _createAlertDialogForFlat(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Enter the Name of Flat'),
            content: SizedBox(
              height: MediaQuery.of(context).size.height / 3.5,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    autofocus: true,
                    controller: flatEditing,
                    textInputAction: TextInputAction.next,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    style: const TextStyle(fontSize: 18, color: Colors.black54),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.place),
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Enter Flat Name',
                      contentPadding: const EdgeInsets.all(15),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    autofocus: true,
                    controller: roomEditing,
                    textInputAction: TextInputAction.next,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    style: const TextStyle(fontSize: 18, color: Colors.black54),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.place),
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Enter Room Name',
                      contentPadding: const EdgeInsets.all(15),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MaterialButton(
                      elevation: 5.0,
                      child: const Text('Submit'),
                      onPressed: () async {
                        await addFlat(flatEditing.text);

                        Navigator.of(context).pop();
                        const snackBar = SnackBar(
                          content: Text('Floor Added'),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        await getAllCurrentFlat();
                        await getAllRoomByAddedFlat();
                      },
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  Future addFlat(flatName) async {
    String? token = await getToken();
    const url = api + "addyourflat/";
    var postData = {
      "user": getUidVariable2,
      "flt_name": flatName,
      "f_id": widget.fl!.fId,
    };
    final response =
        await http.post(Uri.parse(url), body: jsonEncode(postData), headers: {
      'Authorization': 'Token $token',
      'Content-Type': 'application/json; charset=UTF-8',
    });
    if (response.statusCode == 201 || response.statusCode == 200) {
      flatResponse = jsonDecode(response.body);

      await addRoom2(flatResponse, roomEditing.text);
    } else {
      if (kDebugMode) {
        print(response.statusCode);
      }
    }
  }

  Future getAllCurrentFlat() async {
    String? token = await getToken();
    var url = api + "addyourflat/?f_id=" + widget.fl!.fId;
    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Token $token',
    });
    if (response.statusCode == 200) {
      List allFlat = await AllDatabase.instance.getFlatByFId(widget.fl!.fId);
      for (int i = 0; i < allFlat.length; i++) {
        await AllDatabase.instance
            .deleteFlatModel(allFlat[i]['flt_id'].toString());
      }
      List flatData = jsonDecode(response.body);
      for (int i = 0; i < flatData.length; i++) {
        var flatQuery = FlatType(
            fId: flatData[i]['f_id'],
            fltId: flatData[i]['flt_id'],
            fltName: flatData[i]['flt_name'],
            user: flatData[i]['user']);
        await AllDatabase.instance.insertFlatModelData(flatQuery);
      }
    }
  }

  deleteFlatOption(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Select Flat'),
            content: Container(
              color: Colors.amber,
              width: 78,
              child: ListView.builder(
                  itemCount: listOfAllFlat.length,
                  itemBuilder: (context, index) {
                    return Container(
                      color: Colors.blueGrey,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          semanticContainer: true,
                          shadowColor: Colors.grey,
                          child: Column(
                            children: <Widget>[
                              ListTile(
                                title: Text(listOfAllFlat[index]['flt_name']),
                              ),
                              // ignore: deprecated_member_use
                              ElevatedButton(
                                child: const Text('Delete Flat'),
                                onPressed: () async {
                                  if (widget.flat!.fltId.contains(
                                      listOfAllFlat[index]['flt_id']
                                          .toString())) {
                                    oops();
                                  } else {
                                    setState(() {
                                      deletedFlatId = listOfAllFlat[index]
                                              ['flt_id']
                                          .toString();
                                    });
                                    await deleteFlat(deletedFlatId);
                                    Navigator.of(context).pop();
                                  }
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          );
        });
  }

  Future<void> deleteFlat(String fltId) async {
    String? token = await getToken();
    final url = api + 'addyourflat/?flt_id=' + fltId;
    final response = await http.delete(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Token $token',
    });
    if (response.statusCode == 200 || response.statusCode == 201) {
      await AllDatabase.instance.deleteFlatModel(fltId);
      listOfAllFlat = await AllDatabase.instance.getFlatByFId(widget.fl!.fId);

      const snackBar = SnackBar(
        content: Text('Flat Deleted'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      await deleteDatabaseLocalRoomAllUsingFlatId(deletedFlatId);
    } else {
      const snackBar = SnackBar(
        content: Text('Something went wrong'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  deleteDatabaseLocalRoomAllUsingFlatId(fltId) async {
    List roomByFlat = await AllDatabase.instance.getRoomById(fltId);
    List roomDevice = [];
    if (kDebugMode) {
      print(roomByFlat);
    }
    if (roomByFlat.isNotEmpty) {
      for (int i = 0; i < roomByFlat.length; i++) {
        await AllDatabase.instance.deleteRoomModel(fltId);
      }
      for (int i = 0; i < roomByFlat.length; i++) {
        roomDevice = await AllDatabase.instance
            .getDeviceById(roomByFlat[i]['r_id'].toString());
      }
      for (int i = 0; i < roomDevice.length; i++) {
        await AllDatabase.instance.deleteDeviceModel(roomDevice[i]['d_id']);
        await AllDatabase.instance
            .deleteDevicePinNameModel(roomDevice[i]['d_id']);
        await AllDatabase.instance
            .deleteDevicePinStatusModel(roomDevice[i]['d_id']);
      }
    }
  }

  _createAlertDialogForAddMembers(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: SizedBox(
              height: 105,
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.supervised_user_circle_rounded,
                        color: Colors.deepOrange,
                      ),
                      TextButton(
                        child: const Text(
                          'Sub User',
                          style: TextStyle(fontSize: 20),
                        ),
                        onPressed: () {
                          // timer!.cancel();

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ShowAndAddSubUser()));
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.supervised_user_circle_rounded,
                        color: Colors.deepOrange,
                      ),
                      TextButton(
                        child: const Text(
                          'Temporary User',
                          style: TextStyle(fontSize: 20),
                        ),
                        onPressed: () {
                          // timer!.cancel();

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ShowTempUser()));
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: const <Widget>[],
          );
        });
  }

  Future getSubUsers(email) async {
    if (kDebugMode) {
      print("getting Into SubUser");
    }
    String? token = await getToken();
    var url = api + 'subfindsubdata/?email=' + email;
    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Token $token',
    });

    if (response.statusCode == 200) {
      List<dynamic> ans = jsonDecode(response.body);
      List<dynamic> getSubDataLocal = await AllDatabase.instance.getAllSUbAccess();
      if(ans.length != getSubDataLocal.length ){
        print("Not ");
        await AllDatabase.instance.deleteSubAccess();

        for (int i = 0; i < ans.length; i++) {
          allgetSubUsers.add(ans[i]);
          var query = SubAccessModel.fromJson(ans[i]);
          print("insert $allgetSubUsers ");

          await AllDatabase.instance.insertSubAccess(query);
          List<dynamic> getSubDataLocal1 = await AllDatabase.instance.getAllSUbAccess();
          print("insert   ${getSubDataLocal1}");
          await getPlaceNameSubAccess();
        }
      }else{
        print("Else");

        await getPlaceNameSubAccess();
      }

    } else {
      if (kDebugMode) {
        print(response.statusCode);
      }
    }
  }

  Future getPlaceNameSubAccess() async {
    String? token = await getToken();
    var listAllPlaceData = List.empty(growable: true);
    List<dynamic> allgetSubUsers = await AllDatabase.instance.getAllSUbAccess();
    for (int i = 0; i < allgetSubUsers.length; i++) {
      var pId = allgetSubUsers[i]['p_id'].toString();
      print("PPPP $pId");
      var url = api + 'getyouplacename/?p_id=' + pId;
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Token $token',
      });
      if (response.statusCode == 200) {
        List ans = jsonDecode(response.body);

        for(int i=0;i<ans.length;i++){
          listAllPlaceData.add(ans[i]);
        }



        print("ans $listAllPlaceData");


      } else {
        if (kDebugMode) {
          print(response.body);
        }
      }
    }
    List<dynamic> ans = await AllDatabase.instance.getAllPlacesSubAccess();
    print("allData $ans");

    if(listAllPlaceData.length != ans.length){
      await AllDatabase.instance.deleteAllPlacesSubAccess();
      for (int i = 0; i < listAllPlaceData.length; i++) {
         var place = SubAccessPlace.fromJson(listAllPlaceData[i]);
        await AllDatabase.instance.insertAllPlacesSubAccess(place);
      }
      List<dynamic> ans1 = await AllDatabase.instance.getAllPlacesSubAccess();
      print("allData $ans1");

      await getAllFloorSubAccess();
    }else{
      await getAllFloorSubAccess();

    }





  }

  Future getAllFloorSubAccess() async {
    String? token = await getToken();
    List<dynamic> allPlacegetSubUsers = await AllDatabase.instance.getAllPlacesSubAccess();
    var allFloorgetSubUsers = List.empty(growable:true);
    for (int i = 0; i < allPlacegetSubUsers.length; i++) {
      var placeId = allPlacegetSubUsers[i]['p_id'].toString();
      final url = api + 'getallfloorsbyonlyplaceidp_id/?p_id=' + placeId;
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Token $token',
      });
      if (response.statusCode == 200) {
        List ans = jsonDecode(response.body);
        for (int i = 0; i < ans.length; i++) {
          allFloorgetSubUsers.add(ans[i]);
        }
        if (kDebugMode) {
          print("AllFloorSubAccess $allFloorgetSubUsers");
        }

      } else {
        if (kDebugMode) {
          print(response.statusCode);
          print(response.body);
        }
      }
      List<dynamic> allFloorLocal = await AllDatabase.instance.getAllFloorSubAccess();
      if(allFloorLocal.length != allFloorgetSubUsers.length){
        await AllDatabase.instance.deleteAllFloorSubAccess();
        for(int i=0;i<allFloorgetSubUsers.length;i++){
          var subAccessFloor = SubAccessFloor.fromJson(allFloorgetSubUsers[i]);
          await AllDatabase.instance.insertAllFloorsSubAccess(subAccessFloor);
        }
        await getAllFlatSubAccess();
      }else{
        await getAllFlatSubAccess();
      }

    }
  }

  Future getAllFlatSubAccess() async {
    String? token = await getToken();
    List<dynamic> allFloorgetSubUsers = await AllDatabase.instance.getAllFloorSubAccess();
    var allFlatgetSubUsers = List.empty(growable:true);
    for (int i = 0; i < allFloorgetSubUsers.length; i++) {
      var fId = allFloorgetSubUsers[i]['f_id'].toString();
      var url = api + 'getallflatbyonlyflooridf_id/?f_id=' + fId;
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Token $token',
      });
      if (response.statusCode == 200) {
        List<dynamic> ans = jsonDecode(response.body);
        for (int i = 0; i < ans.length; i++) {
          allFlatgetSubUsers.add(ans[i]);

        }

      } else {
        if (kDebugMode) {
          print(response.statusCode);
          print(response.body);
        }
      }
    }
    List<dynamic> allFlatLocal = await AllDatabase.instance.getAllFlatSubAccess();
    if(allFlatLocal.length != allFlatgetSubUsers.length){
      await AllDatabase.instance.deleteAllFlatSubAccess();

      for(int i=0;i<allFlatgetSubUsers.length;i++){
        var subAccessFlat = SubAccessFlat.fromJson(allFlatgetSubUsers[i]);
        await AllDatabase.instance.insertAllFlatSubAccess(subAccessFlat);
      }
      await getAllRoomSubAccess();
    }else{

      await getAllRoomSubAccess();
    }
  }

  Future getAllRoomSubAccess() async {
    String? token = await getToken();
    List<dynamic> allFlatgetSubUsers = await AllDatabase.instance.getAllFlatSubAccess();
    var allRoomgetSubUsers = List.empty(growable:true);
    for (int i = 0; i < allFlatgetSubUsers.length; i++) {
      var flatId = allFlatgetSubUsers[i]['flt_id'].toString();
      var url = api + 'getallroomsbyonlyflooridf_id/?flt_id=' + flatId;
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Token $token',
      });
      if (response.statusCode == 200) {
        List ans = jsonDecode(response.body);

        for(int i=0;i<ans.length;i++){
          allRoomgetSubUsers.add(ans[i]);
        }

      } else {
        if (kDebugMode) {
          print(response.statusCode);
          print(response.body);
        }
      }
    }
      List<dynamic> allRoomLocal = await AllDatabase.instance.getAllRoomSubAccess();

    if(allRoomLocal.length != allRoomgetSubUsers.length){
      await AllDatabase.instance.deleteAllRoomSubAccess();
      for (int i = 0; i < allRoomgetSubUsers.length; i++) {

        var subAccessRoom = SubAccessRoom.fromJson(allRoomgetSubUsers[i]);
        await AllDatabase.instance.insertAllRoomSubAccess(subAccessRoom);
      }

      await getAllDeviceSubAccess();
    }else{

      await getAllDeviceSubAccess();
    }






  }

  Future getAllDeviceSubAccess() async {
    String? token = await getToken();
    List<dynamic> allRoomgetSubUsers = await AllDatabase.instance.getAllRoomSubAccess();
    var allDeviceData = List.empty(growable:true);
    var allDevicegetSubUsers = List.empty(growable:true);
    for (int i = 0; i < allRoomgetSubUsers.length; i++) {
      var rId = allRoomgetSubUsers[i]['r_id'].toString();
      var url = api + 'getalldevicesbyonlyroomidr_id/?r_id=' + rId;
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Token $token',
      });
      if (response.statusCode == 200) {
        if (kDebugMode) {
          print("getLdevice ${response.body}");
        }
        List<dynamic> ans = jsonDecode(response.body);
        for(int i=0;i<ans.length;i++){
          allDevicegetSubUsers.add(ans[i]);
        }
      } else {
        if (kDebugMode) {
          print(response.statusCode);
          print(response.body);
        }
      }
    }
      List getAllDeviceSubAccessList = await AllDatabase.instance.getAllDeviceSubAccess();
    if(getAllDeviceSubAccessList.length != allDevicegetSubUsers.length){
      await AllDatabase.instance.deleteAllDeviceSubAccess();
      for (int i = 0; i < allDevicegetSubUsers.length; i++) {

        var subAccessDevice = SubAccessDevice.fromJson(allDevicegetSubUsers[i]);
        await AllDatabase.instance.insertAllDeviceSubAccess(subAccessDevice);
      }
    }
    List getAllDeviceSubAccessList1 = await AllDatabase.instance.getAllDeviceSubAccess();
    print("OUT OF IF $getAllDeviceSubAccessList1");

    await getAllPinStatusSubAcess();
  }

  Future getAllPinStatusSubAcess() async {

    String? token = await getToken();
    List allDevicegetSubUsers = await AllDatabase.instance.getAllDeviceSubAccess();
    var allDevicePinStatusList = List.empty(growable: true);
    for (int i = 0; i < allDevicegetSubUsers.length; i++) {
      var dId = allDevicegetSubUsers[i]['d_id'];
      String url = api + "getpostdevicePinStatus/?d_id=" + dId.toString();
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Token $token',
      });
      if (response.statusCode == 200) {
        var ans = jsonDecode(response.body);


        allDevicePinStatusList.add(ans);
        print("PINSTATAAAA $allDevicePinStatusList");
        await getAllPinNameSubAccess();
      } else {
        if (kDebugMode) {
          print(response.statusCode);
        }
      }
    }
    List<dynamic> pinStatusLocal = await AllDatabase.instance.subAccessGetAllPinStatus();
    if(allDevicePinStatusList.length != pinStatusLocal.length){
      await AllDatabase.instance.deleteAllDevicePinStatusSubAccess();

      for (int i = 0; i < allDevicePinStatusList.length; i++) {
        var devicePinStatus = DevicePinStatus.fromJson(allDevicePinStatusList[i]);
        await AllDatabase.instance
            .insertAllDevicePinStatusSubAccess(devicePinStatus);
      }
      await getAllPinNameSubAccess();
    }
    await getAllPinNameSubAccess();

  }

  Future getAllPinNameSubAccess() async {
    String? token = await getToken();
    List allDevicegetSubUsers = await AllDatabase.instance.getAllDeviceSubAccess();
    var allDevicePinNameList = List.empty(growable: true);
    for (int i = 0; i < allDevicegetSubUsers.length; i++) {
      var did = allDevicegetSubUsers[i]['d_id'];
      String url = api + "editpinnames/?d_id=" + did;
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Token $token',
      });
      if (response.statusCode == 200) {

        var ans = jsonDecode(response.body);

        allDevicePinNameList.add(ans);
        print("allDevicePinNameList $allDevicePinNameList");

      } else {
        if (kDebugMode) {
          print(response.statusCode);
        }
      }
    }
    List <dynamic> getAllPinName = await AllDatabase.instance.getAllPinNameSubAccess();
    print("getAllPinName $getAllPinName");
    if(allDevicePinNameList.length != getAllPinName.length){
      await AllDatabase.instance.deleteAllDevicePinNameSubAccess();
      for (int i = 0; i < allDevicePinNameList.length; i++) {
        var devicePinNamesQuery = DevicePinName.fromJson(allDevicePinNameList[i]);
        await AllDatabase.instance
            .insertAllDevicePinNameSubAccess(devicePinNamesQuery);
      }
    }

    allgetSubUsers = List.empty(growable: true);
    allPlacegetSubUsers = List.empty(growable: true);
    allFloorgetSubUsers = List.empty(growable: true);
    allFlatgetSubUsers = List.empty(growable: true);
    allRoomgetSubUsers = List.empty(growable: true);
    allDevicegetSubUsers = List.empty(growable: true);
  }


  Future _setTempNumber(mobile) async {
    final pref = await SharedPreferences.getInstance();
    pref.setString('mobileNumber', mobile);
  }

  _showDialogForTempAccessPge() {
    // dialog implementation
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: const Text("Enter your Mobile Number"),
        actions: <Widget>[
          // ignore: deprecated_member_use
          Form(
            key: formKey,
            child: TextFormField(
              autofocus: true,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: phoneController,
              // onSaved: (String value) {
              //   phone = value;
              // },
              style: const TextStyle(fontSize: 18, color: Colors.black54),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.phone_android),
                filled: true,
                fillColor: Colors.white,
                hintText: 'Enter your Contact',
                errorStyle: const TextStyle(),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.circular(50),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.circular(50),
                ),
                contentPadding: const EdgeInsets.all(15),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(50),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
          ),
          // ignore: deprecated_member_use
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // ignore: deprecated_member_use
              ElevatedButton(
                  child: const Text("Submit"),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      var mobile = phoneController.text;
                      _setTempNumber(mobile);
                      // timer!.cancel();

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ListOfTempAccessPage(
                                    mobileNumber: mobile,
                                  )));
                    }
                  }),
              ElevatedButton(
                  child: const Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ],
          ),
        ],
      ),
    );
  }


}
