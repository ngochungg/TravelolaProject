import 'package:app/screens/Hotel/booking.dart';
import 'package:app/screens/Hotel/home.dart';
import 'package:app/screens/Hotel/hotel_details.dart';
import 'package:app/screens/Hotel/room_details.dart';
import 'package:app/screens/changePassword.dart';
import 'package:app/screens/dashboard.dart';
import 'package:app/screens/editInfo.dart';
import 'package:app/screens/home.dart';
import 'package:app/screens/login.dart';
import 'package:app/screens/profile.dart';
import 'package:app/widgets/bottomNav/bottom_navigation.dart';
import 'package:app/widgets/bottomNav/my_account_bottom.dart';
import 'package:app/widgets/bottomNav/my_home_bottom.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future main() async {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: Dashboard.routeName,
    routes: {
      BottomNav.routeName: (context) => BottomNav(),
      Login.routeName: (context) => const Login(),
      Dashboard.routeName: (context) => Dashboard(),
      MyAccount.routeName: (context) => MyAccount(),
      MyHome.routeName: (context) => MyHome(),
      Profile.routeName: (context) => Profile(),
      Home.routeName: (context) => Home(),
      EditInfo.routeName: (context) => EditInfo(),
      ChangePassword.routeName: (context) => ChangePassword(),
      HotelHomePage.routeName: (context) => HotelHomePage(),
      HotelDetail.routeName: (context) => HotelDetail(),
      RoomDetails.routeName: (context) => RoomDetails(),
      BookingCheck.routeName: (context) => BookingCheck(),
    },
  ));
}
