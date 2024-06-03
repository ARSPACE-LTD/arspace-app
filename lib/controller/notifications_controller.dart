
import 'package:arspace/util/all_constants.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../backend/helper/app_router.dart';
import '../backend/models/getUserProfile.dart';
import '../backend/models/notification_model.dart';
import '../backend/parser/notification_parser.dart';

class NotificationController extends GetxController{

  final NotificationParser parser;

  bool isNotification_Loading = true;

  NotificationModel fetchNotificationData = NotificationModel();


  NotificationController({required this.parser});

  Future<void> getAllNotifications() async {

    Response response = await parser.getAllNotifications();

    print("getAllNotifications body--->${response.body}");
    print("getAllNotifications body string--->${response.body.toString()}");

    if (response.statusCode == 200) {
      isNotification_Loading = false;


      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);

      if(myMap["success"] == true){
        fetchNotificationData = NotificationModel.fromJson(myMap);
        print(
            "getAllNotifications ---->${fetchNotificationData.data.toString()}");
      }else{
        showToast(myMap['error']);
      }


      update();


    }
    else if (response.statusCode == 401) {
      isNotification_Loading = false;

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
      isNotification_Loading = false;

      ApiChecker.checkApi(response);
      update();
    }
    update();
  }

  Future<void> ReadNotifications(String UUID) async {

    Response response = await parser.ReadNotifications(UUID);

    print("ReadNotifications body--->${response.body}");
    print("ReadNotifications body string--->${response.body.toString()}");

    if (response.statusCode == 200) {
      isNotification_Loading = false;

      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);

      if(myMap["success"] == true){
        print("ReadNotifications ---->${myMap.toString()}");

      }else{
        showToast(myMap['error']);
      }
      update();
    }
    else if (response.statusCode == 401) {
      isNotification_Loading = false;

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
      isNotification_Loading = false;

      ApiChecker.checkApi(response);
      update();
    }
    update();
  }



}