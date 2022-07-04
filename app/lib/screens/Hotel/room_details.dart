// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';

import 'package:app/screens/Hotel/booking.dart';
import 'package:app/screens/login.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RoomDetails extends StatefulWidget {
  static const routeName = '/room_details';
  const RoomDetails({Key? key}) : super(key: key);

  @override
  State<RoomDetails> createState() => _RoomDetailsState();
}

class _RoomDetailsState extends State<RoomDetails> {
  DateTimeRange dateRange = DateTimeRange(
      start: DateTime.now(), end: DateTime.now().add(Duration(days: 1)));
  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)!.settings;
    late String retriveString;
    if (data.arguments == null) {
      retriveString = jsonEncode({"empty": "empty"});
    } else {
      retriveString = (data.arguments.toString());
    }
    var room = jsonDecode(retriveString);

    final urlImages = [
      "http://localhost:8080/api/auth/getImage/${room['images'][0]['imagePath']}",
    ];

    final start = dateRange.start;
    final end = dateRange.end;
    // print(room['maxAdult']);

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
            Icon(
              Icons.favorite_border,
              color: Colors.white,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 9.0, top: 5),
                      child: Text(
                        'For daily use',
                        style: GoogleFonts.lato(
                            fontSize: 15, color: Colors.pinkAccent),
                      ),
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
                      padding: const EdgeInsets.only(left: 9.0, top: 5),
                      child: Text('${room['roomName']}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          )),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                          padding: const EdgeInsets.only(left: 9.0, top: 5),
                          child: Text(
                            'A ${room['roomType']} room with ${room['maxAdult']} Adult(s)',
                            style: GoogleFonts.lato(
                                fontSize: 15, color: Colors.pinkAccent),
                          ),
                        ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 9, top: 10),
                  child: Row(
                    children: [
                      Text('\$${room['price']}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          )),
                      Text(
                        '/day',
                        style: TextStyle(color: Colors.grey),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Divider(
                  color: Colors.grey[200],
                ),
                Text('Check in and Check out',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    )),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                          child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          primary: Colors.pinkAccent,
                          elevation: 0,
                        ),
                        child:
                            Text('${start.year}/${start.month}/${start.day}'),
                        onPressed: pickDataRange,
                      )),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          primary: Colors.pinkAccent,
                          elevation: 0,
                        ),
                        child: Text('${end.year}/${end.month}/${end.day}'),
                        onPressed: pickDataRange,
                      )),
                    ],
                  ),
                ),

                Divider(
                  color: Colors.grey[200],
                ),
                Container(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      Expanded(
                          child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          primary: Colors.pinkAccent,
                          elevation: 0,
                        ),
                        child: Text('Book now'),
                        onPressed: () async{
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          var username = prefs.getString('username');
                          var userId = prefs.getInt('userId');
                          var phone = prefs.getString('phone');
                          var date = end.difference(start).inDays;
                          var details = jsonEncode({"startDate": start.toString(), "endDate": end.toString(), 
                          "roomId": room['id'], "roomName": room['roomName'], "username": username, "userId": 
                          userId, "phone": phone, "price": room['price']* date, "guest": room['maxAdult']});
                          
                          if(userId != null){
                            Navigator.pushNamed(context, BookingCheck.routeName, arguments: details);
                            
                          }
                          else {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              backgroundColor: Colors.red,
                              content: Text("You need to login first"),
                            ));
                            Navigator.pushNamed(context, Login.routeName);
                            print(userId);
                          }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
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

  Future pickDataRange() async {
    DateTimeRange? newDateRange = await showDateRangePicker(
      context: context,
      builder: (BuildContext context, Widget ?child) {
      return Theme(
        data: ThemeData(
          splashColor: Colors.black,
          textTheme: TextTheme(
            subtitle1: TextStyle(color: Colors.black),
            button: TextStyle(color: Colors.black),
          ),
              dialogBackgroundColor: Colors.white, colorScheme: ColorScheme.light(
              primary: Colors.pinkAccent,
              onSecondary: Colors.pinkAccent,
              onPrimary: Colors.white,
              surface: Colors.pinkAccent,
              onSurface: Colors.pinkAccent,
              secondary: Colors.pinkAccent)
        ),
        child: child ??Text(""),
      );
    }
      initialDateRange: dateRange,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (newDateRange == null) return;

    setState(() {
      dateRange = newDateRange;
    });
  }
}
