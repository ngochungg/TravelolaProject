class Place {
  String place;
  String image;
  String days;

  Place({required this.place, required this.image, required this.days});

  static fromJson(place) {
    return Place(
      place: place['place'],
      image: place['image'],
      days: place['days'],
    );
  }
}
