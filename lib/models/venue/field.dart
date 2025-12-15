class Field {
  int? id;
  String? name;
  String? type;
  String? status;
  String? photoUrl;

  Field({this.id, this.name, this.type, this.status, this.photoUrl});

  @override
  String toString() {
    return 'Field(id: $id, name: $name, type: $type, status: $status, photoUrl: $photoUrl)';
  }

  factory Field.fromJson(Map<String, dynamic> json) => Field(
    id: json['id'] as int?,
    name: json['name'] as String?,
    type: json['type'] as String?,
    status: json['status'] as String?,
    photoUrl: json['photo_url'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'type': type,
    'status': status,
    'photo_url': photoUrl,
  };
}
