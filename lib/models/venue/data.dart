import 'field.dart';
import 'photo.dart';

class Data {
  int? id;
  String? venueName;
  String? description;
  String? address;
  String? city;
  dynamic gpsCoordinate;
  String? openingTime;
  String? closingTime;
  dynamic thumbnail;
  List<Photo>? photos;
  List<Field>? fields;

  Data({
    this.id,
    this.venueName,
    this.description,
    this.address,
    this.city,
    this.gpsCoordinate,
    this.openingTime,
    this.closingTime,
    this.thumbnail,
    this.photos,
    this.fields,
  });

  @override
  String toString() {
    return 'Data(id: $id, venueName: $venueName, description: $description, address: $address, city: $city, gpsCoordinate: $gpsCoordinate, openingTime: $openingTime, closingTime: $closingTime, thumbnail: $thumbnail, photos: $photos, fields: $fields)';
  }

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json['id'] as int?,
    venueName: json['venue_name'] as String?,
    description: json['description'] as String?,
    address: json['address'] as String?,
    city: json['city'] as String?,
    gpsCoordinate: json['gps_coordinate'] as dynamic,
    openingTime: json['opening_time'] as String?,
    closingTime: json['closing_time'] as String?,
    thumbnail: json['thumbnail'] as dynamic,
    photos: (json['photos'] as List<dynamic>?)
        ?.map((e) => Photo.fromJson(e as Map<String, dynamic>))
        .toList(),
    fields: (json['fields'] as List<dynamic>?)
        ?.map((e) => Field.fromJson(e as Map<String, dynamic>))
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'venue_name': venueName,
    'description': description,
    'address': address,
    'city': city,
    'gps_coordinate': gpsCoordinate,
    'opening_time': openingTime,
    'closing_time': closingTime,
    'thumbnail': thumbnail,
    'photos': photos?.map((e) => e.toJson()).toList(),
    'fields': fields?.map((e) => e.toJson()).toList(),
  };
}
