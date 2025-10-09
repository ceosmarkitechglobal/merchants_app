// lib/features/profile/data/profile_api.dart
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ProfileApi {
  static const String _baseUrl =
      "https://telugu-net-backend2.onrender.com/api/merchants";
  static final _storage = FlutterSecureStorage();

  static Future<Map<String, dynamic>> getProfile() async {
    final token = await _storage.read(key: 'jwt_token');
    if (token == null) throw Exception("User not logged in");

    final response = await http.get(
      Uri.parse("$_baseUrl/profile"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return body;
    } else {
      throw Exception("Failed to fetch profile");
    }
  }
}
