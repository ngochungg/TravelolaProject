import 'package:app/model/places.dart';
import 'package:app/widgets/image_card.dart';
import 'package:flutter/material.dart';

class ImageCards extends StatefulWidget {
  @override
  State<ImageCards> createState() => _ImageCardsState();
}

class _ImageCardsState extends State<ImageCards> {
  List<Place> places = [
    Place(place: 'Austia', image: '1.jpeg', days: 7),
    Place(place: 'India', image: '2.jpeg', days: 12),
    Place(place: 'Bali', image: '3.jpeg', days: 3),
    Place(place: 'Austia', image: '1.jpeg', days: 7),
    Place(place: 'India', image: '2.jpeg', days: 12),
    Place(place: 'Bali', image: '3.jpeg', days: 3),
  ];
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: places.length,
        itemBuilder: (_, index) {
          return ImageCard(
            place: places[index],
            name: places[index].place,
            days: places[index].days,
            picture: places[index].image,
          );
        },
      ),
    );
  }
}
