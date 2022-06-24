// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:app/controller/apiController.dart';
import 'package:app/model/user.dart';
import 'package:app/screens/Hotel/hotel_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HotelHomePage extends StatefulWidget {
  static const routeName = '/hotelHome';
  HotelHomePage({Key? key}) : super(key: key);

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
    var hotelData = json.decode(utf8.decode(retriveString.codeUnits));

    void hotelDetails() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('hotelData', jsonEncode(hotelData));
    }

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
                    text: '22 Jun 2022, 1 Night(s), 1 Room(s)',
                    style: TextStyle(color: Colors.white, fontSize: 12),
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
                  Container(
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
                            hotelDetails();
                            var response = await http.get(Uri.parse(
                                getRoomOfHotel +
                                    hotelData[i]['id'].toString()));
                            var utf = json.decode(utf8
                                .decode(response.body.toString().codeUnits));
                            var room = jsonEncode(utf);
                            var hotel = json.encode(hotelData[i]);
                            var temps =
                                json.encode({'room': room, 'hotel': hotel});
                            Navigator.of(context).pushNamed(
                                HotelDetail.routeName,
                                arguments: temps);

                            // print(array);
                          },
                          child: Row(
                            children: [
                              // ClipRRect(
                              //   borderRadius: BorderRadius.circular(8.0),
                              //   child: Image.network(
                              //     "http://localhost:8080/api/auth/getImage/${hotelData[i]['images'][0]['imagePath']}",

                              //     height: 180.0,
                              // width: 100.0,
                              //   ),
                              // ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.asset(
                                  "images/286696674.jpeg",
                                  height: 180.0,
                                  width: 100.0,
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
                                            height: 100,
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
