import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/api_response.dart';

class RestService {
  final String baseUrl;
  final FlutterSecureStorage _storage;

  RestService({String? baseUrl})
      : baseUrl = baseUrl ??
            dotenv.env['API_BASE_URL'] ??
            'https://localhost:7297/api',
        _storage = const FlutterSecureStorage();

  Future<String?> _getToken() async {
    return await _storage.read(key: 'token');
  }

  Map<String, String> _getHeaders({bool requiresAuth = true}) {
    return {
      'Content-Type': 'application/json',
      if (requiresAuth)
        'Authorization': 'Bearer TOKEN', // Will be replaced with actual token
    };
  }

  Future<ApiResponse<T>> get<T>(String endpoint,
      {bool requiresAuth = true,
      T Function(Map<String, dynamic>)? fromJson}) async {
    try {
      final token = requiresAuth ? await _getToken() : null;
      final headers = _getHeaders(requiresAuth: requiresAuth);
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }

      final response = await http.get(
        Uri.parse('$baseUrl/$endpoint'),
        headers: headers,
      );

      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return ApiResponse(
        version: '1.0.0',
        statusCode: 500,
        isError: true,
        message: e.toString(),
        responseException: ApiError(exceptionMessage: e.toString()),
      );
    }
  }

  Future<ApiResponse<T>> post<T>(
    String endpoint,
    dynamic body, {
    bool requiresAuth = true,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final token = requiresAuth ? await _getToken() : null;
      final headers = _getHeaders(requiresAuth: requiresAuth);
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }

      final response = await http.post(
        Uri.parse('$baseUrl/$endpoint'),
        headers: headers,
        body: json.encode(body),
      );

      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return ApiResponse(
        version: '1.0.0',
        statusCode: 500,
        isError: true,
        message: e.toString(),
        responseException: ApiError(exceptionMessage: e.toString()),
      );
    }
  }

  Future<ApiResponse<T>> put<T>(
    String endpoint,
    dynamic body, {
    bool requiresAuth = true,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final token = requiresAuth ? await _getToken() : null;
      final headers = _getHeaders(requiresAuth: requiresAuth);
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }

      final response = await http.put(
        Uri.parse('$baseUrl/$endpoint'),
        headers: headers,
        body: json.encode(body),
      );

      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return ApiResponse(
        version: '1.0.0',
        statusCode: 500,
        isError: true,
        message: e.toString(),
        responseException: ApiError(exceptionMessage: e.toString()),
      );
    }
  }

  Future<ApiResponse<T>> delete<T>(
    String endpoint, {
    bool requiresAuth = true,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final token = requiresAuth ? await _getToken() : null;
      final headers = _getHeaders(requiresAuth: requiresAuth);
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }

      final response = await http.delete(
        Uri.parse('$baseUrl/$endpoint'),
        headers: headers,
      );

      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return ApiResponse(
        version: '1.0.0',
        statusCode: 500,
        isError: true,
        message: e.toString(),
        responseException: ApiError(exceptionMessage: e.toString()),
      );
    }
  }

  ApiResponse<T> _handleResponse<T>(
    http.Response response,
    T Function(Map<String, dynamic>)? fromJson,
  ) {
    final responseData = json.decode(response.body);
    final apiResponse = ApiResponse<T>.fromJson(
      responseData,
      (json) =>
          fromJson != null ? fromJson(json as Map<String, dynamic>) : null as T,
    );

    return apiResponse;
  }
}
