import 'package:arspace/util/all_constants.dart';
import 'package:arspace/util/theme.dart';
import 'package:arspace/widgets/ticket_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../backend/helper/app_router.dart';
import '../backend/models/order_response.dart';
import '../controller/dashboard_controller.dart';
import '../controller/event_controller.dart';
import '../util/dimens.dart';
import '../widgets/commontext.dart';
import '../widgets/custom_divider.dart';
import 'connectivity_service.dart';

class TicketPurchased extends StatefulWidget {
  const TicketPurchased({super.key});

  @override
  State<TicketPurchased> createState() => _TicketPurchasedState();
}

class _TicketPurchasedState extends State<TicketPurchased> {
  final ConnectivityService connectivityService = Get.find();

  double screenHeight = 0;
  double screenWidth = 0;

  final DashboardController dashboardController =
  Get.put(DashboardController(parser: Get.find()));

  @override
  void initState() {
    super.initState();
    dashboardController.initialized; // Initialize the controller if needed

    OrderResponse orderResponse = OrderResponse();

    print(
        "orderResponse on TicketPurchased screen === ${orderResponse.toString()}");
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return GetBuilder<EventController>(builder: (logic) {
      return WillPopScope(
        onWillPop: () {
          Get.toNamed(AppRouter.getDashboardScreenRoute());
          return Future.value(false);
        },
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.0),
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: ThemeProvider.blackColor,
                forceMaterialTransparency: true,
                actions: [
                  InkWell(
                    onTap: (){
                      if(connectivityService.isConnected.value) {
                        Get.toNamed(AppRouter.getDashboardScreenRoute());
                      }else{
                        showToast(AppString.internet_connection);
                      }

                    },
                    child: Container(
                      margin: EdgeInsets.all(10),
                      child: CommonTextWidget(
                        textAlign: TextAlign.end,
                        heading: "Finish",
                        fontSize: Dimens.eighteen,
                        color: ThemeProvider.whiteColor,
                        fontFamily: 'Intern',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
              backgroundColor: ThemeProvider.blackColor,
              body: SingleChildScrollView(
                child: Center(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(AssetPath.purchaseSuccessful),
                        SizedBox(
                          height: screenHeight * 0.02,
                        ),
                        CommonTextWidget(
                          textAlign: TextAlign.end,
                          heading: AppString.purchase_successful,
                          fontSize: Dimens.twentySix,
                          color: ThemeProvider.whiteColor,
                          fontFamily: 'Lexend',
                          fontWeight: FontWeight.w400,
                        ),
                        SizedBox(
                          height: screenHeight * 0.02,
                        ),
                        CommonTextWidget(
                          textAlign: TextAlign.end,
                          heading: "Total Tickets ${ logic.orderResponse.data!.orderItems!.length.toString()
                              }",
                          fontSize: Dimens.sixteen,
                          color: ThemeProvider.whiteColor,
                          fontFamily: 'Lexend',
                          fontWeight: FontWeight.w400,
                        ),
                        SizedBox(
                          height: screenHeight * 0.04,
                        ),

                        Container(
                          height: screenHeight * 0.425,

                          child: Center(
                            child: Swiper(
                              curve: Curves.easeInOut,
                              loop: false,
                              itemBuilder: (context, index) {
                                return  TicketWidget(
                                  width: screenWidth * 0.90,
                                  height: screenHeight * 0.425,
                                  isCornerRounded: true,
                                  padding: EdgeInsets.only(left: 5, top: 5),
                                  child: Column(
                                    children: [
                                      Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: ThemeProvider.transparent,
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
                                                          logic
                                                              .orderResponse
                                                              ?.data
                                                              ?.event
                                                              ?.images
                                                              ?.isNotEmpty ==
                                                              true
                                                              ? logic
                                                              .orderResponse!
                                                              .data!
                                                              .event!
                                                              .images![0]
                                                              .image ??
                                                              ""
                                                              : "",
                                                        ),
                                                        fit: BoxFit.fill)),
                                              ),
                                              SizedBox(
                                                width: screenWidth * 0.02,
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    constraints:
                                                    BoxConstraints(
                                                      maxWidth: MediaQuery.of(
                                                          context)
                                                          .size
                                                          .width *
                                                          0.3,
                                                      // minWidth:  MediaQuery.of(context).size.width * 0.10
                                                    ),
                                                    padding: EdgeInsets.only(left: 2.0),
                                                    child: CommonTextWidget(
                                                      textOverflow: TextOverflow.ellipsis,
                                                      heading: logic.orderResponse.data!
                                                          .event!.title!,
                                                      fontSize: Dimens.twenty,
                                                      color: ThemeProvider.blackColor,
                                                      fontFamily: 'Lexend',
                                                      fontWeight: FontWeight.w800,
                                                    ),

                                                  ),
                                                  Container(
                                                    constraints:
                                                    BoxConstraints(
                                                      maxWidth: MediaQuery.of(
                                                          context)
                                                          .size
                                                          .width *
                                                          0.3,
                                                      // minWidth:  MediaQuery.of(context).size.width * 0.10
                                                    ),
                                                    padding: EdgeInsets.only(left: 2.0),
                                                    child: CommonTextWidget(
                                                      textOverflow: TextOverflow.ellipsis,
                                                      heading: "(" + "${logic.orderResponse.data!
                                                          .orderItems![index].ticket?.name}" +")",
                                                      fontSize: Dimens.forteen,
                                                      color: ThemeProvider.blackColor,
                                                      fontFamily: 'Lexend',
                                                      fontWeight: FontWeight.w400,
                                                    ),

                                                  ),
                                                  SizedBox(height: screenHeight * 0.02),
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      SvgPicture.asset(
                                                        AssetPath.clock,
                                                        color: ThemeProvider.blackColor,
                                                      ),
                                                      SizedBox(
                                                        width: screenWidth * 0.01,
                                                      ),
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
                                                          heading: formatDate(logic
                                                              .orderResponse
                                                              .data!
                                                              .event!
                                                              .date!) + " " + TimeFormate(logic
                                                              .orderResponse
                                                              .data!
                                                              .event!
                                                              .date! ,logic
                                                              .orderResponse
                                                              .data!
                                                              .event!
                                                              .time!),
                                                          //"Dec 7, 2019 23:26",
                                                          fontSize: Dimens.fifteen,
                                                          color: ThemeProvider.blackColor,
                                                          fontFamily: 'Intern',
                                                          textOverflow:
                                                          TextOverflow.ellipsis,
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: screenHeight * 0.01),
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      SvgPicture.asset(AssetPath.mapPoint,
                                                          height: 18,
                                                          color:
                                                          ThemeProvider.blackColor),
                                                      SizedBox(
                                                        width: screenWidth * 0.01,
                                                      ),
                                                      Container(
                                                        constraints:
                                                        BoxConstraints(
                                                          maxWidth: MediaQuery.of(
                                                              context)
                                                              .size
                                                              .width *
                                                              0.3,
                                                          // minWidth:  MediaQuery.of(context).size.width * 0.10
                                                        ),
                                                        child: CommonTextWidget(
                                                          heading: logic.orderResponse.data!
                                                              .event!.location !=
                                                              null
                                                              ? logic.orderResponse.data!
                                                              .event!.location! + "\n"
                                                              : "775 Rolling Green Rd.",
                                                          // heading: "775 Rolling Green Rd.",
                                                          fontSize: Dimens.fifteen,
                                                          maxLines: 2,
                                                          color: ThemeProvider.blackColor,
                                                          fontFamily: 'Intern',
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )),
                                      SizedBox(
                                        height: screenHeight * 0.015,
                                      ),
                                      CustomPaint(
                                        size: Size(screenWidth, 1),
                                        painter: DashLinePainter(),
                                      ),
                                      SizedBox(
                                        height: screenHeight * 0.030,
                                      ),
                                      Container(
                                        height: screenHeight *0.15,
                                        child: QrImageView(
                                         // data: logic.orderResponse.data!.uuid!,
                                          data: logic.orderResponse.data!.orderItems![index].uuid!,
                                          version: QrVersions.auto,
                                          size:  screenHeight *0.15,
                                        ),)
                                      /*SvgPicture.asset(AssetPath.q_r_code))*/
                                    ],
                                  ),
                                );
                              },
                              itemCount: logic.orderResponse.data!.orderItems!.length!,
                              viewportFraction: 0.8,
                              scale: 0.86,
                            ),
                          ),
                        ),

                        SizedBox(
                          height: screenHeight * 0.06,
                        ),
                        SubmitButton(onPressed: () {

                         if(connectivityService.isConnected.value) {
                           dashboardController.updateTab (1);
                           Get.toNamed(AppRouter.getDashboardScreenRoute());
                         }else{
                           showToast(AppString.internet_connection);
                         }




                        }, title: "Match People"),
                        SizedBox(
                          height: screenHeight * 0.02,
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                            fixedSize: MaterialStateProperty.all<Size?>(
                                Size(screenWidth, 50.0)),
                            backgroundColor:
                                MaterialStatePropertyAll(Color(0xFF2F323F)),
                          ),
                          onPressed: () {

                            if(connectivityService.isConnected.value) {
                              Get.toNamed(AppRouter.getChatInbox(),
                                  arguments: [
                                    logic.orderResponse.data!
                                        .event!.room!.uuid!,
                                    logic.orderResponse.data!
                                        .event!.room!.name!,
                                    logic.orderResponse.data!
                                        .event!.room!.type!,
                                  ]);
                            }else{
                              showToast(AppString.internet_connection);
                            }

                          },
                          child: CommonTextWidget(
                            heading: "Join The Group Chat",
                            fontSize: Dimens.eighteen,
                            color: ThemeProvider.whiteColor,
                            fontFamily: 'Lexend',
                            fontWeight: FontWeight.w400,
                          ),
                        )
                      ]),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  String formatDate(String inputDate) {
    DateTime date = DateTime.parse(inputDate);
    String formattedDate = DateFormat('MMMM dd, yyyy').format(date);
    return formattedDate;
  }

  String TimeFormate(String date,String time ){
    DateTime dateTime = DateTime.parse("$date $time");
    String formattedTime = DateFormat.Hm().format(dateTime);
    return formattedTime;

  }
}

class DashLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.1)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final dashWidth = 5;
    final dashSpace = 5;

    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }


}
