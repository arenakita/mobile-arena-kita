import 'data.dart';

class Venue {
  String? status;
  String? message;
  Data? data;

  Venue({this.status, this.message, this.data});

  @override
  String toString() {
    return 'Venue(status: $status, message: $message, data: $data)';
  }

  factory Venue.fromJson(Map<String, dynamic> json) => Venue(
    status: json['status'] as String?,
    message: json['message'] as String?,
    data: json['data'] == null
        ? null
        : Data.fromJson(json['data'] as Map<String, dynamic>),
  );

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    'data': data?.toJson(),
  };
}
