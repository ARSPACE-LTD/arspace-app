
import '../api/api.dart';
import '../helper/shared_pref.dart';

class RequestToSetProfileParser{
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  RequestToSetProfileParser({required this.apiService, required this.sharedPreferencesManager});
}

