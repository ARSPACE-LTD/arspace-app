
import 'package:arspace/util/all_constants.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';

import '../../controller/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => SplashController(parser: Get.find()),
    );
  }
}
