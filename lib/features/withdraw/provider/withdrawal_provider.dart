// lib/features/withdrawal/provider/withdraw_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merchantside_app/features/auth/providers/login_auth_providers.dart';
import 'package:merchantside_app/features/withdraw/data/withdrawal_api.dart';

enum WithdrawStatus { initial, loading, success, error }

class WithdrawState {
  final WithdrawStatus status;
  final String? message;

  WithdrawState({required this.status, this.message});

  factory WithdrawState.initial() =>
      WithdrawState(status: WithdrawStatus.initial);

  WithdrawState copyWith({WithdrawStatus? status, String? message}) {
    return WithdrawState(
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }
}

class WithdrawNotifier extends StateNotifier<WithdrawState> {
  final Ref ref;
  final WithdrawApi api;

  WithdrawNotifier(this.ref, this.api) : super(WithdrawState.initial());

  Future<void> withdraw(double amount) async {
    final token = ref.read(authProvider).token;
    if (token == null) {
      state = state.copyWith(
        status: WithdrawStatus.error,
        message: 'User not logged in',
      );
      return;
    }

    try {
      state = state.copyWith(status: WithdrawStatus.loading);
      final response = await api.withdraw(token, amount);
      state = state.copyWith(
        status: WithdrawStatus.success,
        message: response['message'] ?? 'Withdrawal successful',
      );
    } catch (e) {
      state = state.copyWith(
        status: WithdrawStatus.error,
        message: e.toString(),
      );
    }
  }

  void reset() {
    state = WithdrawState.initial();
  }
}

final withdrawProvider = StateNotifierProvider<WithdrawNotifier, WithdrawState>(
  (ref) => WithdrawNotifier(ref, WithdrawApi()),
);
