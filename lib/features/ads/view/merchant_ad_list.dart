// lib/features/ads_list/view/merchant_ad_list.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../ads/provider/ad_provider.dart';

class MerchantAdsScreen extends ConsumerStatefulWidget {
  const MerchantAdsScreen({super.key});

  @override
  ConsumerState<MerchantAdsScreen> createState() => _MerchantAdsScreenState();
}

class _MerchantAdsScreenState extends ConsumerState<MerchantAdsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(merchantAdProvider.notifier).fetchAds();
    });
  }

  @override
  Widget build(BuildContext context) {
    final adState = ref.watch(merchantAdProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Ads"),
        backgroundColor: const Color(0xFF571094),
      ),
      body: Center(
        child: switch (adState.status) {
          AdStatus.loading => const CircularProgressIndicator(),
          AdStatus.error => Text("Error: ${adState.message}"),
          AdStatus.success =>
            adState.ads.isEmpty
                ? const Text("No ads available")
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: adState.ads.length,
                    itemBuilder: (context, index) {
                      final ad = adState.ads[index];
                      final media = ad['media'] as List<dynamic>? ?? [];

                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ad['title'] ?? '',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(ad['description'] ?? ''),
                              const SizedBox(height: 4),
                              Text("Category: ${ad['category'] ?? ''}"),
                              Text("Location: ${ad['location'] ?? ''}"),
                              Text("Status: ${ad['status'] ?? ''}"),
                              if (ad['isPremium'] == true)
                                const Text(
                                  "Premium Ad ✅",
                                  style: TextStyle(color: Colors.green),
                                ),
                              const SizedBox(height: 8),

                              // Media Section
                              SizedBox(
                                height: 150,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: media.length,
                                  itemBuilder: (context, i) {
                                    final item = media[i];
                                    if (item['type'] == 'image') {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          right: 8.0,
                                        ),
                                        child: Image.network(
                                          item['url'],
                                          width: 150,
                                          height: 150,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  const Icon(
                                                    Icons.broken_image,
                                                    size: 50,
                                                  ),
                                        ),
                                      );
                                    } else if (item['type'] == 'video') {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          right: 8.0,
                                        ),
                                        child: Container(
                                          width: 150,
                                          height: 150,
                                          color: Colors.black12,
                                          child: const Center(
                                            child: Icon(
                                              Icons.play_circle_fill,
                                              size: 50,
                                              color: Colors.blue,
                                            ),
                                          ),
                                        ),
                                      );
                                    } else {
                                      return const SizedBox.shrink();
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          _ => const SizedBox.shrink(),
        },
      ),
    );
  }
}
