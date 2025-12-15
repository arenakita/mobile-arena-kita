import 'dart:convert';

List<Transaction> transactionFromJson(String str) => List<Transaction>.from(json.decode(str)['data'].map((x) => Transaction.fromJson(x)));

class Transaction {
  final int id;
  final String paymentMethod;
  final String paymentStatus;
  final String paymentTime;
  final TransactionBooking booking;

  Transaction({
    required this.id,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.paymentTime,
    required this.booking,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        id: json['id'],
        paymentMethod: json['payment_method'],
        paymentStatus: json['payment_status'],
        paymentTime: json['payment_time'],
        booking: TransactionBooking.fromJson(json['booking']),
      );
}

class TransactionBooking {
  final int id;
  final String bookingDate;
  final String startTime;
  final String endTime;
  final String totalPrice;
  final int rawTotalPrice;
  final String status;
  final String createdAt;
  final String createdAtHuman;
  final TransactionUser user;
  final TransactionFieldInfo fieldInfo;

  TransactionBooking({
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

  factory TransactionBooking.fromJson(Map<String, dynamic> json) =>
      TransactionBooking(
        id: json['id'],
        bookingDate: json['booking_date'],
        startTime: json['start_time'],
        endTime: json['end_time'],
        totalPrice: json['total_price'],
        rawTotalPrice: json['raw_total_price'],
        status: json['status'],
        createdAt: json['created_at'],
        createdAtHuman: json['created_at_human'],
        user: TransactionUser.fromJson(json['user']),
        fieldInfo: TransactionFieldInfo.fromJson(json['field_info']),
      );
}

class TransactionUser {
  final int id;
  final String name;
  final String email;
  final String? phone;

  TransactionUser({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
  });

  factory TransactionUser.fromJson(Map<String, dynamic> json) =>
      TransactionUser(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        phone: json['phone'],
      );
}

class TransactionFieldInfo {
  final String fieldName;
  final String sportType;
  final String venueName;

  TransactionFieldInfo({
    required this.fieldName,
    required this.sportType,
    required this.venueName,
  });

  factory TransactionFieldInfo.fromJson(Map<String, dynamic> json) =>
      TransactionFieldInfo(
        fieldName: json['field_name'],
        sportType: json['sport_type'],
        venueName: json['venue_name'],
      );
}
