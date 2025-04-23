import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkHelper {
  /// Checks if the device is connected to the internet.
  static Future<bool> isInternetAvailable() async {
    // First check network connectivity status
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    }

    // Second check actual internet access by pinging a reliable server
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }
}
