import 'package:arspace/backend/models/logOutResponse.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../backend/api/handler.dart';
import '../backend/helper/app_router.dart';
import '../backend/models/card_model.dart';
import '../backend/models/getUserProfile.dart';
import '../backend/parser/profile_parser.dart';
import '../util/dimens.dart';
import '../util/theme.dart';
import '../util/toast.dart';

class ProfileController extends GetxController {

  final ProfileParser parser;
  GetProfileResponse getProfileResponse = GetProfileResponse();
  bool isLoading = true;
  LogOutResponse logOutResponse = LogOutResponse();

  CardsModel cardsModel = CardsModel();
  bool isCardList_Loading = true;



  ProfileController({required this.parser});




  @override
  void onInit() {
   // getUserProfileApi();
    super.onInit();
  }

  Future<void> getUserProfileApi() async {
    Response response = await parser.getUserProfile();

    print("response body--->${response.body}");
    print("response body string--->${response.body.toString()}");

    if (response.statusCode == 200) {
      isLoading=false;
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      getProfileResponse = GetProfileResponse.fromJson(myMap);
      print("UserProfileResponse ---->${getProfileResponse.message.toString()}");
    }
    else if (response.statusCode == 401) {
      isLoading = false;
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      if (myMap['auth']== false ) {
        showToast(myMap['message'.tr]);
      } else {
        showToast('Something went wrong'.tr);
      }
      update();
    }
    else {
      isLoading=false;
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> CardList(BuildContext context ) async {
    var context = Get.context as BuildContext;



    Response response = await parser.GetCards();


    print("CardList response body--->${response.body}");
    print("CardList response body string--->${response.body.toString()}");

    if (response.statusCode == 200) {
      isCardList_Loading = false;

      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      cardsModel = CardsModel.fromJson(myMap);


      update();

    }
    else if (response.statusCode == 401) {
      isCardList_Loading = false;
      parser.clearAccount();
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
      //     update();
    }
    else {
      isCardList_Loading = false;
      ApiChecker.checkApi(response);
    }
    //   update();
  }

  Future<void> DeleteCardList( String cardID ,BuildContext context ) async {
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

    Response response = await parser.DeleteCards(cardID);
    Navigator.of(context).pop();
    print("CardList response body--->${response.body}");
    print("CardList response body string--->${response.body.toString()}");

    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);

        if (myMap['success'] == true) {
        successToast(myMap['message']);
        CardList(context);
      }else{
          showToast("Card is not vaild");
        }

      update();

    }
    else if (response.statusCode == 401) {
      parser.clearAccount();
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
      //     update();
    }else if(response.statusCode == 404){
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      showToast(myMap['error']);

    } else {
      // isLoading=false;
      ApiChecker.checkApi(response);
    }
    //   update();
  }



  Future<void> logout(BuildContext context) async {
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

    Response response = await parser.logout();
    Navigator.of(context).pop();

    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      logOutResponse = LogOutResponse.fromJson(myMap);
      if (myMap['message'] != '') {
        successToast(myMap['message'.tr]);
      } else {
        showToast('Something went wrong'.tr);
      }
      print("Log Out Response --->${logOutResponse.message.toString()}");
      parser.clearAccount();
      Get.offAllNamed(AppRouter.login);
      
      update();
    }
    else {
      ApiChecker.checkApi(response);
    }
    update();
  }


}