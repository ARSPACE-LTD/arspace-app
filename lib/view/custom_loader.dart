import 'dart:convert';

import 'package:arspace/util/all_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../controller/htmlLoaderController.dart';
import '../util/dimens.dart';
import '../util/theme.dart';

class HtmlLoader extends StatefulWidget {
  @override
  _HtmlLoaderState createState() => _HtmlLoaderState();
}

class _HtmlLoaderState extends State<HtmlLoader> {

  final HtmlLoaderController addChildController = Get.put(HtmlLoaderController(parser: Get.find()));

  @override
  void initState() {
    super.initState();
    addChildController.initialized; // Initialize the controller if needed
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return addChildController.isLoading.value
          ? _buildLoadingWidget()
          : _buildWebViewWidget();
    });
  }

  Widget _buildLoadingWidget() {
    return Center(
      child: LoadingAnimationWidget.threeRotatingDots(
        color: ThemeProvider.loader_color,
        size: Dimens.loder_size,
      ),
    );
  }

  Widget _buildWebViewWidget() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: WebView(
        initialUrl: 'about:blank',
        onWebViewCreated: (WebViewController webViewController) {
        //  _loadHtml(webViewController);
        },
      ),
    );
  }

}