// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:app/controller/apiController.dart';
import 'package:app/screens/Hotel/hotel_details.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HotelHomePage extends StatefulWidget {
  static const routeName = '/hotelHome';
  const HotelHomePage({Key? key}) : super(key: key);

  @override
  State<HotelHomePage> createState() => _HotelHomePageState();
}

class _HotelHomePageState extends State<HotelHomePage> {
  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)!.settings;
    late String retriveString;
    if (data.arguments == null) {
      retriveString = jsonEncode({"empty": "empty"});
    } else {
      retriveString = (data.arguments.toString());
    }
    var data1 = json.decode(utf8.decode(retriveString.codeUnits));

    var hotelData = data1['dataHotel'];
    var infor = data1['infor'];
    var nights = data1['nights'];
    var checkin = infor['checkIn'].substring(0, 10);
    // print(hotelData[0]['images'][1]['room']['price']);
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
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Hotel for You\n',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  TextSpan(
                    text: '$checkin, $nights Night(s)',
                    style: TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 45,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                for (int i = 0; i < hotelData.length; i++)
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.95,
                    height: 200,
                    // decoration: const BoxDecoration(
                    //   color: Colors.white,
                    //   borderRadius: BorderRadius.all(Radius.circular(25)),
                    // ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            primary: Colors.white,
                            elevation: 0,
                          ),
                          onPressed: () async {
                            var response = await http.get(Uri.parse(
                                getRoomOfHotel +
                                    hotelData[i]['id'].toString()));
                            var utf = json.decode(utf8
                                .decode(response.body.toString().codeUnits));
                            var room = jsonEncode(utf);
                            var hotel = json.encode(hotelData[i]);
                            var jsonFb = await http.get(Uri.parse(
                                'http://localhost:8080/api/hotel/showFeedback/${hotelData[i]['id']}'));
                            var feedback = json.decode(
                                utf8.decode(jsonFb.body.toString().codeUnits));
                            var jsonFbb = jsonEncode(feedback);
                            var temps = json.encode({
                              'room': room,
                              'hotel': hotel,
                              'feedback': jsonFbb,
                            });
                            // print(temps);
                            Navigator.of(context).pushNamed(
                                HotelDetail.routeName,
                                arguments: temps);
                          },
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  "http://localhost:8080/api/auth/getImage/${hotelData[i]['images'][0]['imagePath']}",
                                  height: 180.0,
                                  width: 100.0,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Column(
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        WidgetSpan(
                                          child: SizedBox(
                                            width: 10,
                                          ),
                                        ),
                                        TextSpan(
                                          text:
                                              '${hotelData[i]['hotelName']}\n',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18),
                                        ),
                                        WidgetSpan(
                                          child: SizedBox(
                                            width: 10,
                                          ),
                                        ),
                                        WidgetSpan(
                                          child: Icon(
                                            Icons.location_pin,
                                            size: 14,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text:
                                                  '${hotelData[i]['location']['district']['name']},',
                                              style: TextStyle(
                                                  color: Colors.grey[500],
                                                  fontSize: 12),
                                            ),
                                            TextSpan(
                                              text:
                                                  '${hotelData[i]['location']['province']['name']}\n',
                                              style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                        WidgetSpan(
                                          child: SizedBox(
                                            width: 10,
                                          ),
                                        ),
                                        TextSpan(
                                          children: [
                                            if (hotelData[i]['hotelRating'] !=
                                                null)
                                              WidgetSpan(
                                                child: Icon(
                                                  Icons.star,
                                                  size: 17,
                                                  color: Colors.yellow[700],
                                                ),
                                              )
                                            else
                                              WidgetSpan(
                                                child: SizedBox(
                                                  height: 10,
                                                ),
                                              ),
                                            if (hotelData[i]['hotelRating'] !=
                                                null)
                                              TextSpan(
                                                text:
                                                    '${hotelData[i]['hotelRating']}\n',
                                                style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              )
                                            else
                                              TextSpan(
                                                text: '\n',
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 13,
                                                  // fontWeight: FontWeight.w600),
                                                ),
                                              )
                                          ],
                                        ),
                                        WidgetSpan(
                                          child: SizedBox(
                                            height: 90,
                                            width: 10,
                                          ),
                                        ),
                                        TextSpan(
                                            text:
                                                'Price/room/night starts from\n',
                                            style: TextStyle(
                                                color: Colors.black45,
                                                fontSize: 12)),
                                        WidgetSpan(
                                          child: SizedBox(
                                            width: 10,
                                          ),
                                        ),
                                        TextSpan(
                                          text:
                                              '\$${hotelData[i]['images'][1]['room']['price']}',
                                          style: TextStyle(
                                              color: Colors.orange[800],
                                              fontSize: 18),
                                        ),
                                        TextSpan(
                                          text: '/room/night\n',
                                          style: GoogleFonts.cabin(
                                            color: Colors.black38,
                                            fontSize: 14,
                                          ),
                                        ),
                                        WidgetSpan(
                                          child: SizedBox(
                                            width: 10,
                                          ),
                                        ),
                                        TextSpan(
                                          text: 'All charges included',
                                          style: TextStyle(
                                              color: Colors.black38,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
