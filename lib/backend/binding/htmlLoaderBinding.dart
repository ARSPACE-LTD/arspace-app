import 'package:arspace/util/all_constants.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';

import '../../controller/htmlLoaderController.dart';
import '../parser/htmlLoaderParser.dart';

class htmlLoadehtmlLoaderBindingrBinding extends Bindings {


  @override
  void dependencies() {
    Get.lazyPut(
          () => HtmlLoaderController(parser: Get.find()),
    );
  }
}