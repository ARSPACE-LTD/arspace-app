// ignore_for_file: prefer_const_constructors


import 'package:arspace/util/all_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../util/theme.dart';

class SubmitButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;

  const SubmitButton({Key? key, required this.onPressed, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(0.0),
          elevation: 5,
        ),

        onPressed: onPressed,
        child: Ink(
          decoration: BoxDecoration(
              gradient:  LinearGradient(
                  colors: [ThemeProvider.buttonfirstClr, ThemeProvider.buttonSecondClr ,ThemeProvider.buttonThirdClr]),
              borderRadius: BorderRadius.circular(50)),
          child: Container(
            margin: EdgeInsets.all(0),
            width: Get.width,
            height: 60,
            alignment: Alignment.center,
            child: Text(title,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontFamily: "Lexend"
                )),
          ),
        ));
  }
}
