import 'package:arspace/controller/view_ticket_controller.dart';
import 'package:arspace/util/all_constants.dart';
import 'package:arspace/util/theme.dart';
import 'package:arspace/widgets/commontext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../util/app_assets.dart';
import '../util/dimens.dart';

class ViewTicket extends StatefulWidget {
  const ViewTicket({super.key});

  @override
  State<ViewTicket> createState() => _ViewTicketState();
}

class _ViewTicketState extends State<ViewTicket> {
  double screenHeight = 0;
  double screenWidth = 0;

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
    return GetBuilder<ViewTicketController>(builder: (logic) {
      return SafeArea(
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
                SizedBox(
                  height: screenHeight * .01,
                ),
                logic.isTicketPurchased == false
                ?Image(
                  image: AssetImage(
                      AssetPath.view_ticket1
                  ),
                  height: screenHeight * 0.4,
                )
                :Image(
                  image: AssetImage(
                      AssetPath.complete_profile
                  ),
                  height: screenHeight * 0.4,
                ),
                SizedBox(
                  height: screenHeight * .01,
                ),
                CommonTextWidget(
                  textAlign: TextAlign.center,
                  heading: logic.isTicketPurchased == false
                  ?"You can’t match if you haven’t purchased a ticket."
                  :"You need to complete your personal information before matchingYou need to complete your personal information before matching",
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
                      fixedSize: Size(screenWidth * .4, 52)
                  ),

                  onPressed: () {}, child:
                Center(
                  child: CommonTextWidget(
                    heading: logic.isTicketPurchased == false
                    ?"View Ticket"
                    :"Complete Profile",
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
}
