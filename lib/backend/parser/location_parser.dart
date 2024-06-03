
import 'package:get/get_connect/http/src/response/response.dart';

import '../../util/constants.dart';
import '../api/api.dart';
import '../helper/shared_pref.dart';

class LocationParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  LocationParser({required this.sharedPreferencesManager, required this.apiService});

  Future<Response> getPlacesList(url) async {
    var response = await apiService.getOther(url);
    return response;
  }

  void saveLatLng(var lat, var lng, var address ,var short_address) {
    sharedPreferencesManager.putDouble('lat', lat);
    sharedPreferencesManager.putDouble('lng', lng);
    sharedPreferencesManager.putString('address', address);
    sharedPreferencesManager.putString('shortAddress', short_address);

  }

  Future<Response> PutLocation(Map<String, dynamic> body) async {
    return apiService.putPrivate(AppConstants.completeProfile_api,body,
        sharedPreferencesManager.getString('token') ?? '');
  }

  String CheckToken(){
    return  sharedPreferencesManager.getString('token') ?? '';
  }
  void ClearPrafrence() {
    sharedPreferencesManager.clearAll();
  }
}