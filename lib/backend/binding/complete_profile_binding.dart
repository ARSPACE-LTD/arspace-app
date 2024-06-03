
import 'package:arspace/util/all_constants.dart';

import '../../controller/complete_profile_controller.dart';

class CompleteProfileBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(
          () => CompleteProfileController(parser: Get.find()),
    );
  }

}