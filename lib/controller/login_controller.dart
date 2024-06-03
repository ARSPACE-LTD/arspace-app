import 'package:arspace/util/all_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../backend/parser/htmlLoaderParser.dart';
import '../util/dimens.dart';
import '../util/loader.dart';
import '../view/custom_loader.dart';
import '../backend/helper/app_router.dart';
import '../backend/parser/login_parser.dart';
import '../util/theme.dart';
import 'htmlLoaderController.dart';

class LoginController extends GetxController {
  final LoginParser parser;

  LoginController({required this.parser});

  // final countryCodeController = TextEditingController();
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();

  RxBool showPassword = false.obs;

  var has8Char = false.obs;
  var hasLN = false.obs;

  final HtmlLoaderController htmlLoaderController =
      Get.put(HtmlLoaderController(parser: Get.find()));

  @override
  void onInit() {
    super.onInit();
    htmlLoaderController.initialized; // Initialize the controller if needed
  }

  Future<void> onLoginClicked(BuildContext context) async {
    var body = {
      // "email": countryCodeController.text,
      "username": userNameController.text.toString(),
      "password": passwordController.text.toString(),
      "is_staff":false
    };

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

    var response = await parser.loginPhoneNumber(body);

    Navigator.of(context).pop();

    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      if (myMap['success'] == true) {
        successToast(myMap['message']);
        parser.saveToken(myMap['token']);
        parser.saveUserUUID(myMap['data']["uuid"]);
        print("token--->${myMap['token']}");
        print("uuid--->${myMap['data']["uuid"]}");

        UpdateDeviceToken();
        Get.toNamed(AppRouter.getDashboardScreenRoute());
        /*if (myMap['is_registered'] == true) {


          Get.toNamed(AppRouter.dashboardScreen);
        } else {
          Get.toNamed(AppRouter.register, arguments: [email]);
        }*/
      }
    } else if (response.statusCode == 401) {
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
  }

  Future<void> UpdateDeviceToken() async {
    var body = {
      // "email": countryCodeController.text,
      "device_token": AppConstants.fcm_token,
    };
    var response = await parser.updateDeviceToken(body);

    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      if (myMap['success'] == true) {
        print("token is updated --->${myMap.toString()}");
      }
    } else if (response.statusCode == 401) {
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
  }
}
