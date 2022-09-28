import 'package:flutter/material.dart';



class SceneHome extends StatefulWidget {
  const SceneHome({Key? key}) : super(key: key);

  @override
  State<SceneHome> createState() => _SceneHomeState();
}

class _SceneHomeState extends State<SceneHome> {
  TextEditingController sceneNameController = TextEditingController();


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

      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _createAlertDialogForScene();
        },

      ),
    );
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
                prefixIcon: const Icon(Icons.place),
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

                    Navigator.of(context).pop();
                  },
                ),
              )
            ],
          );
        });
  }
  Future<void> addScene()async{

  }

}
