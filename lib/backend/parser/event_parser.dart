import 'package:get/get_connect/http/src/response/response.dart';

import '../../util/constants.dart';
import '../api/api.dart';
import '../helper/shared_pref.dart';

class EventParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  EventParser({required this.sharedPreferencesManager, required this.apiService});

  Future<Response> getEventsInfo(String uuid) async {
    return apiService.getPrivate(AppConstants.get_events_api + "/$uuid",
        sharedPreferencesManager.getString('token') ?? '');
  }

  Future<Response> LikeEvents(String uuid) async {
    return apiService.getPrivatePatchRequest(AppConstants.like_events_api + "/$uuid",
        sharedPreferencesManager.getString('token') ?? '');
  }

  Future<Response> GetCards() async {
    return apiService.getPrivate(AppConstants.cards,
        sharedPreferencesManager.getString('token') ?? '');
  }

  Future<Response> CreateCards(Map<String, String> body) async {
    return apiService.postPrivate(AppConstants.cards,body,
        sharedPreferencesManager.getString('token') ?? '');
  }

  Future<Response> CreateOrder(Map<String, dynamic> orderbody) async {
    return apiService.postPrivate(AppConstants.tickets_api,orderbody,
        sharedPreferencesManager.getString('token') ?? '');
  }

  void ClearPrafrence() {
    sharedPreferencesManager.clearAll();
  }


  String CheckToken(){
    return  sharedPreferencesManager.getString('token') ?? '';
  }

  bool getProfileIsComplete(){
    return  sharedPreferencesManager.getBool('is_profile_active') ?? false;
  }
}