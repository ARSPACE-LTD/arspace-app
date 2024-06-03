
import 'package:arspace/util/all_constants.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';

import '../../controller/forgot_controller.dart';

class ForgotBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(
          () => ForgotControler(parser: Get.find()),
    );
  }



}