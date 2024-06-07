import 'package:arspace/backend/helper/app_router.dart';
import 'package:arspace/controller/profile_controller.dart';
import 'package:arspace/util/all_constants.dart';
import 'package:arspace/view/card_list.dart';
import 'package:arspace/view/webview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../util/app_assets.dart';
import '../util/dimens.dart';
import '../util/string.dart';
import '../util/theme.dart';
import '../widgets/commontext.dart';
import 'connectivity_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ConnectivityService connectivityService = Get.find();

  double screenHeight = 0;
  double screenWidth = 0;

  final ProfileController profileController =
      Get.put(ProfileController(parser: Get.find()));

  @override
  void initState() {
    profileController.initialized;


      profileController.getUserProfileApi();



    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return GetBuilder<ProfileController>(builder: (logic) {
      return Scaffold(
        backgroundColor: ThemeProvider.blackColor,
        body: logic.isLoading == true
            ? Center(
          child: LoadingAnimationWidget.threeRotatingDots(
            color: ThemeProvider.loader_color,
            size: Dimens.loder_size,
          ),
        )
            : Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          height: screenHeight * 0.45,
                          width: screenWidth,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                            colors: [
                              Color(0xFFA154FF),
                              Color(0xFFFF3062),
                              Color(0xFFFF6230)
                            ],
                          )),
                        ),
                        Container(
                          height: screenHeight * 0.55,
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black,
                                  spreadRadius: 20,
                                  offset: Offset(5, -25),
                                  blurRadius: 45,
                                )
                              ]),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: screenHeight,
                    decoration: BoxDecoration(
                        color: ThemeProvider.blackColor.withOpacity(0.55)),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: screenHeight * 0.07,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Get.back();
                                  },
                                  child: CircleAvatar(
                                    maxRadius: screenWidth * 0.055,
                                    backgroundColor: ThemeProvider
                                        .text_background
                                        .withOpacity(0.4),
                                    child: Center(
                                      child: SvgPicture.asset(
                                        AssetPath.left_arrow,
                                        height: 25,
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    if(connectivityService.isConnected.value) {
                                      Get.toNamed(
                                          AppRouter.getComplete_profile());
                                    }else{
                                      showToast(AppString.internet_connection);
                                    }

                                  },
                                  child: CircleAvatar(
                                    maxRadius: screenWidth * 0.055,
                                    backgroundColor: ThemeProvider
                                        .text_background
                                        .withOpacity(0.4),
                                    child: Center(
                                      child: SvgPicture.asset(
                                        AssetPath.edit,
                                        height: 25,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * 0.02,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: CircleAvatar(
                              maxRadius: screenWidth * 0.12,
                              backgroundColor: ThemeProvider.text_background
                                  .withOpacity(0.4),
                              backgroundImage: NetworkImage(
                                  "${logic.getProfileResponse.data?.profilePicture ?? ""}"),
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * 0.01,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: CommonTextWidget(
                              heading:
                                  logic.getProfileResponse.data?.fullName ?? "",
                              fontSize: Dimens.twentyFour,
                              color: ThemeProvider.whiteColor,
                              fontFamily: 'Lexend',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * 0.055,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              children: [
                                CommonTextWidget(
                                  heading: AppString.account,
                                  fontSize: Dimens.sixteen,
                                  color: Color(0xFFA7A9B1),
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * 0.055,
                          ),
                          InkWell(
                            onTap: () {
                              if(connectivityService.isConnected.value) {
                                Get.toNamed(AppRouter.location);
                              }else{
                                showToast(AppString.internet_connection);
                              }

                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    AssetPath.location,
                                  ),
                                  SizedBox(
                                    width: 14,
                                  ),
                                  CommonTextWidget(
                                    heading: AppString.location,
                                    fontSize: Dimens.sixteen,
                                    color: ThemeProvider.whiteColor,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * 0.055,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  AssetPath.card,
                                ),
                                SizedBox(
                                  width: 14,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => CardList()));
                                  },
                                  child: CommonTextWidget(
                                    heading: AppString.card,
                                    fontSize: Dimens.sixteen,
                                    color: ThemeProvider.whiteColor,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * 0.055,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              children: [
                                CommonTextWidget(
                                  heading: AppString.about,
                                  fontSize: Dimens.sixteen,
                                  color: Color(0xFFA7A9B1),
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * 0.055,
                          ),
                          GestureDetector(
                            onTap: () {
                              connectivityService.isConnected.value
                                  ? Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) => TermsWebView()))
                                  : showToast(AppString.internet_connection);
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    AssetPath.favourite,
                                  ),
                                  SizedBox(
                                    width: 14,
                                  ),
                                  CommonTextWidget(
                                    heading: AppString.help,
                                    fontSize: Dimens.sixteen,
                                    color: ThemeProvider.whiteColor,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * 0.055,
                          ),
                          GestureDetector(
                            onTap: () {
                              connectivityService.isConnected.value
                                  ? Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => TermsWebView()))
                                  : showToast(AppString.internet_connection);


                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    AssetPath.terms,
                                  ),
                                  SizedBox(
                                    width: 14,
                                  ),
                                  CommonTextWidget(
                                    heading: AppString.terms,
                                    fontSize: Dimens.sixteen,
                                    color: ThemeProvider.whiteColor,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * 0.055,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                fixedSize: MaterialStateProperty.all<Size?>(
                                    Size(screenWidth, 50.0)),
                                backgroundColor:
                                    MaterialStatePropertyAll(Color(0xFF2F323F)),
                              ),
                              onPressed: () async {
                                await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Container(
                                      height: 300,
                                      child: AlertDialog(
                                        backgroundColor: Color(0xFF2F323F),
                                        title: Column(
                                          children: [
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Center(
                                              child: Text(
                                                "Are you sure?",
                                                style: TextStyle(
                                                    color: ThemeProvider
                                                        .whiteColor,
                                                    fontFamily: "Intern"),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 30,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  width: 80,
                                                  height: 35,
                                                  child: SubmitButton(
                                                    onPressed: () => {
                                                      Navigator.of(context)
                                                          .pop(),
                                                      logic.logout(context)
                                                    },
                                                    title: "Yes",
                                                  ),
                                                ),
                                                Container(
                                                  width: 80,
                                                  height: 35,
                                                  child: SubmitButton(
                                                    onPressed: () => {
                                                      Navigator.of(context)
                                                          .pop()
                                                    },
                                                    title: "No",
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    AssetPath.logOut,
                                  ),
                                  SizedBox(
                                    width: 14,
                                  ),
                                  CommonTextWidget(
                                    heading: AppString.logout,
                                    fontSize: Dimens.sixteen,
                                    color: ThemeProvider.whiteColor,
                                    fontFamily: 'Lexend',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * 0.025,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                fixedSize: MaterialStateProperty.all<Size?>(
                                    Size(screenWidth, 50.0)),
                                backgroundColor:
                                MaterialStatePropertyAll(Color(0xFF2F323F)),
                              ),
                              onPressed: () async {
                                await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Container(
                                      height: 300,
                                      child: AlertDialog(
                                        backgroundColor: Color(0xFF2F323F),
                                        title: Column(
                                          children: [
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Center(
                                              child: Text(
                                                "Are you sure you want to delete this account?",
                                                style: TextStyle(
                                                    color: ThemeProvider
                                                        .whiteColor,
                                                    fontFamily: "Intern"),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 30,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              children: [
                                                Container(
                                                  width: 80,
                                                  height: 35,
                                                  child: SubmitButton(
                                                    onPressed: () => {

                                                      Navigator.of(context).pop(),
                                                      logic.deleteAccont(context)
                                                    },
                                                    title: "Yes",
                                                  ),
                                                ),
                                                Container(
                                                  width: 80,
                                                  height: 35,
                                                  child: SubmitButton(
                                                    onPressed: () => {
                                                      Navigator.of(context)
                                                          .pop()
                                                    },
                                                    title: "No",
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.delete,color: Colors.white,),
                                  SizedBox(
                                    width: 14,
                                  ),
                                  CommonTextWidget(
                                    heading: AppString.deleteAccount,
                                    fontSize: Dimens.sixteen,
                                    color: ThemeProvider.whiteColor,
                                    fontFamily: 'Lexend',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      );
    });
  }
}
