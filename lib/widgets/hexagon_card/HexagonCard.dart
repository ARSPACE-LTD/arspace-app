import 'package:arspace/backend/models/MatchModel.dart';
import 'package:arspace/util/all_constants.dart';
import 'package:flutter/material.dart';

import '../../backend/helper/app_router.dart';
import '../../util/dimens.dart';
import '../../util/theme.dart';

import '../commontext.dart';
import 'HexagonClipper.dart';

class HexagonCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String UUId;
  final String event_id;
  final int card_index;
  final Widget child;
  final List<Interests>? tags ;

  const HexagonCard({
    required this.imageUrl,
    required this.child,
    required this.name,
    required this.UUId,
    required this.event_id,
    required this.card_index,
    required this. tags,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Get.toNamed(AppRouter.getMatchDetails() ,arguments: [UUId]);

        //Get.toNamed(AppRouter.getMatchDetails() ,arguments: UUId);

        // Get.toNamed(AppRouter.getMatchDetails());
      },
      child: Container(
        height: Get.height * .50 ,
        child: Stack(
          children: [
            //SizedBox(height: 40),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /*tags != null
                    ?  Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.only(left: 20 ,right: 20),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: tags!.length,

                    itemBuilder: (BuildContext context, int index) => Wrap(
                      spacing: 8.0,
                      // Set spacing between items horizontally
                      runSpacing: 8.0,
                      // Set spacing between items vertically
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.circular(
                                  50),
                              color: ThemeProvider
                                  .whiteColor
                                  .withOpacity(
                                  0.15),),
                          margin: EdgeInsets.only(left: 10 ,right: 10),

                          child: Padding(
                            padding: const EdgeInsets.all(
                                15.0),
                            child: CommonTextWidget(
                              heading: tags![index].title!,
                              fontSize: Dimens.forteen,
                              color: ThemeProvider
                                  .whiteColor,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        )


                      ],
                    ),
                  ),)*/

                /* Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    spacing: 8.0,
                    // Set spacing between items horizontally
                    runSpacing: 8.0,
                    // Set spacing between items vertically
                    children: [
                      ...tags!.map((item) {
                        return Container(
                          decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.circular(
                                  50),
                              color: ThemeProvider
                                  .text_background),
                          child: Padding(
                            padding: const EdgeInsets.all(
                                15.0),
                            child: CommonTextWidget(
                              heading: item.title!,
                              fontSize: Dimens.forteen,
                              color: ThemeProvider
                                  .whiteColor,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        );
                      }),

                    ],
                  ),
                )*/ /*: SizedBox.shrink(),*/
                Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius:
                    BorderRadius.circular(
                        20),
                  ),
                  child:  Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    width: Get.width * .7 , // Adjust as needed
                    height: Get.height * .50 , // Adjust as needed
                  ),
                  //   color: Colors.blue,
                ),
              ],
            ),




            /*  ClipPath(
              clipper: HexagonClipper(),
              child: Image.network(
                imageUrl,
                fit: BoxFit.fill,
                width: Get.width * .8 , // Adjust as needed
                height: Get.height * .48 , // Adjust as needed
              ),
            ),*/

            Positioned(

              bottom: Get.height * .070,

              child: Container(
                width: Get.width * .7 , // Adjust as needed
                alignment: Alignment.center,
                child: CommonTextWidget(
                  heading: name,
                  fontSize: Dimens.twenty,
                  color: ThemeProvider.whiteColor,
                  fontFamily: 'Lexend',
                  fontWeight: FontWeight.w500,
                ),
              ),
            )

          ],
        ),
      ),
    );
  }
}
