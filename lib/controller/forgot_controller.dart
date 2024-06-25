
import 'package:arspace/util/all_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../backend/helper/app_router.dart';
import '../backend/parser/forgot_parser.dart';
import '../util/dimens.dart';
import '../util/theme.dart';


class ForgotControler extends GetxController{

  final ForgotParser parser;


  RxBool showPassword = false.obs;


  final forgotEmailController = TextEditingController();


  ForgotControler({required this.parser});

  Future<void> onbuttonClicked(BuildContext context) async {
    /*if (countryCodeController.text.isEmpty) {
      countryCodeController.text = '+1';
      // log("This is country code is $countryCodeController");
      // showToast('Please select Country Code'.tr);
      // return;
    }
    if (mobileNumberController.text.isEmpty) {
      log("This is country mobileNumberController is $mobileNumberController");
      showToast('Please add phone number'.tr);
      return;
    }*/

    // String finalNumber = countryCodeController.text + mobileNumberController.text;
    var body = {
      // "email": countryCodeController.text,
      "email": forgotEmailController.text.toString(),
    };

    //HtmlLoader();
    // htmlLoaderController.startLoading();


    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: LoadingAnimationWidget.threeRotatingDots(
            color: ThemeProvider.loader_color,
            size: Dimens.loder_size,
          ),
        ); // Display the custom loader
      },
    );

    var response = await parser.forgot_password_api(body);
    Navigator.of(context).pop();

    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      if (myMap['success'] == true) {
        showToast(myMap['message']);

        Get.toNamed(AppRouter.getLoginRoute());
      }
    }else if (response.statusCode == 401) {
        showToast('Something went wrong while signup');
        update();
      } else if (response.statusCode == 404) {
        Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
        showToast(myMap['error']);
        update();
      } else if (response.statusCode == 500) {
        Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
        if (myMap['message'] != '') {
          showToast(myMap['message']);
        } else {
          showToast('Something went wrong');
        }
        update();
      } else {
        ApiChecker.checkApi(response);
        update();
      }
      update();



    void onBackRoutes() {
      var context = Get.context as BuildContext;
      Navigator.of(context).pop(true);
    }
  }


}