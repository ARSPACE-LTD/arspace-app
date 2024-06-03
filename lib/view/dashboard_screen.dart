
import 'package:arspace/util/all_constants.dart';
import 'package:arspace/util/home_icon_icons.dart';
import 'package:arspace/view/tabs_screens/home_screen.dart';
import 'package:arspace/view/tabs_screens/match_screen.dart';
import 'package:arspace/view/tabs_screens/ticket_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:motion_tab_bar_v2/motion-tab-bar.dart';

import '../controller/dashboard_controller.dart';
import '../util/dimens.dart';
import '../util/string.dart';
import '../util/theme.dart';
import '../widgets/commontext.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  double screenHeight = 0, screenwidth = 0;
  final DashboardController dashboardController  =Get.put(DashboardController(parser: Get.find()));



  final List<Widget> _pages = [
    HomeScreen(),
    MatchScreen(),
    TicketScreen(),
  ];

  void _onItemTapped(int index, DashboardController value) {
    setState(() {
      value.selectedIndex = index;
    });
  }

  @override
  void initState() {
    dashboardController.initialized;

    dashboardController.selectedIndex = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenwidth = MediaQuery.of(context).size.width;
    return GetBuilder<DashboardController>(builder: (value) {

      return WillPopScope(
        onWillPop: () async {

          await showDialog(
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
                        "Do you want to exit the application?",
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
                          width: 80,
                          height: 35,
                          child: SubmitButton(
                            onPressed: () => {
                            SystemChannels.platform.invokeMethod('SystemNavigator.pop')
                            },
                            title: "Yes",
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
                            title: "No",
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


          return Future.value(false);
        },
        child: Scaffold(
          backgroundColor: ThemeProvider.text_background,

          body: _pages[value.selectedIndex],
          bottomNavigationBar: BottomAppBar(
            height: 60,
            color: Colors.black,
            shape: const CircularNotchedRectangle(),
            child: Container(
              color: Colors.black,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  IconButton(
                    onPressed: () => _onItemTapped(0 , value),

                    icon: Icon(HomeIcon.subtract),
                    color: value.selectedIndex == 0 ? ThemeProvider.whiteColor : ThemeProvider.text_light_gray,
                    iconSize: 20,
                    /*icon: _selectedIndex == 0
                        ? Image.asset(
                      'assets/work_filled.png', // Replace with your custom icon asset path
                      color: Colors.white,
                      width: 35,
                      height: 35,
                    )
                        : Image.asset(
                      'assets/work_outline.png', // Replace with your custom icon asset path
                      color: Colors.white,
                      width: 35,
                      height: 35,
                    ),*/
                  ),
                  IconButton(
                    onPressed: () => _onItemTapped(1 ,value),
                    icon:value.selectedIndex == 1 ?Icon( HomeIcon.match,):SizedBox(),
                    color: value.selectedIndex == 1 ? ThemeProvider.whiteColor : ThemeProvider.text_light_gray,
                    iconSize: 28,
                  ),
                  IconButton(
                    onPressed: () => _onItemTapped(2 ,value),
                    icon: Icon(HomeIcon.vector),
                    color: value.selectedIndex == 2 ?ThemeProvider.whiteColor : ThemeProvider.text_light_gray,
                    iconSize: 20,
                  ),

                ],
              ),
            ),
          ),
          floatingActionButton: value.selectedIndex == 2 || value.selectedIndex == 0
              ?  Container(
            width: 70, // Adjust width as needed
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  ThemeProvider.buttonfirstClr,
                  ThemeProvider.buttonSecondClr,
                  ThemeProvider.buttonThirdClr,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),// Adjust height as needed
            child: FloatingActionButton(
              onPressed: () {
                _onItemTapped(1 ,value);
              },
              child: Icon( HomeIcon.match,
                color: ThemeProvider.whiteColor,),
              backgroundColor: Colors.transparent,
              elevation: 6, // Adjust elevation as needed
              shape: CircleBorder(), // Make it circular
            ),
          )
              : null, // Only display FloatingActionButton when index is 2
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        ),
      );



      /* return WillPopScope(
        onWillPop: () {
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          return Future.value(false);
        },
        child: DefaultTabController

          (
          length: 3,
          child: Scaffold(
            backgroundColor: Colors.black,
            bottomNavigationBar: MotionTabBar(

              controller: value.motionTabBarController,
              // ADD THIS if you need to change your tab programmatically
              initialSelectedTab: text1,
              useSafeArea: false,
              // default: true, apply safe area wrapper
              labels: [
                'Home',
                'Match',
                'Match_detail',
              ],
              icons: const [
                HomeIcon.subtract,
                HomeIcon.match,
                HomeIcon.vector,

              ],

              tabSize: 0,
              tabBarHeight: 55,
              textStyle: const TextStyle(
                fontSize: 10,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
              tabIconColor: ThemeProvider.text_light_gray,
              tabIconSize: 22.0,
              tabIconSelectedSize: 22.0,
              tabSelectedColor:   Color.lerp(
                Color.lerp(ThemeProvider.buttonfirstClr, ThemeProvider.buttonSecondClr, 0.5)!,
                Color.lerp(ThemeProvider.buttonSecondClr, ThemeProvider.buttonThirdClr
                    , 0.5)!,
                0.5,
              )!,
              tabIconSelectedColor: Colors.white,
              tabBarColor: Colors.black,
              onTabItemSelected: (int value1) {
                setState(() {
                  // value.motionTabBarController!.index = value;
                  value.updateTabId(value1);
                });
              },
            ),

            body: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                controller: value.motionTabBarController,
                children: <Widget>[
                  HomeScreen(),
                  MatchScreen(),
                  TicketScreen(),
                ]),
          ),
        ),
      );*/

    });
  }

}
