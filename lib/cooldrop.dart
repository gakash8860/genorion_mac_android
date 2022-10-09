import 'package:flutter/material.dart';
import 'package:cool_dropdown/cool_dropdown.dart';

class CoolDrop extends StatefulWidget {
  const CoolDrop({Key? key}) : super(key: key);

  @override
  State<CoolDrop> createState() => _CoolDropState();
}

class _CoolDropState extends State<CoolDrop> {
  List dropdownItemList = [
    {'label': 'apple', 'value': 'apple'}, // label is required and unique
    {'label': 'banana', 'value': 'banana'},
    {'label': 'grape', 'value': 'grape'},
    {'label': 'pineapple', 'value': 'pineapple'},
    {'label': 'grape fruit', 'value': 'grape fruit'},
    {'label': 'kiwi', 'value': 'kiwi'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ASAS"),
      ),
      body: Container(
        child: CoolDropdown(
          dropdownList: dropdownItemList,
          onChange: (_) {},
          defaultValue: dropdownItemList[1],
          // placeholder: 'insert...',
        ),
      ),
    );
  }
}
