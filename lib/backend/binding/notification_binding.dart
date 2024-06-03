
import 'package:arspace/controller/notifications_controller.dart';
import 'package:arspace/util/all_constants.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';

class NotificationBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(
          () => NotificationController(parser: Get.find()),
    );
  }
}