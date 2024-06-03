import 'dart:async';
import 'dart:io';

import 'package:arspace/util/all_constants.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:video_player/video_player.dart';

import '../backend/helper/app_router.dart';
import '../backend/parser/splash_parser.dart';



class SplashController extends GetxController {
  final SplashParser parser;
  SplashController({required this.parser});
 /* String splash_text = "Splash Screen";
  late VideoPlayerController viedo_controller;*/




  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

 /*   viedo_controller = VideoPlayerController.asset('assets/splesh.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized
        viedo_controller.play();
       update();
      })
      ..addListener(() {
        if (viedo_controller.value.position == viedo_controller.value.duration) {

          if (parser.token() != null && parser.token() != "")
            {
              Get.toNamed(AppRouter.getDashboardScreenRoute());
            }
          else
            {Get.toNamed(AppRouter.authenticationTypeRoute());}
              *//*if (parser.isNewUser())
                {}
              else
                {Get.back(), Get.toNamed(AppRouter.onBoardingRoute())}*//*


        }
      });*/

    /*if (Platform.isAndroid) {
      // Code specific to Android
      print('Running on Android');
    } else if (Platform.isIOS) {
      // Code specific to iOS
      print('Running on iOS');
    }*/

    Timer(

        Duration(seconds:Platform.isAndroid ? 5 : 6),
        () => {
        if (parser.token() != null && parser.token() != "")
    {
        Get.toNamed(AppRouter.getDashboardScreenRoute())
    }
    else
    {Get.toNamed(AppRouter.authenticationTypeRoute())}
            });
  }


}
