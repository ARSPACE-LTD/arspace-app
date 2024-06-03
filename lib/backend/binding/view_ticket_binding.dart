import 'package:arspace/controller/view_ticket_controller.dart';
import 'package:arspace/util/all_constants.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';

class ViewTicketBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
          () => ViewTicketController(parser: Get.find()),
    );
  }
}