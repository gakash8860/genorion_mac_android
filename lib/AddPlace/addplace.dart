import 'package:flutter/material.dart';
import 'package:genorion_mac_android/AddPlace/processing.dart';

class AddPlace extends StatefulWidget {
  const AddPlace({Key? key}) : super(key: key);

  @override
  _AddPlaceState createState() => _AddPlaceState();
}

class _AddPlaceState extends State<AddPlace> {
  TextEditingController placeController = TextEditingController();
  TextEditingController floorController = TextEditingController();
  TextEditingController flatController = TextEditingController();
  TextEditingController roomController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff121421),
      body: SafeArea(
        child: Form(
          key: formKey,
          child: ListView(
            physics: const BouncingScrollPhysics(),
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
                    InkWell(
                      child: const Text(" "),
                      onTap: () {},
                    ),
                    Row(
                      children: const [
                        Text("Add Place",
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
            
              SizedBox(
                height: MediaQuery.of(context).size.height / 14.2,
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                  autofocus: true,
                  controller: placeController,
                  textInputAction: TextInputAction.next,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please Enter Place Name";
                    }
                    return null;
                  },
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black54,
                    // fontFamily:  fonttest ?? 'RobotoMono'
                  ),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.place),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Enter Place Name',
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
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                  autofocus: true,
                  controller: floorController,
                  textInputAction: TextInputAction.next,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black54,
                    // fontFamily:  fonttest ?? 'RobotoMono'
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please Enter Floor Name";
                    }
                    return null;
                  },
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
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                  autofocus: true,
                  controller: flatController,
                  textInputAction: TextInputAction.next,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black54,
                    // fontFamily:  fonttest ?? 'RobotoMono'
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please Enter Flat Name";
                    }
                    return null;
                  },
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
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                  autofocus: true,
                  controller: roomController,
                  textInputAction: TextInputAction.next,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black54,
                    // fontFamily:  fonttest ?? 'RobotoMono'
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please Enter Room Name";
                    }
                    return null;
                  },
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
              ),
              _buildSubmitBtn(),
            ],
          ),
        ),
      ),
    );
  
  }

  Widget _buildSubmitBtn() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      margin: EdgeInsets.only(
        right: MediaQuery.of(context).size.height / 8.1,
        left: MediaQuery.of(context).size.height / 8.1,
      ),
      width: double.infinity,
      // ignore: deprecated_member_use
      child: ElevatedButton(
        // elevation: 5.0,
        onPressed: () {
          if (formKey.currentState!.validate()) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => ProcessingData(
                        placeName: placeController.text.toString(),
                        floorName: floorController.text.toString(),
                        flatName: flatController.text.toString(),
                        roomName: roomController.text.toString())));
          }
        },
      
        child: const Text(
          'Submit',
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



}
