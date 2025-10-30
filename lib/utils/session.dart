import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'secure_logger.dart';
import 'secure_storage.dart';

class Session {
  static final Session _instance = Session._internal();
  factory Session() => _instance;
  Session._internal();

  final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      colors: true,
      dateTimeFormat: DateTimeFormat.none, // ✅ replaces printTime: false
    ),
  );

  Map<String, String> cookies = {};

  Future<http.Response> get(String url, {Map<String, String>? headers}) async {
    final client = http.Client();

    try {
      final requestHeaders = headers ?? {};

      // Add cookies to the request if we have any
      if (cookies.isNotEmpty) {
        final cookieString = cookies.entries
            .map((entry) => '${entry.key}=${entry.value}')
            .join('; ');
        requestHeaders['Cookie'] = cookieString;
        SecureLogger.debug('Sending session cookies');
      }

      SecureLogger.debug('Making GET request to: $url');
      final response = await client.get(
        Uri.parse(url),
        headers: requestHeaders,
      );

      _logResponse(response);

      // Extract and store cookies from the response
      _updateCookies(response);

      return response;
    } finally {
      client.close();
    }
  }

  Future<http.Response> post(
    String url, {
    Map<String, String>? headers,
    Object? body,
    Map<String, String>? fields,
    Map<String, List<int>>? files,
  }) async {
    final client = http.Client();

    try {
      final requestHeaders = headers ?? {};

      // Add cookies to the request if we have any
      if (cookies.isNotEmpty) {
        final cookieString = cookies.entries
            .map((entry) => '${entry.key}=${entry.value}')
            .join('; ');
        requestHeaders['Cookie'] = cookieString;
        SecureLogger.debug('Sending session cookies');
      }

      SecureLogger.debug('Making POST request to: $url');

      // If files are provided, use multipart request
      if (files != null && files.isNotEmpty) {
        final request = http.MultipartRequest('POST', Uri.parse(url));
        request.headers.addAll(requestHeaders);

        // Add fields
        if (fields != null) {
          request.fields.addAll(fields);
        }

        // Add files
        files.forEach((fieldName, fileBytes) {
          request.files.add(
            http.MultipartFile.fromBytes(
              fieldName,
              fileBytes,
              filename: 'file_$fieldName',
            ),
          );
        });

        final streamedResponse = await request.send();
        final response = await http.Response.fromStream(streamedResponse);

        _logResponse(response);
        _updateCookies(response);

        return response;
      } else {
        // Regular POST request
        final response = await client.post(
          Uri.parse(url),
          headers: requestHeaders,
          body: body,
        );

        _logResponse(response);
        _updateCookies(response);

        return response;
      }
    } finally {
      client.close();
    }
  }

  void _updateCookies(http.Response response) {
    final setCookieHeader = response.headers['set-cookie'];
    if (setCookieHeader != null) {
      SecureLogger.debug('Received Set-Cookie header');

      // Parse the Set-Cookie header (handle multiple cookies)
      final cookiesList = setCookieHeader.split(',');

      for (var cookie in cookiesList) {
        // Take the first part before semicolon (the actual cookie)
        final cookiePart = cookie.split(';').first.trim();
        final parts = cookiePart.split('=');

        if (parts.length >= 2) {
          final cookieName = parts[0].trim();
          final cookieValue = parts.sublist(1).join('=').trim();
          cookies[cookieName] = cookieValue;
          SecureLogger.debug('Stored session cookie: $cookieName');

          // Store session token in secure storage if it's a session cookie
          if (cookieName.toLowerCase().contains('session') ||
              cookieName.toLowerCase().contains('token')) {
            SecureStorage.storeSessionToken(cookieValue);
          }
        }
      }
    }

    SecureLogger.debug('Total cookies stored: ${cookies.length}');
  }

  void clearCookies() {
    cookies.clear();
    SecureStorage.clearSession();
    SecureLogger.debug('Cleared all session cookies and secure storage');
  }

  // Helper method to check if we have a session
  bool get hasSession => cookies.isNotEmpty;

  void _logResponse(http.Response response) {
    try {
      _logger.i('🌐 Response status: ${response.statusCode}');
      _logger.d('🌐 Response headers: ${response.headers}');
      if (response.statusCode != 200) {
        _logger.w('🌐 Response body (non-200): ${response.body}');
      }
    } catch (e) {
      _logger.e('🌐 Failed to log response details: $e');
    }
  }
}
