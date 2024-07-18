import 'package:arspace/controller/match_controller.dart';
import 'package:arspace/util/all_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../backend/helper/app_router.dart';
import '../../controller/dashboard_controller.dart';
import '../../util/dimens.dart';
import '../../util/theme.dart';
import '../../widgets/commontext.dart';
import '../../widgets/hexagon_card/draggable.dart';
import '../../widgets/round_button.dart';
import '../connectivity_service.dart';

class MatchScreen extends StatefulWidget {
  const MatchScreen({super.key});

  @override
  State<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  final ConnectivityService connectivityService = Get.find();
  final CardSwiperController controller = CardSwiperController();

  final MatchController recordsController =
  Get.put(MatchController(parser: Get.find()));
  ScrollController scrollController = ScrollController();
  double screenHeight = 0;
  double screenWidth = 0;
  int? cardIndex;
  int? like_unlike_cardIndex;

  bool isprofileComplete = false;




  final MatchController matchController =
  Get.put(MatchController(parser: Get.find()));
  final DashboardController dashboardController =
  Get.put(DashboardController(parser: Get.find()));

  @override
  void initState() {
    super.initState();
    matchController.initialized;
    dashboardController.initialized;
    var context = Get.context as BuildContext;

    matchController.isfiltter_message.value  = false;
    matchController.islastCard.value  = false;

    if (matchController.parser.CheckToken() != null &&
        matchController.parser
            .CheckToken()
            .isNotEmpty) {
      matchController.getPuchageTicket(context);
      isprofileComplete = matchController.parser.getProfileIsComplete();
      matchController.getCardDeck();


      matchController.cardDeck = matchController.getCardDeck();
    } else {
      matchController.isTicketLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    /*return Scaffold(
      backgroundColor: ThemeProvider.text_background,
      body: Center(
        child: CommonTextWidget(
          heading: "under process",
          fontSize: Dimens.twentyFour,
          color: ThemeProvider.whiteColor,
          fontFamily: 'Lexend',
          fontWeight: FontWeight.w800,
        ),
      ),
    );*/
    return GetBuilder<MatchController>(builder: (value) {
      return value.isTicketLoading == true
          ? Center(
        child: LoadingAnimationWidget.threeRotatingDots(
          color: ThemeProvider.loader_color,
          size: Dimens.loder_size,
        ),
      )
          : value.ticketResponse.data != null &&
          value.ticketResponse.data!.isNotEmpty && isprofileComplete == true
          ? Scaffold(
        backgroundColor: Colors.transparent,
        // Make Scaffold background transparent
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    ThemeProvider.match_background_light,
                    ThemeProvider.match_background,
                    ThemeProvider.match_background_dark
                  ],
                ),
              ),
            ),
            Stack(
              children: [
                Scaffold(
                    backgroundColor: Colors.transparent,
                    appBar: AppBar(
                      forceMaterialTransparency: true,
                      leadingWidth: screenWidth,
                      toolbarHeight: screenHeight * 0.10,
                      leading: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          crossAxisAlignment:
                          CrossAxisAlignment.end,
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                matchFilter(value);
                              },
                              child: RoundButton(
                                padding: 7,
                                width: Get.width * .1,
                                height: Get.width * .1,
                                child: SvgPicture.asset(
                                    AssetPath.filter),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                chooseTicket(value);
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,

                                  children: [
                                CommonTextWidget(
                                  heading: AppString.match_for_event,
                                  fontSize: Dimens.twentyFour,
                                  color: Colors.white,
                                  fontFamily: 'Lexend',
                                  fontWeight: FontWeight.w800,
                                ),
                                SizedBox(height: 15),
                                Row(
                                  children: [
                                    Obx(() =>
                                        CommonTextWidget(
                                          lineHeight: 1.3,
                                          heading:
                                          value.TicketTitle.value,
                                          fontSize: Dimens.forteen,
                                          color: Colors.white,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w400,
                                        )),
                                    SizedBox(width: 5),
                                    SvgPicture.asset(AssetPath.view)
                                  ],
                                )
                              ]),
                            ),
                            InkWell(
                              onTap: () {
                                connectivityService.isConnected.value
                                    ? Get.toNamed(AppRouter.chatList)
                                    : showToast(AppString
                                    .internet_connection);
                              },
                              child: Stack(
                                children: [
                                  RoundButton(
                                    width: Get.width * .1,
                                    height: Get.width * .1,
                                    child: SvgPicture.asset(
                                        AssetPath.message),
                                  ),
                                  /* Positioned(
                                  left: 20,
                                  bottom: 24,
                                  child: CircleAvatar(
                                    maxRadius: 9,
                                    backgroundColor:
                                    ThemeProvider.transparent,
                                    child: Padding(
                                      padding: EdgeInsets.all(2),
                                      child: CircleAvatar(
                                          maxRadius: 8,
                                          backgroundColor:ThemeProvider.matchButtonColor,
                                        child: Center(
                                          child: CommonTextWidget(
                                            heading: "12",
                                            fontSize: Dimens.nine,
                                            color: Colors.white,
                                            fontFamily: 'Intern',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),*/
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    //  backgroundColor: ThemeProvider.match_background,
                    body: value.matchResponse.data != null &&
                        value.matchResponse.data!.isNotEmpty && value.islastCard.value == false
                        ? Padding(
                      padding: EdgeInsets.only(left: 5, right: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (recordsController.cardDeck[recordsController.current_Index.value].tags != null &&
                              recordsController.cardDeck[recordsController.current_Index.value].tags!.isNotEmpty)
                            Obx(() {
                              return Container(

                                height: Get.height * .060,
                                margin: EdgeInsets.only(top: Get.height * .030),
                                child: ListView.builder(
                                  padding: EdgeInsets.only(left: 20, right: 20),
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: recordsController.cardDeck[recordsController.current_Index.value].tags!.length,
                                  itemBuilder: (BuildContext context, int index) => Wrap(
                                    spacing: 8.0,
                                    runSpacing: 8.0,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(50),
                                          color: ThemeProvider.whiteColor.withOpacity(0.15),
                                        ),
                                        margin: EdgeInsets.only(left: 10, right: 10),
                                        child: Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: CommonTextWidget(
                                            heading: recordsController.cardDeck[recordsController.current_Index.value].tags?[index].title!,
                                            fontSize: Dimens.forteen,
                                            color: ThemeProvider.whiteColor,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }),
                          Flexible(
                            child: Center(
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.7,
                                height: MediaQuery.of(context).size.height, // Adjust the width as needed
                                child: CardSwiper(
                                  controller: controller,
                                  isLoop: true,
                                  onEnd: (){

                                    value.islastCard.value = true ;

                                    value.update();
                                  },

                                  cardsCount: recordsController.cardDeck.length,
                                  allowedSwipeDirection: AllowedSwipeDirection.only(left: true ,right: true ,up: false , down: false),
                                  onSwipe: _onSwipe,
                                  onUndo: _onUndo,
                                  numberOfCardsDisplayed: recordsController.cardDeck.length <= 1 ? 1 : 2,
                                  backCardOffset: const Offset(0, 45),
                                  padding: const EdgeInsets.all(0.0),
                                  cardBuilder: (context, index, percentThresholdX, percentThresholdY) =>
                                  recordsController.cardDeck[index],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    print("name====== ${recordsController.cardDeck[recordsController.current_Index.value].name!}");
                                    recordsController.LikePerson(recordsController.cardDeck[recordsController.current_Index.value].UUId!, context, recordsController.cardDeck[recordsController.current_Index.value].event_id!, false).whenComplete(() {
                                      controller.swipe(CardSwiperDirection.left);
                                    });
                                  },
                                  child: Image(
                                    width: 100,
                                    height: 100,
                                    image: AssetImage(AssetPath.face_exhaling),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    print("name====== ${recordsController.cardDeck[recordsController.current_Index.value].name!}");
                                    recordsController.LikePerson(recordsController.cardDeck[recordsController.current_Index.value].UUId!, context, recordsController.cardDeck[recordsController.current_Index.value].event_id!, true).whenComplete(() {
                                      controller.swipe(CardSwiperDirection.right);
                                    });
                                  },
                                  child: Image(
                                    width: 100,
                                    height: 100,
                                    image: AssetImage(AssetPath.kissing),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                        : Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.center,
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      children: [
                        Image(
                          image: AssetImage(
                              AssetPath.view_ticket1),
                          height: screenHeight * 0.4,
                        ),
                        SizedBox(
                          height: screenHeight * .01,
                        ),
                        Center(
                          child: CommonTextWidget(
                            textAlign: TextAlign.center,
                            heading: value.islastCard == true ? "You’ve swapped all the other users" :value.isfiltter_message == true || value.ticketResponse != null?
                            "No users found matching your criteria. Please try adjusting your filters." :
                            "You can’t match if you haven’t purchased a ticket.",
                            fontSize: Dimens.twenty,
                            color: ThemeProvider.whiteColor,
                            fontFamily: 'Intern',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          height: screenHeight * .1,
                        ),
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                padding:
                                const EdgeInsets.all(0.0),
                                elevation: 5,
                                backgroundColor: ThemeProvider
                                    .matchButtonColor,
                                fixedSize:
                                Size(screenWidth * .5, 52)),
                            onPressed: () {
                              chooseTicket(value);
                            },
                            child: Center(
                              child: CommonTextWidget(
                                heading: "View Ticket",
                                fontSize: Dimens.twenty,
                                color: ThemeProvider.whiteColor,
                                fontFamily: 'Intern',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        )
                      ],
                    )),
              ],
            ),
            if (value.isBottomSheetOpened == true)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  //  color: Colors.black.withOpacity(0.6),
                  // Adjust opacity as needed
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  height: MediaQuery
                      .of(context)
                      .size
                      .height,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        ThemeProvider.background_first_Clr
                            .withOpacity(0.4),
                        ThemeProvider.background_second_Clr
                            .withOpacity(0.4)
                      ],
                    ), // Set the main screen gradient
                  ),
                ),
              ),
          ],
        ),
      )
          : Scaffold(
        backgroundColor: ThemeProvider.blackColor.withOpacity(0.9),
        body: Padding(
          padding: EdgeInsets.only(left: 14.0, right: 14, top: 14),
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    height: screenHeight * .15,
                  ),
                  GestureDetector(
                    onTap: () {
                      dashboardController.updateTab(0);
                      // Get.back();
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
                ],
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    isprofileComplete == true
                        ? Image(
                      image: AssetImage(AssetPath.view_ticket1),
                      height: screenHeight * 0.28,
                    )
                        : Image(
                      image: AssetImage(
                          AssetPath.complete_profile),
                      height: screenHeight * 0.28,
                    ),
                    SizedBox(
                      height: screenHeight * .03,
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          left: screenWidth * .10,
                          right: screenWidth * .10),
                      child: CommonTextWidget(
                        textAlign: TextAlign.center,
                        heading: isprofileComplete == true
                            ? "You can’t match if you haven’t purchased a ticket."
                            : "You need to complete your personal information before matching",
                        fontSize: Dimens.sixteen,
                        color: ThemeProvider.whiteColor,
                        lineHeight: 1.5,
                        fontFamily: 'Intern',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * .030,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(0.0),
                          elevation: 5,
                          backgroundColor:
                          ThemeProvider.matchButtonColor,
                          fixedSize: Size(screenWidth * .5, 52)),
                      onPressed: () {
                        if (value.parser.CheckToken() != null &&
                            value.parser
                                .CheckToken()
                                .isNotEmpty) {
                          if (isprofileComplete == true) {
                            dashboardController.updateTab(0);
                          } else {
                            Get.toNamed(
                                AppRouter.getComplete_profile());
                          }
                        } else {
                          LoginPopUp();
                        }
                      },
                      child: Center(
                        child: CommonTextWidget(
                          heading: isprofileComplete == true
                              ? "purchase Ticket"
                              : "Complete Profile",
                          fontSize: Dimens.twenty,
                          color: ThemeProvider.whiteColor,
                          fontFamily: 'Intern',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * .15,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  void swipeLeft() {
    if (recordsController.cardDeck.isNotEmpty) {
      setState(() {
        recordsController.cardDeck.removeAt(0);
      });
    }
  }

  void swipeRight() {
    if (recordsController.cardDeck.isNotEmpty) {
      setState(() {
        recordsController.cardDeck.removeAt(0);
      });
    }
  }

  void chooseTicket(MatchController matchController) {
    matchController.isBottomSheetOpened = true;
    matchController.update();
    showModalBottomSheet(
      context: context,
      backgroundColor: ThemeProvider.blackColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      isScrollControlled: true,
      builder: (builder) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: Container(
                height: screenHeight * 0.6,
                width: screenWidth,
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CommonTextWidget(
                            heading: AppString.ticket_for_match,
                            fontSize: Dimens.twentySix,
                            color: ThemeProvider.whiteColor,
                            fontFamily: 'Lexend',
                            fontWeight: FontWeight.w800,
                          ),
                          InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: CircleAvatar(
                              maxRadius: screenWidth * 0.055,
                              backgroundColor: ThemeProvider.text_background,
                              child: Center(
                                  child: Icon(
                                    Icons.close,
                                    color: ThemeProvider.whiteColor,
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.02,
                    ),
                    SizedBox(
                      height: screenHeight * 0.5,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: AlwaysScrollableScrollPhysics(),
                        itemCount: matchController.ticketResponse.data!.length!,
                        itemBuilder: (context, index) {
                          final isSelected =
                          matchController.selectedIndices.contains(index);
                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    /* if (isSelected) {
                                      matchController.selectedIndices.remove(index);
                                    } else {
                                      matchController.selectedIndices.add(index);
                                    }*/
                                    matchController.selectedIndices.clear();
                                    matchController.selectedIndices.add(index);

                                    matchController.currentTicketUUID =
                                    matchController.ticketResponse
                                        .data![index].event!.uuid!;

                                    matchController.TicketTitle.value =
                                    matchController.ticketResponse
                                        .data![index].event!.name!;

                                    matchController.getMatches(
                                        matchController.ticketResponse
                                            .data![index].event!.uuid!,
                                        "",
                                        context);

                                    Get.back();
                                  });
                                },
                                child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.transparent,
                                        // Change border color based on selected state
                                        width: isSelected
                                            ? 2.0
                                            : 0.0, // Change border width based on selected state
                                      ),
                                      color: ThemeProvider.text_background,
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 100,
                                          width: 100,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(10),
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                    matchController
                                                        .ticketResponse
                                                        .data?[index]
                                                        .event
                                                        ?.images
                                                        ?.isNotEmpty ==
                                                        true
                                                        ? matchController
                                                        .ticketResponse
                                                        .data![index]
                                                        .event!
                                                        .images![0]
                                                        .image ??
                                                        ""
                                                        : "",
                                                  ),
                                                  fit: BoxFit.fill)),
                                        ),
                                        SizedBox(
                                          width: 12,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                              EdgeInsets.only(left: 2.0),
                                              child: CommonTextWidget(
                                                heading: matchController
                                                    .ticketResponse
                                                    .data![index]
                                                    .event!
                                                    .name!,
                                                // heading: AppString.event_name,
                                                fontSize: Dimens.eighteen,
                                                color: ThemeProvider.whiteColor,
                                                fontFamily: 'Lexend',
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                            SizedBox(height: 36),
                                            Row(
                                              children: [
                                                SvgPicture.asset(
                                                    AssetPath.clock),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                CommonTextWidget(
                                                  heading: formatDate(
                                                      matchController
                                                          .ticketResponse
                                                          .data![index]
                                                          .event!
                                                          .date!) +
                                                      " " +
                                                      TimeFormate(
                                                        matchController
                                                            .ticketResponse
                                                            .data![index]
                                                            .event!
                                                            .date!,
                                                        matchController
                                                            .ticketResponse
                                                            .data![index]
                                                            .event!
                                                            .time!,
                                                      ),
                                                  // heading: "Dec 7, 2019 23:26",
                                                  fontSize: Dimens.forteen,
                                                  color: ThemeProvider
                                                      .text_light_gray,
                                                  fontFamily: 'Intern',
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 6),
                                            Row(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              children: [
                                                SvgPicture.asset(
                                                    AssetPath.mapPoint,
                                                    height: 18,
                                                    color: ThemeProvider
                                                        .whiteColor
                                                        .withOpacity(0.6)),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Container(
                                                  constraints: BoxConstraints(
                                                    maxWidth:
                                                    MediaQuery
                                                        .of(context)
                                                        .size
                                                        .width *
                                                        0.5,
                                                    // minWidth:  MediaQuery.of(context).size.width * 0.10
                                                  ),
                                                  child: CommonTextWidget(
                                                    heading: matchController
                                                        .ticketResponse
                                                        .data![index]
                                                        .event!
                                                        .location !=
                                                        null
                                                        ? matchController
                                                        .ticketResponse
                                                        .data![index]
                                                        .event!
                                                        .location!
                                                        : "",
                                                    // heading: "775 Rolling Green Rd.",
                                                    fontSize: Dimens.forteen,
                                                    color: ThemeProvider
                                                        .text_light_gray,
                                                    fontFamily: 'Intern',
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    )),
                              ),
                              SizedBox(
                                height: 14,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      setState(() {
        matchController.isBottomSheetOpened = false;
      });
    });
  }

  void matchFilter(MatchController matchController) {
    matchController.isBottomSheetOpened = true;
    matchController.update();
    showModalBottomSheet(
      context: context,
      backgroundColor: ThemeProvider.blackColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      isScrollControlled: true,
      builder: (builder) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: Container(
                height: screenHeight * 0.6,
                width: screenWidth,
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CommonTextWidget(
                            heading: AppString.filter,
                            fontSize: Dimens.twentySix,
                            color: ThemeProvider.whiteColor,
                            fontFamily: 'Lexend',
                            fontWeight: FontWeight.w800,
                          ),
                          InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: CircleAvatar(
                              maxRadius: screenWidth * 0.055,
                              backgroundColor: ThemeProvider.text_background,
                              child: Center(
                                  child: Icon(
                                    Icons.close,
                                    color: ThemeProvider.whiteColor,
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.04,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: CommonTextWidget(
                          heading: "Show me",
                          fontSize: Dimens.eighteen,
                          color: ThemeProvider.whiteColor,
                          fontFamily: 'Intern',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.02,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildSelectableContainer(
                            index: 0,
                            imageAssetPath: AssetPath.man,
                            label: AppString.man,
                            screenHeight: screenHeight,
                            screenWidth: screenWidth,
                            selectedIndex: matchController.gender_selectedIndex,
                            updateSelectedIndex: (int index) {
                              setState(() {
                                matchController.gender_selectedIndex = index;
                              });
                            },
                          ),
                          buildSelectableContainer(
                            index: 1,
                            imageAssetPath: AssetPath.woman,
                            label: AppString.woman,
                            screenHeight: screenHeight,
                            screenWidth: screenWidth,
                            selectedIndex: matchController.gender_selectedIndex,
                            updateSelectedIndex: (int index) {
                              setState(() {
                                matchController.gender_selectedIndex = index;
                              });
                            },
                          ),
                          buildSelectableContainer(
                            index: 2,
                            isStacked: true,
                            screenHeight: screenHeight,
                            screenWidth: screenWidth,
                            label: "All",
                            selectedIndex: matchController.gender_selectedIndex,
                            updateSelectedIndex: (int index) {
                              setState(() {
                                matchController.gender_selectedIndex = index;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.02,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14),
                      child: Divider(
                        color: ThemeProvider.dividerColor,
                        height: 2,
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.04,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CommonTextWidget(
                            heading: "Age",
                            fontSize: Dimens.eighteen,
                            color: ThemeProvider.whiteColor,
                            fontFamily: 'Intern',
                            fontWeight: FontWeight.w400,
                          ),
                          CommonTextWidget(
                            heading:
                            "${matchController.start.toStringAsFixed(
                                0)} - ${matchController.end.toStringAsFixed(
                                0)}",
                            fontSize: Dimens.eighteen,
                            color: ThemeProvider.whiteColor,
                            fontFamily: 'Intern',
                            fontWeight: FontWeight.w400,
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.02,
                    ),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 4,
                        thumbColor: ThemeProvider.whiteColor,
                        activeTrackColor: ThemeProvider.buttonborderColors,
                        inactiveTrackColor: ThemeProvider.dividerColor,
                      ),
                      child: RangeSlider(
                        values: RangeValues(
                            matchController.start, matchController.end),
                        labels: RangeLabels(matchController.start.toString(),
                            matchController.end.toString()),
                        onChanged: (value) {
                          setState(() {
                            matchController.start = value.start;
                            matchController.end = value.end;
                          });
                        },
                        min: 18.0,
                        max: 100.0,
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.06,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(0.0),
                            elevation: 5,
                            backgroundColor: ThemeProvider.matchButtonColor,
                            fixedSize: Size(screenWidth, 52)),
                        onPressed: () {
                          Get.back();
                          print("getPuchageTicket2223333 ---->");

                          connectivityService.isConnected.value
                              ? matchController.getMatches(
                              matchController.currentTicketUUID,
                              "filter",
                              context)
                              : showToast(AppString.internet_connection);

                          //  Get.toNamed(AppRouter.matchDetails);
                        },
                        child: Center(
                          child: CommonTextWidget(
                            heading: "Confirm",
                            fontSize: Dimens.twenty,
                            color: ThemeProvider.whiteColor,
                            fontFamily: 'Intern',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      setState(() {
        matchController.isBottomSheetOpened = false;
      });
    });
  }

  Widget buildSelectableContainer({
    required int index,
    String? imageAssetPath,
    String? label,
    bool isStacked = false,
    required double screenHeight,
    required double screenWidth,
    required int selectedIndex,
    required Function(int) updateSelectedIndex,
  }) {
    return InkWell(
      onTap: () {
        updateSelectedIndex(index);
      },
      child: Container(
        height: screenHeight * 0.15,
        width: screenWidth * 0.28,
        decoration: BoxDecoration(
          color: ThemeProvider.text_background,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selectedIndex == index ? Colors.white : Colors.transparent,
            width: 2.0,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!isStacked)
              Image(
                image: AssetImage(imageAssetPath!),
                height: screenHeight * 0.06,
              ),
            if (isStacked)
              Container(
                height: 50,
                width: double.maxFinite,
                child: Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: Color(0xff1F1F1F),
                        child: Image(
                          image: AssetImage(AssetPath.man),
                          height: screenHeight * 0.06,
                        ),
                      ),
                      Positioned(
                        left: 30,
                        child: CircleAvatar(
                          radius: 25,
                          backgroundColor: Color(0xff1F1F1F),
                          child: Image(
                            image: AssetImage(AssetPath.woman),
                            height: screenHeight * 0.06,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            SizedBox(
              height: screenHeight * 0.02,
            ),
            CommonTextWidget(
              heading: label ?? "All",
              fontSize: Dimens.eighteen,
              color: ThemeProvider.whiteColor,
              fontFamily: 'Intern',
              fontWeight: FontWeight.w400,
            ),
          ],
        ),
      ),
    );
  }

  String formatDate(String inputDate) {
    DateTime date = DateTime.parse(inputDate);
    String formattedDate = DateFormat('MMMM dd, yyyy').format(date);
    return formattedDate;
  }

  String TimeFormate(String date, String time) {
    DateTime dateTime = DateTime.parse("$date $time");
    String formattedTime = DateFormat.Hm().format(dateTime);
    return formattedTime;
  }

  Future<Widget> LoginPopUp() async {
    return await showDialog(
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
                    "please Create account/Login first",
                    style: TextStyle(
                        color: ThemeProvider.whiteColor, fontFamily: "Intern"),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 100,
                      height: 35,
                      child: SubmitButton(
                        onPressed: () =>
                        {
                          Navigator.of(context).pop(),
                          Get.toNamed(AppRouter.getLoginRoute())
                        },
                        title: "Login",
                      ),
                    ),
                    Container(
                      width: 80,
                      height: 35,
                      child: SubmitButton(
                        onPressed: () => {Navigator.of(context).pop()},
                        title: "Cancel",
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
  }

  bool _onSwipe(int previousIndex,
      int? currentIndex,
      CardSwiperDirection direction,) {

    debugPrint(
      'The card at index $previousIndex was swiped to the right. Now the card at index $currentIndex is on top',
    );

    recordsController.current_Index?.value = previousIndex! ;

    if(currentIndex!= null){
      recordsController.current_Index?.value = previousIndex! ;

    }else{
      recordsController.islastCard.value = true  ;

      recordsController.current_Index?.value = previousIndex + 1 ;
      recordsController.update();

    }

    switch (direction) {
      case CardSwiperDirection.left:
        debugPrint(
          'The card at index $previousIndex was swiped to the left. Now the card at index $currentIndex is on top',
        );
        debugPrint(
          'unlike person name  ${recordsController.cardDeck[recordsController.current_Index!.value!].name!}',
        );
        recordsController.LikePerson(
          recordsController.cardDeck[recordsController.current_Index!.value!].UUId!,
          context,
          recordsController.cardDeck[recordsController.current_Index!.value].event_id!,
          false,
        ).whenComplete(() => {
          matchController.update()

        });
        return true ;
        break;
      case CardSwiperDirection.right:
        debugPrint(
          'The card at index $previousIndex was swiped to the right. Now the card at index $currentIndex is on top',
        );
        debugPrint(
          'like person name  ${recordsController.cardDeck[recordsController.current_Index!.value].name!}',
        );
        recordsController.LikePerson(
          recordsController.cardDeck[recordsController.current_Index!.value].UUId!,
          context,
          recordsController.cardDeck[recordsController.current_Index!.value].event_id!,
          true,
        ).whenComplete(() => {
        matchController.update()

        });
        return true ;
        break;
      default:
        debugPrint(
          'The card at index $previousIndex was swiped to a direction other than left or right.',
        );
    }
   return false ;
  }

  bool _onUndo(int? previousIndex,
      int currentIndex,
      CardSwiperDirection direction,) {
    debugPrint(
      'The card $currentIndex was undod from the ${direction.name}',
    );
    return true;
  }
}
