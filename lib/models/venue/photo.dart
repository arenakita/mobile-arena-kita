class Photo {
  int? id;
  String? url;

  Photo({this.id, this.url});

  @override
  String toString() => 'Photo(id: $id, url: $url)';

  factory Photo.fromJson(Map<String, dynamic> json) =>
      Photo(id: json['id'] as int?, url: json['url'] as String?);

  Map<String, dynamic> toJson() => {'id': id, 'url': url};
}
