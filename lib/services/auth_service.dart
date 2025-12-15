import 'dart:convert';
import 'package:arena_kita/core/constants/api_constant.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final storage = FlutterSecureStorage();

  Future<bool> isLoggedIn() async {
    final token = await storage.read(key: 'token');
    return token != null;
  }

  Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.login),
        body: {
          'email': email,
          'password': password,
        },
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String token = data['data']['token']; // attribute token pada response JSON

        await storage.write(key: 'token', value: token);
        return true;
      } else {
        debugPrint("Login Gagal: ${response.body}");
        return false;
      }
    } catch (e) {
      debugPrint("Error koneksi: $e");
      return false;
    }
  }

  Future<void> logout() async {
    await storage.delete(key: 'token');
  }
}