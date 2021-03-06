// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:app/screens/Payments/makePaypal.dart';
import 'package:app/screens/Post/hotel_post.dart';
import 'package:app/screens/Post/user_post.dart';
import 'package:app/screens/search_master.dart';
import 'package:app/widgets/hotel/icon_card.dart';
import 'package:app/widgets/hotel/images_cards.dart';

import 'package:app/widgets/nofitication.dart';
import 'package:app/widgets/user_post/images_cards.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../screens/login.dart';
import '../../screens/register.dart';
import '../app_bar.dart';
import '../hotel_post/images_cards.dart';

class MyHome extends StatefulWidget {
  static const routeName = '/myhome';

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  dynamic isLoggedIn;
  late SharedPreferences prefs;
  @override
  void initState() {
    super.initState();
    checkLogin();
    AwesomeNotifications().isNotificationAllowed().then(
      (isAllowed) {
        if (!isAllowed) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Allow Notifications'),
              content: Text('Our app would like to send you notifications'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Don\'t Allow',
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  ),
                ),
                TextButton(
                  onPressed: () => AwesomeNotifications()
                      .requestPermissionToSendNotifications()
                      .then((_) => Navigator.pop(context)),
                  child: Text(
                    'Allow',
                    style: TextStyle(
                      color: Colors.teal,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          );
        }
      },
    );
  }

  void checkLogin() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)!.settings;
    late String retriveString;
    if (data.arguments == null) {
      retriveString = jsonEncode({"empty": "empty"});
    } else {
      retriveString = (data.arguments.toString());
    }
    var user = jsonDecode(retriveString);

    // print(isLoggedIn);

    return WillPopScope(
      onWillPop: () async {
        if (Navigator.of(context).userGestureInProgress) {
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        appBar: buildAppbar(context, 'travelola'),
        body: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                if (isLoggedIn == false)
                  Column(
                    children: <Widget>[
                      Container(
                        color: Colors.pinkAccent,
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
                          child: Text(
                            'Create an account, enjoy more benefits!',
                            style: GoogleFonts.lato(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Colors.white),
                          ),
                        ),
                      ),
                      Container(
                        color: Colors.pinkAccent,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FlatButton(
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(builder: (_) => Login()));
                              },
                              child: Text(
                                '         Log In         ',
                                style: GoogleFonts.lato(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                                side: BorderSide(color: Colors.white),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (_) => Register()));
                              },
                              child: Text(
                                '       Register       ',
                                style: GoogleFonts.lato(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.pinkAccent),
                              ),
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.white,
                                  side: BorderSide(color: Colors.white),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                SizedBox(
                  height: 20,
                ),
                Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: RichText(
                        text: TextSpan(children: const [
                          TextSpan(
                              text: 'Hello, ',
                              style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.pinkAccent)),
                          TextSpan(
                              text: 'what are you\nlooking for?',
                              style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black)),
                        ]),
                      ),
                    )),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    IconCard(
                      iconData: Icons.room_outlined,
                      text: 'Hotels',
                      press: () async {
                        var city = await http.get(Uri.parse(
                            'http://localhost:8080/api/hotel/find4ProvinceHaveMostHotel'));
                        // print(city.body);
                        Navigator.of(context).pushNamed(SearchMater.routeName,
                            arguments: city.body);
                      },
                    ),
                    IconCard(
                        iconData: Icons.directions_bike,
                        text: 'Experiences',
                        press: () async {
                          final response = await http.get(
                              Uri.parse('http://localhost:8080/api/posts/all'));
                          Navigator.of(context).pushNamed(HotelPost.routeName,
                              arguments: response.body);
                        }),
                    IconCard(
                        iconData: Icons.directions,
                        text: 'Adventures',
                        press: () async {
                          final response = await http.get(
                              Uri.parse('http://localhost:8080/api/posts/all'));
                          Navigator.of(context).pushNamed(UserPost.routeName,
                              arguments: response.body);
                        }),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text('New hotels',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                HotelImageCards(),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text('Recommended for you',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                ImageCards(),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text('Everyone\'s Journey',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                UserImageCards(),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
