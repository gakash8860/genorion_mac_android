
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:genorion_mac_android/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangedTheme extends StatefulWidget {
  const ChangedTheme({Key? key}) : super(key: key);

  @override
  _ChangedThemeState createState() => _ChangedThemeState();
}

class _ChangedThemeState extends State<ChangedTheme> {
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
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: changeColor ?? Colors.white,
                  ),
                ),
                Row(
                  children:  [
                    Text("Changed Theme",
                        style: TextStyle(
                            color: changeColor,
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
          Container(
            height: 182,
          ),
          // colorPlates(),
          BlockPicker(
              pickerColor: pickerColor,
              onColorChanged: (Color onColorChanged) async {
                setState(() {
                  changeColor = onColorChanged;
                  changeDone = true;
                  pickerColor = onColorChanged;
                });
                // saveColor2(onColorChanged.value);
                // saveColor(onColorChanged.red, onColorChanged.green,
                //     onColorChanged.blue, onColorChanged.alpha);
                // var ans = getColor1();
                //
                // int an = int.parse(ans.toString());
                // final Color color1 =
                //     Color(an).withOpacity(1);
                // changeColor = color1;
              })
        ],
      )),
    );
  }

  Widget colorPlates() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                child: Container(
                  margin: const EdgeInsets.only(left: 14),
                  width: 38,
                  height: 38,

                  decoration: const BoxDecoration(
                      color: Colors.blue, shape: BoxShape.circle),
                  // child: ...
                ),
                onTap: () {
                  setState(() {
                    changeColor = Colors.blue;
                  });
                },
              ),
              InkWell(
                child: Container(
                  margin: const EdgeInsets.only(left: 14),
                  width: 38,
                  height: 38,

                  decoration: const BoxDecoration(
                      color: Colors.redAccent, shape: BoxShape.circle),
                  // child: ...
                ),
                onTap: () {
                  setState(() {
                    changeColor = Colors.redAccent;
                  });
                },
              ),
              InkWell(
                child: Container(
                  margin: const EdgeInsets.only(left: 14),
                  width: 38,
                  height: 38,

                  decoration: const BoxDecoration(
                      color: Colors.redAccent, shape: BoxShape.circle),
                  // child: ...
                ),
                onTap: () {
                  setState(() {
                    changeColor = Colors.redAccent;
                  });
                },
              ),
              InkWell(
                child: Container(
                  margin: const EdgeInsets.only(left: 14),
                  width: 38,
                  height: 38,

                  decoration: const BoxDecoration(
                      color: Colors.amberAccent, shape: BoxShape.circle),
                  // child: ...
                ),
                onTap: () {
                  setState(() {
                    changeColor = Colors.amberAccent;
                  });
                },
              ),
              InkWell(
                child: Container(
                  margin: const EdgeInsets.only(left: 14),
                  width: 38,
                  height: 38,

                  decoration: const BoxDecoration(
                      color: Colors.orangeAccent, shape: BoxShape.circle),
                  // child: ...
                ),
                onTap: () {

                  // 4294951175
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  saveColor2(value) async {
    final pref = await SharedPreferences.getInstance();
    pref.setInt("color", value);
  }

  saveColor(int r, int g, int b, int alpha) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('r', r);
    prefs.setInt('g', g);
    prefs.setInt('b', b);
    prefs.setInt('a', alpha);
  }

  getColor1() async {
    final pref = await SharedPreferences.getInstance();
    var ans = pref.get("color");
   
    return ans;
  }

  Future<Color> getColor() async {
    final prefs = await SharedPreferences.getInstance();
    final r = prefs.getInt('r');
    final g = prefs.getInt('g');
    final b = prefs.getInt('b');
    final a = prefs.getInt('a');
    return Color.fromARGB(r!, g!, b!, a!);
  }

  // create some values
  Color pickerColor = const Color(0xff443a49);
  Color currentColor = const Color(0xff443a49);

// ValueChanged<Color> callback
  void changeColor2(Color color) {
    setState(() => pickerColor = color);
  }
}
