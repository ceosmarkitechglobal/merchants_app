// lib/features/auth/data/merchant_signup_api.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MerchantSignupApi {
  static const String baseUrl = "https://telugu-net-backend2.onrender.com/api";
  static const _storage = FlutterSecureStorage();

  static Future<Map<String, dynamic>> signup({
    required String email,
    required String password,
    required String shopName,
    required String category,
    required String bankName,
    required String accountNumber,
    required String ifscCode,
    required String holderName,
  }) async {
    final url = Uri.parse('$baseUrl/merchants/signup');

    final body = {
      "email": email,
      "password": password,
      "shop_name": shopName,
      "category": category,
      "bank_details": {
        "bank_name": bankName,
        "account_number": accountNumber,
        "ifsc_code": ifscCode,
        "holder_name": holderName,
      },
    };

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (data['token'] != null) {
        await _storage.write(key: 'jwtToken', value: data['token']);
      }
      return {'success': true, 'data': data};
    } else {
      return {
        'success': false,
        'message': data['message'] ?? 'Signup failed, please try again.',
      };
    }
  }
}
