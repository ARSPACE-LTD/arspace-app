import 'package:arspace/backend/parser/chat_list_parser.dart';
import 'package:arspace/util/all_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../backend/helper/app_router.dart';
import '../backend/models/chat_list_model.dart';
import '../backend/parser/match_detail_parser.dart';
import '../util/toast.dart';

class ChatListController extends GetxController{

  final ChatListParser parser;

  final searchController = TextEditingController();

  bool isChatList_Loading = true;

  ChatListModel fetchChatListData = ChatListModel();

  ChatListController({required this.parser});

  Future<void> getAllChatList() async {

    Response response = await parser.getSearchChatList(searchController.text.toString());

    print("ChatListModel body--->${response.body}");
    print("ChatListModel body string--->${response.body.toString()}");

    if (response.statusCode == 200) {
      isChatList_Loading = false;


      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);

      if(myMap["success"] == true){
        fetchChatListData = ChatListModel.fromJson(myMap);
        print(
            "ChatListModel ---->${fetchChatListData.data.toString()}");
      }else{
        showToast(myMap['error']);
      }


      update();


    }
    else if (response.statusCode == 401) {
      isChatList_Loading = false;

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
      isChatList_Loading = false;

      ApiChecker.checkApi(response);
      update();
    }
    update();
  }

  String getUUID(){
    return parser.sharedPreferencesManager.getString('UUID') ?? '';
  }


}
