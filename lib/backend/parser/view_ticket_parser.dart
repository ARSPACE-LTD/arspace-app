import 'package:get/get_connect/http/src/response/response.dart';

import '../../util/constants.dart';
import '../api/api.dart';
import '../helper/shared_pref.dart';

class ViewTicketParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  ViewTicketParser({required this.sharedPreferencesManager, required this.apiService});

  Future<Response> getTickes() async {
    return apiService.getPrivate(AppConstants.ticket_list,
        sharedPreferencesManager.getString('token') ?? '');
  }

  void ClearPrafrence() {
    sharedPreferencesManager.clearAll();
  }
  String CheckToken(){
    return  sharedPreferencesManager.getString('token') ?? '';
  }
}