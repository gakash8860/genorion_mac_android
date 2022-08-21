// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:io';
import 'package:genorion_mac_android/HomeUi/homepage.dart';
import 'package:genorion_mac_android/Models/devicemodel.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';
import 'package:flutter/material.dart';
import '../Auth/signup.dart';
import '../LocalDatabase/alldb.dart';
import '../Models/flatmodel.dart';
import '../Models/floormodel.dart';
import '../Models/placemodel.dart';
import '../Models/roommodel.dart';

class GettingStartedScreen extends StatefulWidget {
  const GettingStartedScreen({Key? key}) : super(key: key);

  @override
  _GettingStartedScreenState createState() => _GettingStartedScreenState();
}

class _GettingStartedScreenState extends State<GettingStartedScreen> {
  int currentPage = 0;
  PageController pageController = PageController(initialPage: 0);
  PlaceType? pt;
  FloorType? fl;
  FlatType? flt;
  List<RoomType>? rm;
  List<DeviceType> dv = [];
  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (currentPage < 2) {
        currentPage++;
      } else {
        currentPage = 0;
      }
      if (pageController.hasClients) {
        pageController.animateToPage(
          currentPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      }
    });
    placeQueryFunc();
  }

  @override
  void dispose() {
    super.dispose();

    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xff121421),
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: <Widget>[
                      PageView.builder(
                        scrollDirection: Axis.horizontal,
                        onPageChanged: onPageChanged,
                        controller: pageController,
                        itemCount: slideList.length,
                        itemBuilder: (ctx, i) => SlideItem(i),
                      ),
                      Stack(
                        alignment: AlignmentDirectional.topStart,
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(bottom: 35),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                for (int i = 0; i < slideList.length; i++)
                                  if (i == currentPage)
                                    SlideDots(
                                      isActive: true,
                                    )
                                  else
                                    SlideDots(
                                      isActive: false,
                                    )
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Column(
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    ConfirmationSlider(
                      iconColor: Colors.black,
                      foregroundColor: Colors.grey,
                      text: "Getting Started",
                      onConfirmation: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUpScreen())),
                    ),

                    // SliderButton(
                    //   label: const Text(
                    //     "Getting Started",
                    //     style: TextStyle(
                    //         color: Color(0xff4a4a4a),
                    //         fontWeight: FontWeight.w500,
                    //         fontSize: 17),
                    //   ),
                    //   icon: const Center(
                    //       child: Icon(
                    //     Icons.power_settings_new,
                    //     color: Colors.white,
                    //     size: 40.0,
                    //     semanticLabel:
                    //         'Text to announce in accessibility modes',
                    //   )),

                    //   boxShadow: const BoxShadow(
                    //     color: Colors.black,
                    //     blurRadius: 4,
                    //   ),
                    //   width: 230,
                    //   action: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>const SignUpScreen()))
                    //   // radius: 10,
                    //   // buttonColor: Color(0xffd60000),
                    //   // backgroundColor: Color(0xff534bae),
                    //   // highlightedColor: Colors.white,
                    //   // baseColor: Colors.red,
                    // ),

                    // FlatButton(
                    //   child: const Text(
                    //     'Getting Started',
                    //     style: TextStyle(fontSize: 18),
                    //   ),
                    //   shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(500),
                    //   ),
                    //   color: Theme.of(context).primaryColor,
                    //   padding: const EdgeInsets.all(15),
                    //   textColor: Colors.white,
                    //   onPressed: () {
                    //     Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //             builder: (context) => const SignUpScreen()));
                    //   },
                    // ),

                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: <Widget>[
                    //     const Text(
                    //       'Have an account',
                    //       style: TextStyle(fontSize: 18),
                    //     ),
                    //     FlatButton(
                    //       child: const Text(
                    //         'Login',
                    //         style: TextStyle(fontSize: 18),
                    //       ),
                    //       onPressed: () {
                    //         // Navigator.of(context)
                    //         //     .pushNamed(LoginScreen.routeName);
                    //       },
                    //     )
                    //   ],
                    // ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: <Widget>[
                    //     const Text(
                    //       'Temporary User',
                    //       style: TextStyle(fontSize: 14),
                    //     ),
                    //     FlatButton(
                    //       child: const Text(
                    //         'Click Here !',
                    //         style: TextStyle(fontSize: 14),
                    //       ),
                    //       onPressed: () {
                    //         // Navigator.push(
                    //         //     context,
                    //         //     MaterialPageRoute(
                    //         //         builder: (context) =>
                    //         //             EnterPhoneNumber()));
                    //       },
                    //     )
                    //   ],
                    // )
            
                  ],
                )
              ],
            ),
          ),
        ),
      ),

      // },
    );
  }

  onPageChanged(int index) {
    setState(() {
      currentPage = index;
    });
  }

  backPopPage(context) {
    return AlertDialog(
      title: const Text('Warning'),
      content: const Text('Do you want to exit'),
      actions: [
        ElevatedButton(
          child: const Text('Yes'),
          onPressed: () => exit(0),
        ),
        ElevatedButton(
          child: const Text('No'),
          onPressed: () => Navigator.pop(context, false),
        )
      ],
    );
  }

  Future placeQueryFunc() async {
    List queryRows = await AllDatabase.instance.queryPlace();
    if (queryRows.isNotEmpty) {
      var pids = PlaceType(
          pId: queryRows[0]['p_id'].toString(),
          pType: queryRows[0]['p_type'].toString(),
          user: queryRows[0]['user']);
      setState(() {
        pt = pids;
      });

      await floorQueryFunc(pt!.pId);
    }
    return;
  }

  Future floorQueryFunc(id) async {
    List resultFloor = await AllDatabase.instance.getFloorById(id);

    var floor = FloorType(
        fId: resultFloor[0]['f_id'].toString(),
        fName: resultFloor[0]['f_name'].toString(),
        user: resultFloor[0]['user'],
        pId: resultFloor[0]['p_id'].toString());

    setState(() {
      fl = floor;
    });
    await flatQueryFunc(fl!.fId);
  }

  Future flatQueryFunc(id) async {
    List resultFlat = await AllDatabase.instance.getFlatByFId(id);

    var flat = FlatType(
        fId: resultFlat[0]['f_id'].toString(),
        fltName: resultFlat[0]['flt_name'].toString(),
        fltId: resultFlat[0]['flt_id'].toString(),
        user: resultFlat[0]['user']);

    setState(() {
      flt = flat;
    });
    await roomQueryFunc(flt!.fltId);
  }

  Future roomQueryFunc(id) async {
    List resultRoom = await AllDatabase.instance.getRoomById(id);

    setState(() {
      rm = List.generate(
          resultRoom.length,
          (index) => RoomType(
                rId: resultRoom[index]['r_id'].toString(),
                fltId: resultRoom[index]['flt_id'].toString(),
                rName: resultRoom[index]['r_name'].toString(),
                user: resultRoom[index]['user'],
              ));
    });
    if (rm!.isNotEmpty) {
      await deviceQueryFunc(rm![0].rId);
    } else {

    }
  }

  Future deviceQueryFunc(rId) async {
    List deviceList = await AllDatabase.instance.getDeviceById(rId);
    print("Device List $deviceList");
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
                  flat: flt,
                  pt: pt,
                  rm: rm,
                  dv: dv,
                )));
  }
}

class Slide {
  final String imageURL;
  final String tittle;
  final String description;

  Slide(
      {required this.imageURL,
      required this.tittle,
      required this.description});
}

final slideList = [
  Slide(
      imageURL: 'assets/images/genLogo.png',
      tittle: 'Welcome to GenOrion',
      description: 'GenOrion is a part of SpaceStation Automation Pvt. Ltd.'
          'Developing smart switching and control systems for Automation.'),
  Slide(
      imageURL: 'assets/images/slide1.jpg',
      tittle: 'GenOrion',
      description: 'GenOrion is a part of SpaceStation Automation Pvt. Ltd.'
          'Developing smart switching and control systems for Automation.'),
  Slide(
      imageURL: 'assets/images/qwe.png',
      tittle: 'Proposed Solutions by our product',
      description:
          'The system can work with or without the internet on the same network.'
          'Capable of working with old manual switching as well as new.'
          'Users can control devices by manual switching too.'),
];

class SlideDots extends StatelessWidget {
  final bool isActive;
  // ignore: prefer_const_constructors_in_immutables
  SlideDots({Key? key, required this.isActive}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      height: isActive ? 12 : 8,
      width: isActive ? 12 : 8,
      decoration: BoxDecoration(
        color: isActive ? Theme.of(context).primaryColor : Colors.grey,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
    );
  }
}

class SlideItem extends StatelessWidget {
  final int index;
  // ignore: prefer_const_constructors_in_immutables
  SlideItem(this.index, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  image: AssetImage(slideList[index].imageURL),
                  fit: BoxFit.cover)),
        ),
        const SizedBox(
          height: 40,
        ),
        Text(
          slideList[index].tittle,
          style: TextStyle(
            fontSize: 22,
            color: Theme.of(context).primaryColor,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          slideList[index].description,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20)
      ],
    );
  }
}
