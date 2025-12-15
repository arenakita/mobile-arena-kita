import 'dart:convert';

List<Booking> bookingFromJson(String str) => List<Booking>.from(json.decode(str)['data'].map((x) => Booking.fromJson(x)));

class Booking {
    final int id;
    final DateTime bookingDate;
    final String startTime;
    final String endTime;
    final String totalPrice;
    final int rawTotalPrice;
    final String status;
    final String createdAt;
    final String createdAtHuman;
    final User user;
    final FieldInfo fieldInfo;

    Booking({
        required this.id,
        required this.bookingDate,
        required this.startTime,
        required this.endTime,
        required this.totalPrice,
        required this.rawTotalPrice,
        required this.status,
        required this.createdAt,
        required this.createdAtHuman,
        required this.user,
        required this.fieldInfo,
    });

    factory Booking.fromJson(Map<String, dynamic> json) => Booking(
        id: json["id"],
        bookingDate: DateTime.parse(json["booking_date"]),
        startTime: json["start_time"],
        endTime: json["end_time"],
        totalPrice: json["total_price"],
        rawTotalPrice: json["raw_total_price"],
        status: json["status"],
        createdAt: json["created_at"],
        createdAtHuman: json["created_at_human"],
        user: User.fromJson(json["user"]),
        fieldInfo: FieldInfo.fromJson(json["field_info"]),
    );
}

class FieldInfo {
    final String fieldName;
    final String sportType;
    final String venueName;

    FieldInfo({
        required this.fieldName,
        required this.sportType,
        required this.venueName,
    });

    factory FieldInfo.fromJson(Map<String, dynamic> json) => FieldInfo(
        fieldName: json["field_name"],
        sportType: json["sport_type"],
        venueName: json["venue_name"],
    );
}

class User {
    final int id;
    final String name;
    final String email;
    final dynamic phone;

    User({
        required this.id,
        required this.name,
        required this.email,
        required this.phone,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
    );
}
