import 'package:get/get.dart';

import '../backend/parser/htmlLoaderParser.dart';

class HtmlLoaderController extends GetxController {

  final HtmlParser parser;

  HtmlLoaderController({required this.parser});


  final isLoading = true.obs;

  void startLoading() {
    isLoading(true);
  }

  void stopLoading() {
    isLoading(false);
  }
}