


import 'package:arspace/util/all_constants.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';

import '../../controller/home_screen_controller.dart';

class HomeScreenBinding extends Bindings {


  @override
  void dependencies() {
    Get.lazyPut(
          () => HomeScreenController(parser: Get.find()),
    );
  }
}