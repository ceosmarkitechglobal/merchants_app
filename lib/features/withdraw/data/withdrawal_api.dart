// lib/features/withdrawal/data/withdraw_api.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class WithdrawApi {
  Future<Map<String, dynamic>> withdraw(String token, double amount) async {
    final url = Uri.parse(
      'https://telugu-net-backend2.onrender.com/api/merchants/withdrawals',
    );

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'amount': amount}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to withdraw: ${response.body}');
    }
  }
}
