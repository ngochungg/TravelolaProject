import 'dart:convert';
import 'dart:io';

import 'package:app/screens/profile.dart';
import 'package:app/widgets/bottomNav/bottom_navigation.dart';
import 'package:app/widgets/profile_menu.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../screens/home.dart';
import '../../screens/login.dart';
import '../../screens/register.dart';
import '../app_bar.dart';

class MyAccount extends StatelessWidget {
  static const routeName = '/myAccount';
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
      onWillPop: () async => true,
      child: Scaffold(
        appBar: buildAppbar(context, 'My Account'),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Container(
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  if (user["id"] == null)
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
                            children: <Widget>[
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
                    )
                  else
                    Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        if (user["imageUrl"] != null)
                          SizedBox(
                            height: 115,
                            width: 115,
                            child: Stack(
                              fit: StackFit.expand,
                              overflow: Overflow.visible,
                              children: [
                                if (user["imageUrl"].contains("https"))
                                  CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(user['imageUrl']),
                                  )
                                else
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        "http://localhost:8080/api/auth/getImage/" +
                                            user['imageUrl']),
                                  ),
                              ],
                            ),
                          )
                        else
                          SizedBox(
                            height: 115,
                            width: 115,
                            child: Stack(
                              fit: StackFit.expand,
                              overflow: Overflow.visible,
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      "http://localhost:8080/api/auth/getImage/default.png"),
                                ),
                              ],
                            ),
                          )
                      ],
                    ),
                  SizedBox(
                    height: 30,
                  ),
                  if (user["accessToken"] != null)
                    Column(
                      children: [
                        ProfileMenu(
                          icon: "images/User Icon.svg",
                          text: "View My Profile",
                          press: () {
                            Navigator.of(context).pushNamed(Profile.routeName,
                                arguments: jsonEncode(user));
                          },
                        ),
                        ProfileMenu(
                          icon: "images/Bell.svg",
                          text: "Nofitications",
                          press: () {
                            print(user);
                          },
                        ),
                        ProfileMenu(
                          icon: "images/Question mark.svg",
                          text: "Settings",
                          press: () {},
                        ),
                        ProfileMenu(
                          icon: "images/User Icon.svg",
                          text: "Help Center",
                          press: () {},
                        ),
                        ProfileMenu(
                          icon: "images/Log out.svg",
                          text: "Log Out",
                          press: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.clear();
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (_) => Home()));
                          },
                        ),
                      ],
                    )
                  else
                    Column(
                      children: [
                        ProfileMenu(
                          icon: "images/Question mark.svg",
                          text: "Settings",
                          press: () {},
                        ),
                        ProfileMenu(
                          icon: "images/User Icon.svg",
                          text: "Help Center",
                          press: () {},
                        ),
                      ],
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
