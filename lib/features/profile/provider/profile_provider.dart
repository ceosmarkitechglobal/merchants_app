// lib/features/profile/provider/profile_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merchantside_app/features/profile/data/merchant_profile_api.dart';

enum ProfileStatus { initial, loading, success, error }

class ProfileState {
  final ProfileStatus status;
  final String? message;
  final Map<String, dynamic>? data;

  ProfileState({required this.status, this.message, this.data});

  factory ProfileState.initial() => ProfileState(status: ProfileStatus.initial);

  ProfileState copyWith({
    ProfileStatus? status,
    String? message,
    Map<String, dynamic>? data,
  }) {
    return ProfileState(
      status: status ?? this.status,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }
}

class ProfileNotifier extends StateNotifier<ProfileState> {
  ProfileNotifier() : super(ProfileState.initial());

  Future<void> fetchProfile() async {
    state = state.copyWith(status: ProfileStatus.loading);
    try {
      final response = await ProfileApi.getProfile();
      if (response['success'] == true) {
        state = state.copyWith(
          status: ProfileStatus.success,
          data: response['data'],
        );
      } else {
        state = state.copyWith(
          status: ProfileStatus.error,
          message: "Failed to fetch profile",
        );
      }
    } catch (e) {
      state = state.copyWith(
        status: ProfileStatus.error,
        message: e.toString(),
      );
    }
  }
}

final profileProvider = StateNotifierProvider<ProfileNotifier, ProfileState>((
  ref,
) {
  return ProfileNotifier();
});
