


import 'package:app_links/app_links.dart';
import 'package:arspace/util/all_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import '../backend/helper/app_router.dart';
import '../controller/splash_controller.dart';
import '../util/theme.dart';

class SplashScreen extends StatefulWidget{
  @override
  State<SplashScreen> createState() => _splashScreenState();

}

class _splashScreenState extends State<SplashScreen> with TickerProviderStateMixin{
  bool shouldDisplayCheckbox = true;
  late AppLinks _appLinks;
  String? _link;
// Set your condition here
  final SplashController splashController = Get.put(SplashController(parser: Get.find()));


    @override
  void initState() {

    super.initState();
    splashController.initialized;
   // initDeepLink();

  }

  Future<void> initDeepLink() async {
    _appLinks = AppLinks();

    // Handle initial link
    final initialLink = await _appLinks.getInitialLink();
    setState(() {
      _link = initialLink?.toString();
    });

    // Handle subsequent links
    _appLinks.uriLinkStream.listen((Uri? uri) {
      setState(() {
        _link = uri?.toString();
      });

      // Navigate to the specific event page based on the link
      if (uri != null && uri.pathSegments.isNotEmpty) {
        print("appLink eventId ===== ${uri.pathSegments.last}") ;
        final eventId = uri.pathSegments.last;

        Get.toNamed(AppRouter.getEvents() ,arguments: [eventId]) ;
        //Get.toNamed(AppRouter.getEvents() ,arguments: eventId);


      }
    });
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

