// lib/features/ads/data/merchant_ads_api.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class MerchantAdsApi {
  static const String baseUrl =
      "https://telugu-net-backend2.onrender.com/api/merchants";

  static Future<Map<String, dynamic>> createAd({
    required String token,
    required String title,
    required String description,
    required String category,
    required String location,
    required List<Map<String, String>> media,
    required bool isPremium,
  }) async {
    final url = Uri.parse("$baseUrl/ads");
    final body = {
      "title": title,
      "description": description,
      "category": category,
      "location": location,
      "media": media,
      "isPremium": isPremium,
    };

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to create ad: ${response.body}");
    }
  }

  static Future<List<dynamic>> fetchAds({required String token}) async {
    final url = Uri.parse("$baseUrl/ads");
    final response = await http.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'] as List<dynamic>;
    } else {
      throw Exception("Failed to fetch ads: ${response.body}");
    }
  }
}
