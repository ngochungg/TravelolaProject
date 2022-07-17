import 'dart:convert';

import 'package:app/model/places.dart';
import 'package:app/widgets/hotel_post/image_card.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ImageCards extends StatefulWidget {
  @override
  State<ImageCards> createState() => _ImageCardsState();
}

class _ImageCardsState extends State<ImageCards> {
  List data = [];
  @override
  void initState() {
    super.initState();
    _getPlaces();
  }

  void _getPlaces() async {
    final response =
        await http.get(Uri.parse('http://localhost:8080/api/posts/all'));
    if (response.statusCode == 200) {
      var _data = json.decode(response.body);
      var nlist = [
        for (int i = 0; i < _data.length; i++)
          if (_data[i]['user']['roles'][0]['id'] == 2) _data[i]
      ];
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
            place: '${data[i]['title']}',
            image: '${data[i]['imageUrl']}',
            days: '${data[i]['createdAt']}',
            content: '${data[i]['content']}'),
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
          );
        },
      ),
    );
  }
}
