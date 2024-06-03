import 'package:arspace/util/all_constants.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../backend/helper/app_router.dart';
import '../backend/models/profile_info_model.dart';
import '../backend/parser/match_detail_parser.dart';

class MatchDetailController extends GetxController{

  final MatchDetailParser parser;
  ProfileInfoModel profileInfoModel = ProfileInfoModel();
  bool isPerson_detail_Loading = true;
  List<String> imgList = [];




  MatchDetailController({required this.parser});

  Future<void> getPerssonDetails(String uuid) async {


    Response response = await parser.getPersonInfo(uuid);

    print("getPerssonDetails response body--->${response.body}");
    print("getPerssonDetails response body string--->${response.body.toString()}");



    if (response.statusCode == 200) {
      isPerson_detail_Loading = false;

      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      profileInfoModel = ProfileInfoModel.fromJson(myMap);

      imgList.clear();
      //profileInfoModel.data!.room?.clear();

      if (profileInfoModel.data?.images != null &&
          profileInfoModel.data!.images!.isNotEmpty) {
        profileInfoModel.data?.images?.forEach((data) {
          imgList.add(data.image!);
        });
      } else {
        imgList.add(
            "https://fastly.picsum.photos/id/1024/200/300.jpg?hmac=Zf-5s5sbTMmFYhm-_rzZXktzs5i_ES8dVOzXPCS6zxU");
      }


      update();
      print("EventsDetails list ---->${profileInfoModel.toString()}");
    }
    else if (response.statusCode == 401) {
      isPerson_detail_Loading = false;
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
      isPerson_detail_Loading = false;
      ApiChecker.checkApi(response);
    }
    update();
  }


}
