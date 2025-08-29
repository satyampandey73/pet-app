import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient {
  final Dio _dio = Dio();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final String _baseUrl =
      'http://127.0.0.1:8000'; // Update with your FastAPI server URL

  ApiClient() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.read(key: 'token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );
  }

  Future<Response> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/auth/login',
        data: {'email': email, 'password': password},
      );
      print('Debug - Login response: ${response.data}');

      if (response.statusCode == 200 && response.data['access_token'] != null) {
        // FastAPI typically returns token as 'access_token'
        final token = response.data['access_token'];
        print('Debug - Storing token: $token');
        await _storage.write(key: 'token', value: token);
      } else {
        print('Debug - No token in response: ${response.data}');
      }
      return response;
    } catch (e) {
      print('Debug - Login error: $e');
      rethrow;
    }
  }

  Future<Response> register(String email, String password) async {
    try {
      return await _dio.post(
        '$_baseUrl/auth/register',
        data: {'email': email, 'password': password},
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getPets() async {
    try {
      // Debug: Print token
      final token = await _storage.read(key: 'token');
      print('Debug - Token being used: $token');

      final response = await _dio.get('$_baseUrl/pets');
      print('Debug - Response status: ${response.statusCode}');
      print('Debug - Response headers: ${response.headers}');
      return response;
    } catch (e) {
      print('Debug - Error in getPets: $e');
      rethrow;
    }
  }

  Future<Response> addPet(Map<String, dynamic> petData) async {
    try {
      return await _dio.post('$_baseUrl/pets', data: petData);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: 'token');
  }
}
