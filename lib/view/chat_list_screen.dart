import 'dart:convert';

import 'package:arspace/backend/helper/app_router.dart';
import 'package:arspace/util/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../controller/chat_list_controller.dart';
import '../controller/dashboard_controller.dart';
import '../util/all_constants.dart';
import '../util/dimens.dart';
import '../widgets/commontext.dart';
import 'connectivity_service.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final ConnectivityService connectivityService = Get.find();

  double screenHeight = 0;
  double screenWidth = 0;

  final ChatListController chatListController =
      Get.put(ChatListController(parser: Get.find()));

  final DashboardController dashboardController  =Get.put(DashboardController(parser: Get.find()));


  @override
  void initState() {
    super.initState();
    chatListController.initialized;
    dashboardController.initialized;
    chatListController.getAllChatList();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return GetBuilder<ChatListController>(builder: (value) {
      return value.isChatList_Loading == true
          ? Center(
        child: LoadingAnimationWidget.threeRotatingDots(
          color: ThemeProvider.loader_color,
          size: Dimens.loder_size,
        ),
      )
          : value.fetchChatListData.data != null &&
                  value.fetchChatListData.data!.isNotEmpty
              ? Scaffold(
                  backgroundColor: ThemeProvider.blackColor,
                  body: Container(
                    height: screenHeight,
                    width: screenWidth,
                    color: ThemeProvider.blackColor,
                    child: Column(
                      children: [
                        SizedBox(
                          height: screenHeight * 0.06,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
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
                              CommonTextWidget(
                                heading: "Message",
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
                        ),
                        SizedBox(
                          height: screenHeight * 0.02,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: TextField(
                            onChanged: (value) {},
                            onEditingComplete: () {
                              FocusScope.of(context).unfocus();
                              chatListController.getAllChatList();
                            },
                            controller: value.searchController,
                            cursorColor: ThemeProvider.greyColor,
                            style: TextStyle(color: ThemeProvider.whiteColor),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: ThemeProvider.text_background,
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: ThemeProvider.greyColor),
                                borderRadius: BorderRadius.circular(40),
                              ),
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: SvgPicture.asset(AssetPath.searchIcon),
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(40)),
                              hintText: 'Search Conversation',
                              hintStyle: TextStyle(
                                  color: ThemeProvider.whiteColor
                                      .withOpacity(0.6)),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: screenHeight * 0.02,
                        ),
                        Expanded(
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            physics: AlwaysScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: value.fetchChatListData.data!.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {

                                      if( connectivityService.isConnected.value){
                                        Get.toNamed(AppRouter.getChatInbox(),
                                            arguments: [
                                              value.fetchChatListData.data![index]
                                                  .uuid!,

                                              value.fetchChatListData
                                                  .data![index].type == "private" ?
                                              value.fetchChatListData
                                                  .data![index].roomSender!.uuid == value.getUUID() ?
                                              value.fetchChatListData
                                                  .data![index].roomReceiver!.full_name ?? "Unknow" :
                                              value.fetchChatListData
                                                  .data![index].roomSender!.full_name ?? "Unknow"  :value.fetchChatListData
                                                  .data![index].name ?? "Unknow" ,
                                            /*  value.fetchChatListData.data![index]
                                                  .name!,*/
                                              value.fetchChatListData.data![index]
                                                  .type!
                                            ])?.then((value) => {
                                          chatListController.getAllChatList()
                                        });

                                      }else{
                                        showToast(AppString.internet_connection);
                                      }





                                      // Get.toNamed(AppRouter.chatInbox);
                                    },
                                    child: ListTile(
                                      leading: Stack(
                                        children: [
                                          value.fetchChatListData
                                              .data![index].type == "notification" ?
                                          CircleAvatar(
                                            radius: 30,
                                            backgroundImage: AssetImage(AssetPath.arspace),
                                          )

                                        :
                                          CircleAvatar(
                                            radius: 30,
                                            backgroundImage: value.fetchChatListData
                                  .data![index].type == "group" ?
                                            NetworkImage(
                                                "${value.fetchChatListData
                                                    .data![index].event!.images![0].image ?? ""}")
                                       : value.fetchChatListData
                                  .data![index].roomSender!.uuid == value.getUUID() ?
                                            NetworkImage(
                                                "${value.fetchChatListData
                                                    .data![index].roomReceiver!.profilePicture ?? ""}")
                                          :NetworkImage(
                                                "${value.fetchChatListData
                                                    .data![index].roomSender!.profilePicture ?? ""}"))
                                        /*AssetImage (
                                                AssetPath.dummy_profile),
                                          )*/,
                                        ],
                                      ),
                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          CommonTextWidget(
                                            heading: value.fetchChatListData
                                                .data![index].type == "private" ?
                                            value.fetchChatListData
                                                .data![index].roomSender!.uuid == value.getUUID() ?
                                            value.fetchChatListData
                                                .data![index].roomReceiver!.full_name ?? "Unknow" :
                                            value.fetchChatListData
                                                .data![index].roomSender!.full_name ?? "Unknow"  :value.fetchChatListData
                                                .data![index].name ?? "Unknow" ,


                                            fontSize: Dimens.sixteen,
                                            color: Color(0xFFA7A9B1),
                                            fontFamily: 'Lexend',
                                            fontWeight: FontWeight.w700,
                                          ),
                                          value.fetchChatListData.data![index].latest_messages_count !=
                                              null && value.fetchChatListData.data![index].latest_messages_count! > 0 &&
                                              value.fetchChatListData.data![index].latestMessage?.sender !=
                                                  value.getUUID()
                                              ?
                                          CircleAvatar(
                                            radius: 10,
                                            backgroundColor: Color(0xFF8146FF),
                                            child: CommonTextWidget(
                                              heading: value.fetchChatListData.data![index].latest_messages_count!.toString(),
                                              fontSize: Dimens.ten,
                                              color: ThemeProvider.whiteColor,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ): Container()
                                        ],
                                      ),
                                      subtitle: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          CommonTextWidget(
                                            textOverflow: TextOverflow.ellipsis,
                                            heading: value.fetchChatListData.data![index].latestMessage?.message != null
                                                ? Utf8Decoder().convert(value.fetchChatListData.data![index].latestMessage!.message!.codeUnits)
                                                : "",
                                            fontSize: Dimens.sixteen,
                                            color: ThemeProvider.text_light_gray,
                                            fontFamily: 'Intern',
                                            fontWeight: FontWeight.w400,
                                          ),
                                          CommonTextWidget(
                                            heading: value
                                                        .fetchChatListData
                                                        .data![index]
                                                        .latestMessage !=
                                                    null
                                                ? _miliseconds_to_date(
                                                    userTime: value
                                                        .fetchChatListData
                                                        .data![index]
                                                        .latestMessage!
                                                        .createdAt!)
                                                : "",
                                            fontSize: Dimens.twelve,
                                            color:
                                                ThemeProvider.text_light_gray,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w400,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: Divider(
                                      color: ThemeProvider.dividerColor,
                                      height: 2,
                                    ),
                                  )
                                ],
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                )
              : SafeArea(
                  child: Scaffold(
                    backgroundColor: ThemeProvider.blackColor,
                    body: Padding(
                      padding: EdgeInsets.only(left: 14.0, right: 14, top: 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
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
                            ],
                          ),
                          SizedBox(
                            height: screenHeight * .01,
                          ),
                               Image(
                                  image: AssetImage(AssetPath.view_ticket1),
                                  height: screenHeight * 0.4,
                                ),

                          SizedBox(
                            height: screenHeight * .01,
                          ),
                          CommonTextWidget(
                            textAlign: TextAlign.center,
                            heading: "You can’t match if you haven’t purchased a ticket.",
                            fontSize: Dimens.twenty,
                            color: ThemeProvider.whiteColor,
                            fontFamily: 'Intern',
                            fontWeight: FontWeight.w600,
                          ),
                          SizedBox(
                            height: screenHeight * .1,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(0.0),
                                elevation: 5,
                                backgroundColor: ThemeProvider.matchButtonColor,
                                fixedSize: Size(screenWidth * .5, 52)),
                            onPressed: () {

                                dashboardController.updateTab(0);
                            },
                            child: Center(
                              child: CommonTextWidget(
                                heading: "purchase Ticket",
                                fontSize: Dimens.twenty,
                                color: ThemeProvider.whiteColor,
                                fontFamily: 'Intern',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
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
