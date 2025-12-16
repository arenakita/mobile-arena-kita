class Booking {
  final String venueName;
  final String fieldName;
  final String bookingDate;
  final String startTime;
  final String endTime;
  final String totalPrice;
  final String status;

  Booking({
    required this.venueName,
    required this.fieldName,
    required this.bookingDate,
    required this.startTime,
    required this.endTime,
    required this.totalPrice,
    required this.status,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      venueName: json['field_info']?['venue_name'] ?? '-',
      fieldName: json['field_info']?['field_name'] ?? '-',
      bookingDate: json['booking_date'] ?? '-',
      startTime: json['start_time'] ?? '-',
      endTime: json['end_time'] ?? '-',
      totalPrice: json['total_price'] ?? '-',
      status: json['status'] ?? '-',
    );
  }
}
