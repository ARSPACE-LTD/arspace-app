import 'dart:async';
import 'dart:io';

import 'package:app_links/app_links.dart';
import 'package:arspace/util/all_constants.dart';
import 'package:get/get.dart';

import '../backend/helper/app_router.dart';
import '../backend/parser/splash_parser.dart';

class SplashController extends GetxController {
  final SplashParser parser;
  late AppLinks appLinks;
  String? link;
  String? eventId;

  SplashController({required this.parser});

  @override
  void onInit() {
    super.onInit();
    initDeepLink();
  }

  Future<void> initDeepLink() async {
    appLinks = AppLinks();

    // Handle initial link
    final initialLink = await appLinks.getInitialLink();

    link = initialLink?.toString();
    update();

    if (initialLink != null) {
      _navigateBasedOnLink(initialLink);
    } else {
      _navigateNormally();
    }

    appLinks.uriLinkStream.listen((Uri? uri) {
      link = uri?.toString();
      update();

      if (uri != null && uri.pathSegments.isNotEmpty) {
        eventId = uri.pathSegments.last;
       // Get.toNamed(AppRouter.getEvents(), arguments: [eventId]);
      }
    });
  }

  void _navigateBasedOnLink(Uri linkUri) {
    Timer(
      Duration(seconds: Platform.isAndroid ? 5 : 6),
          () {
        if (linkUri.pathSegments.isNotEmpty) {
          eventId = linkUri.pathSegments.last;
          Get.toNamed(AppRouter.getEvents(), arguments: [eventId]);
        } else {
          _navigateNormally();
        }
      },
    );
  }

  void _navigateNormally() {
    Timer(
      Duration(seconds: Platform.isAndroid ? 5 : 6),
          () {
        if (parser.token() != null && parser.token() != "") {
          Get.toNamed(AppRouter.getDashboardScreenRoute());
        } else {
          Get.toNamed(AppRouter.authenticationTypeRoute());
        }
      },
    );
  }
}