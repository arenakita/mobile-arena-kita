import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../models/venue_model.dart';

class VenueService {
  final storage = const FlutterSecureStorage();
  static const String baseUrl = 'https://dev.api.arenakita.my.id/api/v1';

  Future<String?> _getToken() async {
    return await storage.read(key: 'token');
  }

  Future<List<Venue>> getOwnerVenues() async {
    final token = await _getToken();
    if (token == null) throw Exception('Authentication token not found');

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/owners/venues'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> venuesJson = data['data'];
        return venuesJson.map((json) => Venue.fromJson(json)).toList();
      } else {
        throw Exception('Gagal memuat venue');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Venue> addVenue({
    required String venueName,
    required String description,
    required String address,
    required String city,
    String? gpsCoordinate,
    required String openingTime,
    required String closingTime,
  }) async {
    final token = await _getToken();
    if (token == null) throw Exception('Authentication token not found');

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/owners/venues'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'venue_name': venueName,
          'description': description,
          'address': address,
          'city': city,
          'gps_coordinate': gpsCoordinate,
          'opening_time': openingTime,
          'closing_time': closingTime,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Venue.fromJson(data['data']);
      } else {
        throw Exception('Gagal menambahkan venue');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Venue> getVenueDetail(int venueId) async {
    final token = await _getToken();
    if (token == null) throw Exception('Authentication token not found');

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/owners/venues/$venueId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Venue.fromJson(data['data']);
      } else {
        throw Exception('Gagal memuat detail venue');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Venue> updateVenue({
    required int venueId,
    required String venueName,
    required String description,
    required String address,
    required String city,
    String? gpsCoordinate,
    required String openingTime,
    required String closingTime,
  }) async {
    final token = await _getToken();
    if (token == null) throw Exception('Authentication token not found');

    try {
      final response = await http.put(
        Uri.parse('$baseUrl/owners/venues/$venueId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'venue_name': venueName,
          'description': description,
          'address': address,
          'city': city,
          'gps_coordinate': gpsCoordinate,
          'opening_time': openingTime,
          'closing_time': closingTime,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Venue.fromJson(data['data']);
      } else {
        throw Exception('Gagal memperbarui venue');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<bool> deleteVenue(int venueId) async {
    final token = await _getToken();
    if (token == null) throw Exception('Authentication token not found');

    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/owners/venues/$venueId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Gagal menghapus venue');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
