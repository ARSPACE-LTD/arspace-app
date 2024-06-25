import 'package:arspace/util/constants.dart';
import 'package:arspace/util/theme.dart';
import 'package:arspace/view/connectivity_service.dart';
import 'package:arspace/view/custom_loader.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'backend/helper/app_router.dart';
import 'backend/helper/init.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MainBinding().dependencies();

  await Firebase.initializeApp();

  FirebaseMessaging.instance.getToken().then((value) {
    String? token = value;
    print("FirebaseToken  $token");
    // Intercom.sendTokenToIntercom(token!);
    if (token != null) {
      print("fcmToken === ${token}");
      AppConstants.fcm_token = token;
    }
  });

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark, // dark text for status bar
      statusBarColor: Colors.transparent));

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppConstants.appName,
      color: ThemeProvider.blackColor,
      debugShowCheckedModeBanner: false,
      navigatorKey: Get.key,
      initialRoute: AppRouter.splash,
      initialBinding: BindingsBuilder(() => Get.put(ConnectivityService())),
      getPages: AppRouter.routes,
    );
  }
}
