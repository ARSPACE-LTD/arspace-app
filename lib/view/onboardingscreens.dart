import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

import '../backend/helper/app_router.dart';
import '../controller/onboard_controller.dart';
import '../util/all_constants.dart';
import '../util/dimens.dart';
import '../util/theme.dart';
import '../widgets/commontext.dart';

class OnBoardScreen extends StatefulWidget {
  const OnBoardScreen({super.key});

  @override
  State<OnBoardScreen> createState() => _OnBoardScreenState();
}

class _OnBoardScreenState extends State<OnBoardScreen> {
  // declare and initizlize the page controller
  final PageController _pageController = PageController(initialPage: 0);


  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

