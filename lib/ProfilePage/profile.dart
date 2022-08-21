// ignore_for_file: prefer_typing_uninitialized_variables, library_prefixes

import 'dart:convert';
import 'dart:io' as Io;
import 'dart:io';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:genorion_mac_android/Models/userprofike.dart';
import 'package:genorion_mac_android/ProfilePage/photo.dart';
import 'package:genorion_mac_android/ProfilePage/utility.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../LocalDatabase/alldb.dart';
import '../main.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
   UserProfile? userProfile;
  Future? persondalData;
  List<dynamic> deviceLength = [];

  File? image;
  bool checkImage = false;
  final storage = const FlutterSecureStorage();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String? img64;
  var getUidVariable;
  PhotoModel? photo;
  bool prefCheckImage = false;
  @override
  void initState() {
    super.initState();
    persondalData = userPersonalData();
    deviceQuery();
    refreshImagesLocal();
    getImage();

    getUidShared();
  }



 @override
  void dispose() {
  
    super.dispose();
    refreshImages();
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
                    Text("Profile",
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
          Center(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 18,
                ),
                CircularProfileAvatar(
                  '',
                  child: checkImage
                      ? setImage
                      : Image.asset('assets/images/blank.png'),
                  // '',child: Image.network(imageData['images']),
                  radius: 90,
                  elevation: 5,
                  onTap: () {},
                  cacheImage: true,
                ),
                CircleAvatar(
                  maxRadius: MediaQuery.of(context).size.width * 0.05,
                  child: IconButton(
                    icon: const Icon(Icons.edit),
                    color: Colors.black54,
                    onPressed: () {
                      _showChoiceDialog(context);
                    },
                  ),
                ),
              ],
            ),
          ),
          showDetails()
        ],
      )),
    );
  }

  Widget showDetails() {
    return FutureBuilder(
        future: persondalData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                      margin: const EdgeInsets.only(left: 25, right: 25),
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
                      child: Center(
                          child: Text(userProfile!.firstName.toString()))),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                      margin: const EdgeInsets.only(left: 25, right: 25),
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
                      child:
                          Center(child: Text(userProfile!.email.toString()))),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                      margin: const EdgeInsets.only(left: 25, right: 25),
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
                      child: Center(
                          child: Text("Total Device Used By You " +
                              deviceLength.length.toString()))),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  Future<bool> userPersonalData() async {
    List data = await AllDatabase.instance.queryPersonalData();
    setState(() {
      userProfile = UserProfile.fromJson(data[0]);
    });
    if (data.isNotEmpty) {
      return true;
    }
    return false;
  }

  Future deviceQuery() async {
    List ans = await AllDatabase.instance.queryDevice();
    setState(() {
      deviceLength = ans;
    });
    if (kDebugMode) {
      print("deviceLength ${deviceLength.length}");
    }
  }

  _showChoiceDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Make a choice'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: const Text('Gallery'),
                    onTap: () async {
                      // await getCheckPutPostImage();
                      await pickImageFromSource(ImageSource.gallery);
                    },
                  ),
                  const Padding(padding: EdgeInsets.all(8.0)),
                  GestureDetector(
                    child: const Text('Take a photo'),
                    onTap: () async {
                      // await getCheckPutPostImage();
                      await pickImageFromSource(ImageSource.camera);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<String?> getToken() async {
    final tokenVar = await storage.read(key: "token");

    return tokenVar;
  }

  getUidShared() async {
    final SharedPreferences prefs = await _prefs;
    final a = prefs.getInt("uid");
    setState(() {
      getUidVariable = a!;
    });
  }

  imageUpload(img64) async {
    String? token = await getToken();
    String url = api + "testimages123/";

    var postData = {
      "file": img64,
      "user": getUidVariable,
    };
    final response =
        await http.post(Uri.parse(url), body: jsonEncode(postData), headers: {
      'Content-Type': 'application/json',
      // 'Accept': 'application/json',
      'Authorization': 'Token $token',
    });
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (kDebugMode) {
        print("Image upload Response ${response.body}");
      }
      setState(() {
        checkPutPostImage(true);
      });
      await getImage();
    } else {
      if (kDebugMode) {
        print("Image upload Response ${response.statusCode}");
        print("Image upload Response ${response.body}");
      }
    }
  }

  imageUpdate(img64) async {
    String? token = await getToken();
    String url = api + "testimages123/";

    var postData = {
      "file": img64,
      "user": getUidVariable,
    };
    final response =
        await http.put(Uri.parse(url), body: jsonEncode(postData), headers: {
      'Content-Type': 'application/json',
      // 'Accept': 'application/json',
      'Authorization': 'Token $token',
    });
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (kDebugMode) {
        print("Put Image Response ${response.body}");
      }
      await getImage();
    } else {
      if (kDebugMode) {
        print("Image Put Response ${response.statusCode}");
        print("Image Put Response ${response.body}");
      }
    }
  }

  getImage() async {
    String? token = await getToken();

    final url = api + 'testimages123/?user=' + getUidVariable.toString();
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
        checkImage = true;

        setImage = Utility.imageFrom64BaseString(photo!.file);

        AllDatabase.instance.savePhoto(photo!);
        checkPutPostImage(checkImage);
      });

      // refreshImages();
    } else {
      if (kDebugMode) {
        print("Image Get Response ${response.statusCode}");
      }
    }
  }

  Future pickImageFromSource(ImageSource source) async {
    img64 = null;
    ImagePicker().pickImage(source: source).then((imgFile) async {
      final bytes = Io.File(imgFile!.path).readAsBytesSync();
      img64 = base64Encode(bytes);

      PhotoModel photo =
          PhotoModel(user: int.parse(getUidVariable.toString()), file: img64!);
      await AllDatabase.instance.deletePhoto();
      await AllDatabase.instance.savePhoto(photo);
      refreshImages();
    });
  }

  refreshImagesLocal() async {
    List data = await AllDatabase.instance.getPhoto();
    if (data.isEmpty) {
      return;
    }

    setState(() {
      photo = PhotoModel.fromMap(data[0]);
      setImage = Utility.imageFrom64BaseString(photo!.file);
      checkImage = true;
    });
  }

  refreshImages() async {
    List data = await AllDatabase.instance.getPhoto();
    if (data.isEmpty) {
      return;
    }
    if(!mounted){
      return;
    }

    setState(() {
      photo = PhotoModel.fromMap(data[0]);
      setImage = Utility.imageFrom64BaseString(photo!.file);
    });
    if (checkImage == true) {
      await imageUpdate(photo!.file);
    } else {
      await imageUpload(photo!.file.toString());
    }
  }

  checkPutPostImage(value) async {
    final pref = await SharedPreferences.getInstance();
    pref.setBool("checkimage", value);
  }

  bool? checkFinalImage;
  getCheckPutPostImage() async {
    final pref = await SharedPreferences.getInstance();
    bool? ans = pref.getBool("checkimage");
    if (ans == null) {
      return;
    }
    setState(() {
      checkFinalImage = ans;
    });
    if (kDebugMode) {
      print("ansgetcheckbool $ans");
    }
  }
}
