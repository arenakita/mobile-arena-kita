class Venue {
  final int id;
  final String venueName;
  final String description;
  final String address;
  final String city;
  final String? gpsCoordinate;
  final String openingTime;
  final String closingTime;
  final String? thumbnail;
  final List<VenuePhoto>? photos;
  final List<Field>? fields;

  Venue({
    required this.id,
    required this.venueName,
    required this.description,
    required this.address,
    required this.city,
    this.gpsCoordinate,
    required this.openingTime,
    required this.closingTime,
    this.thumbnail,
    this.photos,
    this.fields,
  });

  factory Venue.fromJson(Map<String, dynamic> json) {
    return Venue(
      id: json['id'],
      venueName: json['venue_name'],
      description: json['description'],
      address: json['address'],
      city: json['city'],
      gpsCoordinate: json['gps_coordinate'],
      openingTime: json['opening_time'],
      closingTime: json['closing_time'],
      thumbnail: json['thumbnail'],
      photos: json['photos'] != null
          ? (json['photos'] as List)
                .map((photo) => VenuePhoto.fromJson(photo))
                .toList()
          : null,
      fields: json['fields'] != null
          ? (json['fields'] as List)
                .map((field) => Field.fromJson(field))
                .toList()
          : null,
    );
  }
}

class VenuePhoto {
  final int id;
  final String url;

  VenuePhoto({required this.id, required this.url});

  factory VenuePhoto.fromJson(Map<String, dynamic> json) {
    return VenuePhoto(id: json['id'], url: json['url']);
  }
}

class Field {
  final int id;
  final String name;
  final String type;
  final String status;
  final String? photoUrl;

  Field({
    required this.id,
    required this.name,
    required this.type,
    required this.status,
    this.photoUrl,
  });

  factory Field.fromJson(Map<String, dynamic> json) {
    return Field(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      status: json['status'],
      photoUrl: json['photo_url'],
    );
  }
}
