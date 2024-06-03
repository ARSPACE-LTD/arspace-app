import 'package:arspace/backend/parser/dashboard_parser.dart';
import 'package:arspace/controller/profile_controller.dart';
import 'package:arspace/util/all_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:motion_tab_bar_v2/motion-tab-controller.dart';

import '../backend/parser/login_parser.dart';

/*class DashboardController extends GetxController {
  final LoginParser parser;

  DashboardController({required this.parser});
}*/

class DashboardController extends GetxController with GetTickerProviderStateMixin
    implements GetxService {
  final DashboardParser parser;

  int cartTotal = 0;
  int tabId = 0;
  // late TabController tabController;
  MotionTabBarController? motionTabBarController;
  DashboardController({required this.parser});
  bool login = false;
  int selectedIndex = 0;


  @override
  void onInit() {
    super.onInit();
    final ProfileController profileController = Get.put(ProfileController(parser: Get.find()));

   // profileController.getUserProfileApi();

  //  login = parser.haveLoggedIn();
    // tabController = TabController(length: 6, vsync: this, initialIndex: tabId);
    // if(login == true){
    //   tabController = TabController(length: 6, vsync: this, initialIndex: tabId);
    // }else{
    //   tabController = TabController(length: 5, vsync: this, initialIndex: tabId);
    // }
    motionTabBarController = MotionTabBarController(
      initialIndex: 0,
      length:3,
      vsync: this,
    );
  }



  void cleanLoginCreds() {
    // parser.cleanData();
  }

  void updateTabId(int id) {
    tabId = id;
    motionTabBarController!.animateTo(tabId);
    update();
  }

  void updateTab(int id) {
    selectedIndex = id;
    update();
  }
}
