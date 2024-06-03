
import 'package:get/get_connect/http/src/response/response.dart';

import '../../util/constants.dart';
import '../api/api.dart';
import '../helper/shared_pref.dart';

class RigiterParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  RigiterParser({required this.sharedPreferencesManager, required this.apiService});

  Future<Response> registerEmail(dynamic body) async {
    var response = await apiService.postPublic(AppConstants.signup_api, body);
    return response;
  }

  void saveToken(String token) {
    sharedPreferencesManager.putString('token', token);
  }
}
