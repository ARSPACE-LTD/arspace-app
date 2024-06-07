
import 'package:get/get_connect/http/src/response/response.dart';

import '../../util/constants.dart';
import '../api/api.dart';
import '../helper/shared_pref.dart';

class ProfileParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  ProfileParser({required this.sharedPreferencesManager, required this.apiService});
  Future<Response> getUserProfile() async {
    return apiService.getPrivate(AppConstants.get_user_profile_api,
        sharedPreferencesManager.getString('token') ?? '');
  }

  Future<Response> logout() async {
    return await apiService.logout(AppConstants.logOut_api,
        sharedPreferencesManager.getString('token') ?? '');
  }

  Future<Response> GetCards() async {
    return apiService.getPrivate(AppConstants.cards,
        sharedPreferencesManager.getString('token') ?? '');
  }
  Future<Response> DeleteCards(String cardId) async {
    return apiService.deletePrivate(AppConstants.cards + "/$cardId",
        sharedPreferencesManager.getString('token') ?? '');
  }

  Future<void> clearAccount() async {
    bool? success = await sharedPreferencesManager.clearAll();
    if (success == true) {
      print("Clear sucessful.");
    } else {
      print("Clear failed or sharedPreferences is null.");
    }
  }

  Future<Response> deleteAccount() async {
    return await apiService.deletePrivate(AppConstants.get_user_profile_api,
        sharedPreferencesManager.getString('token') ?? '');
  }

}