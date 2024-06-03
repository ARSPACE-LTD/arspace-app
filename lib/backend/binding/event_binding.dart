import 'package:arspace/controller/event_controller.dart';
import 'package:arspace/util/all_constants.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';


class EventBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(
          () => EventController(parser: Get.find()),
    );
  }
}