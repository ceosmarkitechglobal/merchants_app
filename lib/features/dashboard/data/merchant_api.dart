// lib/features/dashboard/data/merchant_dashboard_api.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class MerchantDashboardApi {
  final String baseUrl = "https://telugu-net-backend2.onrender.com";

  Future<Map<String, dynamic>> fetchDashboard(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/merchants/dashboard'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'];
    } else {
      throw Exception('Failed to load dashboard');
    }
  }
}
