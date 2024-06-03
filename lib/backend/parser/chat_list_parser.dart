
import 'package:get/get_connect/http/src/response/response.dart';

import '../../util/constants.dart';
import '../api/api.dart';
import '../helper/shared_pref.dart';

class ChatListParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  ChatListParser({required this.sharedPreferencesManager, required this.apiService});



  Future<Response> getAllChatList() async {
    return apiService.getPrivate(AppConstants.rooms,
        sharedPreferencesManager.getString('token') ?? '');
  }

  Future<Response> getSearchChatList(String searchValue) async {
    return apiService.getPrivate(AppConstants.rooms+"?search=$searchValue",
        sharedPreferencesManager.getString('token') ?? '');
  }

  void ClearPrafrence() {
    sharedPreferencesManager.clearAll();
  }

}