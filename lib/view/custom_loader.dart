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
          _loadHtml(webViewController);
        },
      ),
    );
  }

  void _loadHtml(WebViewController webViewController) {
    String html = '''
      <div class="container">
        <div class="dot"></div>
        <div class="traveler"></div>
      </div>
      <svg width="0" height="0" class="svg">
        <defs>
          <filter id="uib-jelly-triangle-ooze">
            <feGaussianBlur
              in="SourceGraphic"
              stdDeviation="3.333"
              result="blur"
            />
            <feColorMatrix
              in="blur"
              mode="matrix"
              values="1 0 0 0 0  0 1 0 0 0  0 0 1 0 0  0 0 0 18 -7"
              result="ooze"
            />
            <feBlend in="SourceGraphic" in2="ooze" />
          </filter>
        </defs>
      </svg>
      <style>
        body {
          margin: 0;
        }

        .container {
          --uib-size: 30px;
          --uib-color: white;
          --uib-speed: 1.75s;
          position: relative;
          height: var(--uib-size);
          width: var(--uib-size);
          filter: url('#uib-jelly-triangle-ooze');
        }

        .container::before,
        .container::after,
        .dot {
          content: '';
          position: absolute;
          width: 33%;
          height: 33%;
          background-color: var(--uib-color);
          border-radius: 100%;
          will-change: transform;
          transition: background-color 0.3s ease;
        }

        .dot {
          top: 6%;
          left: 30%;
          animation: grow var(--uib-speed) ease infinite;
        }

        .container::before {
          bottom: 6%;
          right: 0;
          animation: grow var(--uib-speed) ease calc(var(--uib-speed) * -0.666) infinite;
        }

        .container::after {
          bottom: 6%;
          left: 0;
          animation: grow var(--uib-speed) ease calc(var(--uib-speed) * -0.333) infinite;
        }

        .traveler {
          position: absolute;
          top: 6%;
          left: 30%;
          width: 33%;
          height: 33%;
          background-color: var(--uib-color);
          border-radius: 100%;
          animation: triangulate var(--uib-speed) ease infinite;
          transition: background-color 0.3s ease;
        }

        .svg {
          width: 0;
          height: 0;
          position: absolute;
        }

        @keyframes triangulate {
          0%, 100% {
            transform: none;
          }

          33.333% {
            transform: translate(120%, 175%);
          }

          66.666% {
            transform: translate(-95%, 175%);
          }
        }

        @keyframes grow {
          0%, 85%, 100% {
            transform: scale(1.5);
          }

          50%, 60% {
            transform: scale(0);
          }
        }
      </style>
    ''';

    webViewController.loadUrl(Uri.dataFromString(
      html,
      mimeType: 'text/html',
      encoding: Encoding.getByName('utf-8'),
    ).toString());
  }
}