class Venue {
  final int id;
  final String name;
  final String status;

  Venue({required this.id, required this.name, required this.status});

  // Factory method untuk mengubah JSON jadi Object
  factory Venue.fromJson(Map<String, dynamic> json) {
    return Venue(
      id: json['id'],
      name: json['name'],
      status: json['status'],
    );
  }
}