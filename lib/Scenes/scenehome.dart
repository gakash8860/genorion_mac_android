import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:genorion_mac_android/ProfilePage/utility.dart';
import 'package:genorion_mac_android/Scenes/scenedetails.dart';
import 'package:http/http.dart' as http;
import '../Models/scenemodel.dart';
import '../main.dart';


class SceneHome extends StatefulWidget {
  const SceneHome({Key? key}) : super(key: key);

  @override
  State<SceneHome> createState() => _SceneHomeState();
}

class _SceneHomeState extends State<SceneHome> {
  TextEditingController sceneNameController = TextEditingController();
  Future? sceneFuture;
  List<SceneModel> scenesList = [];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sceneFuture = getScene();
  }

  @override
  void dispose() {
    super.dispose();
    sceneNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff121421),
      appBar: AppBar(
        title: Text("Scenes"),

      ),

      body: Container(
        color: Colors.transparent,
        width: MediaQuery
            .of(context)
            .size
            .width,
        child: FutureBuilder(
            future: sceneFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: scenesList.length,
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
                                    scenesList[index].sceneType.toString(),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  trailing:   IconButton(onPressed: (){
                                    _showDialogForDelete(scenesList[index].sceneId);
                                  }, icon: Icon(Icons.delete)),

                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SceneDetails(
                                                    sceneName: scenesList[index]
                                                        .sceneType.toString(),
                                                  sceneId: scenesList[index].sceneId,
                                                )));
                                  }),
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _createAlertDialogForScene();
        },

      ),
    );
  }

  _showDialogForDelete(id) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete"),
        content: const Text("Are you sure to delete"),
        actions: <Widget>[
          MaterialButton(
              child: const Text("Yes"),
              onPressed: () async {
                await deleteScene(id);
                Navigator.pop(context);
              }),
          MaterialButton(
              child: const Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              }),
        ],
      ),
    );
  }



  Future<void> deleteScene(id)async{
    String? token = await Utility.getToken();
    var url = api+"scenedevice/?user="+id.toString();
    final response = await http.delete(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Token $token',
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        sceneFuture = getScene();
      });
      const snackBar = SnackBar(
        content: Text('Deleted'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      if (kDebugMode) {
        print(response.statusCode);
      }
    }


  }










  _createAlertDialogForScene() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Enter the Name of Scene'),
            content: TextFormField(
              autofocus: true,
              controller: sceneNameController,
              textInputAction: TextInputAction.next,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              style: const TextStyle(fontSize: 18, color: Colors.black54),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.heat_pump_sharp),
                filled: true,
                fillColor: Colors.white,
                hintText: 'Enter Scene Name',
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
                    await addScene(sceneNameController.text);
                    Navigator.of(context).pop();
                  },
                ),
              )
            ],
          );
        });
  }


  Future<void> addScene(String sceneName) async {
    String? token = await Utility.getToken();
    int userId = await Utility.getUidShared();
    print("TOKEEE $token");
    print("WREQWEDFSE ${userId}");
    var url = api + 'scenedetail/';
    Map data = {
      "user": userId,
      "scene_type": sceneName
    };

    final response =
    await http.post(Uri.parse(url), body: jsonEncode(data), headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Token $token',
    });
    if (response.statusCode == 201 || response.statusCode == 200) {
      print("response.body ${response.body}");
      sceneFuture = getScene();
    } else {
      print(response.statusCode);
    }
  }

  Future<bool> getScene() async {
    String? token = await Utility.getToken();
    int userId = await Utility.getUidShared();
    var url = api + 'scenedetail/?user=' + userId.toString();
    final response =
    await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Token $token',
    });
    if (response.statusCode == 201 || response.statusCode == 200) {
      print("Scene Details : ${response.body}");
      List data = jsonDecode(response.body);
      setState(() {
        scenesList = data.map((data) => SceneModel.fromJson(data)).toList();
      });
      return true;
    } else {
      print(response.statusCode);
    }
    return false;
  }

}
