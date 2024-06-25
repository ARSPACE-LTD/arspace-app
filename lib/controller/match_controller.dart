import 'dart:math';

import 'package:arspace/backend/parser/match_parser.dart';
import 'package:arspace/util/all_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../backend/helper/app_router.dart';
import '../backend/models/MatchModel.dart';
import '../backend/models/profile_info_model.dart';
import '../backend/models/tickets_model.dart';
import '../util/dimens.dart';
import '../util/theme.dart';
import '../widgets/hexagon_card/HexagonCard.dart';


class MatchController extends GetxController {
  MatchParser parser;
  Set<int> selectedIndices = {0};
  int gender_selectedIndex = 0;

  MatchController({required this.parser});
  double start = 18.0;
  double end = 50.0;
  bool isTapped = false;
  bool isBottomSheetOpened = false;
  bool isMatchLoading = true;
  bool isTicketLoading = true;
  RxBool isfiltter_message = false.obs;
  RxBool islastCard = false.obs;



  MatchModel matchResponse = MatchModel();
  TicketsModel ticketResponse = TicketsModel();
  RxList<HexagonCard> cardDeck = <HexagonCard>[].obs;

  List<MatchData> getcardList = <MatchData>[];
  RxList<MatchData> cardList_data = <MatchData>[].obs;
  RxList<bool> likeList = <bool>[].obs;


  String ? currentTicketUUID ;
  RxString TicketTitle = "".obs ;
  RxInt current_Index = 0.obs;



  RxList<HexagonCard> getCardDeck() {
    cardDeck.clear();
    for (int i = 0; i < cardList_data.length; ++i) {
      // Limiting to 3 cards
      cardDeck.add(
        HexagonCard(
          imageUrl:  cardList_data[i].profilePicture != null && cardList_data[i].profilePicture!.isNotEmpty ?
          cardList_data[i].profilePicture! : "https://images.unsplash.com/source-404?fit=crop&fm=jpg&h=800&q=60&w=1200",
          name:  cardList_data[i].fullName != null && cardList_data[i].fullName!.isNotEmpty ?
          cardList_data[i].fullName! : "",
          UUId: cardList_data[i].uuid!,
          card_index: i,
          tags:  cardList_data[i].interests,

          event_id: cardList_data[i].event!.uuid!,
          child: const SizedBox(),
        ),
      );
    }
    return cardDeck;
  }

  Future<void> getPuchageTicket(BuildContext context) async {

    Response response = await parser.getPuchageTicket();

    print("ticketResponse body--->${response.body}");
    print("ticketResponse body string--->${response.body.toString()}");

    if (response.statusCode == 200) {
      isTicketLoading = false;

      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      ticketResponse = TicketsModel.fromJson(myMap);

      print("ticketResponse ---->${ticketResponse.toString()}");

      if(ticketResponse.data != null && ticketResponse.data!.isNotEmpty){

        TicketTitle.value = ticketResponse.data![0].event!.name!;
        currentTicketUUID = ticketResponse.data![0].event!.uuid;

        print("getPuchageTicket111 ---->");

        getMatches(ticketResponse.data![0].event!.uuid ,"" ,context);
      }else{
        isfiltter_message.value = false;
        islastCard.value = false;
      }
      update();
    }
    else if (response.statusCode == 401) {
      isTicketLoading = false;
      parser.ClearPrafrence();
      Get.toNamed(AppRouter.getLoginRoute(), preventDuplicates: false);

      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);

      if (myMap['auth'] == false) {
        showToast(myMap['error']);
      } else {
        if (myMap['error'] != '') {
          showToast(myMap['error']);
        } else {
          showToast('Token Expire');
        }
      }
      update();
    }
    else {
      isTicketLoading = false;
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> getMatches(String? uiid, String type, BuildContext context) async {
    current_Index.value = 0;

    var context = Get.context as BuildContext;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: LoadingAnimationWidget.threeRotatingDots(
            color: ThemeProvider.loader_color,
            size: Dimens.loder_size,
          ),
        ); // Display the custom loader
      },
    );

    String gender = "male" ;

    if(gender_selectedIndex == 0){
      gender = "male";
    }else if(gender_selectedIndex == 1){
      gender = "female";
    }else if(gender_selectedIndex == 2){
      gender = "all";
    }


    Response? response;

    if(type != "" && type == "filter"){
      print("post filter values ==== gender $gender===== start age = ${start.toInt()} ==== end age = ${end.toInt()} === selectedIndices"
          " ==${gender_selectedIndex}");
       response = await parser.getFilter(uiid! ,gender ,start.toInt() ,end.toInt());

    }else{
      response = await parser.getMatches(uiid!);
    }


    print("getMatches body string--->${response.body.toString()}");

    Navigator.of(context).pop();

    if (response.statusCode == 200) {
      //  isMatchLoading = false;


      getcardList.clear();
      cardList_data.clear();

      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      matchResponse = MatchModel.fromJson(myMap);

      //imageUrl.clear();
      if(matchResponse.data != null && matchResponse.data!.isNotEmpty){

        getcardList.addAll(matchResponse.data!);

        cardList_data.assignAll(getcardList);

        likeList.clear();

        /*if(cardList_data != null && cardList_data.isNotEmpty){

          for (int i = 0; i < cardList_data.length; i++) {
            likeList.add(cardList_data[i].liked!);
          }
        }*/
        if (cardList_data != null && cardList_data.isNotEmpty) {
          for (int i = cardList_data.length - 1; i >= 0; i--) {
            likeList.add(cardList_data[i].liked!);
          }
        }
      }else{
        if(type != "" && type == "filter"){
          isfiltter_message.value  = true;

        }else{
          isfiltter_message.value  = false;
          islastCard.value  = false;
        }

      }

      /*if (matchResponse.data != null && matchResponse.data!.isNotEmpty) {
          matchResponse.data?.forEach((data) {
            if(data.profilePicture != null && data.profilePicture!.isNotEmpty){
              imageUrl.add(data.profilePicture!);
              print("profilePicture======= ${data.profilePicture!}");
            }else {
              imageUrl.add(
                  'https://images.pexels.com/photos/712513/pexels-photo-712513.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'
                   );
            }

          });
        }*/


        getCardDeck();

        update();
        refresh();

    //  Get.toNamed(AppRouter.getDashboardScreenRoute());



    }
    else if (response.statusCode == 401) {
     // isMatchLoading = false;

      parser.ClearPrafrence();
      Get.toNamed(AppRouter.getLoginRoute(), preventDuplicates: false);

      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);

      if (myMap['auth'] == false) {
        showToast(myMap['error']);
      } else {
        if (myMap['error'] != '') {
          showToast(myMap['error']);
        } else {
          showToast('Token Expire');
        }
      }
      update();
    }
    else {
     // isMatchLoading = false;
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> LikePerson(String uuid, BuildContext context, String event_id, bool like_dislike) async {

  //  print("LikePerson person UUid--->${uuid}");

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return /*Center(
          child: LoadingAnimationWidget.threeRotatingDots(
            color: ThemeProvider.loader_color,
            size: Dimens.loder_size,
          ),
        ); */Center(
          child: Image.network(
            like_dislike == true ?
            'https://fonts.gstatic.com/s/e/notoemoji/latest/1f493/512.webp' :
            "https://fonts.gstatic.com/s/e/notoemoji/latest/1f44e_1f3fc/512.webp",
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width * 0.4,
          ),
        );
      },
    );

    var body = {
      "event_id" : event_id ,
      "status": like_dislike
    };



    Response response = await parser.LikePerson(uuid ,body);

    Navigator.of(context).pop();

    print("LikeEvents response body--->${response.body}");
    print("LikeEvents response body string--->${response.body.toString()}");

    if (response.statusCode == 200) {
     // isTapped = isTapped;

      //  isLoading=false;

      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      if (myMap['message'] != '') {
       // successToast(myMap['message']);
      }else{
        successToast(myMap['error']);

      }

     // getMatches(uuid);
      update();
    }
    else if (response.statusCode == 401) {
      parser.ClearPrafrence();
      Get.toNamed(AppRouter.getLoginRoute(), preventDuplicates: false);

      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);

      if (myMap['auth'] == false) {
        showToast(myMap['error']);
      } else {
        if (myMap['error'] != '') {
          showToast(myMap['error']);
        } else {
          showToast('Token Expire');
        }
      }
      update();
    }
    else {
      // isLoading=false;
      ApiChecker.checkApi(response);
    }
    update();
  }


  bool CheckLikeUnLike(bool like){

    if(like == true){
      isTapped = true;
    }else{
      isTapped = false;
    }

    return isTapped ;
  }


}
