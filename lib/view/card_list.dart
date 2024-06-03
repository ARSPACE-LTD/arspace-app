import 'package:arspace/util/all_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../controller/profile_controller.dart';
import '../util/dimens.dart';
import '../util/theme.dart';
import '../widgets/commontext.dart';

class CardList extends StatefulWidget {
  const CardList({super.key});

  @override
  State<CardList> createState() => _CardListState();
}

class _CardListState extends State<CardList> {

  double screenHeight = 0;
  double screenWidth = 0;

  final ProfileController profileController =
  Get.put(ProfileController(parser: Get.find()));

  @override
  void initState() {
    profileController.initialized;
    var context = Get.context as BuildContext;
    profileController.CardList(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return GetBuilder<ProfileController>(builder: (value) {
      return value.isCardList_Loading == true
          ? Center(
        child: LoadingAnimationWidget.threeRotatingDots(
          color: ThemeProvider.loader_color,
          size: Dimens.loder_size,
        ),
      ): Scaffold(
        backgroundColor: ThemeProvider.blackColor,
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
              heading: AppString.Cards,
              fontSize: Dimens.twenty,
              color: ThemeProvider.whiteColor,
              fontFamily: 'Lexend',
              fontWeight: FontWeight.w700,
            )),

        body: value.cardsModel.data != null && value.cardsModel.data!.isNotEmpty ?
        Container(
          margin: EdgeInsets.all(10),
          child: ListView.builder(
              itemCount: value.cardsModel.data!.length!,
              itemBuilder: (BuildContext context, int index) {
                return Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.25,
                  child: GestureDetector(
                    onTap: ()
                    {
                      //    Get.toNamed(AppRouter.getchildDetailsScreenRoute() ,arguments: [value.fetchKidsData[index].deviceId,value.fetchKidsData[index].firestoreChildId]);
                    },
                    child:  Column(
                  children: [
                  GestureDetector(
                  onTap: () {
                setState(() {


              //  Navigator.of(context).pop();

                });
                },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                      color: ThemeProvider.text_background,),
                    margin: EdgeInsets.only(top:
                        10 ,left: 20 ,right: 20),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 14),
                      height: screenHeight * .08,
                      width: screenWidth,

                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image(
                                image: AssetImage(
                                    AssetPath.cardImg),
                              ),
                              SizedBox(width: 10),
                              CommonTextWidget(
                                heading: "${value.cardsModel.data![index].name}",
                                fontSize: Dimens.sixteen,
                                color: ThemeProvider.whiteColor,
                                fontFamily: 'Lexend',
                                fontWeight: FontWeight.w700,
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
                ),
                  ),
                  secondaryActions: [
                    IconSlideAction(
                      caption: 'Delete',
                      color: Colors.red,
                      icon: Icons.delete,
                      onTap: () =>
                      {
                       // value.DeleteChild(value.fetchKidsData[index].firestoreChildId! ,index),
                      value.DeleteCardList(value.cardsModel.data![index].uuid!, context)
                      },
                    ),
                  ],
                );

                /*  return InkWell(
                onTap: () => {
                  *//* Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) {
                          return DetailScreen(
                            contactDetail: _controller.contactList[index],
                          );
                        }))*//*

                },
                child: Container(
                  margin: EdgeInsets.all(10),
                  decoration:  BoxDecoration(
                    color:ThemeProvider.whiteColor,

                    borderRadius: BorderRadius.all(
                        Radius.circular(10.0)), // Set rounded corner radius
                  ),
                  child: Container(
                    padding: EdgeInsets.all(20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Container(
                              width: screenWidth * 0.8,
                              child: CommonTextWidget(
                                heading: AppString.notification_msg,
                                fontSize: Dimens.twelve,
                                color: ThemeProvider.blackColor,
                                fontFamily: 'bold',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),

                          Container(
                            alignment: Alignment.centerRight,
                            width: screenWidth * 0.2,
                            child: CommonTextWidget(
                              heading: AppString.notification_time,
                              fontSize: Dimens.ten,
                              color: ThemeProvider.greyColor,
                              fontFamily: 'bold',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      )),
                )
            );*/
              }),
        ): Container(child: Center(
          child: Icon(
            Icons.credit_card, // Replace this with the desired icon
            color: Colors.white,
            size: 150,// Adjust the color as needed
          ),

        )

        ),
      );
    });

  }
}
