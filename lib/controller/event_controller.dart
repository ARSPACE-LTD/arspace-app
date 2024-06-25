import 'dart:convert';

import 'package:arspace/util/all_constants.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';

import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../backend/helper/app_router.dart';
import '../backend/models/card_data.dart';
import '../backend/models/card_model.dart';
import '../backend/models/create_card_response.dart';
import '../backend/models/events_model.dart';
import '../backend/models/order_response.dart';
import '../backend/parser/event_parser.dart';
import '../util/dimens.dart';
import '../util/theme.dart';
import 'package:http/http.dart' as http;


class EventController extends GetxController {
  final EventParser parser;

  bool isCheckOut = true;
  bool isPayemt = true;
  Set<int> selectedIndices = {};

  // Set<int> selectedIndices = {};
  int quatity = 0;
  bool isSelectTier = false;
  bool isSelectAdd = false;
  bool isSelectsub = false;


  int tickect_index = 0;


  // Track the indices of the selected containers
  bool isBottomSheetOpen = false;
  
  int selectedIndex = -1;
  int itemCount = 0;
  bool isFavorite = false;

  bool isCardAdded = false;

  void toggleBottomSheet() {
    isBottomSheetOpen = !isBottomSheetOpen;
    update();
  }

  EventController({required this.parser});

  ScrollController scrollController = ScrollController();

  EventsModel geteventInfo = EventsModel();

  CardsModel cardsModel = CardsModel();
   RxList<CardDataList> cardList = <CardDataList>[].obs;
   List<CardDataList> getcardList = <CardDataList>[];

  CreateCardResponse create_cardsModel = CreateCardResponse();
  OrderResponse orderResponse = OrderResponse();

  List<String> imgList = [];

  String? UUId;
  String? selectCardpaymentToken;
  String?item_ticket_id;
  RxString selectCardpaymentName = "".obs;

  bool isLoading = true;

  TextEditingController creditCardNumber = TextEditingController();
  TextEditingController monthYearController = TextEditingController();
  TextEditingController cvvController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController streetAddressController = TextEditingController();
  TextEditingController adressController = TextEditingController();

  int? month ;
  int? year ;

  static String secret_key = 'sk_test_51Oc3GII7EzDgVa3Htp1SK7xhXnavCF5VZyvMYtqWU3yxnlw3KxWtiHvhqtwiNprFyfykTqLpkXyj7V3BPaMUTwVM00shvSsEGr';
  static String STRIPE_PUBLISHABLE_KEY = 'pk_test_51Oc3GII7EzDgVa3Ho0JqtnrOr83AeT7s1MqR7ms3fed3Cv8kSFM4tWNIJET69IEbfYJZGqFsZJq4EZApPCjXm5wD00abojyqMG';


  RxString selectedCountry = "".obs;
  RxString selectedState = "".obs;
 // String? selectedState;
  List<String>? states;

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();



  @override
  void onInit() {
    super.onInit();

     isSelectTier = false;
     isSelectAdd = false;
     isSelectsub = false;

    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        // SliverAppBar is expanded
        print("SliverAppBar is expanded");
      } else {
        // SliverAppBar is collapsed
        print("SliverAppBar is collapsed");
      }
    });

   // CardList();

    /* getEventsDetails(UUId!);*/

  }

  Future<void> loadStates(String countryCode) async {
    String data = await rootBundle.loadString('asassets/countries_and_states.jsosets/countries_and_states.json');
    List<dynamic> countries = json.decode(data)['countries'];

    for (var countryData in countries) {
      if (countryData['name'] == countryCode) {
        List<dynamic> statesData = countryData['states'];
        states = statesData.map<String>((state) => state['name'].toString()).toList();
        break;
      }
    }
    update();
  }

  void ShowCountryPicker(BuildContext context) {
    showCountryPicker(
      context: context,
      showPhoneCode: false,
      countryFilter: ['US', 'CA', 'IN', 'CN'],
      onSelect: (Country country) {

          selectedCountry.value = country.name;
          loadStates(selectedCountry.value);
          //selectedState = null; // Reset selected state when country changes
        update();

      },
    );
  }

  String TotalPrice(String ? price , int service_charge) {
    double total_price = double.parse(price!) * quatity;
    total_price = total_price + service_charge;
    return total_price.toString();
  }

  Future<void> getEventsDetails(String uuid) async {


    Response response = await parser.getEventsInfo(uuid);

    print("EventsDetails response body--->${response.body}");
    print("EventsDetails response body string--->${response.body.toString()}");

    if (response.statusCode == 200) {
      isLoading = false;

      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      geteventInfo = EventsModel.fromJson(myMap);

      imgList.clear();

      if (geteventInfo.data?.images != null &&
          geteventInfo.data!.images!.isNotEmpty) {
        geteventInfo.data?.images?.forEach((data) {
          imgList.add(data.image!);
        });
      } else {
        imgList.add(
            "https://fastly.picsum.photos/id/1024/200/300.jpg?hmac=Zf-5s5sbTMmFYhm-_rzZXktzs5i_ES8dVOzXPCS6zxU");
      }


      update();
      print("EventsDetails list ---->${geteventInfo.toString()}");
    }
    else if (response.statusCode == 401) {
      isLoading = false;
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
      isLoading = false;
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> LikeEvent(String uuid, BuildContext context) async {

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


    Response response = await parser.LikeEvents(uuid);

    Navigator.of(context).pop();

    print("LikeEvents response body--->${response.body}");
    print("LikeEvents response body string--->${response.body.toString()}");

    if (response.statusCode == 200) {
      //  isLoading=false;

      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      if (myMap['message'] != '') {
        successToast(myMap['message']);
      }

      getEventsDetails(uuid);
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

  Future<void> CardList(BuildContext context, String call_type ) async {



    if(call_type == "new"){
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
    }


    Response response = await parser.GetCards();
    if(call_type == "new"){
      var context = Get.context as BuildContext;
      Navigator.of(context).pop();
    }

  //  Get.back();

    print("LikeEvents response body--->${response.body}");
    print("LikeEvents response body string--->${response.body.toString()}");

    if (response.statusCode == 200) {
      //  isLoading=false;
      getcardList.clear();
      cardList.clear();

      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      cardsModel = CardsModel.fromJson(myMap);

      getcardList.addAll(cardsModel.data!);

      cardList.assignAll(getcardList);
    /*  if (myMap['message'] != '') {
        successToast(myMap['message']);
      }
*/
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
 //     update();
    }
    else {
      // isLoading=false;
      ApiChecker.checkApi(response);
    }
 //   update();
  }


  Future<void> createToken(BuildContext context) async {

    try {
      // Your Stripe publishable key
      final String publishableKey = 'pk_test_51Oc3GII7EzDgVa3Ho0JqtnrOr83AeT7s1MqR7ms3fed3Cv8kSFM4tWNIJET69IEbfYJZGqFsZJq4EZApPCjXm5wD00abojyqMG';

      final Map<String, dynamic> cardData = {
        'card[number]': '${creditCardNumber.text.toString()}',
        'card[exp_month]': '$month',
        'card[exp_year]': '$year',
        'card[cvc]': '${cvvController.text.toString()}',
      };

      // Encode the card data
      final body = cardData.entries.map((e) => '${e.key}=${e.value}').join('&');

      // Send a request to Stripe API to create a token
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



      final http.Response response = await http.post(
        Uri.parse('https://api.stripe.com/v1/tokens'),
        headers: <String, String>{
          'Authorization': 'Bearer $publishableKey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body,
      );

      // Check if the request was successful
      if (response.statusCode == 200) {
        Navigator.of(context).pop();
        // Parse the response body
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        // Retrieve the token ID
        final String tokenId = responseData['id'];
        print('Card Token: $tokenId');
        print('Card Token create susss: $tokenId');
        successToast("please wait...");

        CreateCard(tokenId ,context);
      } else {
        Navigator.of(context).pop();
        print('Error creating token: ${response.body}');
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        showToast(responseData['error']['message']);
        // Print error message if request failed

      }
    } catch (e) {
      Get.back();
      print('Error creating token: $e');
    }
  }

  Future<void> CreateCard(String tokenId, BuildContext context ) async {
    var body = {
      // "email": countryCodeController.text,
      "name": firstNameController.text.toString() + " "+ lastNameController.text.toString(),
      "card_token":tokenId,
    };


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

    var response = await parser.CreateCards(body);
    Navigator.of(context).pop();

    print("CreateCard response body--->${response.body}");
    print("CreateCard response body string--->${response.body.toString()}");

    if (response.statusCode == 200) {
      //  isLoading=false;

       creditCardNumber.clear();
       monthYearController.clear();
       cvvController.clear();
       firstNameController.clear();
       lastNameController.clear();
       streetAddressController.clear();
       adressController.clear();


      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      create_cardsModel = CreateCardResponse.fromJson(myMap);

      if (myMap['message'] != '') {
        successToast(myMap['message']);

      }
       CardList(context , "new");
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


  Future<void> CreateOrder(String tokenId, BuildContext context ) async {

    var orderBody = {
      "event":tokenId,
      "card_token":selectCardpaymentToken,
      "ticket_id":item_ticket_id,
      "qty":quatity
     /* "items":[
        {

        }
      ]*/
    };

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

    var response = await parser.CreateOrder(orderBody);
    Get.back();

    print("CreateOrder response body--->${response.body}");
    print("CreateOrder response body string--->${response.body.toString()}");

    if (response.statusCode == 200) {
      //  isLoading=false;

      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      orderResponse = OrderResponse.fromJson(myMap);

      if (myMap['message'] != '') {
        successToast(myMap['message']);

      }
      //CardList(context);
      update();

      Navigator.of(context).popUntil((route) => route.isActive!);

      Get.toNamed(AppRouter.ticketPurchased);
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



}

