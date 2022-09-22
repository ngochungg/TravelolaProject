import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../screens/home.dart';

AppBar buildAppbar(BuildContext context, String text) {
  return AppBar(
    backgroundColor: Colors.pinkAccent,
    elevation: 0,
    automaticallyImplyLeading: false,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(text,
            style: GoogleFonts.lato(
                fontSize: 21,
                fontWeight: FontWeight.w400,
                color: Colors.white)),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.12,
        ),
      ],
    ),
  );
}
