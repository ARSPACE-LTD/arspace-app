import 'package:arspace/util/all_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../backend/helper/app_router.dart';
import '../backend/parser/add_payment_parser.dart';

class AddPaymentController extends GetxController {
  late AddPaymentParser parser;


  AddPaymentController({required this.parser});
  var has8Char = false.obs;
  var hasLN = false.obs;

  final formKey = GlobalKey<FormState>();
  Future<void> onPaymentScreenClicked() async {
    Get.close(0);
    Get.toNamed(AppRouter.dashboardScreen);
  }


}
