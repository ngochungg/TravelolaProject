import 'package:app/model/places.dart';
import 'package:app/screens/details.dart';
import 'package:flutter/material.dart';

class ImageCard extends StatelessWidget {
  final String name;
  final String days;
  final String picture;
  final Place place;

  const ImageCard({
    required this.name,
    required this.days,
    required this.picture,
    required this.place,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(4),
        child: InkWell(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => Details(place)));
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
                      "http://localhost:8080/api/auth/getImage/$picture",
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
                                text: name,
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
                                  Icons.calendar_today,
                                  color: Colors.white,
                                  size: 14,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text('$days days',
                                    style: const TextStyle(color: Colors.white))
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
