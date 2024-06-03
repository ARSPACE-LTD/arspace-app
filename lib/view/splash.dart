


import 'package:arspace/util/all_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import '../controller/splash_controller.dart';
import '../util/theme.dart';

class SplashScreen extends StatefulWidget{
  @override
  State<SplashScreen> createState() => _splashScreenState();

}

class _splashScreenState extends State<SplashScreen> with TickerProviderStateMixin{
  bool shouldDisplayCheckbox = true;
// Set your condition here



  @override
  void initState() {

    super.initState();

  }


  @override
  Widget build(BuildContext context) {
   return GetBuilder<SplashController>(builder: (value){

       return Scaffold(
         backgroundColor: ThemeProvider.blackColor,
         body: Center(
           child: Image.asset(
             AssetPath.spleshGif,
             height: Get.height*0.2,
             width: Get.width,
             fit: BoxFit.cover,
           )
         ),
       );

   });
  }

  @override
  void dispose() {
    super.dispose();
  }

}

/*
import 'package:flutter/material.dart';
import 'package:flutter_gif/flutter_gif.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gif/flutter_gif.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late GifController controller;

  @override
  void initState() {
    super.initState();
    navigateToNextScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GifImage(
              image: AssetImage('assets/your_gif.gif'), // Use the path to your GIF file
            ),
          ],
        ),
      ),
    );
  }

  Future<void> navigateToNextScreen() async {
    // Delay for 3 seconds (adjust the duration as needed)
    await Future.delayed(Duration(seconds: 3));
    // Navigate to the next screen
    Navigator.pushReplacementNamed(context, '/next_screen');
  }
}*/
