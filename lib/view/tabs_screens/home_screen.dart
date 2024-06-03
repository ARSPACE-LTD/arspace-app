import 'dart:ui';

import 'package:arspace/util/all_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../backend/helper/app_router.dart';
import '../../controller/home_screen_controller.dart';
import '../../controller/profile_controller.dart';
import '../../util/app_assets.dart';
import '../../util/dimens.dart';
import '../../util/theme.dart';
import '../../widgets/commontext.dart';
import '../connectivity_service.dart';
import 'package:badges/badges.dart' as badges;


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ConnectivityService connectivityService = Get.find();

  double screenHeight = 0;
  double screenWidth = 0;


  final HomeScreenController homeScreenController = Get.put(HomeScreenController(parser: Get.find()));
  final ProfileController profileController = Get.put(ProfileController(parser: Get.find()));

  @override
  void initState() {
    super.initState();
    /*SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: ThemeProvider.match_background,
    ));*/

    homeScreenController.initialized; // Initialize the controller if needed
    profileController.initialized;

    if(homeScreenController.parser.CheckToken() != null && homeScreenController.parser.CheckToken().isNotEmpty ){
      homeScreenController.getUserProfileApi();
      homeScreenController.getAllNotifications();
    }

    homeScreenController.getEvents();

    homeScreenController.currentAddress = homeScreenController.parser.sharedPreferencesManager.getString("shortAddress")??"My Location";
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return GetBuilder<HomeScreenController>(builder: (value) {

      return value.isLoading ==true
          ?Center(
        child: LoadingAnimationWidget.threeRotatingDots(
          color: ThemeProvider.loader_color,
          size: Dimens.loder_size,
        ),
      ): Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          physics: ClampingScrollPhysics(), // Combine with NeverScrollableScrollPhysics to disable bouncing


          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(overscroll: false),
            child: Stack(
              children: [
                Container(
                  color: Colors.black,
                  child: Opacity(
                    opacity: 0.6,
                    child: Stack(
                      children: [
                        ImageFiltered(
                          imageFilter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                          child: Container(
                            height: screenHeight,
                            width: screenWidth,
            
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(
                                  /*"https://fastly.picsum.photos/id/1024/200/300.jpg?hmac=Zf-5s5sbTMmFYhm-_rzZXktzs5i_ES8dVOzXPCS6zxU",*/
                                  value.geteventResponse.data?[value.imageIndex].images != null && value.geteventResponse.data![value.imageIndex].images!.isNotEmpty
                                      ? value.geteventResponse.data![value.imageIndex].images![0].image! : "https://fastly.picsum.photos/id/1024/200/300.jpg?hmac=Zf-5s5sbTMmFYhm-_rzZXktzs5i_ES8dVOzXPCS6zxU",
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: screenHeight * 0.7,
                          width: screenWidth * 20,
                          child: Container(
                            height: screenHeight * 0.30,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black,
                                  spreadRadius: 20,
                                  offset: Offset(5, -25),
                                  blurRadius: 45,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ListTile(
                            title: GestureDetector(
                              onTap: () {
                                connectivityService.isConnected.value
                                    ? Get.toNamed(AppRouter.getLocation())
                                    : showToast(AppString.internet_connection);

                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SvgPicture.asset(
                                    AssetPath.mapPoint,
                                    color: ThemeProvider.whiteColor.withOpacity(0.6),
                                  ),
                                  SizedBox(width: 5),
                                  Container(

                                    constraints:
                                    BoxConstraints(
                                      maxWidth: MediaQuery.of(
                                          context)
                                          .size
                                          .width *
                                          0.4,
                                      // minWidth:  MediaQuery.of(context).size.width * 0.10
                                    ),
                                    child: CommonTextWidget(
                                      heading: value.currentAddress != null ? value.currentAddress : "My location",
                                      fontSize: Dimens.sixteen,
                                      color: ThemeProvider.whiteColor.withOpacity(0.6),
                                      fontFamily: 'Intern',
                                      maxLines: 1,
                                      fontWeight: FontWeight.w400,
                                      textOverflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            subtitle: Container(
                              margin: EdgeInsets.only(top: 5),
                              width: Get.width * 0.6,
                              child: CommonTextWidget(
                                heading: value.getProfileResponse.data?.fullName != null ? value.getProfileResponse.data?.fullName : "",
                                fontSize: Dimens.thirtySix,
                                color: ThemeProvider.whiteColor.withOpacity(0.85),
                                fontFamily: 'Lexend',
                                fontWeight: FontWeight.w400,
                                textOverflow: TextOverflow.visible,
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [

                                homeScreenController.parser.CheckToken() != null && homeScreenController.parser.CheckToken().isNotEmpty?
                            Obx(() =>  badges.Badge(
                              showBadge: homeScreenController.notificationCount.value.isNotEmpty ? true : false,
                              onTap: () {
                                connectivityService.isConnected.value
                                    ? Get.toNamed(AppRouter.getNotification_screen())?.then((value1) => {
                                  value.getAllNotifications()
                                })
                                    : showToast(AppString.internet_connection);


                                print("Tapped");
                              },
                              badgeStyle: badges.BadgeStyle(
                                shape: badges.BadgeShape.circle,
                                badgeColor: ThemeProvider.primary,

                              ),
                              badgeContent: Text(
                                homeScreenController.notificationCount.value,
                                style: TextStyle(color: Colors.white),
                              ),
                              child: IconButton(
                                icon: Icon(Icons.notifications_active,
                                  color: Colors.white,
                                  size: 30,),
                                onPressed: ()  {
                                  connectivityService.isConnected.value
                                      ? Get.toNamed(AppRouter.getNotification_screen())?.then((value1) => {
                                    value.getAllNotifications()
                                  })
                                      : showToast(AppString.internet_connection);


                                  print("Tapped");
                                },
                              ),
                            ))
                                :Container(),

                                SizedBox(width: 10),

                                homeScreenController.parser.CheckToken() != null && homeScreenController.parser.CheckToken().isNotEmpty?

                                GestureDetector(
                                  onTap: () {
                                    connectivityService.isConnected.value
                                        ? Get.toNamed(AppRouter.profile)
                                        : showToast(AppString.internet_connection);

                                    print("Tapped");
                                  },
                                  child: value.getProfileResponse.data?.profilePicture != null && value.getProfileResponse.data?.profilePicture != ""?

                                  CircleAvatar(
                                    maxRadius: 30,
                                    backgroundColor: ThemeProvider.text_background.withOpacity(0.4),
                                    backgroundImage: NetworkImage("${value.getProfileResponse.data?.profilePicture ?? ""}"),
                                  ) :CircleAvatar(
                                    maxRadius: 30,
                                    backgroundColor: ThemeProvider.text_background.withOpacity(0.4),
                                    child: Icon(
                                      Icons.person, // Replace this with the desired icon
                                      color: Colors.white, // Adjust the color as needed
                                    ),
                                  ),
                                ): Container(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    value.geteventResponse.data == null ?
                    Container(
                      child: Center(
                        child:  CommonTextWidget(
                          heading: "Events not found",
                          fontSize: Dimens.twenty,
                          color: ThemeProvider.whiteColor,
                          fontFamily: 'Intern',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ): Container(
                      width: screenWidth,
                      height: Get.height * 0.48,
                      child: Swiper(
                        curve: Curves.easeInOut,
                        itemHeight: 100,
                        itemWidth: 100,
                        onIndexChanged:(index) {
                          value.changeIndex(index);
                          print('Swiped_to_index======: $index');
            
                        } ,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: (){
                              connectivityService.isConnected.value
                                  ?  Get.toNamed(AppRouter.getEvents() ,arguments: [value.geteventResponse.data?[index].uuid])
                                  : showToast(AppString.internet_connection);

            
                              // Get.toNamed(AppRouter.getEvents());
                            },
                            child: Stack(
                              children: [
            
            
                                Container(
                                  width: screenWidth,
                                  height: Get.height * 0.48,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.network(
                                      //"https://fastly.picsum.photos/id/1024/200/300.jpg?hmac=Zf-5s5sbTMmFYhm-_rzZXktzs5i_ES8dVOzXPCS6zxU",
                                      value.geteventResponse.data?[index].images != null && value.geteventResponse.data![index].images!.isNotEmpty
                                          ? value.geteventResponse.data![index].images![0].image! : "https://fastly.picsum.photos/id/1024/200/300.jpg?hmac=Zf-5s5sbTMmFYhm-_rzZXktzs5i_ES8dVOzXPCS6zxU",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
            
            
                                value.geteventResponse.data?[index].interestedUsers != null && value.geteventResponse.data![index].interestedUsers!.isNotEmpty ?
                                Positioned(
                                  top:Get.height * .02,
                                  left:Get.width * .06,
                                  child: Container(
                                    // margin: EdgeInsets.only(bottom: Get.height * .4, right: Get.width * .34 ) ,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        for (int i = 0; i < value.geteventResponse.data![index].interestedUsers!.length && i < 4; i++)
                                          if (i == 3) // Check if index is 3 (4th item)
                                            Align(
                                              widthFactor: 0.8,
                                              child: Container(
                                                height: 32,
                                                width: 42,
                                                decoration: BoxDecoration(
                                                    color: ThemeProvider.text_background,
                                                    borderRadius: BorderRadius.circular(20)
                                                ),
                                                child: Center(
                                                  child: CommonTextWidget(
                                                    heading: "${value.geteventResponse.data![index].interestedUsers!.length-3}",
                                                    fontSize: Dimens.twelve,
                                                    color: ThemeProvider.whiteColor,
                                                    fontFamily: 'Intern',
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                            )
                                          else
                                            Align(
                                              widthFactor: 0.6,
                                              child: CircleAvatar(
                                                radius: 18,
                                                backgroundColor: Colors.white,
                                                child: CircleAvatar(
                                                  radius: 16,
                                                  backgroundImage: NetworkImage(
                                                      "${value.geteventResponse.data![index].interestedUsers![i].profilePicture}"
                                                  ),
                                                ),
                                              ),
                                            ),
                                      ],
                                    ),
                                  ),
                                ) : Container(),
            
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    height: Get.height * 0.12,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(20),
                                        bottomRight: Radius.circular(20),
                                      ),
                                      color: Colors.black.withOpacity(0.6),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.3),
                                          spreadRadius: 2,
                                          blurRadius: 10,
                                          offset: Offset(0, -9),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        CommonTextWidget(
                                          heading:   "${value.geteventResponse.data?[index].title}",
                                          fontSize: Dimens.twenty,
                                          color: ThemeProvider.whiteColor.withOpacity(0.85),
                                          fontFamily: 'Lexend',
                                          fontWeight: FontWeight.w700,
                                          textOverflow: TextOverflow.ellipsis,
                                        ),
            
                                        SizedBox(height: 0),
                                        Row(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "${timestampToString(value.geteventResponse.data![index].created_at_utc!)}",
            
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: ThemeProvider.whiteColor.withOpacity(0.85),
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            Text(
                                              value.geteventResponse.data != null && value.geteventResponse.data![index].tickets != null && value.geteventResponse.data![index].tickets!.isNotEmpty
                                                  ? '\$ ${value.geteventResponse.data![index].tickets!.where((ticket) => ticket.price != null).map<double>((ticket) => ticket.price!).reduce((a, b) => a < b ? a : b).toStringAsFixed(2)}'
                                                  : '00',
                                              // '\$221',
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: ThemeProvider.whiteColor.withOpacity(0.85),
                                                fontFamily: 'Lexend',
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        itemCount: value.geteventResponse.data!.length,
                        viewportFraction: 0.7,
                        scale: 0.6,
                      ),
                    ),
            
                    Container(
                     margin: EdgeInsets.only(left: 20 ,right: 20 ,top: 10),
                      child: Row(
                        crossAxisAlignment:
                        CrossAxisAlignment.center,
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "This Week",
            
                            style: TextStyle(
                              fontSize: 28,
                              color: ThemeProvider.whiteColor.withOpacity(0.85),
                              fontFamily: 'Lexend',
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            "More",
                            // '\$221',
                            style: TextStyle(
                              fontSize: 14,
                              color: ThemeProvider.whiteColor.withOpacity(0.85),
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
            
                    value.geteventResponse.data == null ? Container():   ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: value.geteventResponse.data!.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: (){
                            connectivityService.isConnected.value
                                ? Get.toNamed(AppRouter.getEvents() ,arguments: [value.geteventResponse.data?[index].uuid])
                                : showToast(AppString.internet_connection);

            
                            // Get.toNamed(AppRouter.getEvents());
                          },
                          child: Container(
                            color: Colors.black,
                            child: Card(
                              elevation: 8,
                              margin:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Stack(
                                children: [
                                  Container(
                                    width: screenWidth,
                                    height: Get.height * 0.30,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.network(
                                        value.geteventResponse.data?[index].images != null && value.geteventResponse.data![index].images!.isNotEmpty
                                            ? value.geteventResponse.data![index].images![0].image! : "https://fastly.picsum.photos/id/1024/200/300.jpg?hmac=Zf-5s5sbTMmFYhm-_rzZXktzs5i_ES8dVOzXPCS6zxU",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  value.geteventResponse.data?[index].interestedUsers != null && value.geteventResponse.data![index].interestedUsers!.isNotEmpty ?
                                  Positioned(
                                    top:Get.height * .02,
                                    left:Get.width * .06,
                                    child: Container(
                                      // margin: EdgeInsets.only(bottom: Get.height * .4, right: Get.width * .34 ) ,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          for (int i = 0; i < value.geteventResponse.data![index].interestedUsers!.length && i < 4; i++)
                                            if (i == 3) // Check if index is 3 (4th item)
                                              Align(
                                                widthFactor: 0.8,
                                                child: Container(
                                                  height: 32,
                                                  width: 42,
                                                  decoration: BoxDecoration(
                                                      color: ThemeProvider.text_background,
                                                      borderRadius: BorderRadius.circular(20)
                                                  ),
                                                  child: Center(
                                                    child: CommonTextWidget(
                                                      heading: "${value.geteventResponse.data![index].interestedUsers!.length-3}",
                                                      fontSize: Dimens.twelve,
                                                      color: ThemeProvider.whiteColor,
                                                      fontFamily: 'Intern',
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            else
                                              Align(
                                                widthFactor: 0.6,
                                                child: CircleAvatar(
                                                  radius: 18,
                                                  backgroundColor: Colors.white,
                                                  child: CircleAvatar(
                                                    radius: 16,
                                                    backgroundImage: NetworkImage(
                                                        "${value.geteventResponse.data![index].interestedUsers![i].profilePicture}"
                                                    ),
                                                  ),
                                                ),
                                              ),
                                        ],
                                      ),
                                    ),
                                  ) : Container(),
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      height: Get.height * 0.11,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(20),
                                          bottomRight: Radius.circular(20),
                                        ),
                                        color: Colors.black.withOpacity(0.6),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.3),
                                            spreadRadius: 2,
                                            blurRadius: 10,
                                            offset: Offset(0, -9),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          CommonTextWidget(
                                            heading:   "${value.geteventResponse.data?[index].title}",
                                            fontSize: Dimens.twenty,
                                            color: ThemeProvider.whiteColor.withOpacity(0.85),
                                            fontFamily: 'Lexend',
                                            fontWeight: FontWeight.w700,
                                            textOverflow: TextOverflow.ellipsis,
                                          ),
            
                                          SizedBox(height: 5),
                                          Row(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "${timestampToString(value.geteventResponse.data![index].created_at_utc!)}",
            
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: ThemeProvider.whiteColor.withOpacity(0.85),
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              Text(
                                                //'\$221',
                                                value.geteventResponse.data != null && value.geteventResponse.data![index].tickets != null && value.geteventResponse.data![index].tickets!.isNotEmpty
                                                    ? '\$ ${value.geteventResponse.data![index].tickets!.where((ticket) => ticket.price != null).map<double>((ticket) => ticket.price!).reduce((a, b) => a < b ? a : b).toStringAsFixed(2)}'
                                                    : '00',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: ThemeProvider.whiteColor.withOpacity(0.85),
                                                  fontFamily: 'Lexend',
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

 /* String formatDate(String inputDate) {
    DateTime date = DateTime.parse(inputDate);
    String formattedDate = DateFormat('MMMM dd, yyyy').format(date);
    return formattedDate;
  }*/

  String timestampToString(String timestamp) {

    int timestampInt = int.parse(timestamp);

    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestampInt * 1000);

    String formattedDate = DateFormat('MMMM dd, yyyy').format(dateTime);

    return formattedDate;
  }
}
