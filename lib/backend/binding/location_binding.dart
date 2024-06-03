

import 'package:arspace/controller/location_controller.dart';
import 'package:arspace/util/all_constants.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';

class LocationBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(
          () => LocationController(parser: Get.find()),
    );
  }
}