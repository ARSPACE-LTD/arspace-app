import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:arspace/backend/helper/app_router.dart';
import 'package:carousel_slider/carousel_slider.dart' as carousel ;

import 'package:arspace/controller/event_controller.dart';
import 'package:arspace/util/all_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:share_plus/share_plus.dart';
import '../backend/helper/Button.dart';
import '../util/dimens.dart';
import '../util/theme.dart';
import '../widgets/commontext.dart';
import '../widgets/custom_text_field.dart';
import 'connectivity_service.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({super.key});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  final ConnectivityService connectivityService = Get.find();

  double screenHeight = 0;
  double screenWidth = 0;
  int current = 0;
  final carousel.CarouselController _controller = carousel.CarouselController();
  final EventController eventController =
      Get.put(EventController(parser: Get.find()));
  String UUId = "";

  GlobalKey<FormState> paymentFormKey = GlobalKey<FormState>();
  String? _errorText;
  String? _errorMessage;
  bool add_text = false;
  bool? isprofileComplete;
  int? lastSelectedIndex;
  int? ticketCurrentSelectedIndex;




  @override
  void initState() {
    super.initState();
    eventController.initialized;

    eventController.monthYearController = TextEditingController();
    eventController.monthYearController.addListener(_handleTextChange);
    isprofileComplete = eventController.parser.getProfileIsComplete();


    UUId = Get.arguments[0].toString();

    print(" UUiD== $UUId");
    // eventController.cardsModel.data?.clear();
    // eventController.selectCardpaymentToken = "";
    // eventController.selectCardpaymentName = "";

    eventController.getEventsDetails(UUId!);

    if (eventController.parser.CheckToken() != null &&
        eventController.parser.CheckToken().isNotEmpty) {
      eventController.CardList(context ,"");
    }

// Initialize the controller if needed
  }

  void _handleTextChange() {
    final text = eventController.monthYearController.text;
    if (text.length == 2 && !eventController.monthYearController.text.contains('/')) {
      eventController.monthYearController.value = eventController.monthYearController.value.copyWith(
        text: text + '/',
        selection: TextSelection.collapsed(offset: text.length + 1),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> imageSliders = eventController.imgList
        .map((item) => Container(
            height: screenHeight,
            width: screenWidth,
            child: Image.network(
              item,
              fit: BoxFit.fill,
              width: screenWidth,
              height: screenHeight,
            )
            /* Image.asset(
            item, fit: BoxFit.fill, width: screenWidth,height: screenHeight,),*/
            ))
        .toList();
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return GetBuilder<EventController>(builder: (logic) {
      return logic.isLoading == true
          ? Center(
              child: LoadingAnimationWidget.threeRotatingDots(
                color: ThemeProvider.loader_color,
                size: Dimens.loder_size,
              ),
            )
          : Scaffold(
              key: eventController.scaffoldKey,
              resizeToAvoidBottomInset: true,
              backgroundColor: ThemeProvider.blackColor,
              body: SafeArea(
                top: false, // ignore the top safe area
                bottom: false, // ignore the bottom safe area
                child:  logic.geteventInfo.data != null
                    ? Stack(
                  children: [
                     Stack(
                        children: [
                          CustomScrollView(
                            slivers: [
                              SliverAppBar(
                                  automaticallyImplyLeading: false,
                                  backgroundColor: Colors.white,
                                  expandedHeight: screenHeight * 0.50,
                                  floating: true,
                                  pinned: true,
                                  snap: true,
                                  collapsedHeight: 180,
                                  toolbarHeight: 60,
                                  titleSpacing: 0,
                                  centerTitle: true,
                                  forceMaterialTransparency: true,
                                  bottom: PreferredSize(
                                      preferredSize: Size(screenWidth, 10),
                                      child: Container(
                                        height: 10,
                                        width: screenWidth,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(25),
                                              topLeft: Radius.circular(25),
                                            ),
                                            color: Colors.black),
                                      )),
                                  leadingWidth: screenWidth,
                                  leading: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                          onTap: () {

                                          //  Get.back();
                                            Get.offAllNamed(AppRouter.dashboardScreen) ;

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
                                        Row(children: [
                                          GestureDetector(
                                            onTap: () {

                                              String baseUrl = Platform.isIOS ? 'https://arspace.website/event/ios'
                                                  :'https://arspace.website/event/android';
                                              String shareUrl = '$baseUrl/$UUId';
                                              Share.share('Hi! Download Arspace app: $shareUrl');

                                              /*if (logic.parser
                                                  .CheckToken() !=
                                                  null &&
                                                  logic.parser
                                                      .CheckToken()
                                                      .isNotEmpty) {


                                                *//*Share.share(
                                                    'Hi! Download Arspace app http://www.Arspace.com');*//*


                                                   String baseUrl = 'http://arspace.website/event/android';
                                                   String shareUrl = '$baseUrl/$UUId';
                                                   Share.share('Hi! Download Arspace app: $shareUrl');

                                              } else {
                                                Share.share(
                                                    'Hi! Download Arspace app http://www.Arspace.com');
                                              }*/
                                            },
                                            child: CircleAvatar(
                                              maxRadius:
                                              screenWidth * 0.055,
                                              backgroundColor: ThemeProvider
                                                  .text_background
                                                  .withOpacity(0.4),
                                              child: Center(
                                                child: SvgPicture.asset(
                                                  AssetPath.share,
                                                  height: 25,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              if (connectivityService
                                                  .isConnected.value) {
                                                if (logic.parser
                                                    .CheckToken() !=
                                                    null &&
                                                    logic.parser
                                                        .CheckToken()
                                                        .isNotEmpty) {
                                                  logic.LikeEvent(
                                                      UUId, context);
                                                } else {
                                                  LoginPopUp("login");
                                                }
                                              } else {
                                                showToast(AppString
                                                    .internet_connection);
                                              }
                                            },
                                            child: CircleAvatar(
                                              maxRadius:
                                              screenWidth * 0.055,
                                              backgroundColor: ThemeProvider
                                                  .text_background
                                                  .withOpacity(0.4),
                                              child: Center(
                                                child: SvgPicture.asset(
                                                  logic.geteventInfo.data
                                                      ?.liked ==
                                                      true
                                                      ? AssetPath.liked
                                                      : AssetPath.favourite,
                                                  color: /*logic.geteventInfo.data
                                              ?.liked ==
                                              true
                                              ? Colors.red
                                              : */
                                                  Colors.white,
                                                  height: 25,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ])
                                      ],
                                    ),
                                  ),
                                  flexibleSpace: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      ClipRRect(
                                        child: ImageFiltered(
                                          imageFilter: ImageFilter.blur(
                                              sigmaX: 10, sigmaY: 10),
                                          child: carousel.CarouselSlider(
                                            items: imageSliders,
                                            carouselController: _controller,
                                            options: carousel.CarouselOptions(
                                                autoPlay: true,
                                                aspectRatio: screenWidth *
                                                    2 /
                                                    screenHeight,
                                                viewportFraction: 1,
                                                enlargeCenterPage: false,
                                                onPageChanged:
                                                    (index, reason) {
                                                  setState(() {
                                                    current = index;
                                                  });
                                                }),
                                          ),
                                        ),
                                      ),
                                      FlexibleSpaceBar(
                                        //expandedTitleScale:1.2,
                                        titlePadding:
                                        EdgeInsets.only(right: 0),
                                        centerTitle: true,
                                        title: Stack(
                                          children: [
                                            carousel.CarouselSlider(
                                              items: imageSliders,
                                              carouselController:
                                              _controller,
                                              options: carousel.CarouselOptions(
                                                  autoPlay: true,
                                                  aspectRatio: screenWidth *
                                                      2 /
                                                      screenHeight,
                                                  viewportFraction: 1,
                                                  enlargeCenterPage: false,
                                                  onPageChanged:
                                                      (index, reason) {
                                                    setState(() {
                                                      current = index;
                                                    });
                                                  }),
                                            ),
                                            Positioned(
                                              bottom: 6,
                                              left: 0,
                                              right: 0,
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .center,
                                                children: logic.imgList
                                                    .asMap()
                                                    .entries
                                                    .map((entry) {
                                                  return GestureDetector(
                                                    onTap: () => _controller
                                                        .animateToPage(
                                                        entry.key),
                                                    child: Container(
                                                      width: 8.0,
                                                      height: 8.0,
                                                      margin: EdgeInsets
                                                          .symmetric(
                                                          vertical: 8.0,
                                                          horizontal:
                                                          4.0),
                                                      decoration: BoxDecoration(
                                                          shape: BoxShape
                                                              .circle,
                                                          color: (Theme.of(context)
                                                              .brightness ==
                                                              Brightness
                                                                  .light
                                                              ? Colors
                                                              .white
                                                              : Colors
                                                              .black)
                                                              .withOpacity(
                                                              current ==
                                                                  entry.key
                                                                  ? 0.9
                                                                  : 0.4)),
                                                    ),
                                                  );
                                                }).toList(),
                                              ),
                                            )
                                          ],
                                        ),
                                        // background:Stack(
                                        //   children: [
                                        //     CarouselSlider(
                                        //       items:imageSliders,
                                        //      // items:logic.isHeight == false? imageSliders : imageBlurSliders,
                                        //       carouselController: _controller,
                                        //       options: CarouselOptions(
                                        //           autoPlay: true,
                                        //           aspectRatio: 1.08,
                                        //           //aspectRatio: logic.isHeight == false?1.1:1.7,
                                        //           viewportFraction: 1,
                                        //           enlargeCenterPage: false,
                                        //           onPageChanged: (index, reason) {
                                        //             setState(() {
                                        //               current = index;
                                        //             });
                                        //           }),
                                        //     ),
                                        //     Positioned(
                                        //       top:screenWidth * 0.75 ,
                                        //      // top: logic.isHeight==false?screenWidth * 0.75:screenWidth * 0.48,
                                        //       right: screenWidth * 0.43,
                                        //       child: Row(
                                        //         mainAxisAlignment: MainAxisAlignment.center,
                                        //         children: imgList
                                        //             .asMap()
                                        //             .entries
                                        //             .map((entry) {
                                        //           return GestureDetector(
                                        //             onTap: () => _controller.animateToPage(entry.key),
                                        //             child: Container(
                                        //               width: 8.0,
                                        //               height: 8.0,
                                        //               margin: EdgeInsets.symmetric(
                                        //                   vertical: 8.0, horizontal: 4.0),
                                        //               decoration: BoxDecoration(
                                        //                   shape: BoxShape.circle,
                                        //                   color: (Theme
                                        //                       .of(context)
                                        //                       .brightness == Brightness.light
                                        //                       ? Colors.white
                                        //                       : Colors.black)
                                        //                       .withOpacity(
                                        //                       current == entry.key ? 0.9 : 0.4)),
                                        //             ),
                                        //           );
                                        //         }).toList(),
                                        //       ),
                                        //     )
                                        //   ],
                                        // ),
                                      ),
                                    ],
                                  )),
                              SliverToBoxAdapter(
                                child: SizedBox(
                                  height: screenHeight ,
                                  width: screenWidth,
                                  child: Container(
                                    height: screenHeight * 0.8,
                                    width: screenWidth,
                                    decoration: BoxDecoration(
                                      color: ThemeProvider.blackColor,
                                    ),
                                    child: SingleChildScrollView(
                                      physics:
                                      NeverScrollableScrollPhysics(),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: screenHeight * 0.04,
                                            ),
                                            CommonTextWidget(
                                              heading: logic.geteventInfo
                                                  .data?.title !=
                                                  null
                                                  ? logic.geteventInfo.data
                                                  ?.title
                                                  : "",

                                              //    heading: AppString.event_name,
                                              fontSize: Dimens.twentyFour,
                                              color:
                                              ThemeProvider.whiteColor,
                                              fontFamily: 'Lexend',
                                              fontWeight: FontWeight.w400,
                                            ),
                                            SizedBox(
                                              height: screenHeight * 0.02,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Container(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .center,
                                                    children: [
                                                      for (int i = 0;
                                                      i <
                                                          logic
                                                              .geteventInfo
                                                              .data!
                                                              .interestedUsers!
                                                              .length &&
                                                          i < 4;
                                                      i++)
                                                        if (i ==
                                                            3) // Check if index is 3 (4th item)
                                                          Align(
                                                            widthFactor:
                                                            0.8,
                                                            child:
                                                            Container(
                                                              height: 34,
                                                              width: 42,
                                                              decoration: BoxDecoration(
                                                                  color: ThemeProvider
                                                                      .text_background,
                                                                  borderRadius:
                                                                  BorderRadius.circular(
                                                                      20)),
                                                              child: Center(
                                                                child:
                                                                CommonTextWidget(
                                                                  heading:
                                                                  "${logic.geteventInfo.data!.interestedUsers!.length - 3}",
                                                                  fontSize:
                                                                  Dimens
                                                                      .twelve,
                                                                  color: ThemeProvider
                                                                      .whiteColor,
                                                                  fontFamily:
                                                                  'Intern',
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        else
                                                          Align(
                                                            widthFactor:
                                                            0.6,
                                                            child:
                                                            CircleAvatar(
                                                              radius: 16,
                                                              backgroundColor:
                                                              Colors
                                                                  .white,
                                                              child:
                                                              CircleAvatar(
                                                                radius: 14,
                                                                backgroundImage:
                                                                NetworkImage(
                                                                  // "${logic.imgList[i]}"),
                                                                    "${logic.geteventInfo.data!.interestedUsers![i].profilePicture}"),
                                                                //AssetImage(imgList[i]),
                                                              ),
                                                            ),
                                                          ),
                                                    ],
                                                  ),
                                                ),
                                                CommonTextWidget(
                                                  heading: logic.geteventInfo
                                                      .data !=
                                                      null &&
                                                      logic
                                                          .geteventInfo
                                                          .data!
                                                          .tickets !=
                                                          null &&
                                                      logic
                                                          .geteventInfo
                                                          .data!
                                                          .tickets!
                                                          .isNotEmpty
                                                      ? '\$ ${logic.geteventInfo.data!.tickets!.where((ticket) => ticket.price != null).map<double>((ticket) => ticket.price!).reduce((a, b) => a < b ? a : b).toStringAsFixed(2)}' +
                                                      "-" +
                                                      '${logic.geteventInfo.data!.tickets!.where((ticket) => ticket.price != null).map<double>((ticket) => ticket.price!).reduce((a, b) => a > b ? a : b).toStringAsFixed(2)}'
                                                      : "00",

                                                  /// heading: " ¥ 40-80",
                                                  fontSize: Dimens.twenty,
                                                  color: ThemeProvider
                                                      .whiteColor,
                                                  fontFamily: 'Lexend',
                                                  fontWeight:
                                                  FontWeight.w400,
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: screenHeight * 0.02,
                                            ),
                                            Container(
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color: ThemeProvider
                                                    .text_background,
                                                borderRadius:
                                                BorderRadius.circular(
                                                    20),
                                              ),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      SvgPicture.asset(
                                                          AssetPath.clock),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      CommonTextWidget(
                                                        heading: eventController
                                                            .geteventInfo
                                                            .data
                                                            ?.time !=
                                                            null
                                                            ? formatDate(eventController
                                                            .geteventInfo
                                                            .data!
                                                            .date!) +"  " +formatTime(eventController
                                                            .geteventInfo
                                                            .data!
                                                            .time!)
                                                            : "",
                                                        //  heading: "Dec 7, 2019 23:26",
                                                        fontSize:
                                                        Dimens.forteen,
                                                        color: ThemeProvider
                                                            .text_light_gray,
                                                        fontFamily:
                                                        'Intern',
                                                        fontWeight:
                                                        FontWeight.w400,
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height:
                                                    screenHeight * 0.02,
                                                  ),
                                                  Row(
                                                    children: [
                                                      SvgPicture.asset(
                                                          AssetPath
                                                              .mapPoint,
                                                          height: 18,
                                                          color: ThemeProvider
                                                              .whiteColor
                                                              .withOpacity(
                                                              0.6)),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Container(
                                                        child: Expanded(
                                                          child: CommonTextWidget(
                                                            heading:   eventController
                                                                .geteventInfo
                                                                .data!
                                                                .location!,

                                                            fontSize: Dimens.forteen,
                                                            color: ThemeProvider.text_light_gray,
                                                            textOverflow: TextOverflow.ellipsis,
                                                            maxLines: 2,
                                                            fontFamily: 'Intern',
                                                            fontWeight: FontWeight.w400,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: screenHeight * 0.04,
                                            ),
                                            logic.geteventInfo.data
                                                ?.casts !=
                                                null &&
                                                logic.geteventInfo.data!
                                                    .casts!.isNotEmpty
                                                ? CommonTextWidget(
                                              heading: AppString.cast,
                                              fontSize:
                                              Dimens.twentyFour,
                                              color: ThemeProvider
                                                  .whiteColor,
                                              fontFamily: 'Lexend',
                                              fontWeight:
                                              FontWeight.w400,
                                            )
                                                : Container(),
                                            SizedBox(
                                              height: screenHeight * 0.02,
                                            ),
                                            logic.geteventInfo.data
                                                ?.casts !=
                                                null &&
                                                logic.geteventInfo.data!
                                                    .casts!.isNotEmpty
                                                ? Container(
                                              width: screenWidth * 2,
                                              height:
                                              screenHeight * 0.2,
                                              child: ListView.builder(
                                                scrollDirection:
                                                Axis.horizontal,
                                                physics:
                                                AlwaysScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                itemCount: logic
                                                    .geteventInfo
                                                    .data!
                                                    .casts!
                                                    .length,
                                                itemBuilder:
                                                    (context, index) {
                                                  return Row(
                                                    children: [
                                                      Stack(
                                                        children: [
                                                          Container(
                                                            height:
                                                            screenHeight *
                                                                4,
                                                            width:
                                                            screenWidth *
                                                                0.3,
                                                            decoration:
                                                            BoxDecoration(
                                                              borderRadius:
                                                              BorderRadius.circular(20),
                                                              image: DecorationImage(
                                                                  image:
                                                                  NetworkImage(logic.geteventInfo.data!.casts![index].image!),
                                                                  fit: BoxFit.fill), /*DecorationImage(
                                                          image: AssetImage(
                                                              imgList[index]
                                                          ),
                                                          fit: BoxFit.fill
                                                      ),*/
                                                            ),
                                                          ),
                                                          Positioned(
                                                            top: screenHeight *
                                                                0.152,
                                                            child:
                                                            Container(
                                                              height: screenHeight *
                                                                  0.048,
                                                              width: screenWidth *
                                                                  0.3,
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                  BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                                                                  color: ThemeProvider.text_background),
                                                              child:
                                                              Padding(
                                                                padding: EdgeInsets.only(
                                                                    top: 10,
                                                                    left: 8),
                                                                child:
                                                                CommonTextWidget(
                                                                  heading:
                                                                  logic.geteventInfo.data!.casts![index].cast!,
                                                                  fontSize:
                                                                  Dimens.sixteen,
                                                                  color:
                                                                  ThemeProvider.whiteColor,
                                                                  fontFamily:
                                                                  'Intern',
                                                                  fontWeight:
                                                                  FontWeight.w400,
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        width: 14,
                                                      )
                                                    ],
                                                  );
                                                },
                                              ),
                                            )
                                                : Container(),

                                            SizedBox(
                                              height: screenHeight * 0.04,
                                            ),
                                            CommonTextWidget(
                                              heading: AppString.detail,
                                              fontSize: Dimens.twentyFour,
                                              color:
                                              ThemeProvider.whiteColor,
                                              fontFamily: 'Lexend',
                                              fontWeight: FontWeight.w400,
                                            ),
                                            SizedBox(
                                                height:
                                                screenHeight * 0.02),
                                            Container(
                                              margin: EdgeInsets.only(bottom: 150),
                                              child: CommonTextWidget(
                                                heading: eventController.geteventInfo.data?.description != null
                                                    ? Utf8Decoder().convert(eventController.geteventInfo.data!.description!.codeUnits)
                                                    : "",
                                                fontSize: Dimens.sixteen,
                                                color: ThemeProvider.text_light_gray,
                                                fontFamily: 'Intern',
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),

                                            SizedBox(height: 150,) ,
                                            CommonTextWidget(
                                              heading: AppString.detail,
                                              fontSize: Dimens.twentyFour,
                                              color:
                                              ThemeProvider.whiteColor,
                                              fontFamily: 'Lexend',
                                              fontWeight: FontWeight.w400,
                                            ),


                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Positioned(
                            bottom: 0,
                            child: Container(
                              height: screenWidth * 0.25,
                              width: screenWidth,
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 14.0),
                                  child: GradientSlideToAct(
                                    animationDuration: Duration(seconds: 3),
                                    height: 60,
                                    width: screenWidth * .9,
                                    dragableIconBackgroundColor:
                                    Colors.greenAccent,
                                    draggableWidget: Container(
                                      height: 60,
                                      width: 60,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(colors: [
                                          ThemeProvider.buttonfirstClr,
                                          ThemeProvider.buttonSecondClr,
                                          ThemeProvider.buttonThirdClr
                                        ], stops: [
                                          0.1,
                                          0.5,
                                          0.90
                                        ]),
                                        borderRadius:
                                        BorderRadius.circular(40),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(18.0),
                                        child: SvgPicture.asset(
                                            AssetPath.ticket),
                                      ),
                                    ),
                                    textStyle: TextStyle(
                                        color: Colors.white, fontSize: 15),
                                    backgroundColor: Color(0xFF2F323F),
                                    text: "Continue",
                                    onSubmit: () async {
                                      if (logic.parser.CheckToken() !=
                                          null &&
                                          logic.parser
                                              .CheckToken()
                                              .isNotEmpty) {

                                        selectTicket(logic);

                                        /*if(isprofileComplete == true){
                                          selectTicket(logic);
                                        }else{
                                          LoginPopUp("profile");
                                        }*/


                                      } else {
                                        LoginPopUp("login");
                                      }

                                      // selectTicket(logic);
                                    },
                                    gradient: LinearGradient(
                                      colors: [
                                        ThemeProvider.buttonfirstClr,
                                        ThemeProvider.buttonSecondClr,
                                        ThemeProvider.buttonThirdClr
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),

                    if (logic.isBottomSheetOpen == true)
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          //  color: Colors.black.withOpacity(0.6),
                          // Adjust opacity as needed
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
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
                )
                    : Center(
                  child: CommonTextWidget(
                    heading: "Event Not Found",
                    fontSize: Dimens.eighteen,
                    color: Colors.white,
                    fontFamily: 'Intern',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              )



            );
    });
  }

  void selectTicket(EventController eventController) {
    eventController.toggleBottomSheet();
    showModalBottomSheet(
      constraints: BoxConstraints(
        maxWidth: screenWidth,
      ),
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
                child: eventController.isCheckOut
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                  heading: AppString.select_ticket,
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
                                    backgroundColor:
                                        ThemeProvider.text_background,
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
                            height: screenHeight * 0.4,
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: AlwaysScrollableScrollPhysics(),
                              itemCount: eventController
                                  .geteventInfo.data?.tickets!.length!,
                              itemBuilder: (context, index) {
                                final isSelected = eventController
                                    .selectedIndices
                                    .contains(index);
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      ticketCurrentSelectedIndex = index;
                                      if (lastSelectedIndex != null) {
                                        eventController.geteventInfo.data?.tickets![lastSelectedIndex!].left = (eventController.geteventInfo.data!.tickets![lastSelectedIndex!].left! + eventController.quatity).clamp(0, double.infinity).toInt();;
                                        eventController.update();
                                      }
                                      eventController.quatity = 0;
                                      eventController.tickect_index = index;
                                      eventController.item_ticket_id =
                                          eventController.geteventInfo.data
                                              ?.tickets![index].uuid;
                                      eventController.selectedIndices.clear();
                                      eventController.selectedIndices
                                          .add(index);
                                      eventController.quatity++;
                                      eventController.isSelectTier = true;
                                      eventController.isSelectAdd = true;

                                      eventController.geteventInfo.data!.tickets![index].left =
                                          (eventController.geteventInfo.data!.tickets![index].left! - 1).clamp(0, double.infinity).toInt();

                                      lastSelectedIndex = index;



                                    });
                                  },
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 14),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: isSelected
                                                  ? Colors.white
                                                  : Colors.transparent,
                                              width: isSelected ? 2.0 : 0.0,
                                            ),
                                            color:
                                                ThemeProvider.text_background,
                                            borderRadius:
                                                BorderRadius.circular(14),
                                          ),
                                          child: ListTile(
                                            title: CommonTextWidget(
                                              heading:
                                                  "${eventController.geteventInfo.data?.tickets![index].name}",
                                              fontSize: Dimens.eighteen,
                                              color: ThemeProvider.whiteColor,
                                              fontFamily: 'Lexend',
                                              fontWeight: FontWeight.w800,
                                            ),
                                            subtitle: CommonTextWidget(
                                              heading:
                                                  "${eventController.geteventInfo.data?.tickets![index].left.toString()}",
                                              fontSize: Dimens.forteen,
                                              color:
                                                  ThemeProvider.text_light_gray,
                                              fontFamily: 'Intern',
                                              fontWeight: FontWeight.w500,
                                            ),
                                            trailing: CommonTextWidget(
                                              heading:
                                                  "${eventController.geteventInfo.data?.tickets![index].price}",
                                              fontSize: Dimens.twenty,
                                              color: ThemeProvider.whiteColor,
                                              fontFamily: 'Lexend',
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 14,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          Divider(
                            height: 2,
                            color: ThemeProvider.dividerColor,
                          ),
                          SizedBox(
                            height: 14,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 14),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CommonTextWidget(
                                  heading: AppString.quality,
                                  fontSize: Dimens.twentySix,
                                  color: ThemeProvider.text_light_gray,
                                  fontFamily: 'Lexend',
                                  fontWeight: FontWeight.w800,
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 4),
                                  height: 40,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: ThemeProvider.text_background,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          // Implement logic to decrement quantity
                                          setState(() {
                                            // Check if quantity is greater than 0 before decrementing
                                            if (eventController.selectedIndices
                                                        .length >
                                                    0 &&
                                                eventController.quatity > 0) {
                                              eventController.quatity--;
                                              eventController.geteventInfo.data!.tickets![ticketCurrentSelectedIndex!].left =
                                                  (eventController.geteventInfo.data!.tickets![ticketCurrentSelectedIndex!].left! + 1).clamp(0, double.infinity).toInt();
                                              eventController.isSelectAdd =
                                                  false;
                                              eventController.isSelectsub =
                                                  true;
                                            }
                                          });
                                        },
                                        child: CircleAvatar(
                                          backgroundColor: eventController
                                                          .isSelectTier ==
                                                      true &&
                                                  eventController.isSelectsub ==
                                                      true
                                              ? ThemeProvider.whiteColor
                                              : ThemeProvider.greyColor,
                                          maxRadius: 12,
                                          child: Center(
                                            child: Icon(
                                              Icons.remove,
                                              color: ThemeProvider.blackColor,
                                              size: 22,
                                            ),
                                          ),
                                        ),
                                      ),
                                      CommonTextWidget(
                                        heading: eventController
                                                    .selectedIndices.length >
                                                0
                                            ? "${eventController.quatity.toString()}"
                                            : "0",
                                        fontSize: Dimens.forteen,
                                        color: ThemeProvider.whiteColor,
                                        fontFamily: 'Intern',
                                        fontWeight: FontWeight.w800,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          // Implement logic to increment quantity
                                          setState(() {
                                            if (eventController
                                                    .selectedIndices.length >
                                                0) {
                                              eventController.quatity++;
                                            }
                                            eventController.geteventInfo.data!.tickets![ticketCurrentSelectedIndex!].left =
                                                (eventController.geteventInfo.data!.tickets![ticketCurrentSelectedIndex!].left! - 1).clamp(0, double.infinity).toInt();
                                            eventController.isSelectAdd = true;
                                            eventController.isSelectsub = false;


                                            // eventController.selectedIndices.add(1); // For example, add 1 to the quantity
                                          });
                                        },
                                        child: CircleAvatar(
                                          backgroundColor: eventController
                                                          .isSelectTier ==
                                                      true &&
                                                  eventController.isSelectAdd ==
                                                      true
                                              ? ThemeProvider.whiteColor
                                              : ThemeProvider.greyColor,
                                          maxRadius: 12,
                                          child: Center(
                                            child: Icon(
                                              Icons.add,
                                              color: ThemeProvider.blackColor,
                                              size: 22,
                                            ),
                                          ),
                                        ),
                                        /* CircleAvatar(
                                    child: Center(
                                      child: Icon(
                                        Icons.add,
                                        color: ThemeProvider.blackColor,
                                        size: 24,
                                      ),
                                    ),
                                    backgroundColor: eventController
                                        .selectedIndices.length >
                                        0
                                        ? ThemeProvider.whiteColor
                                        : ThemeProvider.greyColor,
                                    maxRadius: 10,
                                  ),*/
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 14,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: SubmitButton(
                                onPressed: () {
                                  if (eventController.quatity != 0) {
                                    setState(() {
                                      eventController.isCheckOut = false;
                                    });
                                    eventController.update();
                                  } else {
                                    showToast(
                                        "Please select Ticket and Quatity");
                                  }
                                },
                                title: "Continue"),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      )
                    //: eventController.isPayemt && !eventController.isCheckOut
                    : Padding(
                        padding: EdgeInsets.symmetric(horizontal: 14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CommonTextWidget(
                                  heading: AppString.check_out,
                                  fontSize: Dimens.twentySix,
                                  color: ThemeProvider.whiteColor,
                                  fontFamily: 'Lexend',
                                  fontWeight: FontWeight.w800,
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      eventController.isCheckOut = true;
                                      eventController.update();
                                    });
                                  },
                                  child: CircleAvatar(
                                    maxRadius: screenWidth * 0.055,
                                    backgroundColor:
                                        ThemeProvider.text_background,
                                    child: Center(
                                        child: Icon(
                                      Icons.close,
                                      color: ThemeProvider.whiteColor,
                                    )),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: ThemeProvider.text_background,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                          image: NetworkImage(eventController.imgList[0]),
                                          fit: BoxFit.fill
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(left: 2.0),
                                          child: CommonTextWidget(
                                            heading: eventController.geteventInfo.data?.title ?? "",
                                            fontSize: Dimens.eighteen,
                                            color: ThemeProvider.whiteColor,
                                            fontFamily: 'Lexend',
                                            fontWeight: FontWeight.w800,
                                            textOverflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        SizedBox(height: 36),
                                        Row(
                                          children: [
                                            SvgPicture.asset(AssetPath.clock),
                                            SizedBox(width: 10),
                                            CommonTextWidget(
                                              heading: eventController.geteventInfo.data?.time != null
                                                  ? formatDate(eventController
                                                  .geteventInfo
                                                  .data!
                                                  .date!) +"  " +formatTime(eventController
                                                  .geteventInfo
                                                  .data!
                                                  .time!)
                                                  : "",
                                              fontSize: Dimens.forteen,
                                              color: ThemeProvider.text_light_gray,
                                              fontFamily: 'Intern',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 6),
                                        Row(
                                          children: [
                                            SvgPicture.asset(
                                              AssetPath.mapPoint,
                                              height: 18,
                                              color: ThemeProvider.whiteColor.withOpacity(0.6),
                                            ),
                                            SizedBox(width: 10),
                                            Expanded( // Wrap the text widget within Expanded
                                              child: CommonTextWidget(
                                                heading: eventController.geteventInfo.data?.location ?? "",
                                                fontSize: Dimens.forteen,
                                                color: ThemeProvider.text_light_gray,
                                                textOverflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                fontFamily: 'Intern',
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                           /* Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CommonTextWidget(
                                  heading: AppString.contact,
                                  fontSize: Dimens.eighteen,
                                  color: ThemeProvider.whiteColor,
                                  fontFamily: 'Intern',
                                ),
                                Row(
                                  children: [
                                    CommonTextWidget(
                                      heading: "123456789",
                                      fontSize: Dimens.sixteen,
                                      color: ThemeProvider.text_light_gray,
                                      fontFamily: 'Intern',
                                    ),
                                    SizedBox(width: 6),
                                    Icon(
                                      Icons.arrow_forward_ios_outlined,
                                      color: ThemeProvider.text_light_gray,
                                      size: 12,
                                    )
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 30,
                            ),*/
                            GestureDetector(
                              onTap: () {
                                // Navigator.of(context).pop();

                                /* eventController.CardList().whenComplete(() => {
                                paymentBottomSheet(eventController)
                                });*/
                                paymentBottomSheet(eventController);
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CommonTextWidget(
                                    heading: AppString.payment,
                                    fontSize: Dimens.eighteen,
                                    color: ThemeProvider.whiteColor,
                                    fontFamily: 'Intern',
                                  ),
                                  Row(
                                    children: [
                                      Obx(() => CommonTextWidget(
                                            heading: eventController
                                                    .selectCardpaymentName
                                                    .value
                                                    .isNotEmpty
                                                ? eventController
                                                    .selectCardpaymentName.value
                                                : AppString.add_payment_method,
                                            fontSize: Dimens.sixteen,
                                            color:
                                                ThemeProvider.text_light_gray,
                                            fontFamily: 'Intern',
                                          )),
                                      SizedBox(width: 6),
                                      Icon(
                                        Icons.arrow_forward_ios_outlined,
                                        color: ThemeProvider.text_light_gray,
                                        size: 12,
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Divider(
                              height: 2,
                              color: ThemeProvider.dividerColor,
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CommonTextWidget(
                                  heading: AppString.quality,
                                  fontSize: Dimens.eighteen,
                                  color: ThemeProvider.whiteColor,
                                  fontFamily: 'Intern',
                                ),
                                Row(
                                  children: [
                                    CommonTextWidget(
                                      heading:
                                          "${eventController.geteventInfo.data?.tickets![eventController.tickect_index].name}",

                                      //   heading: AppString.early_bird_ticket,
                                      fontSize: Dimens.sixteen,
                                      color: ThemeProvider.text_light_gray,
                                      fontFamily: 'Intern',
                                    ),
                                    SizedBox(width: 6),
                                    Icon(
                                      Icons.close,
                                      color: ThemeProvider.text_light_gray,
                                      size: 10,
                                    ),
                                    SizedBox(width: 6),
                                    CommonTextWidget(
                                      heading:
                                          "${eventController.quatity.toString()}",
                                      fontSize: Dimens.sixteen,
                                      color: ThemeProvider.text_light_gray,
                                      fontFamily: 'Intern',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Divider(
                              height: 2,
                              color: ThemeProvider.dividerColor,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    CommonTextWidget(
                                      heading: "Price",
                                      fontSize: Dimens.eighteen,
                                      color: ThemeProvider.whiteColor,
                                      fontFamily: 'Intern',
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    CommonTextWidget(
                                      heading: "(1",
                                      fontSize: Dimens.sixteen,
                                      color: ThemeProvider.text_light_gray,
                                      fontFamily: 'Intern',
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Icon(
                                      Icons.close,
                                      color: ThemeProvider.text_light_gray,
                                      size: 10,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    CommonTextWidget(
                                      heading:
                                          "${eventController.geteventInfo.data?.tickets![eventController.tickect_index].price} )",

                                      // heading:"\$30 each)",
                                      fontSize: Dimens.sixteen,
                                      color: ThemeProvider.text_light_gray,
                                      fontFamily: 'Intern',
                                    )
                                  ],
                                ),
                                CommonTextWidget(
                                  heading:
                                      "\$ ${eventController.geteventInfo.data?.tickets![eventController.tickect_index].price}",

                                  //   heading:"\$30",
                                  fontSize: Dimens.sixteen,
                                  color: ThemeProvider.text_light_gray,
                                  fontFamily: 'Intern',
                                )
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CommonTextWidget(
                                  heading: AppString.fees,
                                  fontSize: Dimens.eighteen,
                                  color: ThemeProvider.whiteColor,
                                  fontFamily: 'Intern',
                                ),
                                CommonTextWidget(
                                  heading: "\$${eventController.geteventInfo.data?.fees.toString()}",
                                  fontSize: Dimens.sixteen,
                                  color: ThemeProvider.text_light_gray,
                                  fontFamily: 'Intern',
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Divider(
                              height: 2,
                              color: ThemeProvider.dividerColor,
                            ),
                            SizedBox(
                              height: 14,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CommonTextWidget(
                                  heading: AppString.total_price,
                                  fontSize: Dimens.twentySix,
                                  color: ThemeProvider.whiteColor,
                                  fontFamily: 'Lexend',
                                  fontWeight: FontWeight.w800,
                                ),
                                CommonTextWidget(
                                  heading:
                                      "\$${eventController.TotalPrice(eventController.geteventInfo.data?.tickets![eventController.tickect_index].price!.toString() ,
                                          eventController.geteventInfo.data!.fees!
                                      )}",

                                  //  heading: "\$32",
                                  fontSize: Dimens.twentySix,
                                  color: ThemeProvider.whiteColor,
                                  fontFamily: 'Lexend',
                                  fontWeight: FontWeight.w800,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 14,
                            ),
                            SubmitButton(
                                onPressed: () {
                                  setState(() {
                                    eventController.isPayemt = false;
                                    eventController.isCheckOut = false;
                                  });
                                  eventController.update();

                                  if (eventController
                                      .selectCardpaymentName.isNotEmpty) {
                                    if (connectivityService.isConnected.value) {
                                      eventController.CreateOrder(
                                          UUId, context);
                                    } else {
                                      showToast(AppString.internet_connection);
                                    }
                                  } else {
                                    showToast('Please select payment method');
                                  }
                                },
                                title: "Place Order  "),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      )



                );
          },
        );
      },
    ).whenComplete(() {
      setState(() {
        eventController.isBottomSheetOpen = false;
      });
    });
  }


  void paymentBottomSheet(EventController eventController) {
    eventController.toggleBottomSheet();
    showModalBottomSheet(
      constraints: BoxConstraints(
        maxWidth: screenWidth,
      ),
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
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CommonTextWidget(
                            heading: AppString.payment,
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
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    eventController.cardList != null &&
                            eventController.cardList!.isNotEmpty
                        ? Obx(() => SizedBox(
                              height: screenHeight * 0.5,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: eventController.cardList!.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            eventController
                                                    .selectCardpaymentToken =
                                                eventController.cardList![index]
                                                    .cardToken!;

                                            eventController
                                                    .selectCardpaymentName
                                                    .value =
                                                eventController
                                                    .cardList![index].name!;

                                            eventController.selectedIndex =
                                                index;

                                            Navigator.of(context).pop();
                                          });
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 14),
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 14),
                                            height: screenHeight * .08,
                                            width: screenWidth,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: eventController
                                                            .selectedIndex ==
                                                        index
                                                    ? Colors.white
                                                    : Colors.transparent,
                                                width: eventController
                                                            .selectedIndex ==
                                                        index
                                                    ? 2.0
                                                    : 0.0,
                                              ),
                                              color:
                                                  ThemeProvider.text_background,
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Image(
                                                      image: AssetImage(
                                                          AssetPath.cardImg),
                                                    ),
                                                    SizedBox(width: 10),
                                                    CommonTextWidget(
                                                      heading:
                                                          "${eventController.cardList?[index].name}",
                                                      fontSize: Dimens.sixteen,
                                                      color: ThemeProvider
                                                          .whiteColor,
                                                      fontFamily: 'Lexend',
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 14),
                                    ],
                                  );
                                },
                              ),
                            ))
                        : Container(
                            height: screenHeight * 0.5,
                            child: Center(
                              child: CommonTextWidget(
                                heading: AppString.card_message,
                                fontSize: Dimens.twenty,
                                color: ThemeProvider.whiteColor,
                                fontFamily: 'Lexend',
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                    SizedBox(height: 14),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: SubmitButton(
                        onPressed: () {
                          addCardBottomSheet(eventController);
                        },
                        title: "Add New Card",
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
        eventController.isBottomSheetOpen = false;
      });
    });
  }

  void addCardBottomSheet(EventController eventController) {
    eventController.toggleBottomSheet();
    showModalBottomSheet(
      constraints: BoxConstraints(
        maxWidth: screenWidth,
      ),
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
            return Container(
              height: screenHeight * 0.80,
              child: Form(
                key: paymentFormKey,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14),
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        child: Container(
                          margin: EdgeInsets.only(bottom: 150),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CommonTextWidget(
                                    heading: AppString.payment,
                                    fontSize: Dimens.twentySix,
                                    color: ThemeProvider.whiteColor,
                                    fontFamily: 'Lexend',
                                    fontWeight: FontWeight.w800,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Get.back();
                                      eventController.isCheckOut = false;
                                      eventController.isPayemt = true;
                                      setState(() {});
                                    },
                                    child: CircleAvatar(
                                      maxRadius: screenWidth * 0.055,
                                      backgroundColor:
                                          ThemeProvider.text_background,
                                      child: Center(
                                          child: Icon(
                                        Icons.close,
                                        color: ThemeProvider.whiteColor,
                                      )),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                //height: screenHeight * 0.4,
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      CustomTextField(
                                        maxLength: 19,
                                        controller:
                                            eventController.creditCardNumber,
                                        hintStyle: TextStyle(
                                            color: Color(0xFF4D4F5D),
                                            fontFamily: "Intern",
                                            fontSize: Dimens.eighteen),
                                        prefixIcon: Padding(
                                          padding: EdgeInsets.only(
                                              left: 10, right: 6),
                                          child: Image(
                                            image: AssetImage(
                                                AssetPath.credit_card),
                                            height: 20,
                                            width: 20,
                                          ),
                                        ),
                                        // controller: value.userNameController,
                                        hintText: AppString.credit_Card_Number,
                                        keyboardType: TextInputType.number,
                                        onChanged: (value) {
                                          String formattedValue = _formatCardNumber(value.replaceAll(' ', ''));
                                          eventController.creditCardNumber.value = TextEditingValue(
                                            text: formattedValue,
                                            selection: TextSelection.collapsed(offset: formattedValue.length),
                                          );
                                          _validateCard(formattedValue);
                                        },

                                        backgroundColor:
                                            ThemeProvider.text_background,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return AppString.error_card;
                                          }else if (value.length < 19){
                                            return AppString.error_card;
                                          }
                                          return null;
                                        },
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: screenWidth * 0.45,
                                            child: TextFormField(
                                              keyboardType: TextInputType.number,
                                              style: TextStyle(color: ThemeProvider.whiteColor ),

                                              inputFormatters: [
                                                FilteringTextInputFormatter.digitsOnly,
                                                LengthLimitingTextInputFormatter(4),
                                                CardMonthInputFormatter(),
                                              ],
                                                decoration: InputDecoration(
                                                  hintText: "MM/YY" ,
                                                    hintStyle: TextStyle(
                                                      fontSize: 18,
                                                      color: ThemeProvider.greyColor,
                                                      fontFamily: 'Intern',
                                                    ),
                                                  filled: true,
                                                  fillColor: ThemeProvider.text_background,



                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(8),
                                                    borderSide: BorderSide.none,
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: ThemeProvider.primary,
                                                      width: 1.5,
                                                    ),
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  isDense: true,
                                                  contentPadding: const EdgeInsets.symmetric(
                                                    horizontal: 15,
                                                    vertical: 15,
                                                  )),
                                                validator: (value){
                                                  if (value == null || value.isEmpty) {
                                                    return 'Please enter MM/YY';
                                                  }
                                                  if (value.length != 5) {
                                                    return 'Please enter MM/YY format';
                                                  }
                                                  if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(value)) {
                                                    return 'Please enter valid MM/YY format';
                                                  }else if (_validateExpiry(
                                                      value!,
                                                      eventController) !=
                                                      null) {
                                                    return _validateExpiry(
                                                        value!, eventController)!;
                                                  }
                                                  return null;


                                                },

                                            )) ,/*CustomTextFieldValidation(
                                              controller: eventController
                                                  .monthYearController,
                                              // controller: value.userNameController,
                                              hintText: "MM/YY",
                                              keyboardType: TextInputType.number,
                                              backgroundColor:
                                                  ThemeProvider.text_background,
                                              onChanged: (value) {

                                                print("onChanged");
                                                *//*if (_validateExpiry(value!,
                                                    eventController) !=
                                                    null) {
                                                  //return AppString.error_vaild_mmYY;
                                                }*//*
                                                     //<-- Automatically show a '/' after dd

                                              },


                                              validator: (value) {
                                                if (value == null || value.isEmpty) {
                                                  return 'Please enter MM/YY';
                                                }
                                                if (value.length != 5) {
                                                  return 'Please enter MM/YY format';
                                                }
                                                if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(value)) {
                                                  return 'Please enter valid MM/YY format';
                                                }else if (_validateExpiry(
                                                    value!,
                                                    eventController) !=
                                                    null) {
                                                  return _validateExpiry(
                                                      value!, eventController)!;
                                                }
                                                return null;

                                              *//*  if (value == null ||
                                                    value.isEmpty) {
                                                  return AppString.error_mmyy;
                                                } else if (_validateExpiry(
                                                        value!,
                                                        eventController) !=
                                                    null) {
                                                  return _validateExpiry(
                                                      value!, eventController)!;
                                                }

                                                return null;*//*
                                              },
                                            ),
                                          ),*/
                                          Container(
                                            width: screenWidth * 0.45,
                                            child: CustomTextField(
                                              controller:
                                                  eventController.cvvController,
                                              // controller: value.userNameController,
                                              hintText: "CVV",
                                              maxLength: 4,
                                              keyboardType:
                                                  TextInputType.number,
                                              backgroundColor:
                                                  ThemeProvider.text_background,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return AppString.error_cvv;
                                                }
                                                return null;
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Divider(
                                        height: 2,
                                        color: ThemeProvider.dividerColor,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            width: screenWidth * 0.45,
                                            child: CustomTextField(
                                              controller: eventController
                                                  .firstNameController,
                                              hintText: "First Name",
                                              keyboardType: TextInputType.text,
                                              backgroundColor:
                                                  ThemeProvider.text_background,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return AppString
                                                      .error_firstName;
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                          Container(
                                            width: screenWidth * 0.45,
                                            child: CustomTextField(
                                              controller: eventController
                                                  .lastNameController,
                                              hintText: "Last Name",
                                              keyboardType: TextInputType.text,
                                              backgroundColor:
                                                  ThemeProvider.text_background,
                                              validator: (value) {
                                                /* if (value == null || value.isEmpty) {
                                          return AppString.error_lastName;
                                        }*/
                                                return null;
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Divider(
                                        height: 2,
                                        color: ThemeProvider.dividerColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              InkWell(
                                onTap: () {
                                //  eventController.ShowCountryPicker(context);
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Obx(() => CommonTextWidget(
                                          heading: eventController
                                                          .selectedCountry
                                                          .value !=
                                                      null &&
                                                  eventController
                                                          .selectedCountry
                                                          .value !=
                                                      ""
                                              ? eventController
                                                  .selectedCountry.value
                                              : "Canada",
                                          fontSize: Dimens.eighteen,
                                          color: ThemeProvider.whiteColor,
                                          fontFamily: 'Intern',
                                        )),
                                    /*Icon(
                                      Icons.arrow_forward_ios_outlined,
                                      color: ThemeProvider.text_light_gray,
                                      size: 12,
                                    ),*/
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Divider(
                                height: 2,
                                color: ThemeProvider.dividerColor,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              CustomTextField(
                                controller:
                                eventController.postCodeController,
                                hintText: "Postal Code",
                                maxLength: 6,
                                keyboardType: TextInputType.text,
                                backgroundColor: ThemeProvider.text_background,
                                validator: (value) {
                                  /* if (value == null || value.isEmpty) {
                                    return AppString.error_userName;
                                  }*/
                                  return null;
                                },
                              ),
                              /*CustomTextField(
                                controller:
                                    eventController.streetAddressController,
                                hintText: "Street Address",
                                keyboardType: TextInputType.text,
                                backgroundColor: ThemeProvider.text_background,
                                validator: (value) {
                                  *//* if (value == null || value.isEmpty) {
                                    return AppString.error_userName;
                                  }*//*
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              CustomTextField(
                                controller: eventController.adressController,
                                hintText:
                                    "Apartment, building, suite (optional)",
                                keyboardType: TextInputType.text,
                                backgroundColor: ThemeProvider.text_background,
                                validator: (value) {
                                  *//*if (value == null || value.isEmpty) {
                                    return AppString.error_userName;
                                  }*//*
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Divider(
                                height: 2,
                                color: ThemeProvider.dividerColor,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              InkWell(
                                onTap: () {
                                  if (eventController.states != null) {
                                    showStateDialog(eventController);
                                  } else {
                                    showToast('please select country ');
                                    eventController.loadStates(
                                        eventController.selectedCountry.value);
                                  }
                                  *//*eventController.states != null
                                      ? showStateDialog(eventController)
                                      : SizedBox.shrink();*//*
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Obx(() => CommonTextWidget(
                                          heading: eventController.selectedState
                                                          .value !=
                                                      null &&
                                                  eventController.selectedState
                                                          .value !=
                                                      ""
                                              ? eventController
                                                  .selectedState.value
                                              : "City",
                                          fontSize: Dimens.eighteen,
                                          color: ThemeProvider.whiteColor,
                                          fontFamily: 'Intern',
                                        )),
                                    Icon(
                                      Icons.arrow_forward_ios_outlined,
                                      color: ThemeProvider.text_light_gray,
                                      size: 12,
                                    ),
                                  ],
                                ),
                              ),*/
                              SizedBox(
                                height: 25,
                              ),
                              Divider(
                                height: 2,
                                color: ThemeProvider.dividerColor,
                              ),
                              SizedBox(
                                height: 100,
                              ),
                              /* SubmitButton(
                                  onPressed: () {
                                    if (paymentFormKey.currentState!.validate()) {
                                      eventController.createToken(context).whenComplete(() => {
                                        Navigator.of(context).pop(),
                                      */ /*eventController.CardList(context).whenComplete(() => {
                                      //  Navigator.of(context).pop(),
                                       // paymentBottomSheet(eventController)
                                      })*/ /*
                                      });
                                      */ /* .whenComplete(() => {
                                            Navigator.of(context).pop(),
                                            addCardBottomSheet(eventController)
                                          });*/ /*
                                    }

                                    // Get.toNamed(AppRouter.ticketPurchased);
                                  },
                                  title: "Done"),*/
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        left: 0,
                        right: 0,
                        child: SubmitButton(
                            onPressed: () {
                              if (paymentFormKey.currentState!.validate()) {
                                if (connectivityService.isConnected.value) {
                                  eventController
                                      .createToken(context)
                                      .whenComplete(() => {
                                            Navigator.of(context).pop(),
                                            /*eventController.CardList(context).whenComplete(() => {
                                    //  Navigator.of(context).pop(),
                                     // paymentBottomSheet(eventController)
                                    })*/
                                          });
                                } else {
                                  showToast(AppString.internet_connection);
                                }
                              }

                              // Get.toNamed(AppRouter.ticketPurchased);
                            },
                            title: "Done"),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      setState(() {
        eventController.isBottomSheetOpen = false;
      });
    });
  }

 /* String formatDate(String inputDate) {
    DateTime date = DateTime.parse(inputDate);
    String formattedDate = DateFormat('MMMM dd, yyyy').format(date);
    return formattedDate;
  }*/

  String timestampToString(String timestamp) {
    // Parse the string to an integer
    int timestampInt = int.parse(timestamp);

    // Convert the integer timestamp to a DateTime object
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestampInt * 1000);

    // Format the DateTime object
    String formattedDateTime = DateFormat('MMMM dd, yyyy HH:mm').format(dateTime);


    return formattedDateTime;
  }

  String formatDate(String date) {
    DateFormat inputFormat = DateFormat('yyyy-MM-dd');
    DateFormat outputFormat = DateFormat('MMMM dd, yyyy');
    DateTime dateTime = inputFormat.parse(date);
    return outputFormat.format(dateTime);
  }

  String formatTime(String time) {
    DateFormat inputFormat = DateFormat('HH:mm:ss');
    DateFormat outputFormat = DateFormat('HH:mm');
    DateTime dateTime = inputFormat.parse(time);
    return outputFormat.format(dateTime);
  }

/*  String TimeFormate(String date, String time) {
    DateTime dateTime = DateTime.parse("$date $time");
    String formattedTime = DateFormat.Hm().format(dateTime);
    return formattedTime;
  }*/

  Future<void> showStateDialog(EventController eventController) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select State'),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: eventController.states!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(eventController.states![index]),
                  onTap: () {
                    setState(() {
                      eventController.selectedState.value =
                          eventController.states![index];
                    });
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }


  @override
  void dispose() {
    //_expiryController.dispose();
    super.dispose();
  }

  Future<Widget> LoginPopUp(String popup_type) async {
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
                    popup_type == "login" ?
                    "please Create account/Login first" :
                    "You need to complete your personal information before continue",
                    style: TextStyle(
                        color: ThemeProvider.whiteColor, fontFamily: "Intern"),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: popup_type == "login" ?MainAxisAlignment.spaceBetween :MainAxisAlignment.center,
                  children: [
                    Container(
                      width: popup_type == "login" ?100: 180,
                      height: 35,
                      child: SubmitButton(
                        onPressed: () => {
                          Navigator.of(context).pop(),
                          if( popup_type == "login"){
                            Get.toNamed(AppRouter.getLoginRoute())
                          }else{
                          Get.toNamed(
                          AppRouter.getComplete_profile())
                          }



                        },
                        title: popup_type == "login" ? "Login" : "Complete Profile",
                      ),
                    ),
                    popup_type == "login" ?  Container(
                      width: 80,
                      height: 35,
                      child: SubmitButton(
                        onPressed: () => {Navigator.of(context).pop()},
                        title: "Cancel",
                      ),
                    ) :SizedBox.shrink(),
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

  void _validateCard(String cardNumber) {
    setState(() {
      _errorMessage = null;
      if (cardNumber.isNotEmpty) {
        bool isValid = validateCard(cardNumber);
        if (!isValid) {
          _errorMessage = 'Invalid credit card number';
        }
      }
    });
  }

  String _formatCardNumber(String input) {
    String output = '';
    for (int i = 0; i < input.length; i++) {
      if (i > 0 && i % 4 == 0) {
        output += ' ';
      }
      output += input[i];
    }
    return output;
  }

  bool validateCard(String cardNumber) {
    // Remove any whitespace from the card number
    String sanitizedCardNumber = cardNumber.replaceAll(RegExp(r'\s+\b|\b\s'), '');

    // Regular expression to match credit card number format
    RegExp cardNumberRegex = RegExp(r'^\d{13,16}$');

    // Check if the card number matches the format
    if (!cardNumberRegex.hasMatch(sanitizedCardNumber)) {
      return false;
    }

    // Checksum validation algorithm (Luhn algorithm)
    int sum = 0;
    bool alternate = false;
    for (int i = sanitizedCardNumber.length - 1; i >= 0; i--) {
      int digit = int.parse(sanitizedCardNumber[i]);

      if (alternate) {
        digit *= 2;
        if (digit > 9) {
          digit -= 9;
        }
      }

      sum += digit;
      alternate = !alternate;
    }

    return sum % 10 == 0;
  }


  String? _validateExpiry(String value, EventController eventController) {
    if (value.isEmpty || value.length != 5 || !value.contains('/')) {
      return 'Invalid formate(MM/YY)';
    }

    List<String> parts = value.split('/');
    eventController.month = int.tryParse(parts[0]);
    eventController.year = int.tryParse(parts[1]);

    if (eventController.month == null ||
        eventController.month! < 1 ||
        eventController.month! > 12) {
      return 'Invalid month';
    }
    if (eventController.year == null ||
        eventController.year! < 0 ||
        eventController.year! > 99) {
      return 'Invalid year';
    }

    return null;
  }


}

class CardMonthInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var newText = newValue.text;
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }
    var buffer = StringBuffer();
    for (int i = 0; i < newText.length; i++) {
      buffer.write(newText[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 2 == 0 && nonZeroIndex != newText.length) {
        buffer.write('/');
      }
    }
    var string = buffer.toString();
    return newValue.copyWith(
        text: string,
        selection: TextSelection.collapsed(offset: string.length));
  }
}