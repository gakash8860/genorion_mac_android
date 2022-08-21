// import 'package:flutter/material.dart';

// class Slide {
//   final String imageURL;
//   final String tittle;
//   final String description;

//   Slide({ required this.imageURL,required this.tittle,required this.description});
// }

// final slideList = [
//   Slide(
//       imageURL: 'assets/images/genLogo.png',
//       tittle: 'Welcome to GenOrion',
//       description: 'GenOrion is a part of SpaceStation Automation Pvt. Ltd.'
//           'Developing smart switching and control systems for Automation.'),
//   Slide(
//       imageURL: 'assets/images/slide1.jpg',
//       tittle: 'GenOrion',
//       description: 'GenOrion is a part of SpaceStation Automation Pvt. Ltd.'
//           'Developing smart switching and control systems for Automation.'),
//   Slide(
//       imageURL: 'assets/images/qwe.png',
//       tittle: 'Proposed Solutions by our product',
//       description:
//           'The system can work with or without the internet on the same network.'
//           'Capable of working with old manual switching as well as new.'
//           'Users can control devices by manual switching too.'),
// ];

// class SlideDots extends StatelessWidget {
//   final bool isActive;
//   SlideDots(this.isActive);

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedContainer(
//       duration: Duration(milliseconds: 150),
//       margin: const EdgeInsets.symmetric(horizontal: 10),
//       height: isActive ? 12 : 8,
//       width: isActive ? 12 : 8,
//       decoration: BoxDecoration(
//         color: isActive ? Theme.of(context).primaryColor : Colors.grey,
//         borderRadius: const BorderRadius.all(Radius.circular(12)),
//       ),
//     );
//   }
// }
