// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';

class FeedbackHistory extends StatefulWidget {
  static const routeName = '/feedback-history';
  FeedbackHistory({Key? key}) : super(key: key);

  @override
  State<FeedbackHistory> createState() => _FeedbackHistoryState();
}

class _FeedbackHistoryState extends State<FeedbackHistory> {
  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)!.settings;
    late String retriveString;
    if (data.arguments == null) {
      retriveString = jsonEncode({"empty": "empty"});
    } else {
      retriveString = (data.arguments.toString());
    }
    var feedback = jsonDecode(retriveString);
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
            Text('Feedback History',
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
                reverse: true,
                itemCount: feedback.length,
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
                        onPressed: () {},
                        child: Column(
                          children: [
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(width: 40),
                                Expanded(
                                  child: Text(
                                    '${feedback[index]['hotel']['hotelName']}',
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
                                Icon(
                                  Icons.star,
                                  color: Colors.yellow,
                                ),
                                Text(
                                  "${feedback[index]['rating']}",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w300),
                                ),
                                const SizedBox(width: 38),
                                Expanded(
                                  child: Text("${feedback[index]['feedback']}",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w300)),
                                ),
                                SizedBox(width: 10),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
