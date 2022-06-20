import 'dart:convert';

import 'package:app/controller/dataController.dart';
import 'package:app/widgets/bottomNav/bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../screens/login.dart';
import '../../screens/register.dart';
import '../app_bar.dart';
import '../icon_card.dart';
import '../images_cards.dart';

class MyHome extends StatelessWidget {
  static const routeName = '/myhome';
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
                  if (user["accessToken"] == null)
                    Column(
                      children: <Widget>[
                        Container(
                          color: Colors.pinkAccent,
                          alignment: Alignment.center,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(bottom: 8.0, top: 8.0),
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
                                      MaterialPageRoute(
                                          builder: (_) => Login()));
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
                          text: TextSpan(children: [
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
                      IconCard(iconData: Icons.room_outlined, text: 'Booking'),
                      IconCard(
                          iconData: Icons.directions_bike, text: 'Experiences'),
                      IconCard(iconData: Icons.directions, text: 'Adventures'),
                      IconCard(iconData: Icons.flight, text: 'Flights'),
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
                        child: Text('Best Experiences',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500)),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.more_horiz,
                          color: Colors.black,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ImageCards(),
                  SizedBox(
                    height: 10,
                  ),
                ],
              )),
        ),
      ),
    );
  }
}