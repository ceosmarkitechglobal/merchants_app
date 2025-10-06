import 'package:merchantside_app/features/ads/data/ad_model.dart';

class CreateAdRepository {
  Future<bool> createAd(CreateAdModel ad) async {
    await Future.delayed(const Duration(seconds: 1));
    return true; // mock success
  }
}
