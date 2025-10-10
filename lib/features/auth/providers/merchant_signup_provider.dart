// lib/features/auth/providers/merchant_signup_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merchantside_app/features/auth/data/signup_auth_api.dart';
import 'package:merchantside_app/core/storage/secure_storage_service.dart';

enum SignupStatus { idle, loading, success, error }

class SignupState {
  final SignupStatus status;
  final String? message;
  final String? token;

  SignupState({this.status = SignupStatus.idle, this.message, this.token});

  SignupState copyWith({SignupStatus? status, String? message, String? token}) {
    return SignupState(
      status: status ?? this.status,
      message: message ?? this.message,
      token: token ?? this.token,
    );
  }
}

class SignupNotifier extends StateNotifier<SignupState> {
  SignupNotifier() : super(SignupState());

  Future<void> signup({
    required String email,
    required String password,
    required String shopName,
    required String category,
    required String bankName,
    required String accountNumber,
    required String ifscCode,
    required String holderName,
  }) async {
    state = state.copyWith(status: SignupStatus.loading);

    try {
      final result = await MerchantSignupApi.signup(
        email: email,
        password: password,
        shopName: shopName,
        category: category,
        bankName: bankName,
        accountNumber: accountNumber,
        ifscCode: ifscCode,
        holderName: holderName,
      );

      if (result['success'] == true) {
        // ✅ If token exists, save it
        final token = result['token'];
        if (token != null) {
          await SecureStorageService.saveToken(token);
        }

        state = state.copyWith(
          status: SignupStatus.success,
          token: token,
          message: result['message'] ?? "Signup successful",
        );
      } else {
        // ❌ API returned success: false
        state = state.copyWith(
          status: SignupStatus.error,
          message: result['message'] ?? "Signup failed",
        );
      }
    } catch (e) {
      state = state.copyWith(status: SignupStatus.error, message: e.toString());
    }
  }
}

final signupProvider = StateNotifierProvider<SignupNotifier, SignupState>(
  (ref) => SignupNotifier(),
);
