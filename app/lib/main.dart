import 'package:app/screens/dashboard.dart';
import 'package:app/screens/home.dart';
import 'package:app/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MaterialApp(
    title: 'Named Routes Demo',
    debugShowCheckedModeBanner: false,
    initialRoute: Dashboard.routeName,
    routes: {
      Home.routeName: (context) => Home(),
      Login.routeName: (context) => Login(),
      Dashboard.routeName: (context) => Dashboard(),
    },
  ));
}
