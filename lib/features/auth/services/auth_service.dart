import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/services/rest_service.dart';
import '../models/auth_models.dart';

class AuthService {
  final RestService _restService;
  final FlutterSecureStorage _storage;

  AuthService({RestService? restService})
      : _restService = restService ?? RestService(),
        _storage = const FlutterSecureStorage();

  Future<bool> login(String username, String password) async {
    final response = await _restService.post<TokenResponseDto>(
      'Auth/login',
      UserDto(username: username, password: password).toJson(),
      requiresAuth: false,
      fromJson: (json) => TokenResponseDto.fromJson(json),
    );

    if (!response.isError && response.result != null) {
      await _storage.write(key: 'token', value: response.result!.token);
      await _storage.write(
          key: 'refresh_token', value: response.result!.refreshToken);
      await _storage.write(
          key: 'user_id', value: response.result!.id.toString());
      return true;
    }
    return false;
  }

  Future<bool> register(String username, String password, String firstName,
      String lastName, String email) async {
    final response = await _restService.post<void>(
      'Auth/register',
      CreateUserDto(
        username: username,
        password: password,
        firstName: firstName,
        lastName: lastName,
        email: email,
        role: 'User', // Default role
      ).toJson(),
      requiresAuth: false,
    );

    return !response.isError;
  }

  Future<bool> refreshToken() async {
    final token = await _storage.read(key: 'token');
    final refreshToken = await _storage.read(key: 'refresh_token');
    final userId = await _storage.read(key: 'user_id');

    if (token == null || refreshToken == null || userId == null) {
      return false;
    }

    final response = await _restService.post<TokenResponseDto>(
      'Auth/refresh-token',
      RefreshTokenRequestDto(
        userId: int.parse(userId),
        refreshToken: refreshToken,
      ).toJson(),
      requiresAuth: false,
      fromJson: (json) => TokenResponseDto.fromJson(json),
    );

    if (!response.isError && response.result != null) {
      await _storage.write(key: 'token', value: response.result!.token);
      await _storage.write(
          key: 'refresh_token', value: response.result!.refreshToken);
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    await _storage.delete(key: 'token');
    await _storage.delete(key: 'refresh_token');
    await _storage.delete(key: 'user_id');
  }

  Future<bool> isAuthenticated() async {
    final token = await _storage.read(key: 'token');
    return token != null;
  }
}
