import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkStatus {
  static final Connectivity _connectivity = Connectivity();

  static Future<bool> hasConnection() async {
    final result = await _connectivity.checkConnectivity();

    if (result.contains(ConnectivityResult.mobile)
    || result.contains(ConnectivityResult.wifi)
    || result.contains(ConnectivityResult.vpn)) {
      return true;
    }

    return false;
  }

  static Future<bool> hasInternet() async {
    try {
      final lookup = await InternetAddress.lookup("google.com");
      return lookup.isNotEmpty && lookup.first.rawAddress.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}