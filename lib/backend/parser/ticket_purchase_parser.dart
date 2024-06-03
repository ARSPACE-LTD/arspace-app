import '../api/api.dart';
import '../helper/shared_pref.dart';

class TicketPurchasedParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  TicketPurchasedParser({required this.sharedPreferencesManager, required this.apiService});


}