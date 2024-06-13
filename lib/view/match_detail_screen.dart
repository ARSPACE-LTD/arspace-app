import 'package:carousel_slider/carousel_slider.dart' as carousel ;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';


import '../backend/helper/app_router.dart';
import '../controller/match_controller.dart';
import '../controller/match_detail_controller.dart';
import '../util/all_constants.dart';
import '../util/dimens.dart';
import '../util/theme.dart';
import '../widgets/commontext.dart';
import 'connectivity_service.dart';

class MatchDetailScreen extends StatefulWidget {
  const MatchDetailScreen({super.key});

  @override
  State<MatchDetailScreen> createState() => _MatchDetailScreenState();
}

class _MatchDetailScreenState extends State<MatchDetailScreen> {

  final ConnectivityService connectivityService = Get.find();


  double screenHeight = 0;
  double screenWidth = 0;

  int current = 0;
  final carousel.CarouselController _controller = carousel.CarouselController();

  final MatchDetailController matchDetailController =
  Get.put(MatchDetailController(parser: Get.find()));

  String UUId = "";



  @override
  void initState() {
    super.initState();
    matchDetailController.initialized;

    UUId = Get.arguments[0].toString();

    print("matchDetail UUiD== $UUId");


    matchDetailController.getPerssonDetails(UUId!);

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
    final List<Widget> imageSliders = matchDetailController.imgList.map((item) =>
        Container(
          height: screenHeight,
          width: screenWidth,
          child: Image.network(
            item,
            fit: BoxFit.fill,
            width: screenWidth,
            height: screenHeight,
          ),
        )).toList();


    return GetBuilder<MatchDetailController>(builder: (value) {

      return  value.isPerson_detail_Loading == true
          ? Center(
        child: LoadingAnimationWidget.threeRotatingDots(
          color: ThemeProvider.loader_color,
          size: Dimens.loder_size,
        ),
      )
          :Scaffold(
      body: Stack(
        children: [
          Container(
            height: screenHeight,
            width: screenWidth,
            child: Stack(
                children: [
                  carousel.CarouselSlider(
                items: imageSliders,
                carouselController: _controller,
                options: carousel.CarouselOptions(
                    autoPlay: true,
                    enlargeCenterPage: false,
                    aspectRatio: 0.80,
                    viewportFraction: 1,
                    onPageChanged: (index, reason) {
                      setState(() {
                        current = index;
                      });
                    }),
              ),
              Positioned(
                top: screenHeight * .52,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: matchDetailController.imgList.asMap().entries.map((entry) {
                    return GestureDetector(
                      onTap: () => _controller.animateToPage(entry.key),
                      child: Container(
                        width: 8.0,
                        height: 8.0,
                        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:Colors.white
                                .withOpacity(current == entry.key ? 0.9 : 0.4)
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ]),
          ),
          Padding(
            padding: EdgeInsets.only(top: 50.0 , left: 15),
            child: Row(
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
          ),
          Positioned(
            top: screenHeight * .56,
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 5),
                  height: screenHeight * .44,
                  width: screenWidth,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(25),
                      topLeft: Radius.circular(25)
                    )
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: screenHeight *.04,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 14.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: CommonTextWidget(
                              heading: value.profileInfoModel.data
                                  ?.fullName !=
                                  null
                                  ? value.profileInfoModel.data
                                  ?.fullName
                                  : "Jasper 21",
                              //heading: "Jasper 21",
                              fontSize: Dimens.twentyEight,
                              color: ThemeProvider.whiteColor,
                              fontFamily: 'Poppins-Bold',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: screenHeight *.04,
                        ),
                        value.profileInfoModel.data!.interests!.length != null && value.profileInfoModel.data!.interests!.isNotEmpty ?
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 14.0),
                          child: Wrap(
                            spacing: 10.0, // Spacing between each container
                            runSpacing: 12.0, // Spacing between each row of containers
                            children: List.generate(
                              value.profileInfoModel.data!.interests!.length,
                                  (index) {
                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: ThemeProvider.text_background,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: CommonTextWidget(
                                      heading:  value.profileInfoModel.data
                                      !.interests?[index].title,

                                      fontSize: Dimens.forteen,
                                      color: ThemeProvider.whiteColor,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ) : Container(),
                        SizedBox(
                          height: screenHeight *.04,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 22.0),
                          child: CommonTextWidget(
                                                    //    heading: "Hi! I'm Hannah. I live in California. I really like fashion things like watching concerts",
                            heading: value.profileInfoModel.data
                                ?.intro !=
                                null
                                ? value.profileInfoModel.data
                                ?.intro
                                : "Hi! I'm Hannah. I live in California. I really like fashion things like watching concerts",
                            fontSize: Dimens.eighteen,
                            color: ThemeProvider.text_light_gray,
                            textAlign: TextAlign.start,

                            fontFamily: 'Intern',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(
                          height: screenHeight *.08,
                        ),

                        value.profileInfoModel.data
                            ?.room !=
                            null ?  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14.0),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(0.0),
                            elevation: 5,
                          ),
                          onPressed: (){

                            if(connectivityService.isConnected.value) {
                              Get.toNamed(AppRouter.getChatInbox(),
                                  arguments: [
                                    value.profileInfoModel.data
                                        ?.room!.uuid!,
                                    value.profileInfoModel.data
                                        ?.room!.name!,
                                    value.profileInfoModel.data
                                        ?.room!.type!,

                                  ]);
                             // Get.toNamed(AppRouter.chatList);
                            }else{
                              showToast(AppString.internet_connection);
                            }


                          },
                          child: Ink(
                            decoration: BoxDecoration(
                                gradient:  LinearGradient(
                                    colors: [ThemeProvider.buttonfirstClr, ThemeProvider.buttonSecondClr ,ThemeProvider.buttonThirdClr]),
                                borderRadius: BorderRadius.circular(50)),
                            child: Container(
                              margin: EdgeInsets.all(0),
                              width: Get.width,
                              height: 50,
                              alignment: Alignment.center,
                              child:Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add,color: ThemeProvider.whiteColor,),
                                  SizedBox(width: 4,),
                                  CommonTextWidget(
                                    heading: "Add to Chat list",
                                    fontSize: Dimens.eighteen,
                                    color: ThemeProvider.whiteColor,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "Lexend"
                                  ),
                                ],

                              )
                            ),
                          )),
                    ) : Container(),

                        SizedBox(
                          height: screenHeight *.04,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
    });

}}
