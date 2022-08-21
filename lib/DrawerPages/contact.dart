import 'package:contactus/contactus.dart';
import 'package:flutter/material.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({Key? key}) : super(key: key);

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff121421),
      body: SafeArea(
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
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    )),
                // Row(
                //   children: const [
                //     Text("Contact Us",
                //         style: TextStyle(
                //             color: Colors.white,
                //             fontSize: 28,
                //             fontWeight: FontWeight.bold)),
                //   ],
                // ),

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
          SizedBox(
            child: ContactUs(
              logo: const AssetImage('assets/images/genLogo.png'),
              email: 'contact@genorion.com',
              dividerColor: Colors.white,
              companyName: 'Genorion',
              phoneNumber: '+919911757588',
              
              // dividerThickness: 2,
              website: 'https://genorion.com/',

              linkedinURL: 'https://www.linkedin.com/company/spaceorion/',
              tagLine: 'Automation',
              twitterHandle: 'https://twitter.com/GENORION1',
              emailText: 'contact@genorion.com',
              
              phoneNumberText: '+919911757588',
              companyColor: Colors.white, cardColor: Colors.white,
              taglineColor: Colors.white, textColor: Colors.black,

              // instagramUserName: '_abhishek_doshi',
            ),
          )
        ],
      )),
    );
  }
}
