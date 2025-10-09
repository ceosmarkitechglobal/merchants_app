// lib/features/ads/provider/ad_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merchantside_app/features/ads/data/ads_api.dart';
import '../../auth/providers/auth_providers.dart';

enum AdStatus { initial, loading, success, error }

class AdState {
  final AdStatus status;
  final String? message;
  final List<dynamic> ads;

  AdState({required this.status, this.message, this.ads = const []});

  factory AdState.initial() => AdState(status: AdStatus.initial);

  AdState copyWith({AdStatus? status, String? message, List<dynamic>? ads}) {
    return AdState(
      status: status ?? this.status,
      message: message ?? this.message,
      ads: ads ?? this.ads,
    );
  }
}

class MerchantAdNotifier extends StateNotifier<AdState> {
  final Ref ref;
  MerchantAdNotifier(this.ref) : super(AdState.initial());

  Future<void> createAd({
    required String title,
    required String description,
    required String category,
    required String location,
    required List<Map<String, String>> media,
    required bool isPremium,
  }) async {
    state = state.copyWith(status: AdStatus.loading);
    try {
      final token = ref.read(authProvider).token;
      if (token == null) throw Exception("Unauthorized");

      await MerchantAdsApi.createAd(
        token: token,
        title: title,
        description: description,
        category: category,
        location: location,
        media: media,
        isPremium: isPremium,
      );

      state = state.copyWith(status: AdStatus.success, message: "Ad created ✅");
      await fetchAds(); // refresh list after creation
    } catch (e) {
      state = state.copyWith(status: AdStatus.error, message: e.toString());
    }
  }

  Future<void> fetchAds() async {
    state = state.copyWith(status: AdStatus.loading);
    try {
      final token = ref.read(authProvider).token;
      if (token == null) throw Exception("Unauthorized");

      final ads = await MerchantAdsApi.fetchAds(token: token);
      state = state.copyWith(status: AdStatus.success, ads: ads);
    } catch (e) {
      state = state.copyWith(status: AdStatus.error, message: e.toString());
    }
  }
}

final merchantAdProvider = StateNotifierProvider<MerchantAdNotifier, AdState>((
  ref,
) {
  return MerchantAdNotifier(ref);
});
