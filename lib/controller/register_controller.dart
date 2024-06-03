import 'package:arspace/util/all_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../backend/helper/app_router.dart';
import '../backend/parser/register_parser.dart';
import '../util/dimens.dart';
import '../util/theme.dart';

class RegisterController extends GetxController {
  final RigiterParser parser;

  RxBool showPassword = false.obs;
  RxBool isShowingConfirmPassword = false.obs;

  var has8Char = false.obs;
  var hasLN = false.obs;



  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();


  // final passwordController = TextEditingController();

  RegisterController({required this.parser});

  @override
  void onInit() {
    super.onInit();

   // phoneNumber = Get.arguments[0].toString();
  }

  Future<void> onRegister(BuildContext context) async {

    //log("Email adrees going is ${emailController.text} and $phoneNumber");

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

    var body = {"email": emailController.text, "password": passwordController.text};
    var response = await parser.registerEmail(body);

    Navigator.of(context).pop();

    debugPrint(response.bodyString);

    if (response.statusCode == 200) {


      debugPrint(response.bodyString);

      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);

     // successToast("${myMap['message']}");

      if (myMap['success'] == true) {
        successToast("${myMap['message']}");

    //    parser.saveToken(myMap['data']['accessToken']);

        if(myMap['is_verified'] == true){
          Get.toNamed(AppRouter.getLoginRoute());
        }else{
          Get.toNamed(AppRouter.phoneVerificationRoute() ,arguments: [emailController.text.toString()]);

         // Get.toNamed(AppRouter.phoneVerificationRoute());
        }

        emailController.clear();
        passwordController.clear();
        confirmPasswordController.clear();
      } else {
        successToast("${myMap['message']}");
      }
    } else if (response.statusCode == 401) {
      showToast('Something went wrong while signup');
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
      update();
    } else {
      ApiChecker.checkApi(response);
      update();
    }
    update();
  }

  void onBackRoutes() {
    var context = Get.context as BuildContext;
    Navigator.of(context).pop(true);
  }
}
