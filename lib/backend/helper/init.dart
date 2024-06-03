

import 'package:arspace/backend/helper/shared_pref.dart';
import 'package:arspace/backend/parser/chat_inbox_parser.dart';
import 'package:arspace/backend/parser/chat_list_parser.dart';
import 'package:arspace/backend/parser/event_parser.dart';
import 'package:arspace/backend/parser/home_screen_parser.dart';
import 'package:arspace/backend/parser/location_parser.dart';
import 'package:arspace/backend/parser/match_detail_parser.dart';
import 'package:arspace/backend/parser/match_parser.dart';
import 'package:arspace/backend/parser/notification_parser.dart';
import 'package:arspace/backend/parser/profile_parser.dart';
import 'package:arspace/backend/parser/ticket_history_parser.dart';
import 'package:arspace/backend/parser/ticket_purchase_parser.dart';
import 'package:arspace/backend/parser/view_ticket_parser.dart';
import 'package:arspace/util/all_constants.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controller/home_screen_controller.dart';
import '../../controller/splash_controller.dart';
import '../../util/environment.dart';
import '../../view/connectivity_service.dart';
import '../api/api.dart';
import '../parser/CompleteProfileParser.dart';
import '../parser/htmlLoaderParser.dart';
import '../parser/requestToSetProfileParser.dart';
import '../parser/add_payment_parser.dart';
import '../parser/dashboard_parser.dart';
import '../parser/forgot_parser.dart';
import '../parser/login_parser.dart';
import '../parser/onboard_parser.dart';
import '../parser/phoneverification_parser.dart';
import '../parser/register_parser.dart';
import '../parser/splash_parser.dart';

class MainBinding extends Bindings {
  @override
  Future<void> dependencies() async {
    final sharedPref = await SharedPreferences.getInstance();
    Get.put(
      SharedPreferencesManager(sharedPreferences: sharedPref),
      permanent: true,
    );


    Get.lazyPut(() => ApiService(appBaseUrl: Environments.apiBaseURL));

    // Parser LazyLoad
   // Get.put(ConnectivityService());

    Get.lazyPut(() => ConnectivityService());

    Get.lazyPut(() => SplashParser(apiService: Get.find(), sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => RigiterParser(apiService: Get.find(), sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => OnBoardParser(apiService: Get.find(), sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => ForgotParser(apiService: Get.find(), sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => LoginParser(apiService: Get.find(), sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => PhoneVerificationParser(apiService: Get.find(), sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => AddPaymentParser(apiService: Get.find(), sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => DashboardParser(apiService: Get.find(), sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => RequestToSetProfileParser(apiService: Get.find(), sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => CompleteProfileParser(apiService: Get.find(), sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => HtmlParser(apiService: Get.find(), sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => ProfileParser(apiService: Get.find(), sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => LocationParser(apiService: Get.find(), sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => MatchParser(apiService: Get.find(), sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => EventParser(apiService: Get.find(), sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => TicketPurchasedParser(apiService: Get.find(), sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => HomeScreenParser(apiService: Get.find(), sharedPreferencesManager: Get.find()), fenix: true);

    Get.lazyPut(
          () => HomeScreenController(parser: Get.find()),
    );

    Get.lazyPut(() => ViewTicketParser(apiService: Get.find(), sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => MatchDetailParser(apiService: Get.find(), sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => TicketHistoryParser(apiService: Get.find(), sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => ChatListParser(apiService: Get.find(), sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => ChatInboxParser(apiService: Get.find(), sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => NotificationParser(apiService: Get.find(), sharedPreferencesManager: Get.find()), fenix: true);
  }
}
