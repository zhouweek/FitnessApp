import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_config.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  late final http.Client _httpClient;

  String? token;
  String? username;
  String? name;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('access_token');
    username = prefs.getString('username');
    name = prefs.getString('name');
    
    final ioClient = HttpClient()
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    _httpClient = IOClient(ioClient);
  }

  Future<void> saveToken(String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', accessToken);
    await prefs.setString('refresh_token', refreshToken);
    token = accessToken;
  }

  Future<void> saveUserInfo(Map<String, dynamic> userInfo) async {
    final prefs = await SharedPreferences.getInstance();
    if (userInfo.containsKey('name') && userInfo['name'] != null) {
      name = userInfo['name'].toString();
      await prefs.setString('name', name!);
    }
    if (userInfo.containsKey('username')) {
      username = userInfo['username'].toString();
      await prefs.setString('username', username!);
    }
    if (userInfo.containsKey('phone')) {
      await prefs.setString('phone', userInfo['phone'].toString());
    }
  }

  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
    await prefs.remove('username');
    await prefs.remove('name');
    await prefs.remove('phone');
    token = null;
    username = null;
    name = null;
  }

  bool get isLoggedIn => token != null;

  Map<String, String> _getHeaders({bool withAuth = true}) {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36',
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
      final response = await _httpClient.get(
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
      final response = await _httpClient.post(
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
      final response = await _httpClient.put(
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
      final response = await _httpClient.delete(
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
