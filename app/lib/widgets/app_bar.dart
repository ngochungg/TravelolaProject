import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../screens/home.dart';

AppBar buildAppbar(BuildContext context) {
  return AppBar(
    backgroundColor: Colors.pinkAccent,
    elevation: 0,
    automaticallyImplyLeading: false,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text('travelola',
            style: GoogleFonts.lato(
                fontSize: 21,
                fontWeight: FontWeight.w400,
                color: Colors.white)),
        IconButton(
          icon: Icon(Icons.menu),
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => Home()),
            );
          },
        ),
      ],
    ),
  );
}
