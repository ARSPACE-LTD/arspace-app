import 'package:arspace/controller/ticket_purchase_controller.dart';
import 'package:arspace/util/all_constants.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';

class TicketPurchasedBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
          () => TicketPurchasedController(parser: Get.find()),
    );
  }
}