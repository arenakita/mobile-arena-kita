import 'package:arena_kita/core/constants/api_constant.dart';
import 'package:arena_kita/core/dynamics/api_dynamic.dart';
import 'package:arena_kita/models/booking_model.dart';
import 'package:arena_kita/models/transaction_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class BookingService {
  final storage = const FlutterSecureStorage();

  Future<String?> _getToken() async {
    return await storage.read(key: 'token');
  }

  Future<List<Booking>> getBookings() async {
    final token = await _getToken();
    if (token == null) throw Exception('Authentication token not found');

    final response = await http.get(
      Uri.parse(ApiConstants.bookings),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return bookingFromJson(response.body);
    } else {
      debugPrint('Failed to load bookings: ${response.body}');
      throw Exception('Failed to load bookings');
    }
  }

  Future<bool> approveBooking(int bookingId) async {
    final token = await _getToken();
    if (token == null) throw Exception('Authentication token not found');

    final response = await http.post(
      Uri.parse(ApiDynamic.approveBookings(bookingId)),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );
    
    return response.statusCode == 200;
  }

  Future<bool> rejectBooking(int bookingId) async {
    final token = await _getToken();
    if (token == null) throw Exception('Authentication token not found');

    final response = await http.post(
      Uri.parse(ApiDynamic.rejectBookings(bookingId)),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    return response.statusCode == 200;
  }

  Future<List<Transaction>> getTransactions() async {
    final token = await _getToken();
    if (token == null) throw Exception('Authentication token not found');

    final response = await http.get(
      Uri.parse(ApiConstants.transactions),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return transactionFromJson(response.body);
    } else {
      debugPrint('Failed to load transactions: ${response.body}');
      throw Exception('Failed to load transactions');
    }
  }
}
