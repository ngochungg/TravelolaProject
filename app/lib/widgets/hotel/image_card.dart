// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:convert';

import 'package:app/controller/apiController.dart';
import 'package:app/model/places.dart';
import 'package:app/screens/Hotel/hotel_details.dart';
import 'package:app/screens/details.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class ImageCard extends StatefulWidget {
  final String name;
  final String days;
  final String picture;
  final Place place;
  final String content;

  const ImageCard({
    required this.name,
    required this.days,
    required this.picture,
    required this.place,
    required this.content,
  });

  @override
  State<ImageCard> createState() => _ImageCardState();
}

class _ImageCardState extends State<ImageCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(4),
        child: InkWell(
            onTap: () async {
              var response =
                  await http.get(Uri.parse(getRoomOfHotel + widget.content));
              var utf = json.decode(utf8.decode(response.body.codeUnits));
              var room = jsonEncode(utf);
              var hotelData = await http.get(
                  Uri.parse('http://localhost:8080/api/hotel/getAllHotel'));
              var hotelDecode =
                  json.decode(utf8.decode(hotelData.body.toString().codeUnits));
              var testData;
              for (int i = 0; i < hotelDecode.length; i++)
                if (hotelDecode[i]['id'].toString() == widget.content)
                  setState(() {
                    testData = hotelDecode[i];
                  });
              var hotel = json.encode(testData);
              var jsonFb = await http.get(Uri.parse(
                  'http://localhost:8080/api/hotel/showFeedback/${widget.content}'));
              var feedback =
                  json.decode(utf8.decode(jsonFb.body.toString().codeUnits));
              var jsonFbb = jsonEncode(feedback);
              var temps = json.encode({
                'room': room,
                'hotel': hotel,
                'feedback': jsonFbb,
              });
              Navigator.of(context)
                  .pushNamed(HotelDetail.routeName, arguments: temps);
            },
            child: Container(
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(62, 168, 174, 201),
                    offset: Offset(0, 9),
                    blurRadius: 14,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                  children: <Widget>[
                    Image.network(
                      "http://localhost:8080/api/auth/getImage/${widget.picture}",
                      height: 260,
                      width: 200,
                      fit: BoxFit.cover,
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 100,
                        width: 200,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                              Colors.black.withOpacity(1),
                              Colors.black.withOpacity(0.9),
                              Colors.black.withOpacity(0.8),
                              Colors.black.withOpacity(0.7),
                              Colors.black.withOpacity(0.6),
                              Colors.black.withOpacity(0.5),
                              Colors.black.withOpacity(0.4),
                              Colors.black.withOpacity(0.1),
                              Colors.black.withOpacity(0.05),
                              Colors.black.withOpacity(0.025),
                            ])),
                        child: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Container()),
                      ),
                    ),
                    Positioned(
                      bottom: 30,
                      left: 5,
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: RichText(
                              text: TextSpan(children: [
                            TextSpan(
                                text: widget.name,
                                style: const TextStyle(fontSize: 22)),
                          ])),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      left: 5,
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Row(
                              children: <Widget>[
                                const Icon(
                                  Icons.star,
                                  color: Colors.yellow,
                                  size: 14,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                if (widget.days != 'null')
                                  Text(
                                    '${widget.days}',
                                    style: const TextStyle(color: Colors.white),
                                  )
                                else
                                  Text(
                                    'Not feedbacked',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                              ],
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            )));
  }
}
