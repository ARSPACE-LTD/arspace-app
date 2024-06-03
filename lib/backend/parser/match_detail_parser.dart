
import 'package:get/get_connect/http/src/response/response.dart';

import '../../util/constants.dart';
import '../api/api.dart';
import '../helper/shared_pref.dart';

class MatchDetailParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  MatchDetailParser({required this.sharedPreferencesManager, required this.apiService});


  Future<Response> getPersonInfo(String uuid) async {
    return apiService.getPrivate(AppConstants.get_user_profile_api + "/$uuid",
        sharedPreferencesManager.getString('token') ?? '');
  }

  void ClearPrafrence() {
    sharedPreferencesManager.clearAll();
  }


}