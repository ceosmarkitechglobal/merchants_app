// lib/features/dashboard/provider/dashboard_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merchantside_app/features/auth/providers/login_auth_providers.dart';
import 'package:merchantside_app/features/dashboard/data/merchant_api.dart';

enum DashboardStatus { initial, loading, success, error }

class DashboardState {
  final DashboardStatus status;
  final Map<String, dynamic>? data;
  final String? message;

  DashboardState({required this.status, this.data, this.message});

  factory DashboardState.initial() =>
      DashboardState(status: DashboardStatus.initial);

  DashboardState copyWith({
    DashboardStatus? status,
    Map<String, dynamic>? data,
    String? message,
  }) {
    return DashboardState(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }
}

class DashboardNotifier extends StateNotifier<DashboardState> {
  final MerchantDashboardApi api;
  final Ref ref;

  DashboardNotifier(this.api, this.ref) : super(DashboardState.initial());

  /// Fetch dashboard using token from AuthProvider
  Future<void> getDashboard() async {
    final token = ref.read(authProvider).token;
    if (token == null) {
      state = state.copyWith(
        status: DashboardStatus.error,
        message: 'User not logged in',
      );
      return;
    }

    try {
      state = state.copyWith(status: DashboardStatus.loading);
      final dashboardData = await api.fetchDashboard(token);
      state = state.copyWith(
        status: DashboardStatus.success,
        data: dashboardData,
      );
    } catch (e) {
      state = state.copyWith(
        status: DashboardStatus.error,
        message: e.toString(),
      );
    }
  }
}

final dashboardProvider =
    StateNotifierProvider<DashboardNotifier, DashboardState>(
      (ref) => DashboardNotifier(MerchantDashboardApi(), ref),
    );
