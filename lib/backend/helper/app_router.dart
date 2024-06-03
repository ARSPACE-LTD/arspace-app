

import 'package:arspace/backend/binding/chat_inbox_binding.dart';
import 'package:arspace/backend/binding/chat_list_binding.dart';
import 'package:arspace/backend/binding/event_binding.dart';
import 'package:arspace/backend/binding/location_binding.dart';
import 'package:arspace/backend/binding/match_binding.dart';
import 'package:arspace/backend/binding/match_detail_binding.dart';
import 'package:arspace/backend/binding/ticket_history_binding.dart';
import 'package:arspace/view/chat_inbox_screen.dart';
import 'package:arspace/view/chat_list_screen.dart';
import 'package:arspace/view/location_screen.dart';
import 'package:arspace/view/match_detail_screen.dart';
import 'package:arspace/view/request_to_set_profile.dart';
import 'package:arspace/view/tabs_screens/match_screen.dart';
import 'package:arspace/backend/binding/ticket_purchase_binding.dart';
import 'package:arspace/backend/binding/view_ticket_binding.dart';
import 'package:arspace/view/event_screen.dart';
import 'package:arspace/view/location_screen.dart';
import 'package:arspace/view/request_to_set_profile.dart';
import 'package:arspace/view/ticket_history_screen.dart';
import 'package:arspace/view/ticket_purchase.dart';
import 'package:arspace/view/view_ticket.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

import '../../view/add_payment_screen.dart';
import '../../view/authentication_typescreen.dart';
import '../../view/complete_profile.dart';
import '../../view/custom_loader.dart';
import '../../view/dashboard_screen.dart';
import '../../view/forgot_screen.dart';
import '../../view/login_view.dart';
import '../../view/notifications_screen.dart';
import '../../view/onboardingscreens.dart';
import '../../view/phone_verificationscreen.dart';
import '../../view/profile_screen.dart';
import '../../view/register.dart';
import '../../view/splash.dart';
import '../../view/tabs_screens/ticket_screen.dart';
import '../binding/add_paymentinfo_binding.dart';
import '../binding/authentication_type_binding.dart';
import '../binding/complete_profile_binding.dart';
import '../binding/dashboard_binding.dart';
import '../binding/forgot_binding.dart';
import '../binding/htmlLoaderBinding.dart';
import '../binding/login_binding.dart';
import '../binding/notification_binding.dart';
import '../binding/onboard_binding.dart';
import '../binding/phone_verificationbinding.dart';
import '../binding/profile_binding.dart';
import '../binding/register_binding.dart';
import '../binding/requestToSetProfilebinding.dart';
import '../binding/splash_binding.dart';

class AppRouter {
  static const String splash = '/splash';
  static const String register = '/register';
  static const String forgot = '/forgot_screen';
  static const String login = '/login_view';
  static const String onboardingScreen = '/onboardingscreens';
  static const String phoneVerification = '/phone_verificationscreen';
  static const String authenticationTypeScreen = '/authentication_typescreen';
  static const String addPaymentScreen = '/add_payment_screen';
  static const String dashboardScreen = '/dashboard_screen';
  static const String request_to_set_profile = '/request_to_set_profile';
  static const String complete_profile = '/complete_profile';
  static const String custom_loader = '/custom_loader';
  static const String profile = '/profile_screen';
  static const String location = '/location_screen';
  static const String match = '/match_screen';
  static const String events = '/event_screen';
  static const String ticketPurchased = '/ticket_purchase';
  static const String viewTicket = '/view_ticket';
  static const String matchDetails = '/match_detail_screen';
  static const String ticketHistory = '/ticket_history_screen';
  static const String chatList = '/chat_list_screen';
  static const String chatInbox = '/chat_inbox_screen';
  static const String ticket_screen = '/ticket_screen';
  static const String notification_screen = '/notifications_screen';

  static String getSplashRoute() => splash;
  static String getRegisterRoute() => register;
  static String getForgotRoute() => forgot;
  static String getLoginRoute() => login;
  static String onBoardingRoute() => onboardingScreen;
  static String phoneVerificationRoute() => phoneVerification;
  static String authenticationTypeRoute() => authenticationTypeScreen;
  static String addPaymentScreenRoute() => addPaymentScreen;
  static String getDashboardScreenRoute() => dashboardScreen;
  static String requestToSetProfile() => request_to_set_profile;
  static String getComplete_profile() => complete_profile;
  static String getCustom_loader() => custom_loader;
  static String getProfileRoute() => profile;
  static String getLocation() => location;
  static String getEvents() => events;
  static String getTicketPurchased() => ticketPurchased;
  static String getTicketView() => viewTicket;
  static String getMatchDetails() => matchDetails;
  static String getTicketHistory() => ticketHistory;
  static String getChatList() => chatList;
  static String getChatInbox() => chatInbox;

  static String getMatch() => match;
  static String getTicket_screen() => ticket_screen;
  static String getNotification_screen() => notification_screen;

  static List<GetPage> routes = [
    GetPage(name: splash, page: () => SplashScreen(), binding: SplashBinding()),
    GetPage(name: register, page: () => RegisterScreen(), binding: RegisterBinding()),
    GetPage(name: forgot, page: () => ForgotScreen(), binding: ForgotBinding()),
    GetPage(name: login, page: () => LoginScreen(), binding: LoginBinding()),
    GetPage(name: onboardingScreen, page: () => OnBoardScreen(), binding: OnBoardBinding()),
    GetPage(name: phoneVerification, page: () => PhoneVerificationScreen(), binding: PhoneVerificationBinding()),
    GetPage(name: authenticationTypeScreen, page: () => AuthenticationTypeScreen(), binding: AuthenticationTypeBinding()),
    GetPage(name: addPaymentScreen, page: () => AddPaymentScreen(), binding: AddPaymentBinding()),
    GetPage(name: dashboardScreen, page: () => DashboardScreen(), binding: DashboardBinding()),
    GetPage(name: request_to_set_profile, page: () => RequestToSetProfile(), binding: RequestToSetProfileBinding()),
    GetPage(name: complete_profile, page: () => CompleteProfile(), binding: CompleteProfileBinding()),
    GetPage(name: custom_loader, page: () => HtmlLoader(), binding: htmlLoadehtmlLoaderBindingrBinding()),
    GetPage(name: profile, page: () => ProfileScreen(), binding: ProfileBinding()),
    GetPage(name: location, page: () => LocationScreen(), binding: LocationBinding()),
    GetPage(name: match, page: () => MatchScreen(), binding: MatchBinding()),
    GetPage(name: events, page: () => EventScreen(), binding: EventBinding()),
    GetPage(name: ticketPurchased, page: () => TicketPurchased(), binding: TicketPurchasedBinding()),
    GetPage(name: viewTicket, page: () => ViewTicket(), binding: ViewTicketBinding()),
    GetPage(name: matchDetails, page: () => MatchDetailScreen(), binding: MatchDetailBinding()),
    GetPage(name: ticketHistory, page: () => TicketHistoryScreen(), binding: TicketHistoryBinding()),
    GetPage(name: chatList, page: () => ChatListScreen(), binding: ChatListBinding()),
    GetPage(name: chatInbox, page: () => ChatInboxScreen(), binding: ChatInboxBinding()),
    GetPage(name: notification_screen, page: () => Notifications(), binding: NotificationBinding()),
   // GetPage(name: ticket_screen, page: () => TicketScreen(), binding: ChatInboxBinding()),
  ];
}
