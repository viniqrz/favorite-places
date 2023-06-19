class Place {
  Place(
    this.name, {
    this.lat,
    this.lng,
    this.imageUrl,
  });

  double? lat;
  double? lng;
  String name;
  String? imageUrl;
}
