
import 'package:arspace/util/all_constants.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../backend/helper/app_router.dart';
import '../backend/models/events_model.dart';
import '../backend/models/getUserProfile.dart';
import '../backend/models/home_events.dart';
import '../backend/models/notification_model.dart';
import '../backend/models/tickets_model.dart';
import '../backend/parser/home_screen_parser.dart';
import '../util/theme.dart';

class HomeScreenController extends GetxController {

  final HomeScreenParser parser;
  GetProfileResponse getProfileResponse = GetProfileResponse();
  NotificationModel fetchNotificationData = NotificationModel();
  RxList<NotificationData> NotificationList = <NotificationData>[].obs;


  HomeEvents geteventResponse = HomeEvents();

  String currentAddress = "";
  double myLat = 51.509865;
  double myLng = -0.118092;

  bool isConfirmed = false;
  bool isFetchingLocation = true;
  RxString notificationCount = "".obs;


  HomeScreenController({required this.parser});

  int imageIndex = 0;
  bool isLoading = true;


  @override
  void onInit() {
    super.onInit();
  /*  getUserProfileApi();
    getEvents();*/

    WidgetsBinding.instance.addPostFrameCallback((_) {

      if(parser.sharedPreferencesManager.getString("address") == null
          || parser.sharedPreferencesManager.getString("address")!.isEmpty){

        getLocation();
      }

    });


    /*if(parser.sharedPreferencesManager.getString("address") != null
        || parser.sharedPreferencesManager.getString("address")!.isNotEmpty){

      currentAddress = parser.sharedPreferencesManager.getString("shortAddress")!;

    }else{

    }*/

  }

  changeIndex(int index) {
    imageIndex = index;
    update();
  }

  Future<void> getEvents() async {


    Response response = await parser.getEvents();

    print("Event response body--->${response.body}");
    print("Events response body string--->${response.body.toString()}");

    if (response.statusCode == 200) {
      isLoading = false;

      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      geteventResponse = HomeEvents.fromJson(myMap);
      update();
      print("geteventResponse ---->${geteventResponse.toString()}");
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

  Future<void> getUserProfileApi() async {
    Response response = await parser.getUserProfile();

    print("response body--->${response.body}");
    print("response body string--->${response.body.toString()}");

    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      getProfileResponse = GetProfileResponse.fromJson(myMap);

      parser.isProfileActive(getProfileResponse.data!.isProfileSetup!);


      print(
          "UserProfileResponse ---->${getProfileResponse.message.toString()}");
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
      ApiChecker.checkApi(response);
    }
    update();
  }


  Future<void> getAllNotifications() async {
    if(fetchNotificationData.data != null){
      fetchNotificationData.data!.clear();
    }

    NotificationList.clear();
    notificationCount.value = "";

    Response response = await parser.getAllNotifications();

    print("getAllNotifications body--->${response.body}");
    print("getAllNotifications body string--->${response.body.toString()}");

    if (response.statusCode == 200) {


      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);

      if(myMap["success"] == true){
        fetchNotificationData = NotificationModel.fromJson(myMap);

        if(fetchNotificationData.data != null){
          notificationCount.value = fetchNotificationData.data!.length.toString();


         // cardList.clear();

          NotificationList.addAll(fetchNotificationData.data!);

        }


        print(
            "getAllNotifications ---->${fetchNotificationData.data.toString()}");
      }else{
        //showToast(myMap['error']);
      }
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

      ApiChecker.checkApi(response);
      update();
    }
    update();
  }




  void getLocation() async {
    isFetchingLocation = true;
    _determinePosition().then((value) async {
      isFetchingLocation = false;
      debugPrint(value.toString());
      List<Placemark> newPlace = await placemarkFromCoordinates(value.latitude, value.longitude);
      Placemark placeMark = newPlace[0];
      String name = placeMark.name.toString();
      String subLocality = placeMark.subLocality.toString();
      String locality = placeMark.locality.toString();
      String administrativeArea = placeMark.administrativeArea.toString();
      String postalCode = placeMark.postalCode.toString();
      String country = placeMark.country.toString();
      String full_address = "$name,$subLocality,$locality,$administrativeArea,$postalCode,$country";
      String address = "$subLocality,$administrativeArea";
      print("name == $name , subLocality== $subLocality , administrativeArea== $administrativeArea , postalCode===$postalCode ,country==  $country");
      currentAddress = address;
      update();
      print("CurrentAddress--> $currentAddress");
      debugPrint(address);
      parser.saveLatLng(value.latitude, value.longitude, address ,address);
      print("latlng--->${value.latitude}${value.longitude}");

      if(parser.CheckToken() != null && parser.CheckToken().isNotEmpty){
        UpDateLocation();
      }



    }).catchError((error) async {
      Get.back();
      showToast(error.toString());
      await Geolocator.openLocationSettings();
    });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.'.tr);
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied'.tr);
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.'
              .tr);
    }
    return await Geolocator.getCurrentPosition();
  }


  Future<void> UpDateLocation() async {
    var body = {
      // "email": countryCodeController.text,
      "location": parser.sharedPreferencesManager.getString("address")?? '',
      "latitude":parser.sharedPreferencesManager.getDouble("lat")?? 0.0,
      "longitude":parser.sharedPreferencesManager.getDouble("lng")?? 0.0,
    };

    Response response = await parser.PutLocation(body);

    print("UpDateLocation body--->${response.body}");
    if (response.statusCode == 200) {

      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      print("UpDateLocation ---->${myMap.toString()}");

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
      ApiChecker.checkApi(response);
    }
    update();
  }
}