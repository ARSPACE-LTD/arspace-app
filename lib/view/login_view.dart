import 'package:arspace/util/all_constants.dart';
import 'package:arspace/util/extensions/textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

import '../backend/helper/app_router.dart';
import '../controller/login_controller.dart';
import '../util/dimens.dart';
import '../util/theme.dart';
import '../widgets/commontext.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_textfield.dart';
import 'connectivity_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final ConnectivityService connectivityService = Get.find();

  double screenHeight = 0;
  double screenWidth = 0;
  GlobalKey<FormState> loginformKey = GlobalKey<FormState>();



  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return GetBuilder<LoginController>(builder: (value) {
      return Scaffold(
          backgroundColor: ThemeProvider.blackColor,

          resizeToAvoidBottomInset: true,
          body: GestureDetector(
            onTap: (){
              FocusScope.of(context).unfocus();
            },
            child: SafeArea(
                child: Form(
                key: loginformKey,
                child: Container(
                color: ThemeProvider.blackColor,
                padding: EdgeInsets.only(
                    left: Get.width * 0.06, right: Get.width * 0.06),
                child: WillPopScope(
                  onWillPop: () {
                    Get.back();
                  ///  Get.offNamedUntil('authentication_typescreen', (route) => false);
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
                                  Get.back();
                                 /* Get.offNamedUntil('authentication_typescreen',
                                          (route) => false);*/
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
                                heading: AppString.login_header,
                                fontSize: Dimens.thirtySix,
                                color: ThemeProvider.whiteColor,
                                fontFamily: 'Lexend',
                                fontWeight: FontWeight.w600,
                              )),
                              SizedBox(
                                height: screenHeight * 0.02,
                              ),
                              CommonTextWidget(
                                heading: AppString.welcome_back,
                                fontSize: Dimens.sixteen,
                                color: Color(0xFFA7A9B1),
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                              ),
                              SizedBox(
                                height: screenHeight * 0.06,
                              ),
                              CustomTextField(
                                controller: value.userNameController,
                                hintText: AppString.email,
                                keyboardType: TextInputType.text,
                                backgroundColor: ThemeProvider.whiteColor,

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
                                backgroundColor: ThemeProvider.whiteColor,

                                controller: value.passwordController,
                                obscureText: value.showPassword.value == true
                                    ? false
                                    : true,
                                maxLines: 1,

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
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return AppString.error_msg_password;
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: screenHeight * 0.08,
                              ),

                              SubmitButton(
                                onPressed: () => {

                                  if (loginformKey.currentState!.validate())
                                    {
                                      connectivityService.isConnected.value
                                          ? value.onLoginClicked(context)
                                          :  showToast(AppString.internet_connection),

                                    }
                                },
                                title: AppString.login_button,
                              ),
                              SizedBox(
                                height: screenHeight * 0.05,
                              ),
                              InkWell(
                                onTap: (){
                                  Get.toNamed(AppRouter.getForgotRoute());
                                },
                                child: Center(
                                  child: CommonTextWidget(
                                    heading: AppString.Forgot_password,
                                    fontSize: Dimens.seventeen,
                                    color: ThemeProvider.primary,
                                    fontFamily: 'Manrope',
                                  ),
                                ),
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
                                  heading: AppString.dont_have,
                                  fontSize: Dimens.sixteen,
                                  color: ThemeProvider.whiteColor,
                                  fontFamily: 'Manrope',
                                ),
                                SizedBox(
                                  width: 2,
                                ),
                                InkWell(
                                  onTap: (){
                                    Get.toNamed(AppRouter.getRegisterRoute());
                                  },
                                  child: CommonTextWidget(
                                    heading: AppString.sign_up,
                                    fontSize: Dimens.sixteen,
                                    color: ThemeProvider.primary,
                                    fontFamily: 'Roboto'
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
