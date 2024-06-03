import 'package:arspace/backend/models/InterestsModel.dart';
import 'package:get/get_connect/http/src/response/response.dart';

import '../../util/constants.dart';
import '../api/api.dart';
import '../helper/shared_pref.dart';

class CompleteProfileParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  CompleteProfileParser(
      {required this.sharedPreferencesManager, required this.apiService});

  Future<Response> completeProfile_api(
      Map<String, dynamic> textData, List<MultipartBody> multipartBody) async {
    var response = await apiService.MultipartBodyStringAndImage(
        AppConstants.completeProfile_api,
        multipartBody,
        textData,
      sharedPreferencesManager.getString('token') ?? '');
    return response;
  }

  Future<Response> getInterst_api() async {
    var response =
        await apiService.getPublic(AppConstants.getInterst_api + "?limit=50");
    return response;
  }

  Future<String?> token() async {
    return await sharedPreferencesManager.getString('token');
  }


  Future<Response> getUserProfile() async {
    return apiService.getPrivate(AppConstants.get_user_profile_api,
        sharedPreferencesManager.getString('token') ?? '');
  }

  Future<Response> DeleteUserImage(String ImageUUid) async {
    return apiService.deletePrivate(AppConstants.delete_image + "/$ImageUUid",
        sharedPreferencesManager.getString('token') ?? '');
  }

}
