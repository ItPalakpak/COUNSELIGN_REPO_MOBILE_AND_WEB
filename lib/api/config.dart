import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class ApiConfig {
  // Localhost (desktop browser / web debug)
  static const String localhostUrl =
      'http://192.168.18.65/Counselign/public';

  // XAMPP loopback for desktop (if using 127.0.0.1)
  static const String xamppUrl = 'http://127.0.0.1/Counselign/public';

  // Android emulator
  static const String emulatorUrl =
      'http://10.0.2.2/Counselign/public';

  // Real device (replace with your PC's local IP)
  static const String deviceUrl =
      'http://192.168.18.65/Counselign/public';

  // Production/live server
  static const String productionUrl =
      'http://192.168.18.65/Counselign/public';

  // Timeout settings
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Default headers
  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'X-Requested-With': 'XMLHttpRequest',
  };

  // Auto-detect environment
  static String get currentBaseUrl {
    if (kIsWeb) {
      // Running on web (use localhost)
      return localhostUrl;
    } else if (Platform.isAndroid) {
      // Running on Android
      // Use deviceUrl for physical device testing
      // Use emulatorUrl only when running on Android emulator
      return deviceUrl; // Use deviceUrl for physical device
    } else if (Platform.isIOS) {
      // Use device URL for iOS testing on physical device
      return deviceUrl;
    } else {
      // Desktop (Windows/macOS/Linux)
      return localhostUrl;
    }
  }
}
