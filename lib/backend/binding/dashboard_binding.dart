

import 'package:arspace/controller/home_screen_controller.dart';
import 'package:arspace/controller/match_controller.dart';
import 'package:arspace/util/all_constants.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';

import '../../controller/dashboard_controller.dart';

class DashboardBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(
          () => DashboardController(parser: Get.find()),
    );

    Get.lazyPut(
          () => HomeScreenController(parser: Get.find()),
    );
  }



}