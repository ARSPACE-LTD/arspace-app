
import 'package:arspace/util/all_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:intl/intl.dart';

import '../backend/helper/app_router.dart';
import '../controller/home_screen_controller.dart';
import '../controller/notifications_controller.dart';
import '../util/app_assets.dart';
import '../util/dimens.dart';
import '../util/string.dart';
import '../util/theme.dart';
import '../widgets/commontext.dart';
import 'connectivity_service.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final ConnectivityService connectivityService = Get.find();

  double screenHeight = 0;
  double screenWidth = 0;

  final NotificationController notificationController =
  Get.put(NotificationController(parser: Get.find()));


  @override
  void initState() {
    super.initState();
    notificationController.initialized;

  //  notificationController.getAllNotifications();

  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return GetBuilder<HomeScreenController>(builder: (value) {
      return Scaffold(
        backgroundColor: ThemeProvider.text_background,
        appBar:  AppBar(
            centerTitle: true,
            backgroundColor: ThemeProvider.blackColor,
            leading: GestureDetector(
              onTap: (){
                Get.back();
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: ThemeProvider.whiteColor,
                size: 20,
              ),
            ),
            title: CommonTextWidget(
              heading: AppString.notification,
              fontSize: Dimens.twenty,
              color: ThemeProvider.whiteColor,
              fontFamily: 'Lexend',
              fontWeight: FontWeight.w700,
            )),

        body: value.NotificationList != null && value.NotificationList!.isNotEmpty ?
         Obx(() =>   Container(
           margin: EdgeInsets.all(10),

           child: ListView.builder(
               itemCount: value.NotificationList!.length,
               itemBuilder: (BuildContext context, int index) {
                 return GestureDetector(
                   onTap: ()
                   {
                     if( connectivityService.isConnected.value){


                       if(value.NotificationList![index].type == "event"){
                         notificationController.ReadNotifications(value.NotificationList![index].uuid!);

                         Get.toNamed(AppRouter.getEvents() ,arguments: [value.NotificationList![index].event!.uuid])?.then((value1) => {
                           value.getAllNotifications()
                         });

                       }
                       else if(value.NotificationList![index].type == "like"){
                         notificationController.ReadNotifications(value.NotificationList![index].uuid!);

                         Get.toNamed(AppRouter.getMatchDetails() ,arguments: [value.NotificationList![index].likedBy!.uuid])?.then((value1) => {
                           value.getAllNotifications()
                         });


                       }
                       else if(value.NotificationList![index].type == "room"){
                         notificationController.ReadNotifications(value.NotificationList![index].uuid!);

                         Get.toNamed(AppRouter.getChatInbox(),
                             arguments: [
                               value.NotificationList![index].room!.uuid,
                               value.NotificationList![index].room!.name,
                               value.NotificationList![index].room!.type,
                             ])?.then((value1) => {
                           value.getAllNotifications()
                         });

                       }else if(value.NotificationList![index].type == "notification"){
                         notificationController.ReadNotifications(value.NotificationList![index].uuid!);

                         Get.toNamed(AppRouter.getChatInbox(),
                             arguments: [
                               value.NotificationList![index].room!.uuid,
                               value.NotificationList![index].room!.name,
                               value.NotificationList![index].room!.type,
                             ])?.then((value1) => {
                           value.getAllNotifications()
                         });

                       }

                     }else{
                       showToast(AppString.internet_connection);
                     }


                   },
                   child: Container(
                     margin: EdgeInsets.all(10),
                     padding: EdgeInsets.all(3),
                     decoration:  BoxDecoration(
                       color:ThemeProvider.whiteColor,

                       borderRadius: BorderRadius.all(
                           Radius.circular(10.0)), // Set rounded corner radius
                     ),
                     child: Container(
                         padding: EdgeInsets.all(10),
                         child: Row(
                           crossAxisAlignment: CrossAxisAlignment.center,
                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                           children: [

                             Expanded(
                               child: Container(
                                 width: screenWidth * 0.6,
                                 child: Column(
                                   mainAxisAlignment: MainAxisAlignment.start,
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children: [
                                     CommonTextWidget(
                                       heading:value.NotificationList![index].title,
                                       fontSize: Dimens.sixteen,
                                       color: ThemeProvider.blackColor,
                                       fontFamily: 'bold',
                                       fontWeight: FontWeight.w700,
                                     ),
                                     SizedBox(height: 5,),
                                     CommonTextWidget(
                                       heading:value.NotificationList![index].message,
                                       fontSize: Dimens.twelve,
                                       color: ThemeProvider.blackColor,
                                       fontFamily: 'bold',
                                       fontWeight: FontWeight.w400,
                                     ),
                                   ],
                                 ),
                               ),
                             ),

                             Container(
                               alignment: Alignment.centerRight,
                               width: screenWidth * 0.2,
                               child: CommonTextWidget(
                                 heading:  _miliseconds_to_date(
                                     userTime:
                                     value.NotificationList![index].createdAt!) ,
                                 //  heading: " time",
                                 fontSize: Dimens.ten,
                                 color: ThemeProvider.greyColor,
                                 fontFamily: 'bold',
                                 fontWeight: FontWeight.w400,
                               ),
                             ),
                           ],
                         )),
                   ),
                 );

                 // with slide delete
                 /*return Slidable(
                    actionPane: SlidableDrawerActionPane(),
                    actionExtentRatio: 0.25,
                    child: GestureDetector(
                      onTap: ()
                      {
                        if( connectivityService.isConnected.value){

                          if(value.fetchNotificationData.data![index].type == "event"){
                            Get.toNamed(AppRouter.getEvents() ,arguments: [value.fetchNotificationData.data![index].event!.uuid]);

                          }
                          else if(value.fetchNotificationData.data![index].type == "like"){
                            Get.toNamed(AppRouter.getMatchDetails() ,arguments: [value.fetchNotificationData.data![index].likedBy!.uuid]);

                          }
                          else if(value.fetchNotificationData.data![index].type == "room"){
                            Get.toNamed(AppRouter.getChatInbox(),
                                arguments: [
                                  value.fetchNotificationData.data![index].room!.uuid,
                                  value.fetchNotificationData.data![index].room!.name,
                                  value.fetchNotificationData.data![index].room!.type,
                                ]);

                          }

                        }else{
                          showToast(AppString.internet_connection);
                        }


                      },
                      child: Container(
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.all(3),
                        decoration:  BoxDecoration(
                          color:ThemeProvider.whiteColor,

                          borderRadius: BorderRadius.all(
                              Radius.circular(10.0)), // Set rounded corner radius
                        ),
                        child: Container(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [

                                Expanded(
                                  child: Container(
                                    width: screenWidth * 0.6,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        CommonTextWidget(
                                          heading:value.fetchNotificationData.data![index].title,
                                          fontSize: Dimens.sixteen,
                                          color: ThemeProvider.blackColor,
                                          fontFamily: 'bold',
                                          fontWeight: FontWeight.w700,
                                        ),
                                        SizedBox(height: 5,),
                                        CommonTextWidget(
                                          heading:value.fetchNotificationData.data![index].message,
                                          fontSize: Dimens.twelve,
                                          color: ThemeProvider.blackColor,
                                          fontFamily: 'bold',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                Container(
                                  alignment: Alignment.centerRight,
                                  width: screenWidth * 0.2,
                                  child: CommonTextWidget(
                                    heading:  _miliseconds_to_date(
                                        userTime:
                                        value.fetchNotificationData.data![index].createdAt!) ,
                                  //  heading: " time",
                                    fontSize: Dimens.ten,
                                    color: ThemeProvider.greyColor,
                                    fontFamily: 'bold',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            )),
                      ),
                    ),
                    secondaryActions: [
                      IconSlideAction(
                        caption: 'Delete',
                        color: Colors.red,
                        icon: Icons.delete,
                        onTap: () =>
                        {
                          //      value.DeleteChild(value.fetchKidsData[index].firestoreChildId! ,index),
                        },
                      ),
                    ],
                  );*/

               }),
         ))
      : Container(child: Center(
              child: Icon(
                Icons.notifications_active, // Replace this with the desired icon
                color: Colors.white,
                size: 150,// Adjust the color as needed
              ),

            )

        ),
      );
    });
  }

  String _miliseconds_to_date({required String userTime}) {
    // Parse the string date into a DateTime object
    DateTime notificationDate = DateTime.parse(userTime);

    // Calculate the time difference
    Duration diff = DateTime.now().difference(notificationDate);

    // Determine the appropriate format based on the time difference
    String formattedDateTime;
    if (diff.inDays >= 1) {
      formattedDateTime = DateFormat('MMM d, yyyy').format(notificationDate);
    } else if (diff.inHours >= 1) {
      formattedDateTime = '${diff.inHours} hour(s) ago';
    } else if (diff.inMinutes >= 1) {
      formattedDateTime = '${diff.inMinutes} minute(s) ago';
    } else if (diff.inSeconds >= 1) {
      formattedDateTime = '${diff.inSeconds} second(s) ago';
    } else {
      formattedDateTime = 'just now';
    }

    return formattedDateTime; // Return the formatted date
  }
}
