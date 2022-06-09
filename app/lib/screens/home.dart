// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';

import 'package:app/screens/login.dart';
import 'package:app/screens/profile.dart';
import 'package:app/widgets/icon_card.dart';
import 'package:app/widgets/images_cards.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:google_sign_in/google_sign_in.dart';

class Home extends StatefulWidget {
  static const routeName = '/home';

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
          if (Navigator.of(context).userGestureInProgress)
            return false;
          else
            return true;
        },
        child: Scaffold(
          body: SafeArea(
            child: Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.menu),
                          color: Colors.black,
                          onPressed: () {},
                        ),
                        if (user["accessToken"] == null)
                          IconButton(
                            icon: Icon(
                              Icons.person_outline,
                              size: 30,
                              color: Colors.black,
                            ),
                            color: Colors.black,
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => Login(),
                                ),
                              );
                            },
                          )
                        else
                          FlatButton(
                            child: Text(
                              'Hello, ${user["username"]}',
                              style: GoogleFonts.montserrat(
                                fontSize: 20,
                                fontWeight: FontWeight.w200,
                                color: Colors.black,
                              ),
                            ),
                            onPressed: () {},
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
                        IconCard(iconData: Icons.home, text: 'Room'),
                        IconCard(
                            iconData: Icons.directions_bike,
                            text: 'Experiences'),
                        IconCard(
                            iconData: Icons.directions, text: 'Adventures'),
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
                    Expanded(child: Container(child: ImageCards())),
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(
                                Icons.home,
                                color: Colors.pink,
                                size: 30,
                              ),
                              onPressed: () {},
                            ),
                            IconButton(
                                icon: Icon(
                                  Icons.search,
                                  color: Colors.black,
                                  size: 30,
                                ),
                                onPressed: () {}),
                            IconButton(
                                icon: Icon(
                                  Icons.favorite_border,
                                  color: Colors.black,
                                  size: 30,
                                ),
                                onPressed: () {}),
                            IconButton(
                                icon: Icon(
                                  Icons.person_outline,
                                  color: Colors.black,
                                  size: 30,
                                ),
                                onPressed: () {
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) => Home()));
                                }),
                          ],
                        )),
                  ],
                )),
          ),
        ));
  }
}
