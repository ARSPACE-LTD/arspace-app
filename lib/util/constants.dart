import 'environment.dart';

class AppConstants {
  static const String appName = Environments.appName;
  static const String companyName = Environments.companyName;
  static  String fcm_token = "";
  static const String login_api = 'auth/login';
  static const String verify_api = 'auth/verify-otp';
  static const String signup_api = 'auth/register';
  static const String resend_otp_api = 'auth/resend-verification-otp';
  static const String forgot_password_api = 'auth/password-reset';
  static const String completeProfile_api = 'profile';
  static const String getInterst_api = 'interests';
  static const String get_user_profile_api = 'profile';
  static const String logOut_api = 'auth/logout';
  static const String get_events_api = 'events';
  static const String like_events_api = 'favourite/events';
  static const String like_person_api = 'favourite/users';
  static const String tickets_api = 'orders';
  static const String cards = 'cards';
  static const String matches = 'event';
  static const String notifications = 'notifications';
  static const String rooms = 'rooms';
  static const String rooms_messages = 'messages';
  static const String upload_attachment = 'upload-attachment';
  static const String ticket_list = 'tickets';
  static const String ticket_history = 'tickets?type=history';
  static const String delete_image = 'image';

}

























