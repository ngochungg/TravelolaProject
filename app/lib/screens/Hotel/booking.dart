// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:convert';

import 'package:app/controller/apiController.dart';
import 'package:app/screens/Hotel/hotel_details.dart';
import 'package:app/widgets/bottomNav/bottom_navigation.dart';
import 'package:app/widgets/nofitication.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookingCheck extends StatefulWidget {
  static const routeName = '/booking_check';
  const BookingCheck({Key? key}) : super(key: key);

  @override
  State<BookingCheck> createState() => _BookingCheckState();
}

class _BookingCheckState extends State<BookingCheck> {
  static List<String> paymentList = [
    'At the hotel',
    'Momo',
    'Paypal',
    'ZaloPay',
  ];

  String? payment;

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)!.settings;
    late String retriveString;
    if (data.arguments == null) {
      retriveString = jsonEncode({"empty": "empty"});
    } else {
      retriveString = (data.arguments.toString());
    }
    var jsonData = json.decode(retriveString);

    String start = jsonData['startDate'];
    String end = jsonData['endDate'];

    final RoundedLoadingButtonController _btnController =
        RoundedLoadingButtonController();
    setState(() {
      _btnController.reset();
    });
    void _doSomething() async {
      Timer(Duration(seconds: 5), () {
        _btnController.success();
        _btnController.reset();
      });
      var body = jsonEncode({
        "checkInDate": start.substring(0, 10),
        "checkOutDate": end.substring(0, 10),
        "numOfGuest": jsonData['guest'],
        "paymentMethod": payment,
        "totalPrice": jsonData['price'],
        "roomId": jsonData['roomId'],
        "userId": jsonData['userId'],
      });
      print(body.toString());
      final response = await http.post(
          Uri.parse("http://localhost:8080/api/hotel/hotelBooking"),
          body: body,
          headers: {
            "Content-Type": "application/json",
          });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final login = await http
          .post(Uri.parse(urlSignin), body: prefs.getString('body'), headers: {
        "Content-Type": "application/json",
      });
      print(response.statusCode);
      if (response.statusCode == 200) {
        Navigator.of(context)
            .pushNamed(BottomNav.routeName, arguments: login.body);
        notification(
            title: "You have successfully booked a room in the hotel!!",
            body: "Please check your booking history");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text("The checkin date must be after today"),
        ));
      }
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
                Navigator.of(context)
                    .popUntil(ModalRoute.withName(HotelDetail.routeName));
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
                Text("Check your booking",
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
                    child: Text('Check-in: \n${start.substring(0, 10)}',
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
                    child: Text('Check-out: \n${end.substring(0, 10)}',
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
                    'Room name',
                    style: TextStyle(color: Colors.grey, fontSize: 15),
                  ),
                  Text('${jsonData['roomName']}',
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
                    '${jsonData['username']}',
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
                    '${jsonData['phone']}',
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
                    '\$${jsonData['price']}',
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
                    onPressed: () {
                      _tripEditModalBottomSheet(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 10,
                        bottom: 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Payment method\n',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black),
                                ),
                                if (payment == null)
                                  TextSpan(
                                    text: 'Choose your payment method',
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.pinkAccent),
                                  )
                                else
                                  TextSpan(
                                    text: '$payment',
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.pinkAccent),
                                  ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.pinkAccent,
                          ),
                        ],
                      ),
                    )),
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
            if (payment != null)
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
                        child: RoundedLoadingButton(
                          color: Colors.pinkAccent,
                          height: 40,
                          width: 350,
                          child: Text('Book now',
                              style: TextStyle(color: Colors.white)),
                          controller: _btnController,
                          onPressed: _doSomething,
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
                  children: <Widget>[
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
                      onPressed: null,
                    ))
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }

  void _tripEditModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 2,
          child: Padding(
            padding: const EdgeInsets.only(left: 15, top: 20),
            child: Column(
              children: [
                Row(
                  children: const [
                    Text('Choose your payment method',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600)),
                  ],
                ),
                ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: paymentList.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title: Text(paymentList[index]),
                        onTap: () {
                          setState(() {
                            payment = paymentList[index];
                          });
                          Navigator.pop(context);
                        },
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
