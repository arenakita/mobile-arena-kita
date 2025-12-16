import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../core/constants/api_constant.dart';
import '../models/dashboard_model.dart';
import '../models/dashboard_booking_model.dart';

class DashboardService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<String?> _getToken() async {
    return await _storage.read(key: 'token');
  }

  /// =============================
  /// DASHBOARD STATS
  /// =============================
  Future<DashboardStats> getDashboardStats() async {
    try {
      final token = await _getToken();

      final response = await http.get(
        Uri.parse(ApiConstants.dashboardStats),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return DashboardStats.fromJson(json['data']);
      } else {
        throw Exception('Gagal mengambil statistik');
      }
    } catch (e) {
      debugPrint('ERROR getDashboardStats: $e');
      rethrow;
    }
  }

  /// =============================
  /// DASHBOARD BOOKINGS
  /// =============================
  Future<List<Booking>> getDashboardBookings() async {
    try {
      final token = await _getToken();

      final response = await http.get(
        Uri.parse(ApiConstants.dashboardBookings),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final List list = json['data'];
        return list.map((e) => Booking.fromJson(e)).toList();
      } else {
        throw Exception('Gagal mengambil booking');
      }
    } catch (e) {
      debugPrint('ERROR getDashboardBookings: $e');
      rethrow;
    }
  }
}
