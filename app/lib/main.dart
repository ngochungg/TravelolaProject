import 'package:app/screens/Hotel/booking.dart';
import 'package:app/screens/Hotel/home.dart';
import 'package:app/screens/Hotel/hotel_details.dart';
import 'package:app/screens/Hotel/room_details.dart';
import 'package:app/screens/booking_history.dart';
import 'package:app/screens/booking_history_sub.dart';
import 'package:app/screens/changePassword.dart';
import 'package:app/screens/dashboard.dart';
import 'package:app/screens/editInfo.dart';
import 'package:app/screens/feedback_history.dart';
import 'package:app/screens/home.dart';
import 'package:app/screens/login.dart';
import 'package:app/screens/profile.dart';
import 'package:app/screens/search_master.dart';
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
        BottomNav.routeName: (context) => const BottomNav(),
        Login.routeName: (context) => const Login(),
        Dashboard.routeName: (context) => const Dashboard(),
        MyAccount.routeName: (context) => MyAccount(),
        MyHome.routeName: (context) => MyHome(),
        Profile.routeName: (context) => const Profile(),
        Home.routeName: (context) => Home(),
        EditInfo.routeName: (context) => const EditInfo(),
        ChangePassword.routeName: (context) => const ChangePassword(),
        HotelHomePage.routeName: (context) => const HotelHomePage(),
        HotelDetail.routeName: (context) => const HotelDetail(),
        RoomDetails.routeName: (context) => const RoomDetails(),
        BookingCheck.routeName: (context) => const BookingCheck(),
        BookingsHistory.routeName: (context) => const BookingsHistory(),
        HistorySub.routeName: (context) => const HistorySub(),
        SearchMater.routeName: (context) => const SearchMater(),
        FeedbackHistory.routeName: (context) => FeedbackHistory(),
      },
    ),
  );
}
