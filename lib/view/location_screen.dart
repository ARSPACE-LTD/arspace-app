import 'package:arspace/controller/location_controller.dart';
import 'package:arspace/util/all_constants.dart';
import 'package:arspace/util/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../util/app_assets.dart';
import '../util/dimens.dart';
import '../util/string.dart';
import '../widgets/commontext.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  double screenHeight = 0;
  double screenWidth = 0;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return GetBuilder<LocationController>(
        builder: (logic) {
          return Scaffold(
            backgroundColor: ThemeProvider.blackColor,
          body: logic.isFetchingLocation == true
          ?Center(
            child: LoadingAnimationWidget.threeRotatingDots(
              color: ThemeProvider.loader_color,
              size: Dimens.loder_size,
            ),
          )
          :SafeArea(
            child: Container(
            height: screenHeight,
            width: screenWidth,
            color: ThemeProvider.blackColor,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: screenHeight * 0.04,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            Get.back();
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
                        CommonTextWidget(
                          heading: AppString.locate,
                          fontSize: Dimens.twentyFour,
                          color: ThemeProvider.whiteColor,
                          fontFamily: 'Lexend',
                          fontWeight: FontWeight.w400,
                        ),
                        CircleAvatar(
                          maxRadius: screenWidth * 0.055,
                          backgroundColor: ThemeProvider.blackColor,
                        )
                      ],
                    ),
                    SizedBox(
                      height: screenHeight * 0.02,
                    ),
                    TextField(
                      onChanged: (value){
                        logic.onSearchChanged(value);
                      },
                      controller: logic.searchController,
                      cursorColor: ThemeProvider.greyColor,
                      style: TextStyle(
                          color: ThemeProvider.whiteColor
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: ThemeProvider.text_background,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: ThemeProvider.greyColor
                          ),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SvgPicture.asset(
                              AssetPath.searchIcon
                          ),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40)
                        ),
                        hintText: 'Search Locate',
                        hintStyle: TextStyle(
                            color: ThemeProvider.whiteColor.withOpacity(0.6)
                        ),

                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.04,
                    ),
                    logic.getList.isNotEmpty?
                    Container(
                      decoration:
                       BoxDecoration(color: ThemeProvider.text_background,
                       borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        children: [
                          for (var item in logic.getList)
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              child: InkWell(
                                onTap: () {
                                  logic.getLatLngFromAddress(item.description.toString() ,"");
                                },
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(5.0),
                                      child: SvgPicture.asset(
                                          AssetPath.searchIcon
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      item.description!.length > 25
                                          ? '${item.description!.substring(0, 25)}...'
                                          : item.description!,
                                      style: TextStyle(
                                        color: ThemeProvider.whiteColor.withOpacity(0.6),
                                        fontFamily: 'Lexend',
                                      )
                                    )
                                  ],
                                ),
                              ),
                            )
                        ],
                      ),
                    )
                    :SizedBox.shrink(),
                    logic.getList.isNotEmpty
                        ? SizedBox(
                      height: screenHeight * 0.04,
                    )
                    :SizedBox.shrink(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CommonTextWidget(
                          heading: AppString.your_locate,
                          fontSize: Dimens.sixteen,
                          color: Color(0xFFA7A9B1),
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: screenHeight * 0.02,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                            AssetPath.mapPoint
                        ),
                        SizedBox(width: 5,),
                        Container(
                          height: 20,
                          width: screenWidth * 0.85,
                          child: CommonTextWidget(
                            heading: logic.currentAddress,
                            fontSize: Dimens.sixteen,
                            color: ThemeProvider.whiteColor,
                            fontFamily: 'Lexend',
                            fontWeight: FontWeight.w400,
                            textOverflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: screenHeight * 0.05,
                    ),
                    logic.recentSearchList.isNotEmpty
                    ? Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CommonTextWidget(
                          heading: AppString.recent,
                          fontSize: Dimens.sixteen,
                          color: Color(0xFFA7A9B1),
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                        ),
                      ],
                    )
                    :SizedBox.shrink(),
                    SizedBox(
                      height: screenHeight * 0.02,
                    ),
                    ListView.builder(
                      padding: EdgeInsets.zero,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: logic.recentSearchList.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: (){

                            logic.getLatLngFromAddress(logic.recentSearchList[index].toString() ,"recent");

                          },
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SvgPicture.asset(
                                      AssetPath.mapPoint
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  CommonTextWidget(
                                    heading: logic.recentSearchList[index].toString(),
                                    fontSize: Dimens.sixteen,
                                    color: ThemeProvider.whiteColor,
                                    fontFamily: 'Lexend',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 18,
                              )
                            ],
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
                    ),
          ),
      );
    });
  }
}
