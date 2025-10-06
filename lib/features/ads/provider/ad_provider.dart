import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merchantside_app/features/ads/data/ad_model.dart';
import 'package:merchantside_app/features/ads/data/ad_repository.dart';

final createAdRepoProvider = Provider((ref) => CreateAdRepository());

final createAdProvider = FutureProvider.family.autoDispose<bool, CreateAdModel>(
  (ref, ad) async {
    final repo = ref.read(createAdRepoProvider);
    return repo.createAd(ad);
  },
);
