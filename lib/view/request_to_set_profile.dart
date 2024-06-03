import 'package:arspace/util/all_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

import '../backend/helper/app_router.dart';
import '../controller/requestToSetProfileController.dart';
import '../util/dimens.dart';
import '../util/theme.dart';
import '../widgets/commontext.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/skip_button.dart';

class RequestToSetProfile extends StatefulWidget {
  const RequestToSetProfile({super.key});

  @override
  State<RequestToSetProfile> createState() => _RwquestToSetProfileState();
}

class _RwquestToSetProfileState extends State<RequestToSetProfile> {
  double screenHeight = 0;
  double screenWidth = 0;
  @override
  Widget build(BuildContext context) {

    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return GetBuilder<RequestToSetProfileController>(builder: (value){
      return Scaffold(
          backgroundColor: ThemeProvider.blackColor,

          resizeToAvoidBottomInset: true,
          body: SafeArea(

              child: Container(
                color: ThemeProvider.blackColor,
                padding: EdgeInsets.only(
                    left: Get.width * 0.06, right: Get.width * 0.06),
                child: WillPopScope(
                  onWillPop: () {
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  /*  Get.offNamedUntil(
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
                                 // Get.back();
                                  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
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
                                    heading: AppString.request_to_set_profile,
                                    fontSize: Dimens.thirtySix,
                                    color: ThemeProvider.whiteColor,
                                    fontFamily: 'Lexend',
                                    fontWeight: FontWeight.w600,
                                  )),
                              SizedBox(
                                height: screenHeight * 0.02,
                              ),
                              CommonTextWidget(
                                heading: AppString.request_to_set_profile_text,
                                fontSize: Dimens.sixteen,
                                color: Color(0xFFA7A9B1),
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                              ),

                              SizedBox(
                                height: screenHeight * 0.06,
                              ),

                              SkipButton(onPressed: (){
                                Get.toNamed(AppRouter.getDashboardScreenRoute());
                              },
                                title: AppString.skip,) ,

                              SizedBox(
                                height: screenHeight * 0.04,
                              ),

                              SubmitButton(onPressed: (){
                                Get.toNamed(AppRouter.getComplete_profile());


                              }, title: AppString.Sure_let_go)

                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )));

    });
  }
}
