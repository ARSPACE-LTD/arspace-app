


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

