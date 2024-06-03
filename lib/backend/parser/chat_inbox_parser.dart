import 'package:get/get_connect/http/src/response/response.dart';

import '../../util/constants.dart';
import '../api/api.dart';
import '../helper/shared_pref.dart';

class ChatInboxParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  ChatInboxParser({required this.sharedPreferencesManager, required this.apiService});

  Future<Response> getRoomChat(String roomId) async {
    return apiService.getPrivate(AppConstants.rooms_messages + "/$roomId",
        sharedPreferencesManager.getString('token') ?? '');
  }

  Future<Response> uploadProfil(List<MultipartBody> multipartBody) async {
    var response = await apiService.uploadFiles(
        AppConstants.upload_attachment,
        multipartBody,
        sharedPreferencesManager.getString('token') ?? '');
    return response;
  }

  Future<Response> uploadRecordingFiles(String file) async {
    var response = await apiService.uploadRecordingFiles(
        AppConstants.upload_attachment,
        file
       );
    return response;
  }


  void ClearPrafrence() {
    sharedPreferencesManager.clearAll();
  }


}