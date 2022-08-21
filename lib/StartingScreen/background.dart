import 'package:flutter/material.dart';

class BackGround extends StatefulWidget {
  const BackGround({ Key? key }) : super(key: key);

  @override
  _BackGroundState createState() => _BackGroundState();
}

class _BackGroundState extends State<BackGround> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Image.asset("assets/images/back.jpg")),
      
    );
  }
}