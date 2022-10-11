// ignore_for_file: deprecated_member_use, prefer_typing_uninitialized_variables, unused_local_variable

import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:genorion_mac_android/AddPlace/addplace.dart';
import 'package:genorion_mac_android/HomeUi/homepage.dart';
import 'package:genorion_mac_android/Models/flatmodel.dart';
import 'package:genorion_mac_android/Models/pinname.dart';
import 'package:genorion_mac_android/Models/pinschedule.dart';
import 'package:genorion_mac_android/ProfilePage/utility.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../LocalDatabase/alldb.dart';
import '../Models/devicemodel.dart';
import '../Models/floormodel.dart';
import '../Models/pinstatus.dart';
import '../Models/placemodel.dart';
import '../Models/roommodel.dart';
import '../Models/sensor.dart';
import '../Models/userprofike.dart';
import '../Styles/style.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../main.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isVisible = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  static bool isHiddenPassword = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  var storage = const FlutterSecureStorage();
  PlaceType? pt;
  FloorType? fl;
  FlatType? flat;
  List<RoomType> rm = [];
  List<DeviceType> dv = [];
  List placeData = [];
  List floorData = [];
  List flatData = [];
  List roomData = [];
  List deviceData = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff121421),
      body: isVisible
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.amber,
              ),
            )
          : SafeArea(
              child: Form(
                key: formKey,
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 28,
                        right: 18,
                        top: 36,
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
                              Text("",
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
                                  //   Icons.notifications,
                                  //   color: Colors.white,
                                  // ),
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 56,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                      ),
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const SizedBox(
                            height: 25,
                          ),
                          const Text(
                            'Sign In',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'OpenSans',
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 55,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                              // color: Color(0xFF6CA8F1),
                              color: Colors.white70,
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 6.0,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            height: 60.0,
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              controller: emailController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter email';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.emailAddress,
                              style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'OpenSans',
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(top: 14.0),
                                prefixIcon: Icon(
                                  Icons.email,
                                  color: Colors.white,
                                ),
                                hintText: 'Email ',
                                // hintStyle: kHintTextStyle,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                              // color: Color(0xFF6CA8F1),
                              color: Colors.white70,
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 6.0,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            height: 60.0,
                            child: TextFormField(
                              controller: passwordController,
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter password';
                                }
                                return null;
                              },
                              obscureText: isHiddenPassword,
                              style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'OpenSans',
                              ),
                              decoration:  InputDecoration(
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.only(top: 14.0),
                                prefixIcon: const Icon(
                                  Icons.security,
                                  color: Colors.white,
                                ),
                                suffixIcon: InkWell(
                                    onTap: togglePassword,
                                    child: Icon(isHiddenPassword == true
                                        ? Icons.visibility
                                        : Icons.visibility_off)),
                                hintText: 'confirm password',
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          _buildForgotPasswordBtn(),
                          _buildLoginBtn()
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
  void togglePassword() {
    setState(() {
      isHiddenPassword = !isHiddenPassword;
    });
  }



  Widget _buildForgotPasswordBtn() {
    return Container(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        onPressed: () {
         Utility.launchURL('https://genorion1.herokuapp.com/reset_password/');
        },
        // padding: const EdgeInsets.only(right: 0.0),
        child: const Text(
          'Forgot Password?',
          style: kLabelStyle,
        ),
      ),
    );
  }

  Widget _buildLoginBtn() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: ElevatedButton(
        // elevation: 5.0,
        onPressed: () {
          if (formKey.currentState!.validate()) {
            goToNextPage();
          } else {}
        },
        // padding: const EdgeInsets.all(15.0),
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.circular(30.0),
        // ),
        // color: Colors.white,
        child: const Text(
          'LOGIN',
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  goToNextPage() async {
    formKey.currentState!.save();
    if (kDebugMode) {
      print('clear');
    }

    await checkDetails();
  }

  checkDetails() async {
    setState(() {
      isVisible = true;
    });
    const url = api + 'api-token-auth/';

    var map = <String, dynamic>{};
    map['username'] = emailController.text;
    map['password'] = passwordController.text;

    final response = await http.post(Uri.parse(url), body: map);
    if (response.statusCode == 200) {
      Map<String, dynamic> map = jsonDecode(response.body);
      const storage = FlutterSecureStorage();
      await storage.write(key: "token", value: map["token"]);
      final all = await storage.readAll();

      if (kDebugMode) {
        print(all);
      }
      await getUid();
      await checkUserPlace();
    }

    if (response.statusCode == 400) {
      //  final snackBar=SnackBar(content: Text('Login Successful')
      // Navigator.push(context, MaterialPageRoute(builder: (context)=>WrongPassword()));
      _wrongPassword();

      throw ("Wrong Credentials");
    }
    if (response.statusCode == 500) {
      throw ("Internal Server Error");
    } else {
      if (kDebugMode) {
        print(response.statusCode);
      }
    }
  }

  _wrongPassword() {
    return AwesomeDialog(
      context: context,
      dialogType: DialogType.ERROR,
      animType: AnimType.BOTTOMSLIDE,
      title: 'Oops !!',
      desc: 'Wrong Credentials',
      // btnCancelOnPress: () {
      //   return null;
      // },
      btnOkOnPress: () async {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      },
    )..show();
  }

  Future<String?> getToken() async {
    final token = await storage.read(key: "token");
    return token;
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
      placeData = jsonDecode(response.body);
      if (kDebugMode) {
        print('userplace $placeData');
      }
      if (placeData.isEmpty) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const AddPlace()));
      } else {
        for (int i = 0; i < placeData.length; i++) {
          var placeQuery = PlaceType.fromJson(placeData[i]);
          AllDatabase.instance.insertPlaceModelData(placeQuery);
        }
        List ans = await AllDatabase.instance.queryPlace();

        await getAllFloor();
      }
    }
  }

  var floorList = List.empty(growable: true);
  var flatList = List.empty(growable: true);
  var roomList = List.empty(growable: true);
  var deviceList = List.empty(growable: true);

  Future<void> getAllFloor() async {
    String? token = await getToken();

    for (int i = 0; i < placeData.length; i++) {
      var pId = placeData[i]['p_id'].toString();
      final url = api + "addyourfloor/?p_id=" + pId;
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Token $token',
      });
      if (response.statusCode == 200) {
        List floorData = jsonDecode(response.body);
        if (kDebugMode) {
          print('floorData12 $floorData');
        }
        for (int i = 0; i < floorData.length; i++) {
          floorList.add(floorData[i]);
          var floorQuery = FloorType.fromJson(floorData[i]);

          await AllDatabase.instance.insertFloorModelData(floorQuery);
        }
      }
    }
    await getAllFlat();
  }

  Future<void> getAllFlat() async {
    String? token = await getToken();
    for (int i = 0; i < floorList.length; i++) {
      var fId = floorList[i]['f_id'].toString();
      String url = api + 'addyourflat/?f_id=' + fId;
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Token $token',
      });

      if (response.statusCode == 200) {
        List flatData = jsonDecode(response.body);
        for (int i = 0; i < flatData.length; i++) {
          flatList.add(flatData[i]);
          var flatQuery = FlatType.fromJson(flatData[i]);
          await AllDatabase.instance.insertFlatModelData(flatQuery);
        }
      }
    }
    await getAllRoom();
  }

  Future<void> getAllRoom() async {
    String? token = await getToken();
    for (int i = 0; i < flatList.length; i++) {
      var fltId = flatList[i]['flt_id'].toString();
      String url = api + "addroom/?flt_id=" + fltId;
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Token $token',
      });

      if (response.statusCode == 200) {
        List roomData = jsonDecode(response.body);

        for (int i = 0; i < roomData.length; i++) {
          roomList.add(roomData[i]);
          var roomQuery = RoomType.fromJson(roomData[i]);
          await AllDatabase.instance.insertRoomModelData(roomQuery);
        }
      } else {
        if (kDebugMode) {
          print(response.statusCode);
        }
        return;
      }
    }
    await getAllDevice();
  }

  Future getAllDevice() async {
    String? token = await getToken();
    for (int i = 0; i < roomList.length; i++) {
      var roomId = roomList[i]['r_id'].toString();
      String url = api + "addyourdevice/?r_id=" + roomId;
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Token $token',
      });
      if (response.statusCode == 200) {
        List deviceData = jsonDecode(response.body);

        for (int i = 0; i < deviceData.length; i++) {
          deviceList.add(deviceData[i]);

          var deviceQuery = DeviceType(
            user: deviceData[i]['user'],
            rId: deviceData[i]['r_id'],
            dId: deviceData[i]['d_id'],
            id: deviceData[i]['id'],
            dateInstalled: DateTime.parse(deviceData[i]['date_installed']),
          );

          await AllDatabase.instance.insertDeviceModelData(deviceQuery);
        }

      } else {
        return;
      }
    }

    await getAllPinNames();
  }

  Future<void> getAllPinNames() async {
    String? token = await getToken();
    for (int i = 0; i < deviceList.length; i++) {
      var did = deviceList[i]['d_id'].toString();
      String url = api + "editpinnames/?d_id=" + did;
      // try {
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Token $token',
      });
      if (response.statusCode == 200) {
        var devicePinNamesData = json.decode(response.body);
        DevicePinName devicePinNamesQuery =
            DevicePinName.fromJson(devicePinNamesData);
        await AllDatabase.instance.insertDevicePinNames(devicePinNamesQuery);
      }
    }
    await getPinStatusData();
  }

  Future<void> getPinStatusData() async {
    String? token = await getToken();

    for (int i = 0; i < deviceList.length; i++) {
      var did = deviceList[i]['d_id'].toString();
      String url = api + "getpostdevicePinStatus/?d_id=" + did.toString();
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Token $token',
      });

      if (response.statusCode == 200) {
        print("RESPONSE ${response.body}");
        print("LOGIN DEVICE LIST $deviceList");
        var pinStatus = jsonDecode(response.body);
        DevicePinStatus pinQuery = DevicePinStatus.fromJson(pinStatus);
        await AllDatabase.instance.insertPinStatusData(pinQuery);


      }
    }
    await getAllPinScheduled();
    // await getSensorData();
  }

  Future<void> getSensorData() async {
    String? token = await getToken();
    for (int i = 0; i < deviceList.length; i++) {
      var did = deviceList[i]['d_id'].toString();
      String url = api + "tensensorsdata/?d_id=" + did;
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Token $token',
      });
      if (response.statusCode == 200) {
        var arr = jsonDecode(response.body);
        SensorData sensorQuery = SensorData.fromJson(arr);
        // await AllDatabase.instance.insertSensorData(sensorQuery);
      }
    }

  }

  Future<void> getAllPinScheduled() async {
    String? token = await getToken();
    for (int i = 0; i < deviceList.length; i++) {
      var did = deviceList[i]['d_id'].toString();
      var url = api + "scheduledatagetbyid/?d_id=" + did;
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Token $token',
      });
      if (response.statusCode == 200) {
        List<dynamic> ans = jsonDecode(response.body);
        for (int i = 0; i < ans.length; i++) {
          var schedule = ScheduledPin(
              id: ans[i]['id'],
              date1: DateTime.parse(ans[i]['date1']),
              timing1: ans[i]['timing1'],
              pin1Status: ans[i]['pin1Status'],
              pin2Status: ans[i]['pin2Status'],
              pin3Status: ans[i]['pin3Status'],
              pin4Status: ans[i]['pin4Status'],
              pin5Status: ans[i]['pin5Status'],
              pin6Status: ans[i]['pin6Status'],
              pin7Status: ans[i]['pin7Status'],
              pin8Status: ans[i]['pin8Status'],
              pin9Status: ans[i]['pin9Status'],
              pin10Status: ans[i]['pin10Status'],
              pin11Status: ans[i]['pin11Status'],
              pin12Status: ans[i]['pin12Status'],
              pin13Status: ans[i]['pin13Status'],
              pin14Status: ans[i]['pin14Status'],
              pin15Status: ans[i]['pin15Status'],
              pin16Status: ans[i]['pin16Status'],
              pin17Status: ans[i]['pin17Status'],
              pin18Status: ans[i]['pin18Status'],
              pin19Status: ans[i]['pin19Status'],
              pin20Status: ans[i]['pin20Status'],
              user: ans[i]['user'],
              dId: ans[i]['d_id']);
          await AllDatabase.instance.insertDevicePinSchedule(schedule);
        }
      }
    }
    await placeQueryFunc();
  }

  Future getUid() async {
    const uri = api + 'getuid/';
    String? token = await getToken();
    final response = await http.get(Uri.parse(uri), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Token $token',
    });
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print('UiD ${response.body}');
      }
      var getUidVariable = jsonDecode(response.body);
      int getUidVariable2 = int.parse(getUidVariable.toString());
      await storeUidSharedPref(getUidVariable2);
      await getUidShared();
      await getUserDetails(getUidVariable.toString());
      if (kDebugMode) {
        print(getUidVariable2);
      }
    } else {
      if (kDebugMode) {
        print(response.statusCode);
      }
    }
  }

  storeUidSharedPref(value) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setInt("uid", value);
  }

  getUidShared() async {
    final SharedPreferences prefs = await _prefs;
    final a = prefs.getInt("uid");
    if (kDebugMode) {
      print("aas $a");
    }
  }

  Future<void> getUserDetails(getUidVariable) async {
    String? token = await getToken();

    String uri = api + "getthedataofuser/?id=" + getUidVariable;
    final response = await http.get(Uri.parse(uri), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Token $token',
    });

    if (response.statusCode == 200) {
      var userDataVariable = jsonDecode(response.body);

      var userQuery = UserProfile.fromJson(userDataVariable);
      await AllDatabase.instance.insertUserDetailsModelData(userQuery);
    }
  }

  Future placeQueryFunc() async {
    List placeTypeSingle = await AllDatabase.instance.queryPlace();
    setState(() {
      pt = PlaceType.fromJson(placeTypeSingle[0]);
    });
    await floorQueryFunc(pt!.pId);
  }

  Future floorQueryFunc(placeId) async {
    List floorList = await AllDatabase.instance.getFloorById(placeId);
    setState(() {
      fl = FloorType.fromJson(floorList[0]);
    });
    await flatQueryFunc(fl?.fId);
  }

  Future flatQueryFunc(floorId) async {
    List flatList = await AllDatabase.instance.getFlatByFId(floorId);
    setState(() {
      flat = FlatType.fromJson(flatList[0]);
    });
    await roomQueryFunc(flat?.fltId);
  }

  Future roomQueryFunc(flatId) async {
    List roomList = await AllDatabase.instance.getRoomById(flatId);
    setState(() {
      rm = List.generate(
          roomList.length,
          (index) => RoomType(
                rId: roomList[index]['r_id'].toString(),
                fltId: roomList[index]['flt_id'].toString(),
                rName: roomList[index]['r_name'].toString(),
                user: roomList[index]['user'],
              ));
    });

    List deviceList = await AllDatabase.instance.getDeviceById(rm.first.rId);

    if (deviceList.isNotEmpty) {
      await deviceQueryFunc(rm[0].rId);
    } else {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage(
                    fl: fl,
                    flat: flat,
                    pt: pt,
                    rm: rm,
                    dv: dv,
                  )));
    }
  }

  Future deviceQueryFunc(rId) async {
    List deviceList = await AllDatabase.instance.getDeviceById(rId);

    setState(() {
      dv = List.generate(
          deviceList.length,
          (index) => DeviceType(
              id: deviceList[index]['id'],
              dateInstalled:
                  DateTime.parse(deviceList[index]['date_installed']),
              user: deviceList[index]['user'],
              rId: deviceList[index]['r_id'].toString(),
              dId: deviceList[index]['d_id']));
    });
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => HomePage(
                  fl: fl,
                  flat: flat,
                  pt: pt,
                  rm: rm,
                  dv: dv,
                )));
  }
}
