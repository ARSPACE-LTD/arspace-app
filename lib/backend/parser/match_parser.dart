
import 'package:get/get_connect/http/src/response/response.dart';

import '../../util/constants.dart';
import '../api/api.dart';
import '../helper/shared_pref.dart';

class MatchParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  MatchParser({required this.sharedPreferencesManager, required this.apiService});

  Future<Response> getPuchageTicket() async {
    return apiService.getPrivate(AppConstants.ticket_list,
        sharedPreferencesManager.getString('token') ?? '');
  }


  Future<Response> getMatches(String UId) async {
    return apiService.getPrivate(AppConstants.matches + "/$UId" +"/users",
        sharedPreferencesManager.getString('token') ?? '');
  }

  Future<Response> getFilter(String UId ,String gender,int min_age, int max_age) async {
    return apiService.getPrivate(AppConstants.matches + "/$UId" +"/users" + "?gender=$gender&min_age=$min_age&max_age=$max_age",
        sharedPreferencesManager.getString('token') ?? '');
  }

  Future<Response> LikePerson(String uuid, Map<String, Object> body ) async {
    return apiService.getPrivatePatchLIkeDislikeRequest(AppConstants.like_person_api + "/$uuid",
        sharedPreferencesManager.getString('token') ?? '' ,body);
  }



  void ClearPrafrence() {
    sharedPreferencesManager.clearAll();
  }

 bool getProfileIsComplete(){
    return  sharedPreferencesManager.getBool('is_profile_active') ?? false;
  }

  String CheckToken(){
    return  sharedPreferencesManager.getString('token') ?? '';
  }
}
