import 'dart:convert';

import 'package:app/model/places.dart';
import 'package:app/widgets/hotel/image_card.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HotelImageCards extends StatefulWidget {
  @override
  State<HotelImageCards> createState() => _HotelImageCards();
}

class _HotelImageCards extends State<HotelImageCards> {
  List data = [];
  @override
  void initState() {
    super.initState();
    _getPlaces();
  }

  void _getPlaces() async {
    final response = await http
        .get(Uri.parse('http://localhost:8080/api/hotel/getAllHotel'));
    if (response.statusCode == 200) {
      var _data = json.decode(utf8.decode(response.body.codeUnits));
      var nlist = [for (int i = 0; i < _data.length; i++) _data[i]];
      nlist.sort((b, a) => a['id'].compareTo(b['id']));
      setState(() {
        data = nlist;
      });
    } else {
      print('error');
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Place> places = [
      for (int i = 0; i < data.length; i++)
        Place(
            place: '${data[i]['hotelName']}',
            image: '${data[i]['images'][0]['imagePath']}',
            days: '${data[i]['hotelRating']}',
            content: '${data[i]['id']}'),
      // Place(place: 'alo', image: '1.jpeg', days: '7'),
    ];

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
            content: places[index].content,
          );
        },
      ),
    );
  }
}
