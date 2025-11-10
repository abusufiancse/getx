// lib/data/services/network_caller.dart
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NetworkResponse {
  final bool isSuccess;
  final int statusCode;
  dynamic responseData;
  final String errorMessage;

  NetworkResponse({
    required this.isSuccess,
    required this.statusCode,
    this.responseData,
    this.errorMessage = 'Something went wrong',
  });
}

class NetworkCaller {
  final Logger _logger = Logger();
  static const String _tokenKey = 'auth_token';

  Future<String?> _getAuthToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_tokenKey);
    } catch (e) {
      _logger.e('Error getting auth token: $e');
      return null;
    }
  }

  Future<void> saveAuthToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, token);
    } catch (e) {
      _logger.e('Error saving auth token: $e');
    }
  }

  Future<void> clearAuthToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenKey);
    } catch (e) {
      _logger.e('Error clearing auth token: $e');
    }
  }

  Future<NetworkResponse> request({
    required String method, // 'GET', 'POST', etc.
    required String url,
    Map<String, String>? headers,
    dynamic body,
    bool requireAuth = false,
  }) async {
    Uri uri = Uri.parse(url);

    // Prepare headers
    final Map<String, String> requestHeaders = {};

    if (headers != null) {
      requestHeaders.addAll(headers);
    }

    // Add content-type if not provided and body exists
    if (body != null && !requestHeaders.containsKey('Content-Type')) {
      requestHeaders['Content-Type'] = 'application/json';
    }

    // Add auth token if required
    if (requireAuth) {
      final token = await _getAuthToken();
      if (token != null) {
        requestHeaders['Authorization'] = 'Bearer $token';
      } else {
        _logger.w('Auth token required but not found');
        return NetworkResponse(
          isSuccess: false,
          statusCode: 401,
          errorMessage: 'Authentication required',
        );
      }
    }

    _logRequest(method, url, requestHeaders, body);

    try {
      http.Response response;

      switch (method.toUpperCase()) {
        case 'GET':
          response = await http.get(uri, headers: requestHeaders).timeout(const Duration(seconds: 10));
          break;
        case 'POST':
          response = await http.post(uri, headers: requestHeaders, body: body != null ? jsonEncode(body) : null)
              .timeout(const Duration(seconds: 10));
          break;
        case 'PUT':
          response = await http.put(uri, headers: requestHeaders, body: body != null ? jsonEncode(body) : null)
              .timeout(const Duration(seconds: 10));
          break;
        case 'DELETE':
          response = await http.delete(uri, headers: requestHeaders, body: body != null ? jsonEncode(body) : null)
              .timeout(const Duration(seconds: 10));
          break;
        default:
          throw UnsupportedError('Unsupported HTTP method: $method');
      }

      _logResponse(url: url, statusCode: response.statusCode, headers: response.headers, body: response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(response.body);
        return NetworkResponse(isSuccess: true, statusCode: response.statusCode, responseData: decoded);
      } else {
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: 'Error ${response.statusCode}: ${response.reasonPhrase}',
        );
      }
    } on SocketException catch (_) {
      _logError(url, 'No Internet Connection');
      return NetworkResponse(isSuccess: false, statusCode: -1, errorMessage: 'No Internet Connection');
    } on FormatException catch (_) {
      _logError(url, 'Invalid JSON format');
      return NetworkResponse(isSuccess: false, statusCode: -1, errorMessage: 'Invalid JSON format');
    } catch (e) {
      _logError(url, e.toString());
      return NetworkResponse(isSuccess: false, statusCode: -1, errorMessage: e.toString());
    }
  }

  void _logRequest(String method, String url, Map<String, dynamic>? headers, dynamic body) {
    _logger.i('''
🔗 [$method REQUEST]
URL: $url
Headers: ${headers ?? {}}
Body: ${body ?? {}}
''');
  }

  void _logResponse({
    required String url,
    required int statusCode,
    required Map<String, String> headers,
    required String body,
  }) {
    _logger.i('''
✅ [RESPONSE]
URL: $url
Status Code: $statusCode
Headers: $headers
Body: $body
''');
  }

  void _logError(String url, String errorMessage) {
    _logger.e('''
❌ [ERROR]
URL: $url
Message: $errorMessage
''');
  }
}