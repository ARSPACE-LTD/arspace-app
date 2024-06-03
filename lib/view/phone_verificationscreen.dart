import 'package:arspace/util/all_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../controller/phone_verficationcontroller.dart';
import '../util/dimens.dart';
import '../util/theme.dart';
import '../widgets/commontext.dart';
import 'connectivity_service.dart';

class PhoneVerificationScreen extends StatefulWidget {
  const PhoneVerificationScreen({Key? key}) : super(key: key);

  @override
  State<PhoneVerificationScreen> createState() => _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState extends State<PhoneVerificationScreen> {
  final ConnectivityService connectivityService = Get.find();

  double screenHeight = 0;
  double screenWidth = 0;
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
//    GlobalKey<FormState> otpformKey = GlobalKey<FormState>();
    final PhoneVerificationController verificationController = Get.put(PhoneVerificationController(parser: Get.find()));


   /* @override
    void initState() {
      super.initState();
      verificationController.initialized;
      verificationController.email = Get.arguments[0].toString();
      // Initialize the controller if needed
    }*/
    return GetBuilder<PhoneVerificationController>(builder: (value) {
      return Scaffold(
        backgroundColor: ThemeProvider.blackColor,

        body: SafeArea(
          child: SingleChildScrollView(
            child: Form(
           //   key: otpformKey,
              child: WillPopScope(
                onWillPop: () {
                  Get.back();
                 // Get.offNamedUntil('authentication_typescreen', (route) => false);
                  return Future.value(false);
                },
                child: Container(
                  width: Get.width,
                  height: Get.height,
                  color: ThemeProvider.blackColor,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
                    SizedBox(
                      height: screenHeight * 0.02,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20),
                      child: InkWell(
                        onTap: () {
                          Get.back();
                          /*  Get.offNamedUntil('authentication_typescreen',
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
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: screenHeight * 0.02,
                          ),
                          Center(
                              child: CommonTextWidget(
                            heading: AppString.otp,
                            fontSize: Dimens.thirty,
                            color: ThemeProvider.whiteColor,
                            fontFamily: 'bold',
                            fontWeight: FontWeight.w600,
                          )),
                          SizedBox(
                            height: screenHeight * 0.02,
                          ),
                          CommonTextWidget(
                            heading: AppString.mobile_verify,
                            fontSize: Dimens.sixteen,
                            color: ThemeProvider.whiteColor,
                            fontFamily: 'bold',
                            fontWeight: FontWeight.w400,
                          ),
                          Obx(() =>  CommonTextWidget(
                            heading: value.email.value,
                            fontSize: Dimens.sixteen,
                            color: ThemeProvider.whiteColor,
                            fontFamily: 'bold',
                            fontWeight: FontWeight.w600,
                          )),

                          pinArea1(context, value),
                          SizedBox(
                            height: screenHeight * 0.03,
                          ),
                          SubmitButton(
                            onPressed: () => {
                            connectivityService.isConnected.value ?
                              value.verifyOtp(context):
                showToast(AppString.internet_connection)


                             // if (otpformKey.currentState!.validate()) {}
                            },
                            title: AppString.submit,
                          ),
                          SizedBox(
                            height: screenHeight * 0.03,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // CommonTextWidget(
                              //   heading: AppString.notgot_otp,
                              //   fontSize: Dimens.sixteen,
                              //   color: Colors.black,
                              //   fontFamily: 'bold',
                              //   fontWeight: FontWeight.w600,
                              // ),
                              Text(
                                AppString.notgot_otp,
                                style: TextStyle(fontFamily: 'bold', fontWeight: FontWeight.w600, fontSize: Dimens.sixteen ,color: ThemeProvider.whiteColor),
                              ),
                              InkWell(
                                onTap: () {
                                  value.resendOtp(context);
                                },
                                child: Text(
                                  AppString.resend_sms,
                                  style: TextStyle(fontFamily: 'bold', fontWeight: FontWeight.w600, fontSize: Dimens.sixteen, decoration: TextDecoration.underline, color: ThemeProvider.secondaryAppColor),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ]),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget pinArea1(BuildContext context1, PhoneVerificationController value) {
    return Container(
      height: 100.0,
      margin: EdgeInsets.only(top: Dimens.twenty),
      padding: EdgeInsets.symmetric(vertical: Dimens.ten),
      child: GestureDetector(
        onLongPress: () {
          print("LONG");
        },
        child: PinCodeTextField(
          cursorColor:  ThemeProvider.blackColor,
          length: 6,
          obscureText: false,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          textStyle: TextStyle(fontSize: Dimens.twenty, fontWeight: FontWeight.w500),
          animationType: AnimationType.fade,
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.box,
            borderRadius: BorderRadius.circular(5),
            fieldHeight: Dimens.forty,
            fieldWidth: Dimens.forty,
            selectedColor: ThemeProvider.whiteColor,
            selectedFillColor: ThemeProvider.whiteColor,
            inactiveColor: ThemeProvider.whiteColor,
            activeColor: ThemeProvider.appColor,
            inactiveFillColor: ThemeProvider.whiteColor,
            activeFillColor: ThemeProvider.light_primary,
          ),
          animationDuration: Duration(milliseconds: 300),
          enableActiveFill: true,
          keyboardType: TextInputType.number,
          onCompleted: (v) {
            print("Completed");
            // _allFilled = true;
            // _newPin = v;
            value.otpValue.text = v;
          },
          onChanged: (value1) {
            print("value is $value and lengtbn is ${value1.length}");
            setState(() {
              if (value1.length == 6) {
                value.otpValue.text = value1;
                //   _allFilled = true;
                //   _showDarkButton = true;
                // } else if (value.length < 4) {
                //   _allFilled = false;
                // }
                //   setState(() {});
              }
            });
          },
          beforeTextPaste: (text) {
            print("Allowing to paste $text");
            //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
            //but you can show anything you want here, like your pop up saying wrong paste format or etc
            return true;
          },
          appContext: context1,
        ),
      ),
    );
  }
}
