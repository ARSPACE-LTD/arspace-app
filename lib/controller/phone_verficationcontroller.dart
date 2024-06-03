import 'package:arspace/util/all_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../backend/helper/app_router.dart';
import '../backend/parser/phoneverification_parser.dart';
import '../util/dimens.dart';
import '../util/theme.dart';

class PhoneVerificationController extends GetxController {
  final PhoneVerificationParser parser;

  late TextEditingController otpValue = TextEditingController();

  final isShowingPassword = false.obs;
  final isShowingConfirmPsd = false.obs;

  var has8Char = false.obs;
  var hasLN = false.obs;

  RxString email = "".obs;

  PhoneVerificationController({required this.parser});
  @override
  void onInit() {
    super.onInit();
    email.value = Get.arguments[0].toString();

  }

  Future<void> resendOtp(BuildContext context) async {
    var body = {"email": email.value};

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

    var response = await parser.resendOtpApi(body);
    
    Navigator.of(context).pop();
    //  Get.back();
    debugPrint(response.bodyString);

    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      if (myMap['success'] == true) {
        if(myMap['is_login'] == true){
          successToast(myMap['message']);
          Get.toNamed(AppRouter.getLoginRoute());

        }else{
          successToast(myMap['message']);
        }
      } else {
        showToast('Details are incorrect');
      }
    } else if (response.statusCode == 400) {
      showToast('Something went wrong'.tr);
      update();
    } else if (response.statusCode == 404) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      showToast(myMap['error']);
      update();
    }else if (response.statusCode == 500) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      if (myMap['message'] != '') {
        showToast(myMap['message']);
      } else {
        showToast('Something went wrong');
      }
    } else {
      ApiChecker.checkApi(response);
      update();
    }
    update();
  }

  Future<void> verifyOtp(BuildContext context) async {
    if (otpValue.text.isEmpty) {
      showToast('Please enter Otp'.tr);
      return;
    }

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

    var body = {"email":email.value ,  "otp": otpValue.text};

    var response = await parser.EmailVerificationApi(body);
    Navigator.of(context).pop();
    debugPrint(response.bodyString);

    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      if (myMap['success'] == true) {
        successToast(myMap['message']);
        parser.saveToken(myMap['token']);
        parser.saveUserUUID(myMap['data']["uuid"]);

        Get.toNamed(AppRouter.requestToSetProfile());
        /*if (myMap['is_registered'] == true) {


          Get.toNamed(AppRouter.dashboardScreen);
        } else {
          Get.toNamed(AppRouter.register, arguments: [email]);
        }*/
      } else {
        if (myMap['message'] != '') {
          showToast(myMap['message']);
        }
      }
    } else if (response.statusCode == 400) {
      showToast('Something went wrong while signup'.tr);
      update();
    }else if (response.statusCode == 404) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      showToast(myMap['error']);
      update();
    }  else if (response.statusCode == 500) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      if (myMap['message'] != '') {
        showToast(myMap['message'.tr]);
      } else {
        showToast('Something went wrong'.tr);
      }
      update();
    } else {
      ApiChecker.checkApi(response);
      update();
    }
  }

  void onBackRoutes() {
    var context = Get.context as BuildContext;
    Navigator.of(context).pop(true);
  }
}
