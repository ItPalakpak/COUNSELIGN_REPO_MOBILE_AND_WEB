import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb, kReleaseMode;

class ApiConfig {
  // Optional build-time override (e.g., --dart-define=API_BASE_URL=https://api.example.com)
  static const String envBaseUrl = String.fromEnvironment('API_BASE_URL');
  // Localhost (desktop browser / web debug)
  static const String localhostUrl = 'http://192.168.18.89/Counselign/public';

  // XAMPP loopback for desktop (if using 127.0.0.1)
  static const String xamppUrl = 'http://127.0.0.1/Counselign/public';

  // Android emulator
  static const String emulatorUrl = 'http://10.0.2.2/Counselign/public';

  // Real device (replace with your PC's local IP)
  static const String deviceUrl = 'http://192.168.18.89/Counselign/public';

  // Production/live server (replace with your public HTTPS endpoint)
  static const String productionUrl =
      'https://your-domain.example.com/Counselign/public';

  // Timeout settings
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Default headers
  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'X-Requested-With': 'XMLHttpRequest',
  };

  // Auto-detect environment and pick the most appropriate base URL.
  //
  // Priority:
  // 1) API_BASE_URL (build-time override via --dart-define) – use this whenever
  //    you need to point to a different machine/network without editing code.
  // 2) Release builds – fall back to productionUrl to avoid shipping a build
  //    that accidentally targets a LAN-only HTTP endpoint.
  // 3) Debug/dev – use platform-specific local URLs.
  static String get currentBaseUrl {
    // 1) Build-time override always wins (debug or release).
    if (envBaseUrl.isNotEmpty) {
      return envBaseUrl;
    }

    // 2) In release mode, prefer the configured production URL.
    if (kReleaseMode) {
      return productionUrl;
    }

    // 3) Development / debug fallbacks by platform.
    if (kIsWeb) {
      // Running on web (dev server).
      return localhostUrl;
    }

    if (Platform.isAndroid) {
      // Running on Android.
      // - For emulators, prefer emulatorUrl via API_BASE_URL override.
      // - For physical devices, prefer deviceUrl or override via API_BASE_URL.
      return deviceUrl;
    }

    if (Platform.isIOS) {
      // iOS simulators/devices – same pattern as Android: override via
      // API_BASE_URL when testing against a different host.
      return deviceUrl;
    }

    // Desktop (Windows/macOS/Linux).
    return localhostUrl;
  }
}
