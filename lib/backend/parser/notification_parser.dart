

import 'package:get/get_connect/http/src/response/response.dart';

import '../../util/constants.dart';
import '../api/api.dart';
import '../helper/shared_pref.dart';

class NotificationParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  NotificationParser({required this.sharedPreferencesManager, required this.apiService});


  Future<Response> getAllNotifications() async {
    return apiService.getPrivate(AppConstants.notifications,
        sharedPreferencesManager.getString('token') ?? '');
  }

  Future<Response> ReadNotifications(String uuid) async {
    return apiService.getPrivatePatchRequest(AppConstants.notifications+ "/$uuid",
        sharedPreferencesManager.getString('token') ?? '');
  }



  void ClearPrafrence() {
    sharedPreferencesManager.clearAll();
  }
}