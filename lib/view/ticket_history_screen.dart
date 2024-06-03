import 'package:arspace/util/theme.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../controller/home_screen_controller.dart';
import '../controller/ticket_history_controller.dart';
import '../util/all_constants.dart';
import '../util/dimens.dart';
import '../widgets/commontext.dart';
import '../widgets/container_clipper.dart';
import '../widgets/custom_divider.dart';

class TicketHistoryScreen extends StatefulWidget {
  const TicketHistoryScreen({super.key});

  @override
  State<TicketHistoryScreen> createState() => _TicketHistoryScreenState();
}

class _TicketHistoryScreenState extends State<TicketHistoryScreen> {
  double screenHeight = 0;
  double screenWidth = 0;

  final TicketHistoryController ticketHistoryController =
  Get.put(TicketHistoryController(parser: Get.find()));

  @override
  void initState() {
    super.initState();
    ticketHistoryController.initialized;
    ticketHistoryController.getHistroyTickets();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return GetBuilder<TicketHistoryController>(builder: (value) {

      return value.isTicketHistroyLoading == true
          ? Center(
        child: LoadingAnimationWidget.threeRotatingDots(
          color: ThemeProvider.loader_color,
          size: Dimens.loder_size,
        ),
      ):Scaffold(
      backgroundColor: ThemeProvider.blackColor,
      appBar: AppBar(
        backgroundColor: ThemeProvider.blackColor,
        leading: Padding(
          padding: EdgeInsets.all(5.0),
          child: InkWell(
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
        ),
        centerTitle: true,
        title:CommonTextWidget(
          heading: "History",
          fontSize: Dimens.twenty,
          color: Colors.white,
          fontFamily: 'Lexend',
          fontWeight: FontWeight.w700,
        ),
      ),
      body:value.ticketResponse.data != null &&
          value.ticketResponse.data!.isNotEmpty ?
      Column(
        children: [
          SizedBox(
            height: screenHeight * .02,
          ),
          Container(
            height: screenHeight * 0.72,
            child: Center(
              child: Swiper(
                loop: false,
                curve: Curves.easeInOut,
                itemBuilder: (context, index) {
                  return ClipPath(
                    clipper: ContainerClipper(),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: ThemeProvider.whiteColor),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Container(
                                height: screenHeight * .2,
                                width: double.maxFinite,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30),
                                      topRight: Radius.circular(30),
                                    ),
                                    image: DecorationImage(
                                        image: NetworkImage(
                                          value
                                              .ticketResponse
                                              .data?[index]
                                              .event
                                              ?.images
                                              ?.isNotEmpty ==
                                              true
                                              ? value
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
                              Positioned(

                                child: value
                                    .ticketResponse
                                    .data?[index].order!.type != null &&value
                                    .ticketResponse
                                    .data?[index].order!.type == "free" ?
                                Image(
                                  width: screenHeight * .10,
                                  height: screenHeight * .10,
                                  image: AssetImage(
                                      AssetPath
                                          .free),
                                ) : SizedBox.shrink(),
                              )
                            ],
                          ),
                          SizedBox(
                            height: screenHeight * .01,
                          ),
                          CommonTextWidget(
                            heading: value.ticketResponse
                                .data![index].event!.name!,
                            fontSize: Dimens.twentySix,
                            color: Colors.black,
                            fontFamily: 'Poppins-Bold',
                            fontWeight: FontWeight.w600,
                          ),
                          SizedBox(
                            height: screenHeight * .04,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.0),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                CommonTextWidget(
                                  heading: value.ticketResponse
                                .data![index].event!.created_at_utc != null ?
                                  timestampToString(value.ticketResponse
                                      .data![index].event!.created_at_utc! , "date") : "",
                                  fontSize: Dimens.eighteen,
                                  color: Colors.black
                                      .withOpacity(0.5),
                                  fontFamily: 'PingFang',
                                  fontWeight: FontWeight.w400,
                                ),
                                CommonTextWidget(
                                  heading: "Ticket/Seat",
                                  fontSize: Dimens.eighteen,
                                  color: Colors.black
                                      .withOpacity(0.5),
                                  fontFamily: 'PingFang',
                                  fontWeight: FontWeight.w400,
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * .01,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.0),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                CommonTextWidget(
                                  heading: value.ticketResponse
                                      .data![index].ticket!.name!,
                                  // heading: "Dec 7, 2019 23:26",
                                  fontSize: Dimens.eighteen,
                                  color: Colors.black,
                                  fontFamily: 'PingFang',
                                  fontWeight: FontWeight.w600,
                                ),
                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.end,
                                  mainAxisAlignment:
                                  MainAxisAlignment.end,
                                  children: [
                                    CommonTextWidget(
                                     /* heading: value
                                          .ticketResponse
                                          .data?[index]
                                          .orderItems
                                          ?.isNotEmpty ==
                                          true
                                          ? value
                                          .ticketResponse
                                          .data![index]
                                          .orderItems![0]
                                          .qty
                                          .toString() ??
                                          ""
                                          : "",*/
                                      heading: "1",

                                      //  heading: "General Admission",
                                      fontSize: Dimens.eighteen,
                                      color: Colors.black,
                                      fontFamily: 'PingFang',
                                      fontWeight: FontWeight.w600,
                                    ),
                                    /* CommonTextWidget(
                                      heading: "4-10pm",
                                      fontSize: Dimens.eighteen,
                                      color: Colors.black,
                                      fontFamily: 'PingFang',
                                      fontWeight: FontWeight.w600,
                                    ),*/
                                  ],
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * .04,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.0),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                CommonTextWidget(
                                  heading: "Location",
                                  fontSize: Dimens.eighteen,
                                  color: Colors.black
                                      .withOpacity(0.5),
                                  fontFamily: 'PingFang',
                                  fontWeight: FontWeight.w400,
                                ),
                                CommonTextWidget(
                                  heading: "Time",
                                  fontSize: Dimens.eighteen,
                                  color: Colors.black
                                      .withOpacity(0.5),
                                  fontFamily: 'PingFang',
                                  fontWeight: FontWeight.w400,
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * .01,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.0),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  constraints:
                                  BoxConstraints(
                                    maxWidth: MediaQuery.of(
                                        context)
                                        .size
                                        .width *
                                        0.6,
                                    // minWidth:  MediaQuery.of(context).size.width * 0.10
                                  ),
                                  child: CommonTextWidget(
                                    heading: value
                                        .ticketResponse
                                        .data![index]
                                        .event!
                                        .location !=
                                        null
                                        ? value
                                        .ticketResponse
                                        .data![index]
                                        .event!
                                        .location! +"\n"
                                        : "JIEXPO Kemayoran",
                                    //   heading: "JIEXPO Kemayoran",
                                    fontSize: Dimens.eighteen,
                                    color: Colors.black,
                                    maxLines: 2,
                                    fontFamily: 'PingFang',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                CommonTextWidget(

                                  heading:value
                                    .ticketResponse
                                    .data![index]
                                    .event!
                                    .created_at_utc != null ? timestampToString( value
                                      .ticketResponse
                                      .data![index]
                                      .event!
                                      .created_at_utc! ,"") : "",
                                  fontSize: Dimens.eighteen,
                                  color: Colors.black,
                                  fontFamily: 'PingFang',
                                  fontWeight: FontWeight.w600,
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * .035,
                          ),
                          CustomPaint(
                            size: Size(screenWidth, 1),
                            painter: DashLinePainter(),
                          ),
                          SizedBox(
                            height: screenHeight * .024,
                          ),
                          Container(
                            height: screenHeight *0.15,
                            child: QrImageView(
                              data: value
                                  .ticketResponse
                                  .data![index].uuid!,
                              version: QrVersions.auto,
                              size:  screenHeight *0.15,
                            ),)
                        ],
                      ),
                    ),
                  );
                },
                itemCount: value
                    .ticketResponse
                    .data!.length!,
                viewportFraction: 0.8,
                scale: 0.86,
              ),

            ),
          ),
        ],
      ) : Center(child:CommonTextWidget(
        heading: "History not found",
        fontSize: Dimens.twenty,
        color: Colors.white,
        fontFamily: 'Lexend',
        fontWeight: FontWeight.w700,
      ), )

    );
    });
  }

  /*String formatDate(String inputDate) {
    DateTime date = DateTime.parse(inputDate);
    String formattedDate = DateFormat('MMMM dd, yyyy').format(date);
    return formattedDate;
  }

  String TimeFormate(String date,String time ){
    DateTime dateTime = DateTime.parse("$date $time");
    String formattedTime = DateFormat.Hm().format(dateTime);
    return formattedTime;

  }*/

  String timestampToString(String timestamp, String type) {

    int timestampInt = int.parse(timestamp);

    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestampInt * 1000);

    String formattedDate ;
    if(type == "date"){
      formattedDate = DateFormat('MMMM dd, yyyy').format(dateTime);
    }else{

      formattedDate = DateFormat('HH:mm').format(dateTime);

    }

    return formattedDate;
  }
}

