import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merchantside_app/features/auth/data/auth_api.dart';

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
  AuthNotifier() : super(AuthState.initial());

  /// EMAIL/PASSWORD LOGIN
  Future<void> login(String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading);

    try {
      final response = await AuthApi.login(email, password);

      if (response.containsKey('token')) {
        state = state.copyWith(
          status: AuthStatus.success,
          message: "Login Successful ✅",
          token: response['token'],
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
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
