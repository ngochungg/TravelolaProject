import 'dart:convert';
import 'dart:io';

import 'package:app/controller/apiController.dart';
import 'package:app/controller/dataController.dart';
import 'package:app/screens/profile.dart';
import 'package:app/widgets/profile_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../model/user.dart';
import '../../screens/home.dart';
import '../../screens/login.dart';
import '../../screens/register.dart';
import '../app_bar.dart';
import 'bottom_navigation.dart';

class MyAccount extends StatelessWidget {
  static const routeName = '/myAccount';
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
      var stream = http.ByteStream(image.openRead());
      var length = await image.length();
      var uri =
          Uri.parse("http://localhost:8080/api/auth/uploadImage/${user['id']}");
      var request = new http.MultipartRequest("POST", uri);
      var multipartFile =
          http.MultipartFile('file', stream, length, filename: 'image.jpg');
      request.files.add(multipartFile);
      await request.send();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final responseImage = await http
          .post(Uri.parse(urlSignin), body: prefs.getString('body'), headers: {
        "Content-Type": "application/json",
      });
      storeUserData(responseImage.body);
      Navigator.pop(context);
      Navigator.pushReplacementNamed(context, Home.routeName,
          arguments: responseImage.body);
    }

    Future getUser() async {
      print(user);
    }

    return Scaffold(
      appBar: buildAppbar(context, 'My Account'),
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
    );
  }
}
