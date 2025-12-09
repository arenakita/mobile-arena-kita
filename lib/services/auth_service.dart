import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl = "https://dev.api.arenakita.my.id/api/v1/auth/owner"; 

  Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        body: {
          'email': email,
          'password': password,
        },
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String token = data['data']['token']; // attribute token pada response JSON
        
        // Simpan token ke memori HP
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        return true;
      } else {
        print("Login Gagal: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error koneksi: $e");
      return false;
    }
  }
}