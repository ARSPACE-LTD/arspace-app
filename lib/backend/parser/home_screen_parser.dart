

import 'package:get/get_connect/http/src/response/response.dart';

import '../../util/constants.dart';
import '../api/api.dart';
import '../helper/shared_pref.dart';

class HomeScreenParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  HomeScreenParser({required this.sharedPreferencesManager, required this.apiService});

  Future<Response> getEvents() async {
    return apiService.getPrivate(AppConstants.get_events_api,
        sharedPreferencesManager.getString('token') ?? '');
  }

  Future<Response> getUserProfile() async {
    return apiService.getPrivate(AppConstants.get_user_profile_api,
        sharedPreferencesManager.getString('token') ?? '');
  }



  Future<Response> PutLocation(Map<String, dynamic> body) async {
    return apiService.putPrivate(AppConstants.completeProfile_api,body,
        sharedPreferencesManager.getString('token') ?? '');
  }

  void saveLatLng(var lat, var lng, var address ,var short_address) {
    sharedPreferencesManager.putDouble('lat', lat);
    sharedPreferencesManager.putDouble('lng', lng);
    sharedPreferencesManager.putString('address', address);
    sharedPreferencesManager.putString('shortAddress', short_address);
  }

  void isProfileActive( bool is_profile_active) {
    sharedPreferencesManager.putBool('is_profile_active', is_profile_active);
  }

  Future<Response> getAllNotifications() async {
    return apiService.getPrivate(AppConstants.notifications,
        sharedPreferencesManager.getString('token') ?? '');
  }

  void ClearPrafrence() {
    sharedPreferencesManager.clearAll();
  }

  String CheckToken(){
    return  sharedPreferencesManager.getString('token') ?? '';
  }

}