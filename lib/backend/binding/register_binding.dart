

import 'package:arspace/util/all_constants.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';

import '../../controller/register_controller.dart';

class RegisterBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(
          () => RegisterController(parser: Get.find()),
    );
  }

}