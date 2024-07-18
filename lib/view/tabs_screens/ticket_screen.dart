import 'package:arspace/backend/helper/app_router.dart';
import 'package:arspace/util/all_constants.dart';
import 'package:arspace/util/theme.dart';
import 'package:arspace/view/ticket_history_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../controller/dashboard_controller.dart';
import '../../controller/home_screen_controller.dart';
import '../../controller/view_ticket_controller.dart';
import '../../util/app_assets.dart';
import '../../util/dimens.dart';
import '../../util/string.dart';
import '../../widgets/commontext.dart';
import '../../widgets/container_clipper.dart';
import '../../widgets/custom_divider.dart';
import '../../widgets/ticket_widget.dart';
import '../connectivity_service.dart';

class TicketScreen extends StatefulWidget {
  const TicketScreen({super.key});

  @override
  State<TicketScreen> createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  final ConnectivityService connectivityService = Get.find();

  double screenHeight = 0;
  double screenWidth = 0;
  bool isTicket = false;

  final ViewTicketController viewTicketController =
      Get.put(ViewTicketController(parser: Get.find()));

  final DashboardController dashboardController =
  Get.put(DashboardController(parser: Get.find()));

  @override
  void initState() {
    super.initState();
    viewTicketController.initialized; // Initialize the controller if needed
    dashboardController.initialized; // Initialize the controller if needed

    if(viewTicketController.parser.CheckToken() != null && viewTicketController.parser.CheckToken().isNotEmpty ){
      viewTicketController.getTickets();
    }else{
      viewTicketController.isTicketLoading == false;
    }

  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return GetBuilder<ViewTicketController>(builder: (value) {
      return  Scaffold(
              backgroundColor: ThemeProvider.blackColor,
              appBar: AppBar(
                leadingWidth: screenWidth,
                backgroundColor: ThemeProvider.blackColor,
                forceMaterialTransparency: true,
                leading: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CommonTextWidget(
                        heading: "My Ticket",
                        fontSize: Dimens.thirtyTwo,
                        color: Colors.white,
                        fontFamily: 'Poppins-Bold',
                        fontWeight: FontWeight.w700,
                      ),
                      InkWell(
                        onTap: () {

                          if(value.parser.CheckToken() != null && value.parser.CheckToken().isNotEmpty){
                            connectivityService.isConnected.value
                                ? Get.toNamed(AppRouter.ticketHistory)
                                : showToast(AppString.internet_connection);
                          }else{

                            LoginPopUp();
                          }
                        },
                        child: CommonTextWidget(
                          heading: "History",
                          fontSize: Dimens.eighteen,
                          color: Colors.white,
                          fontFamily: 'Intern',
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              body: value.ticketResponse.data != null &&
                      value.ticketResponse.data!.isNotEmpty
                  ? Column(
                children: [
                  SizedBox(
                    height: screenHeight * .02,
                  ),
                  Container(
                    height: screenHeight * 0.72,
                    child: Center(
                      child: Swiper(
                        curve: Curves.easeInOut,
                        loop: false,
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
                                                fit: BoxFit.fill)
                                        ),
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
                                          heading: value
                                        .ticketResponse
                                        .data![index]
                                        .event!
                                        .created_at_utc != null ? timestampToString( value
                                              .ticketResponse
                                              .data![index]
                                              .event!
                                              .created_at_utc! , "date") :"",

                                         /* formatDate(value.ticketResponse
                                              .data![index].event!.date!) + " " + TimeFormate(value
                                              .ticketResponse
                                              .data![index]
                                              .event!
                                              .date!, value
                                              .ticketResponse
                                              .data![index]
                                              .event!
                                              .time!,),*/
                                          fontSize: Dimens.forteen,
                                          color: Colors.black
                                              .withOpacity(0.5),
                                          fontFamily: 'PingFang',
                                          fontWeight: FontWeight.w400,
                                        ),
                                        CommonTextWidget(
                                          heading: "Ticket/Seat",
                                          fontSize: Dimens.forteen,
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
                                            /*  heading: value
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
                                                : "",
                                            //   heading: "JIEXPO Kemayoran",
                                            fontSize: Dimens.eighteen,
                                            maxLines: 2,
                                            textOverflow: TextOverflow.ellipsis,

                                            color: Colors.black,
                                            fontFamily: 'PingFang',
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        CommonTextWidget(

                                          heading: value
                                              .ticketResponse
                                              .data![index]
                                              .event!
                                              .time != null ? formatTime(
                                              value
                                              .ticketResponse
                                              .data![index]
                                              .event!
                                              .time!) : "",
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
              )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        /*SizedBox(
            height: screenHeight * .01,
          ),*/
                        Center(
                          child: Image(
                            image: AssetImage(AssetPath.view_ticket1),
                            height: screenHeight * 0.28,
                          ),
                        ),
                        SizedBox(
                          height: screenHeight * .01,
                        ),
                        CommonTextWidget(
                          textAlign: TextAlign.center,
                          heading: "You dont have any ticket",
                          fontSize: Dimens.sixteen,
                          color: ThemeProvider.whiteColor,
                          fontFamily: 'Intern',
                          fontWeight: FontWeight.w400,
                        ),
                        SizedBox(
                          height: screenHeight * .03,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(0.0),
                              elevation: 5,
                              backgroundColor: ThemeProvider.matchButtonColor,
                              fixedSize: Size(screenWidth * .4, 52)),
                          onPressed: () {

                         //   Get.toNamed(AppRouter.getDashboardScreenRoute());
                            dashboardController.updateTab (0);
                          },
                          child: Center(
                            child: CommonTextWidget(
                              heading: "View Event",
                              fontSize: Dimens.twenty,
                              color: ThemeProvider.whiteColor,
                              fontFamily: 'Intern',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ) ,
                        SizedBox(
                          height: screenHeight * .050,
                        ),
                      ],
                    ));
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

  String formatTime(String time) {
    DateFormat inputFormat = DateFormat('HH:mm:ss');
    DateFormat outputFormat = DateFormat('HH:mm');
    DateTime dateTime = inputFormat.parse(time);
    return outputFormat.format(dateTime);
  }

  Future<Widget> LoginPopUp() async {
    return  await showDialog(
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
                      width: 100,
                      height: 35,
                      child: SubmitButton(
                        onPressed: () => {
                          Navigator.of(context)
                              .pop(),
                          Get.toNamed(AppRouter.getLoginRoute())

                        },
                        title: "Login",
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
}
