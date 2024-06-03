
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

    // Future<void> googleSignIn() async {
    //   String? email;
    //   String? token;
    //   final GoogleSignIn googleSignIn = GoogleSignIn();
    //   final isAlreadySignIn = await googleSignIn.isSignedIn();
    //   if (isAlreadySignIn) {
    //     await googleSignIn.signOut();
    //   }
    //   final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
    //   email = googleSignInAccount?.email;
    //   print("email==> $email");
    //
    //   if (googleSignInAccount != null) {
    //     final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
    //     print(googleSignInAuthentication.accessToken);
    //   }
    //   //   controller.login(email!, "socials");
    // }
    //
    // Future<void> faceBookSignUp() async {
    //   final fb = FacebookLogin();
    //   final isAlreadyLogin = await fb.isLoggedIn;
    //   if (isAlreadyLogin) {
    //     await fb.logOut();
    //   }
    //
    //   final res = await fb.logIn(permissions: [
    //     FacebookPermission.publicProfile,
    //     FacebookPermission.email,
    //   ]);
    //
    //   switch (res.status) {
    //     case FacebookLoginStatus.success:
    //       final FacebookAccessToken? accessToken = res.accessToken;
    //       print('Access token: ${accessToken?.token}');
    //       final profile = await fb.getUserProfile();
    //       print('Hello, ${profile?.name}! You ID: ${profile?.userId}');
    //       final imageUrl = await fb.getProfileImageUrl(width: 100);
    //       print('Your profile image: $imageUrl');
    //       final emailuser = await fb.getUserEmail();
    //       if (emailuser != null) {
    //         print('And your email is $emailuser');
    //
    //         if (emailuser.isEmpty) {
    //           print("User login failed");
    //         } else {
    //           String token = accessToken!.token;
    //           // controller.login(emailuser, "socials");
    //           // Get.find<ApiClient>().socialLoginService(email ,token);
    //         }
    //       }
    //       break;
    //     case FacebookLoginStatus.cancel:
    //       // User cancel log in
    //       break;
    //     case FacebookLoginStatus.error:
    //       // Log in failed
    //       print('Error while log in: ${res.error}');
    //       break;
    //   }
    // }

    void onBackRoutes() {
      var context = Get.context as BuildContext;
      Navigator.of(context).pop(true);
    }
  }


}