import 'dart:convert';
import 'dart:io';

import 'package:arspace/util/all_constants.dart';
import 'package:arspace/util/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../backend/api/api.dart';
import '../backend/api/handler.dart';
import '../backend/helper/app_router.dart';
import '../backend/models/chat_box_model.dart';
import '../backend/parser/chat_inbox_parser.dart';
import '../util/dimens.dart';
import '../util/toast.dart';

class ChatInboxController extends GetxController{

  final ChatInboxParser parser;
  final messageController = TextEditingController();

  bool isChatBox_Loading = true;

  ChatBoxModel chatBoxModel_data = ChatBoxModel();

  RxList<ChatBoxModelData> roomChatList = <ChatBoxModelData>[].obs;
  String attached_image = "";






  ChatInboxController({required this.parser});

  Future<void> getRoomMessage(String roomId) async {

    Response response = await parser.getRoomChat(roomId);

    print("getRoomMessage body--->${response.body}");
    print("getRoomMessage body string--->${response.body.toString()}");

    if (response.statusCode == 200) {
      isChatBox_Loading = false;

      roomChatList.clear();

      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);

      if(myMap["success"] == true){
        chatBoxModel_data = ChatBoxModel.fromJson(myMap);
        print("chatBoxModel_data ---->${chatBoxModel_data.data.toString()}");

        if(chatBoxModel_data.data != null && chatBoxModel_data.data!.isNotEmpty){
          roomChatList.addAll(chatBoxModel_data.data!.reversed);
        }


        print("roomChatList ---->${roomChatList.toString()}");

      }else{
        showToast(myMap['error']);
      }

      update();

    }
    else if (response.statusCode == 401) {
      isChatBox_Loading = false;

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
      isChatBox_Loading = false;

      ApiChecker.checkApi(response);
      update();
    }
    update();
  }





  String getUUID(){
    return parser.sharedPreferencesManager.getString('UUID') ?? '';
  }







  Future<void> UploadImage(  XFile? selectedImage, String mainfilePath ,String type, BuildContext context  ) async {

    if(type== "image"){
      if (selectedImage == null || selectedImage == "") {
        showToast('Please select image');
        return;
      }
    }


    // String finalNumber = countryCodeController.text + mobileNumberController.text;
    var multipartBody;
    if(type== "image"){
       multipartBody = [
        MultipartBody('attachment', selectedImage as XFile),
      ];
    }

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

    var response;
    if(type== "recorder"){
      response = await parser.uploadRecordingFiles(mainfilePath);
    }else{
      response = await parser.uploadProfil(multipartBody);
    }

    Get.back();

    print("UploadImage body--->${response.body}");
    print("UploadImage body string--->${response.body.toString()}");

    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      if (myMap['success'] == true) {

         attached_image = myMap['data'];
     //   AddDataInChat(myMap['data']);

      }} else if (response.statusCode == 401) {
        showToast('Something went wrong while signup');
        update();
      } else if (response.statusCode == 404) {
        Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
        showToast(myMap['error']);
        update();
      } else if (response.statusCode == 500) {
        Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
        if (myMap['message'] != '') {
          showToast(myMap['message']);
        } else {
          showToast('Something went wrong');
        }
        update();
      } else {
        ApiChecker.checkApi(response);
        update();
      }
      update();
    }


  }



