
import 'package:get/get_connect/http/src/response/response.dart';

import '../../util/constants.dart';
import '../api/api.dart';
import '../helper/shared_pref.dart';

class PhoneVerificationParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  PhoneVerificationParser({required this.sharedPreferencesManager, required this.apiService});

  Future<Response> EmailVerificationApi(dynamic body) async {
    var response = await apiService.postPublic(AppConstants.verify_api, body);
    return response;
  }

  Future<Response> resendOtpApi(dynamic body) async {
    var response = await apiService.postPublic(AppConstants.resend_otp_api, body);
    return response;
  }

  void saveToken(String token) {
    sharedPreferencesManager.putString('token', token);
  }

  void saveUserUUID(String UUID) {
    sharedPreferencesManager.putString('UUID', UUID);
  }
}
