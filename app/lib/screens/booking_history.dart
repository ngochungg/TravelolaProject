// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:app/screens/booking_history_sub.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';

class BookingsHistory extends StatefulWidget {
  static const routeName = '/bookingsHistory';
  const BookingsHistory({Key? key}) : super(key: key);

  @override
  State<BookingsHistory> createState() => _BookingsHistoryState();
}

class _BookingsHistoryState extends State<BookingsHistory> {
  final TextEditingController _feedbackController = TextEditingController();
  double? _rating;
  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)!.settings;
    late String retriveString;
    if (data.arguments == null) {
      retriveString = jsonEncode({"empty": "empty"});
    } else {
      retriveString = (data.arguments.toString());
    }
    var booking = json.decode(retriveString);
    print(booking.length);
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
            Text('Booking History',
                style: GoogleFonts.lato(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Colors.white)),
            const SizedBox(width: 40),
          ],
        ),
      ),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: booking.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      const SizedBox(height: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          primary: Colors.white,
                          elevation: 0,
                        ),
                        onPressed: () {
                          Navigator.of(context).pushNamed(HistorySub.routeName,
                              arguments: jsonEncode(booking[index]));
                        },
                        child: Column(
                          children: [
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                if (booking[index]['status'] == true)
                                  SizedBox(
                                    width: 80.0,
                                    height: 20.0,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        primary: Colors.greenAccent,
                                        elevation: 0,
                                      ),
                                      onPressed: () {},
                                      child: Text(
                                        'Appeared',
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  )
                                else
                                  SizedBox(
                                    width: 80.0,
                                    height: 20.0,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        primary: Colors.pinkAccent,
                                        elevation: 0,
                                      ),
                                      onPressed: () {},
                                      child: Text(
                                        'Not show',
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ),
                                const SizedBox(width: 40),
                                Expanded(
                                  child: Text(
                                    '${booking[index]['room']['images'][0]['hotel']['hotelName']}',
                                    style: GoogleFonts.lato(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Icon(
                                  Icons.more_vert,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${booking[index]['checkInDate']}",
                                  style: TextStyle(
                                      color: Colors.grey[700],
                                      fontWeight: FontWeight.w300),
                                ),
                                const SizedBox(width: 38),
                                Expanded(
                                  child: Text(
                                      "${booking[index]['room']['roomName']}",
                                      style: TextStyle(
                                          color: Colors.grey[700],
                                          fontWeight: FontWeight.w300)),
                                ),
                                SizedBox(width: 10),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${booking[index]['totalPrice'] ~/ booking[index]['room']['price']} day(s)",
                                  style: TextStyle(
                                      color: Colors.grey[700],
                                      fontWeight: FontWeight.w300),
                                ),
                                const SizedBox(width: 67),
                                SizedBox(width: 10),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(width: 115),
                                Expanded(
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        WidgetSpan(
                                          child: Icon(
                                              Icons.attach_money_outlined,
                                              color: Colors.grey[700]),
                                        ),
                                        TextSpan(
                                          text:
                                              '${booking[index]['totalPrice']}',
                                          style: TextStyle(
                                              color: Colors.grey[700],
                                              fontWeight: FontWeight.w300),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                              ],
                            ),
                            if (booking[index]['status'] == true)
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          side: BorderSide(color: Colors.grey),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                          ),
                                          primary: Colors.white,
                                          elevation: 0,
                                        ),
                                        child: Text('Feedback this hotel',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 15)),
                                        onPressed: () async {
                                          showModalBottomSheet(
                                            context: context,
                                            builder: (BuildContext bc) {
                                              return SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    4,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 20),
                                                  child: Column(
                                                    children: [
                                                      Text('Feedback',
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600)),
                                                      RatingBar.builder(
                                                        minRating: 1,
                                                        direction:
                                                            Axis.horizontal,
                                                        allowHalfRating: true,
                                                        itemCount: 5,
                                                        itemPadding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    4.0),
                                                        itemBuilder:
                                                            (context, _) =>
                                                                Icon(
                                                          Icons.star,
                                                          color: Colors.amber,
                                                        ),
                                                        onRatingUpdate:
                                                            (rating) {
                                                          _rating = rating;
                                                        },
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(12.0),
                                                        child: Divider(
                                                          thickness: 1,
                                                        ),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(12.0),
                                                            child: Text(
                                                                'Your feedback',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: Colors
                                                                        .black)),
                                                          ),
                                                        ],
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: TextField(
                                                          controller:
                                                              _feedbackController,
                                                          decoration:
                                                              InputDecoration(
                                                            border:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                            hintText:
                                                                'Write your feedback',
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(20.0),
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                                child:
                                                                    ElevatedButton(
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              25),
                                                                ),
                                                                primary: Colors
                                                                    .pinkAccent,
                                                                elevation: 0,
                                                              ),
                                                              child: Text(
                                                                  'Continue'),
                                                              onPressed:
                                                                  () async {
                                                                var body =
                                                                    jsonEncode({
                                                                  "feedback":
                                                                      _feedbackController
                                                                          .text,
                                                                  "rating":
                                                                      _rating,
                                                                  "hotel_booking_id":
                                                                      booking[index]
                                                                          ['id']
                                                                });
                                                                final response =
                                                                    await http.post(
                                                                        Uri.parse(
                                                                            "http://localhost:8080/api/auth/feedback"),
                                                                        body: body,
                                                                        headers: {
                                                                      "Content-Type":
                                                                          "application/json"
                                                                    });
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                        const SnackBar(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
                                                                  content: Text(
                                                                      "Your feedback has been sent"),
                                                                ));
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                            ))
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      ))
                                    ],
                                  ),
                                ),
                              )
                            else
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                          ),
                                          primary: Colors.pinkAccent,
                                          elevation: 0,
                                        ),
                                        child: Text('Feedback this hotel'),
                                        onPressed: null,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                          ],
                        ),
                      )
                    ],
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
