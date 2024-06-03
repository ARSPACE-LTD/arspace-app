


import 'package:get/get_connect/http/src/response/response.dart';

import '../../util/constants.dart';
import '../api/api.dart';
import '../helper/shared_pref.dart';

class ForgotParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  ForgotParser(
      {required this.sharedPreferencesManager, required this.apiService});


  Future<Response> forgot_password_api(dynamic body) async {
    var response = await apiService.postPublic(AppConstants.forgot_password_api, body);
    return response;
  }
}

