
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class FlushUtil {
  static final List<Flushbar> flushBars = [];

  static void showSnackBar(
      BuildContext context, {
        required String text,
      }) =>
      _show(
        context,
        Flushbar(
          messageText: Center(
              child: Text(
                text,
                style: const TextStyle(color: Colors.white, fontSize: 24),
              )),
          duration: const Duration(seconds: 3),
          flushbarPosition: FlushbarPosition.TOP,
          backgroundColor: Colors.black,
          animationDuration: const Duration(microseconds: 0),
        ),
      );

  static Future _show(BuildContext context, Flushbar newFlushBar) async {
    await Future.wait(flushBars.map((flushBar) => flushBar.dismiss()).toList());
    flushBars.clear();

    newFlushBar.show(context);
    flushBars.add(newFlushBar);
  }
}