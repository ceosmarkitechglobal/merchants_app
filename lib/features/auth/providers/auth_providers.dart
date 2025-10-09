import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../data/auth_api.dart';

enum AuthStatus { initial, loading, success, error }

class AuthState {
  final AuthStatus status;
  final String? message;
  final String? token;

  AuthState({required this.status, this.message, this.token});

  factory AuthState.initial() => AuthState(status: AuthStatus.initial);

  AuthState copyWith({AuthStatus? status, String? message, String? token}) {
    return AuthState(
      status: status ?? this.status,
      message: message ?? this.message,
      token: token ?? this.token,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final _storage = const FlutterSecureStorage();

  AuthNotifier() : super(AuthState.initial()) {
    _loadToken();
  }

  Future<void> _loadToken() async {
    final token = await _storage.read(key: 'jwt_token');
    if (token != null) {
      state = state.copyWith(status: AuthStatus.success, token: token);
    }
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final response = await AuthApi.login(email, password);
      if (response.containsKey('token')) {
        final token = response['token'];
        await _storage.write(key: 'jwt_token', value: token);
        state = state.copyWith(
          status: AuthStatus.success,
          message: "Login Successful ✅",
          token: token,
        );
      } else {
        state = state.copyWith(
          status: AuthStatus.error,
          message: response['message'] ?? "Login failed",
        );
      }
    } catch (e) {
      state = state.copyWith(status: AuthStatus.error, message: e.toString());
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: 'jwt_token');
    state = state.copyWith(token: null, status: AuthStatus.initial);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
