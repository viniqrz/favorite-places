class Place {
  Place(
    this.name, {
    this.lat,
    this.lng,
    this.imagePath,
    this.id,
    this.createdAt,
    this.updatedAt,
    this.address,
  }) {
    id = id ?? DateTime.now().millisecondsSinceEpoch;
    createdAt = createdAt ?? DateTime.now().toIso8601String();
    updatedAt = updatedAt ?? DateTime.now().toIso8601String();
  }

  String name;
  int? id;

  double? lat;
  double? lng;
  String? imagePath;
  String? address;

  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'lat': lat,
      'lng': lng,
      'image_path': imagePath,
      'address': address,
    };
  }

  factory Place.fromMap(Map<String, dynamic> map) {
    return Place(
      map['name'],
      id: map['id'],
      lat: map['lat'],
      lng: map['lng'],
      imagePath: map['image_path'],
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
      address: map['address'],
    );
  }

  @override
  String toString() {
    return '''
    {
      name: $name, id: $id,
      lat: $lat,
      lng: $lng,
      imagePath: $imagePath,
      createdAt: $createdAt,
      updatedAt: $updatedAt,
      address: $address
    }
    ''';
  }
}
