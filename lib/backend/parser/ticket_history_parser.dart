import 'package:get/get_connect/http/src/response/response.dart';

import '../../util/constants.dart';
import '../api/api.dart';
import '../helper/shared_pref.dart';

class TicketHistoryParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  TicketHistoryParser({required this.sharedPreferencesManager, required this.apiService});

  Future<Response> ticket_history() async {
    return apiService.getPrivate(AppConstants.ticket_history,
        sharedPreferencesManager.getString('token') ?? '');
  }


  void ClearPrafrence() {
    sharedPreferencesManager.clearAll();
  }


}