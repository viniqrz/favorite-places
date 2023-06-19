class Place {
  Place({
    required this.x,
    required this.y,
    required this.name,
    this.imageUrl,
  });

  double x;
  double y;
  String name;
  String? imageUrl;
}
