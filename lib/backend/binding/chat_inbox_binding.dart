import 'package:arspace/controller/chat_inbox_controller.dart';
import 'package:arspace/controller/chat_list_controller.dart';
import 'package:arspace/util/all_constants.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';

class ChatInboxBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(
          () => ChatInboxController(parser: Get.find()),
    );
  }
}