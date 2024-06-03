import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';



class ConnectivityService extends GetxService {
  var isConnected = true.obs;

  @override
  void onInit() {
    super.onInit();
    // Start listening for connectivity changes
    Connectivity().onConnectivityChanged.listen((result) {
      updateConnectionStatus(result);
    });
    // Check initial connection status
    checkInitialConnection();
  }

  Future<void> checkInitialConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    updateConnectionStatus(connectivityResult);
  }

  void updateConnectionStatus(ConnectivityResult result) {
    if (result == ConnectivityResult.none) {
      isConnected.value = false;
    } else {
      isConnected.value = true;
    }
  }

  Future<ConnectivityResult> getCurrentNetworkStatus() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult;
  }
}