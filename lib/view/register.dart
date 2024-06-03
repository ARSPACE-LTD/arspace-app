import 'package:arspace/util/all_constants.dart';
import 'package:arspace/util/extensions/textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

import '../backend/helper/app_router.dart';
import '../controller/register_controller.dart';
import '../util/dimens.dart';
import '../util/theme.dart';
import '../widgets/commontext.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/next_button.dart';
import 'connectivity_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final ConnectivityService connectivityService = Get.find();

  double screenHeight = 0;
  double screenWidth = 0;


  GlobalKey<FormState> registerformKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return GetBuilder<RegisterController>(builder: (value) {
      return Scaffold(
          backgroundColor: ThemeProvider.blackColor,

          resizeToAvoidBottomInset: true,
          body: GestureDetector(
            onTap: (){
              FocusScope.of(context).unfocus();
            },
            child: SafeArea(
                child: Form(
                  key: registerformKey,
                  child: Container(
                    color: ThemeProvider.blackColor,
                    padding: EdgeInsets.only(
                        left: Get.width * 0.06, right: Get.width * 0.06),
                    child: WillPopScope(
                      onWillPop: () {
                        //  Get.close(0);
                        Get.offNamedUntil(
                            'authentication_typescreen', (route) => false);
                        return Future.value(false);
                      },
                      child: Column(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: screenHeight * 0.04,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Get.offNamedUntil('authentication_typescreen',
                                              (route) => false);
                                    },
                                    child: CircleAvatar(
                                      maxRadius: screenWidth * 0.055,
                                      backgroundColor: ThemeProvider.text_background,
                                      child: Center(
                                        child: SvgPicture.asset(
                                          AssetPath.left_arrow,
                                          height: 25,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: screenHeight * 0.06,
                                  ),
                                  Container(
                                      child: CommonTextWidget(
                                        heading: AppString.signUp_header,
                                        fontSize: Dimens.thirtySix,
                                        color: ThemeProvider.whiteColor,
                                        fontFamily: 'Lexend',
                                        fontWeight: FontWeight.w600,
                                      )),
                                  SizedBox(
                                    height: screenHeight * 0.02,
                                  ),
                                  CommonTextWidget(
                                    heading: AppString.sign_up_text,
                                    fontSize: Dimens.sixteen,
                                    color: Color(0xFFA7A9B1),
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                  ),
                                  SizedBox(
                                    height: screenHeight * 0.06,
                                  ),
                                  CustomTextField(
                                    controller: value.emailController,
                                    backgroundColor: ThemeProvider.whiteColor,
                                    hintText: AppString.email,
                                    keyboardType: TextInputType.text,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return AppString.error_email;
                                      } else if (value.isValidEmail() == false) {
                                        return AppString.please_enter_valid_email;
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(
                                    height: screenHeight * 0.02,
                                  ),
                                  CustomTextField(
                                    controller: value.passwordController,
                                    backgroundColor: ThemeProvider.whiteColor,
                                    maxLines: 1,
                                    //  controller: value.socialSecurityController,
                                    obscureText: value.showPassword.value == true
                                        ? false
                                        : true,

                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          value.showPassword.value =
                                          !value.showPassword.value;
                                        });
                                      },
                                      icon: Icon(
                                        value.showPassword.value == false
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: ThemeProvider.blackColor,
                                      ),
                                    ),
                                    hintText: AppString.password,
                                    keyboardType: TextInputType.text,
                                    onChanged: (check_value) {
                                      if (value.has8Char.isFalse && check_value.length > 7) {
                                        value.has8Char.value = true;
                                      }
                                      if (value.has8Char.isTrue && check_value.length < 8) {
                                        value.has8Char.value = false;
                                      }
                                      if (value.hasLN.isFalse && RegExp(".*([a-zA-Z].*[0-9]|[0-9].*[a-zA-Z]).*").hasMatch(check_value)) {
                                        value.hasLN.value = true;
                                      }
                                      if (value.hasLN.isTrue && !RegExp(".*([a-zA-Z].*[0-9]|[0-9].*[a-zA-Z]).*").hasMatch(check_value)) {
                                        value.hasLN.value = false;
                                      }
                                    },
                                    validator: (value1) {
                                      if (value1 == null || value1.isEmpty) {
                                        return AppString.error_msg_password;
                                      }else if (!value.has8Char.value) {
                                        return 'Password must have at least 8 characters';
                                      } else if (!value.hasLN.value) {
                                        return 'Password must contain both letters and numbers';
                                      }
                                      return null;
                                    },

                                  ),
                                  SizedBox(
                                    height: screenHeight * 0.02,
                                  ),
                                  CustomTextField(
                                    controller: value.confirmPasswordController,
                                    backgroundColor: ThemeProvider.whiteColor,
                                    maxLines: 1,
                                    //  controller: value.socialSecurityController,
                                    obscureText: value.isShowingConfirmPassword.value == true
                                        ? false
                                        : true,

                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          value.isShowingConfirmPassword.value =
                                          !value.isShowingConfirmPassword.value;
                                        });
                                      },
                                      icon: Icon(
                                        value.isShowingConfirmPassword.value == false
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: ThemeProvider.blackColor,
                                      ),
                                    ),
                                    hintText: AppString.confirm_password,
                                    keyboardType: TextInputType.text,
                                    onChanged: (check_value) {
                                      if (value.has8Char.isFalse && check_value.length > 7) {
                                        value.has8Char.value = true;
                                      }
                                      if (value.has8Char.isTrue && check_value.length < 8) {
                                        value.has8Char.value = false;
                                      }
                                      if (value.hasLN.isFalse && RegExp(".*([a-zA-Z].*[0-9]|[0-9].*[a-zA-Z]).*").hasMatch(check_value)) {
                                        value.hasLN.value = true;
                                      }
                                      if (value.hasLN.isTrue && !RegExp(".*([a-zA-Z].*[0-9]|[0-9].*[a-zA-Z]).*").hasMatch(check_value)) {
                                        value.hasLN.value = false;
                                      }
                                    },
                                    validator: (value1) {
                                      if (value1 == null || value1.isEmpty) {
                                        return AppString.confirm_error_msg_password;
                                      }else if (!value.has8Char.value) {
                                        return 'Password must have at least 8 characters';
                                      } else if (!value.hasLN.value) {
                                        return 'Password must contain both letters and numbers';
                                      }else if (value.passwordController.text.toString() != value.confirmPasswordController.text.toString()){
                                        return AppString.msg_your_password_doesnt_match;
                                      }
                                      return null;
                                    },

                                  ),

                                  SizedBox(
                                    height: screenHeight * 0.08,
                                  ),
                                  SubmitButton(
                                    onPressed: () => {
                                    FocusScope.of(context).unfocus(),

                                      /* Get.toNamed(AppRouter.requestToSetProfile())*/
                                      if (registerformKey.currentState!.validate()){
                                       connectivityService.isConnected.value ? value.onRegister(context)


                            :showToast(AppString.internet_connection)



                                      }
                                    },
                                    title: AppString.Continue,
                                  ),

                                ],
                              ),
                            ),
                          ),
                          Container(
                              alignment: Alignment.bottomCenter,
                              padding: EdgeInsets.only(bottom: 20 ,top: 10),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CommonTextWidget(
                                      heading: AppString.have_account,
                                      fontSize: Dimens.sixteen,
                                      color: ThemeProvider.whiteColor,
                                      fontFamily: 'Manrope',
                                    ),
                                    SizedBox(
                                      width: 2,
                                    ),
                                    InkWell(
                                      onTap: (){
                                        Get.toNamed(AppRouter.getLoginRoute());
                                      },
                                      child: CommonTextWidget(
                                        heading: AppString.login,
                                        fontSize: Dimens.sixteen,
                                        color: ThemeProvider.primary,
                                        fontFamily: 'Roboto',
                                      ),
                                    ),
                                  ])),
                        ],
                      ),
                    ),
                  ),
                )),
          ));
    });
  }


}
