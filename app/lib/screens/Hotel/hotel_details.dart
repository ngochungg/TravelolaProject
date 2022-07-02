// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';

import 'package:app/controller/apiController.dart';
import 'package:app/screens/Hotel/room_details.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HotelDetail extends StatefulWidget {
  static const routeName = '/hotelDetail';
  // final int id;
  HotelDetail({Key? key}) : super(key: key);

  @override
  State<HotelDetail> createState() => _HotelDetailState();
}

class _HotelDetailState extends State<HotelDetail> {
  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)!.settings;
    late String retriveString;
    if (data.arguments == null) {
      retriveString = jsonEncode({"empty": "empty"});
    } else {
      retriveString = (data.arguments.toString());
    }
    Map<String, dynamic> hotelData = json.decode(retriveString);
    var hotel = jsonDecode(hotelData['hotel']);
    var room = jsonDecode(hotelData['room']);
    var feedback = jsonDecode(hotelData['feedback']);
    var hotelList = jsonDecode(hotelData['hotelList']);

    final urlImages = [
      for (int i = 0; i < room.length; i++)
        "http://localhost:8080/api/auth/getImage/${room[i]['images'][0]['imagePath']}",
    ];
    final urlFeedback = [
      for (int i = 0; i < feedback.length; i++) "${feedback[i]['feedback']}",
    ];
    print(urlFeedback);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            BackButton(
              color: Colors.white,
              onPressed: () async {
                Navigator.of(context).pop();
              },
            ),
            // Text('${hotel['hotelName']}'),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              children: [
                CarouselSlider.builder(
                  options: CarouselOptions(
                    height: 200,
                    // reverse: true,
                    autoPlayInterval: const Duration(seconds: 10),
                    autoPlay: true,
                  ),
                  itemCount: urlImages.length,
                  itemBuilder: (context, index, realIndex) {
                    final urlImage = urlImages[index];
                    return buildImage(urlImage, index);
                  },
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 5,
                    ),
                    Icon(Icons.star_rounded,
                        color: Colors.pinkAccent, size: 25),
                    SizedBox(
                      width: 2,
                    ),
                    Text(
                      '5.0',
                      style: TextStyle(
                        // color: Colors.pinkAccent,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text('(100 feedbacks)',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                        )),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 12, top: 5),
                  child: Container(
                    width: 75,
                    height: 25,
                    // padding: EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: Colors.red,
                    ),
                    child: Center(
                      child: Text(
                        'Book Now',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(9.0),
                  child: Text('${hotel['hotelName']}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      )),
                ),
              ],
            ),
            Container(
              child: Row(
                children: [
                  Icon(
                    Icons.location_pin,
                    color: Colors.pinkAccent,
                    size: 25,
                  ),
                  Flexible(
                    child: Text(
                      '${hotel['location']['street']}, ${hotel['location']['ward']['name']}, ${hotel['location']['district']['name']}, ${hotel['location']['province']['name']}',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Divider(
              color: Colors.grey[200],
            ),
            Column(
              children: [
                Text('Facilities',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    )),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (hotel['wifi'] == true)
                        Icon(
                          Icons.wifi,
                          color: Colors.green,
                          size: 25,
                        )
                      else
                        Icon(
                          Icons.wifi_off,
                          color: Colors.red,
                          size: 25,
                        ),
                      if (hotel['freeBreakfast'] == true)
                        Icon(
                          Icons.fastfood,
                          color: Colors.green,
                          size: 25,
                        )
                      else
                        Icon(
                          Icons.no_food,
                          color: Colors.red,
                          size: 25,
                        ),
                      if (hotel['wfreeParkingifi'] == true)
                        Icon(
                          Icons.local_parking_rounded,
                          color: Colors.green,
                          size: 25,
                        )
                      else
                        Icon(
                          Icons.local_parking_rounded,
                          color: Colors.red,
                          size: 25,
                        ),
                      if (hotel['petsAllowed'] == true)
                        Icon(
                          Icons.pets,
                          color: Colors.green,
                          size: 25,
                        )
                      else
                        Icon(
                          Icons.pets,
                          color: Colors.red,
                          size: 25,
                        ),
                      if (hotel['hotTub'] == true)
                        Icon(
                          Icons.hot_tub,
                          color: Colors.green,
                          size: 25,
                        )
                      else
                        Icon(
                          Icons.hot_tub,
                          color: Colors.red,
                          size: 25,
                        ),
                      if (hotel['swimmingPool'] == true)
                        Icon(
                          Icons.pool,
                          color: Colors.green,
                          size: 25,
                        )
                      else
                        Icon(
                          Icons.pool,
                          color: Colors.red,
                          size: 25,
                        ),
                      if (hotel['wifi'] == true)
                        Icon(
                          Icons.wifi,
                          color: Colors.green,
                          size: 25,
                        )
                      else
                        Icon(
                          Icons.wifi_off,
                          color: Colors.red,
                          size: 25,
                        ),
                      if (hotel['gym'] == true)
                        Icon(
                          Icons.fitness_center,
                          color: Colors.green,
                          size: 25,
                        )
                      else
                        Icon(
                          Icons.fitness_center,
                          color: Colors.red,
                          size: 25,
                        )
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Divider(
              color: Colors.grey[200],
            ),
            Column(
              children: [
                Column(
                  children: [
                    for (int i = 0; i < room.length; i++)
                      Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                  RoomDetails.routeName,
                                  arguments: jsonEncode(room[i]));
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              primary: Colors.white,
                              elevation: 0,
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image(
                                      image: NetworkImage(
                                          "http://localhost:8080/api/auth/getImage/${hotel['images'][0]['imagePath']}"),
                                      height: 150,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child: Text('${room[i]['roomName']}',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black)),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          RichText(
                                            text: TextSpan(
                                              style: TextStyle(
                                                // color: Colors.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w400,
                                              ),
                                              children: [
                                                WidgetSpan(
                                                  child: Icon(
                                                    Icons
                                                        .people_outline_rounded,
                                                    color: Colors.black87,
                                                    size: 20,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text:
                                                      ' ${room[i]['maxAdult']} Adult(s), ${room[i]['maxChildren']} Child(ren)',
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text('${room[i]['roomType']}',
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black87,
                                              )),
                                        ],
                                      ),
                                    ],
                                  ),
                                  if (hotel['wifi'] == true)
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          child: RichText(
                                              text: TextSpan(
                                            style: TextStyle(
                                              // color: Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            children: [
                                              WidgetSpan(
                                                child: Icon(
                                                  Icons.wifi,
                                                  color: Colors.green,
                                                  size: 20,
                                                ),
                                              ),
                                              TextSpan(
                                                text: ' Free Wi-Fi',
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.green,
                                                ),
                                              ),
                                            ],
                                          )),
                                        ),
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          child: Text('\$${room[i]['price']}',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.orange)),
                                        ),
                                      ],
                                    )
                                  else
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          child: RichText(
                                            text: TextSpan(
                                              style: TextStyle(
                                                // color: Colors.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w400,
                                              ),
                                              children: [
                                                WidgetSpan(
                                                  child: Icon(
                                                    Icons.wifi_off,
                                                    color: Colors.red,
                                                    size: 20,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: ' No Free Wi-Fi',
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          child: Text('\$${room[i]['price']}',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.orange)),
                                        ),
                                      ],
                                    ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(),
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            primary: Colors.pinkAccent,
                                            elevation: 0,
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pushNamed(
                                                RoomDetails.routeName,
                                                arguments: jsonEncode(room[i]));
                                          },
                                          child: Text(
                                            'Choose',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          )),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
            Divider(
              color: Colors.grey[200],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text('Feedback',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      )),
                ],
              ),
            ),
            if (urlFeedback.length == 0)
              SizedBox(
                // you may want to use an aspect ratio here for tablet support
                height: 100.0,
                child: PageView.builder(
                  itemCount: 1,
                  controller: PageController(viewportFraction: 0.8),
                  itemBuilder: (BuildContext context, int itemIndex) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          'No feedback yet',
                          style: TextStyle(
                            fontSize: 18,
                            // fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            else
              SizedBox(
                // you may want to use an aspect ratio here for tablet support
                height: 100.0,
                child: PageView.builder(
                  itemCount: urlFeedback.length,
                  controller: PageController(viewportFraction: 0.8),
                  itemBuilder: (BuildContext context, int itemIndex) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Icon(Icons.star, color: Colors.yellow[700]),
                                  Text(
                                    '${feedback[itemIndex]['rating']}',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 13),
                              child: Row(
                                children: [
                                  Text(
                                    '${feedback[itemIndex]['user']['username']}',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 13),
                              child: Row(
                                children: [
                                  Text(
                                    '${feedback[itemIndex]['feedback']}',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            Divider(
              color: Colors.grey[200],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Row(
                children: [
                  Text('Description',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      )),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      '${hotel['description']}',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.grey[200],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildImage(String urlImage, int index) => Container(
        margin: EdgeInsets.symmetric(horizontal: 12),
        color: Colors.grey,
        width: MediaQuery.of(context).size.width,
        child: Image.network(
          urlImage,
          fit: BoxFit.cover,
        ),
      );
}
