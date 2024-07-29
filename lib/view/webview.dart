import 'package:arspace/util/all_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../util/dimens.dart';
import '../util/theme.dart';
import '../widgets/commontext.dart';

class TermsWebView extends StatefulWidget {
  final String link_type;

  TermsWebView({required this.link_type});

  //const TermsWebView({super.key});

  @override
  State<TermsWebView> createState() => _TermsWebViewState();
}

class _TermsWebViewState extends State<TermsWebView> {
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeProvider.text_background,
      appBar: AppBar(
          centerTitle: true,
          backgroundColor: ThemeProvider.blackColor,
          leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: ThemeProvider.whiteColor,
              size: 20,
            ),
          ),
          title: CommonTextWidget(
            heading: widget.link_type,
            fontSize: Dimens.twenty,
            color: ThemeProvider.whiteColor,
            fontFamily: 'Lexend',
            fontWeight: FontWeight.w700,
          )),
      body: Stack(
        children: [
          WebView(
            initialUrl: widget.link_type == AppString.terms ? "https://arspace.website/privacy-policy" :"https://arspace.website/contact", // Replace this with your URL
            javascriptMode: JavascriptMode.unrestricted,
            onPageStarted: (String url) {
              setState(() {
                _isLoading = true;
              });
            },
            onPageFinished: (String url) {
              setState(() {
                _isLoading = false;
              });
            },
          ),
          if (_isLoading)
            Container(
              color: ThemeProvider.text_background,
              child: Center(
                child: LoadingAnimationWidget.threeRotatingDots(
                  color: ThemeProvider.loader_color,
                  size: Dimens.loder_size,
                ),
              ),
            ),
        ],
      ),
    );
  }

}
