import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_config.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  String? token;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('access_token');
  }

  Future<void> saveToken(String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', accessToken);
    await prefs.setString('refresh_token', refreshToken);
    token = accessToken;
  }

  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
    token = null;
  }

  Map<String, String> _getHeaders({bool withAuth = true}) {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (withAuth && token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Future<Map<String, dynamic>> get(String endpoint, {bool withAuth = true}) async {
    final url = '${ApiConfig.baseUrl}$endpoint';
    final headers = _getHeaders(withAuth: withAuth);
    print('httpapi: GET $url');
    print('httpapi: Headers: $headers');
    
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      ).timeout(const Duration(seconds: 30));
      
      print('httpapi: Response status: ${response.statusCode}');
      print('httpapi: Response body: ${response.body}');
      
      return _handleResponse(response);
    } catch (e) {
      print('httpapi: Request failed with error: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> post(String endpoint, {Object? body, bool withAuth = true}) async {
    final url = '${ApiConfig.baseUrl}$endpoint';
    final headers = _getHeaders(withAuth: withAuth);
    print('httpapi: POST $url');
    print('httpapi: Headers: $headers');
    print('httpapi: Body: ${jsonEncode(body)}');
    
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      ).timeout(const Duration(seconds: 30));
      
      print('httpapi: Response status: ${response.statusCode}');
      print('httpapi: Response body: ${response.body}');
      
      return _handleResponse(response);
    } catch (e) {
      print('httpapi: Request failed with error: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> put(String endpoint, {Object? body, bool withAuth = true}) async {
    final url = '${ApiConfig.baseUrl}$endpoint';
    final headers = _getHeaders(withAuth: withAuth);
    print('httpapi: PUT $url');
    print('httpapi: Headers: $headers');
    print('httpapi: Body: ${jsonEncode(body)}');
    
    try {
      final response = await http.put(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      ).timeout(const Duration(seconds: 30));
      
      print('httpapi: Response status: ${response.statusCode}');
      print('httpapi: Response body: ${response.body}');
      
      return _handleResponse(response);
    } catch (e) {
      print('httpapi: Request failed with error: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> delete(String endpoint, {bool withAuth = true}) async {
    final url = '${ApiConfig.baseUrl}$endpoint';
    final headers = _getHeaders(withAuth: withAuth);
    print('httpapi: DELETE $url');
    print('httpapi: Headers: $headers');
    
    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: headers,
      ).timeout(const Duration(seconds: 30));
      
      print('httpapi: Response status: ${response.statusCode}');
      print('httpapi: Response body: ${response.body}');
      
      return _handleResponse(response);
    } catch (e) {
      print('httpapi: Request failed with error: $e');
      rethrow;
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    Map<String, dynamic> data;
    try {
      data = jsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      print('httpapi: Failed to decode response body: $e');
      data = {'message': 'Failed to decode response' };
    }
    
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    } else {
      throw ApiException(
        message: data['message'] ?? data['detail'] ?? '请求失败',
        code: response.statusCode,
      );
    }
  }
}

class ApiException implements Exception {
  final String message;
  final int code;

  ApiException({required this.message, required this.code});

  @override
  String toString() => 'ApiException: $message (code: $code)';
}
