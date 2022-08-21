import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../ColorPlates/changecolor.dart';
import '../main.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
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
                      Text("Setting",
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
                      child: Center(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Card(
              color: Colors.white,
              elevation: 4.0,
              child: Column(
                children: <Widget>[
                  GestureDetector(
                    onTap: _launchURL,
                    child: ListTile(
                      leading: const CircleAvatar(
                          radius: 15.0, child: Icon(Icons.password_sharp)),
                      title: const Text(
                        'Change Password',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      selectedTileColor: Colors.blue,
                      // onTap: ,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const <Widget>[
                          Icon(Icons.arrow_forward_ios),
                        ],
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const CircleAvatar(
                        radius: 15.0, child: Icon(Icons.home_work_outlined)),
                    title: const Text(
                      'Change Home Screen Layout',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    // onTap: ,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const <Widget>[
                        Icon(Icons.arrow_forward_ios),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: const CircleAvatar(
                        radius: 15.0,
                        child: Icon(Icons.perm_device_information_sharp)),
                    title: const Text(
                      'Manage Devices',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    onTap: () {},
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const <Widget>[
                        Icon(Icons.arrow_forward_ios),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: const CircleAvatar(
                        radius: 15.0, child: Icon(Icons.change_history_sharp)),
                    title: const Text(
                      'Manage Themes',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    onTap: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ChangedTheme()));
                    },
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const <Widget>[
                        Icon(Icons.arrow_forward_ios),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _launchURL() async {
    var url = api + 'change_password_phone';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
