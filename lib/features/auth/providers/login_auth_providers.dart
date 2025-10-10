// lib/features/auth/providers/login_auth_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merchantside_app/core/storage/secure_storage_service.dart';

import '../data/login_auth_api.dart';

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
  AuthNotifier() : super(AuthState.initial()) {
    _loadToken();
  }

  Future<void> _loadToken() async {
    final token = await SecureStorageService.getToken();
    if (token != null) {
      state = state.copyWith(status: AuthStatus.success, token: token);
    }
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      print("📡 Calling login API: $email / $password");
      final response = await AuthApi.login(email, password);
      print("📥 Login API Response: $response");

      if (response.containsKey('token')) {
        final token = response['token'];
        await SecureStorageService.saveToken(token);
        state = state.copyWith(status: AuthStatus.success, token: token);
        print("✅ Login successful, token saved");
      } else {
        state = state.copyWith(
          status: AuthStatus.error,
          message: response['message'] ?? "Login failed",
        );
        print("❌ Login failed: ${response['message']}");
      }
    } catch (e) {
      state = state.copyWith(status: AuthStatus.error, message: e.toString());
      print("❌ Login Exception: $e");
    }
  }

  Future<void> logout() async {
    await SecureStorageService.deleteToken();
    state = state.copyWith(token: null, status: AuthStatus.initial);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
