import 'dart:convert';

import 'package:app/controller/apiController.dart';
import 'package:app/screens/profile.dart';
import 'package:app/widgets/profile_menu.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../screens/home.dart';
import '../../screens/login.dart';
import '../../screens/register.dart';
import '../app_bar.dart';
import 'package:http/http.dart' as http;

class MyAccount extends StatefulWidget {
  static const routeName = '/myAccount';

  @override
  State<MyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  var _id;
  var _image;
  late SharedPreferences prefs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLogin();
  }

  void checkLogin() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      _id = prefs.getInt('userId');
      _image = prefs.getString('image');
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

    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        appBar: buildAppbar(context, 'travelola'),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Container(
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  if (_id == null)
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
                                          builder: (_) => const Login()));
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
                                  side: const BorderSide(color: Colors.white),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (_) => const Register()));
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
                                    side: const BorderSide(color: Colors.white),
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
                        const SizedBox(
                          height: 20,
                        ),
                        if (_image != null)
                          SizedBox(
                            height: 115,
                            width: 115,
                            child: Stack(
                              clipBehavior: Clip.none,
                              fit: StackFit.expand,
                              children: [
                                if (_image.contains("https"))
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(_image),
                                  )
                                else
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        "http://localhost:8080/api/auth/getImage/" +
                                            _image),
                                  ),
                              ],
                            ),
                          )
                        else
                          SizedBox(
                            height: 115,
                            width: 115,
                            child: Stack(
                              clipBehavior: Clip.none,
                              fit: StackFit.expand,
                              children: const [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      "http://localhost:8080/api/auth/getImage/default.png"),
                                ),
                              ],
                            ),
                          )
                      ],
                    ),
                  const SizedBox(
                    height: 30,
                  ),
                  if (_id != null)
                    Column(
                      children: [
                        ProfileMenu(
                          icon: "images/User Icon.svg",
                          text: "View My Profile",
                          press: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            final response = await http.post(
                                Uri.parse(urlSignin),
                                body: prefs.getString('body'),
                                headers: {
                                  "Content-Type": "application/json",
                                });
                            print(response.body);
                            Navigator.of(context).pushNamed(Profile.routeName,
                                arguments: response.body);
                          },
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
                          icon: "images/User Icon.svg",
                          text: "Login for more benefits",
                          press: () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (_) => const Login()));
                          },
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
