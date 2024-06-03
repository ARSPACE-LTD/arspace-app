import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

import '../backend/helper/app_router.dart';
import '../controller/authentication_type_controller.dart';
import '../util/all_constants.dart';
import '../util/dimens.dart';
import '../util/theme.dart';
import '../widgets/commontext.dart';

class AuthenticationTypeScreen extends StatefulWidget {
  const AuthenticationTypeScreen({Key? key}) : super(key: key);

  @override
  State<AuthenticationTypeScreen> createState() => _AuthenticationTypeScreenState();
}

class _AuthenticationTypeScreenState extends State<AuthenticationTypeScreen> {
  double screenHeight = 0;
  double screenWidth = 0;
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return GetBuilder<AuthenticationTypeController>(builder: (value) {
      return Scaffold(
          backgroundColor: ThemeProvider.blackColor,
          body: SafeArea(
              top: false, // ignore the top safe area
              bottom: false, // ignore the bottom safe area
              child: Container(

        //margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: WillPopScope(
          onWillPop: () {
            SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            return Future.value(false);
          },
          child: Column(
            /* crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,*/
            children: [


              CarouselSlider.builder(
                itemCount: 3,
                itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) => Container(
                  child: Container(
                    height: Get.height * 0.7,
                    width: Get.width ,

                    decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(0),
                        image: DecorationImage(image: AssetImage('assets/images/onboard${itemIndex + 1}.png'),
                            fit: BoxFit.fill)),
                  ),
                ),
                options: CarouselOptions(
                  autoPlayInterval: Duration(seconds: 5),
                  viewportFraction: 1,
                  height: Get.height * 0.7,
                  autoPlay: true,
                  autoPlayCurve: Curves.ease,
                  enableInfiniteScroll: true,
                  autoPlayAnimationDuration: Duration(milliseconds: 500),
                ),
              ),

           /*   Container(
                child: Image.asset( AssetPath.discover1,
                  height: Get.height * 0.7,
                  width: Get.width ,
                  fit: BoxFit.fill ,
                ),
              ),*/
              Container(
                /*decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        spreadRadius: 20,
                        offset: Offset(5, -25),
                        blurRadius: 45,
                      )
                    ]
                ),*/
                child: Column(
                  children: [
                    SizedBox(height:Get.height * 0.040 ,),
                    Container(
                      margin: EdgeInsets.only(left: Get.width*0.08 ,right: Get.width*0.08),
                      child: CommonTextWidget(
                        textAlign: TextAlign.center,

                        heading: AppString.intro_text,
                        fontSize: Dimens.sixteen,
                        color: Colors.white,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                    SizedBox(height:Get.height * 0.040 ,),


                    Container(
                      margin: EdgeInsets.only(left: Get.width*0.08 ,right: Get.width*0.08 ,top:Get.width*0.08 ),

                      child: SubmitButton(
                        onPressed: () => {
                        //  Get.toNamed(AppRouter.getLoginRoute())
                          Get.toNamed(AppRouter.getDashboardScreenRoute())
                        },
                        title: AppString.intro_button_text,
                      ),
                    ),
                  ],
                ),
              )


              /*
                  SizedBox(
                    height: screenHeight * 0.02,
                  ),
                  SubmitButton(
                    onPressed: () => {
                      {Get.toNamed(AppRouter.getLoginRoute())},

                      ///  if (value.formKey.currentState!.validate()) {value.onLoginClicked()}
                    },
                    title: AppString.create_an_account,
                  )*/
            ],
          ),
        ),
      )));
    });
  }
}
