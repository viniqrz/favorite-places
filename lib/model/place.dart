class Place {
  Place({
    required this.lat,
    required this.lng,
    required this.name,
    this.imageUrl,
  });

  double lat;
  double lng;
  String name;
  String? imageUrl;
}
