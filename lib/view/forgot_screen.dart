import 'package:arspace/util/all_constants.dart';
import 'package:arspace/util/extensions/textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

import '../controller/forgot_controller.dart';
import '../util/dimens.dart';
import '../util/theme.dart';
import '../widgets/commontext.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/submit_button.dart';
import 'connectivity_service.dart';

class ForgotScreen extends StatefulWidget {
  const ForgotScreen({Key? key}) : super(key: key);

  @override
  State<ForgotScreen> createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
  final ConnectivityService connectivityService = Get.find();

  double screenHeight = 0;
  double screenWidth = 0;

  GlobalKey<FormState> forgotformKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return GetBuilder<ForgotControler>(builder: (value) {
      return Scaffold(
          backgroundColor: ThemeProvider.blackColor,
          resizeToAvoidBottomInset: true,
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SafeArea(
                child: Form(
              key: forgotformKey,
              child: Container(
                color: ThemeProvider.blackColor,
                padding: EdgeInsets.only(
                    left: Get.width * 0.06, right: Get.width * 0.06),
                child: WillPopScope(
                  onWillPop: () {
                    Get.back();
                    /*   Get.offNamedUntil(
                            'authentication_typescreen', (route) => false);*/
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
                                },
                                child: CircleAvatar(
                                  maxRadius: screenWidth * 0.055,
                                  backgroundColor:
                                      ThemeProvider.text_background,
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
                                heading: AppString.reset_password,
                                fontSize: Dimens.thirtySix,
                                color: ThemeProvider.whiteColor,
                                fontFamily: 'Lexend',
                                fontWeight: FontWeight.w600,
                              )),
                              SizedBox(
                                height: screenHeight * 0.02,
                              ),
                              CommonTextWidget(
                                heading: AppString.reset_password_text,
                                fontSize: Dimens.sixteen,
                                color: Color(0xFFA7A9B1),
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                              ),
                              SizedBox(
                                height: screenHeight * 0.06,
                              ),
                              CustomTextField(
                                controller: value.forgotEmailController,
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
                                height: screenHeight * 0.08,
                              ),
                              SubmitButton(
                                onPressed: () => {
                                  if (forgotformKey.currentState!.validate())
                                    {
                                      if (connectivityService.isConnected.value)
                                        {value.onbuttonClicked( context) }
                                      else
                                        {
                                          showToast(
                                              AppString.internet_connection)
                                        }
                                    }
                                },
                                title: AppString.Continue,
                              ),
                              /*   SizedBox(
                                    height: screenHeight * 0.08,
                                  ),
                                  Center(
                                    child: CommonTextWidget(
                                      heading: AppString.Forgot_password,
                                      fontSize: Dimens.seventeen,
                                      color: ThemeProvider.primary,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),*/
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )),
          ));
    });
  }
}
