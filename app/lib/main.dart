import 'package:app/screens/Hotel/booking.dart';
import 'package:app/screens/Hotel/home.dart';
import 'package:app/screens/Hotel/hotel_details.dart';
import 'package:app/screens/Hotel/room_details.dart';
import 'package:app/screens/booking_history.dart';
import 'package:app/screens/booking_history_sub.dart';
import 'package:app/screens/changePassword.dart';
import 'package:app/screens/dashboard.dart';
import 'package:app/screens/editInfo.dart';
import 'package:app/screens/home.dart';
import 'package:app/screens/login.dart';
import 'package:app/screens/profile.dart';
import 'package:app/widgets/bottomNav/bottom_navigation.dart';
import 'package:app/widgets/bottomNav/my_account_bottom.dart';
import 'package:app/widgets/bottomNav/my_home_bottom.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

void main() async {
  AwesomeNotifications().initialize(
    'resource://drawable/res_notification_app_icon',
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic Notifications',
        defaultColor: Colors.teal,
        importance: NotificationImportance.High,
        channelShowBadge: true,
        channelDescription: '',
      )
    ],
  );
  runApp(
    MaterialApp(
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
        BookingsHistory.routeName: (context) => BookingsHistory(),
        HistorySub.routeName: (context) => HistorySub(),
      },
    ),
  );
}
