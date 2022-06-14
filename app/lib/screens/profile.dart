import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'home.dart';
import 'login.dart';

class Profile extends StatefulWidget {
  static const routeName = '/profile';
  Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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
      onWillPop: () async => false,
      child: Scaffold(
          body: SafeArea(
        child: Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    BackButton(
                      color: Colors.black,
                      onPressed: () {
                        Navigator.pop(context);
                      },
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
                        onPressed: () {
                          print(user);
                        },
                      ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.home_outlined,
                            color: Colors.black,
                            size: 30,
                          ),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: ((context) => Home())));
                          },
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
                              Icons.person,
                              color: Colors.pink,
                              size: 30,
                            ),
                            onPressed: () {}),
                      ],
                    )),
              ],
            )),
      )),
    );
  }
}
