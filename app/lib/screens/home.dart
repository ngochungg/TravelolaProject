// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unused_local_variable, unnecessary_new

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:app/screens/login.dart';
import 'package:app/screens/profile.dart';
import 'package:app/screens/register.dart';
import 'package:app/widgets/app_bar.dart';
import 'package:app/widgets/icon_card.dart';
import 'package:app/widgets/images_cards.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class Home extends StatefulWidget {
  static const routeName = '/home';

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectedIndex = 0;
  Widget _myHome = MyHome();
  Widget _mySaved = MySaved();
  Widget _myBooking = MyBooking();
  Widget _myNoti = MyNoti();
  Widget _myAccount = MyAccount();

  @override
  Widget build(BuildContext context) {
    void onTapHandler(int index) {
      this.setState(() {
        selectedIndex = index;
      });
    }

    return Scaffold(
      body: getBody(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.pink,
        unselectedItemColor: Colors.black,
        selectedFontSize: 13,
        unselectedFontSize: 10,
        iconSize: 30,
        onTap: (int index) {
          onTapHandler(index);
        },
        items: [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: 'Saved',
            icon: Icon(Icons.favorite_border),
            activeIcon: Icon(Icons.favorite),
          ),
          BottomNavigationBarItem(
            label: 'My Booking',
            icon: Icon(Icons.library_books_outlined),
            activeIcon: Icon(Icons.library_books),
          ),
          BottomNavigationBarItem(
            label: 'Notifications',
            icon: Icon(Icons.notifications_outlined),
            activeIcon: Icon(Icons.notifications),
          ),
          BottomNavigationBarItem(
            label: 'My Account',
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
          ),
        ],
      ),
    );
  }

  Widget getBody() {
    if (selectedIndex == 0) {
      return _myHome;
    } else if (selectedIndex == 1) {
      return _mySaved;
    } else if (selectedIndex == 2) {
      return _myBooking;
    } else if (selectedIndex == 3) {
      return _myNoti;
    } else {
      return _myAccount;
    }
  }
}

class MyHome extends StatelessWidget {
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
        appBar: buildAppbar(context),
        body: SingleChildScrollView(
          child: SafeArea(
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
                        IconCard(
                            iconData: Icons.room_outlined, text: 'Booking'),
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
                    ImageCards(),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}

class MySaved extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Saved"));
  }
}

class MyBooking extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Booking"));
  }
}

class MyNoti extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Notification"));
  }
}

class MyAccount extends StatelessWidget {
  late File _image;
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

    Future takePicture() async {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      var stream = new http.ByteStream(image.openRead());
      var length = await image.length();
      var uri =
          Uri.parse("http://localhost:8080/api/auth/uploadImage/${user['id']}");
      var request = new http.MultipartRequest("POST", uri);
      var multipartFile =
          new http.MultipartFile('file', stream, length, filename: 'image.jpg');
      request.files.add(multipartFile);
      var response = await request.send();
      print(response.statusCode);
      Navigator.of(context).pushNamed(Home.routeName, arguments: retriveString);
    }

    return Scaffold(
      appBar: buildAppbar(context),
      body: SingleChildScrollView(
        child: SafeArea(
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
                          children: <Widget>[
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
                  )
                else
                  Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 115,
                        width: 115,
                        child: Stack(
                          fit: StackFit.expand,
                          overflow: Overflow.visible,
                          children: [
                            if (user["imageUrl"].contains("https"))
                              CircleAvatar(
                                backgroundImage: NetworkImage(user['imageUrl']),
                              )
                            else
                              CircleAvatar(
                                backgroundImage: NetworkImage(
                                    "http://localhost:8080/api/auth/getImage/" +
                                        user['imageUrl']),
                              ),
                            Positioned(
                              right: -5,
                              bottom: 0,
                              child: SizedBox(
                                  height: 46,
                                  width: 46,
                                  child: FlatButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                      side: BorderSide(color: Colors.white),
                                    ),
                                    color: Color(0xFFF5F6F9),
                                    child: SvgPicture.asset(
                                        "images/Camera Icon.svg"),
                                    onPressed: () {
                                      takePicture();
                                    },
                                  )),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                SizedBox(
                  height: 20,
                ),
                if (user["accessToken"] != null)
                  Column(
                    children: [
                      ProfileMenu(
                        icon: "images/User Icon.svg",
                        text: "My Account",
                        press: () {},
                      ),
                      ProfileMenu(
                        icon: "images/Bell.svg",
                        text: "Nofitications",
                        press: () {},
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
                        press: () {
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
    );
  }
}

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    Key? key,
    required this.icon,
    required this.text,
    required this.press,
  }) : super(key: key);
  final String icon, text;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: FlatButton(
        padding: EdgeInsets.all(15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: Color(0xFFF5F6F9),
        onPressed: press,
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
              color: Colors.pinkAccent,
              width: 22,
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
                child: Text(
              text,
              style: TextStyle(color: Colors.grey),
            )),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.pinkAccent,
            ),
          ],
        ),
      ),
    );
  }
}
