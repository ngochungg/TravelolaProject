// ignore_for_file: prefer_const_constructors, curly_braces_in_flow_control_structures

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;

class HistorySub extends StatefulWidget {
  static const routeName = '/history_sub';
  const HistorySub({Key? key}) : super(key: key);

  @override
  State<HistorySub> createState() => _HistorySub();
}

class _HistorySub extends State<HistorySub> {
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
    var jsonData = json.decode(utf8.decode(retriveString.toString().codeUnits));

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
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text("Your booking history",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black)),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${jsonData['room']['images'][0]['hotel']['hotelName']}',
                    style: TextStyle(color: Colors.black87, fontSize: 20),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${jsonData['room']['images'][0]['hotel']['location']['street']}, ${jsonData['room']['images'][0]['hotel']['location']['district']['name']}, ${jsonData['room']['images'][0]['hotel']['location']['province']['name']}',
                    style: TextStyle(color: Colors.black87),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12),
              child: Divider(
                thickness: 1,
              ),
            ),
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
                    child: Text('Check-in: \n${jsonData['checkInDate']}',
                        style: TextStyle(color: Colors.black87)),
                    onPressed: null,
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
                    child: Text('Check-out: \n${jsonData['checkOutDate']}',
                        style: TextStyle(color: Colors.black87)),
                    onPressed: null,
                  )),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Booking code',
                    style: TextStyle(color: Colors.grey, fontSize: 15),
                  ),
                  Text('${jsonData['bookingCode']}',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black)),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Room name',
                    style: TextStyle(color: Colors.grey, fontSize: 15),
                  ),
                  Text('${jsonData['room']['roomName']}',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12),
              child: Divider(
                thickness: 1,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Your name ',
                    style: TextStyle(color: Colors.grey, fontSize: 15),
                  ),
                  Text(
                    '${jsonData['user']['username']}',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Phone number ',
                    style: TextStyle(color: Colors.grey, fontSize: 15),
                  ),
                  Text(
                    '${jsonData['user']['phone']}',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12),
              child: Divider(
                thickness: 1,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total price ',
                    style: TextStyle(color: Colors.grey, fontSize: 15),
                  ),
                  Text(
                    '\$${jsonData['totalPrice']}',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12, top: 20, right: 12),
              child: Container(
                alignment: Alignment.centerLeft,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    elevation: 0,
                    primary: Colors.grey[200],
                  ),
                  onPressed: null,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        RichText(
                          text: TextSpan(
                            // ignore: prefer_const_literals_to_create_immutables
                            children: [
                              TextSpan(
                                text: 'Payment method\n',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black),
                              ),
                              TextSpan(
                                text: '${jsonData['paymentMethod']}',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.pinkAccent),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12.0),
              child: Divider(
                thickness: 1,
              ),
            ),
            if (jsonData['status'] == true)
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.pinkAccent.withAlpha(100),
                        blurRadius: 30.0,
                        spreadRadius: -15.0,
                        offset: Offset(
                          0.0,
                          15.0,
                        ),
                      ),
                    ]),
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
                          child: Text('Feedback this hotel'),
                          onPressed: () async {
                            showModalBottomSheet(
                                context: context,
                                builder: (BuildContext bc) {
                                  return SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height * 4,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 20),
                                      child: Column(
                                        children: [
                                          Text('Feedback',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600)),
                                          RatingBar.builder(
                                            minRating: 1,
                                            direction: Axis.horizontal,
                                            allowHalfRating: true,
                                            itemCount: 5,
                                            itemPadding: EdgeInsets.symmetric(
                                                horizontal: 4.0),
                                            itemBuilder: (context, _) => Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                            onRatingUpdate: (rating) {
                                              _rating = rating;
                                            },
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Divider(
                                              thickness: 1,
                                            ),
                                          ),
                                          Row(
                                            children: const [
                                              Padding(
                                                padding:
                                                    EdgeInsets.all(12.0),
                                                child: Text('Your feedback',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.black)),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: TextField(
                                              controller: _feedbackController,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                hintText: 'Write your feedback',
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(20.0),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                    child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              25),
                                                    ),
                                                    primary: Colors.pinkAccent,
                                                    elevation: 0,
                                                  ),
                                                  child: Text('Continue'),
                                                  onPressed: () async {
                                                    var body = jsonEncode({
                                                      "feedback":
                                                          _feedbackController
                                                              .text,
                                                      "rating": _rating,
                                                      "hotel_booking_id":
                                                          jsonData['id']
                                                    });
                                                    final response = await http
                                                        .post(
                                                            Uri.parse(
                                                                "http://localhost:8080/api/auth/feedback"),
                                                            body: body,
                                                            headers: {
                                                          "Content-Type":
                                                              "application/json"
                                                        });
                                                    Navigator.of(context).pop();
                                                  },
                                                ))
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          },
                        ),
                      )
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
                            borderRadius: BorderRadius.circular(25),
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
              )
          ],
        ),
      ),
    );
  }
}
