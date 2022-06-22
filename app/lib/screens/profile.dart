import 'dart:convert';

import 'package:app/controller/apiController.dart';
import 'package:app/controller/dataController.dart';
import 'package:app/screens/editInfo.dart';
import 'package:app/widgets/bottomNav/my_account_bottom.dart';
import 'package:app/widgets/profile_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'changePassword.dart';
import 'home.dart';

class Profile extends StatefulWidget {
  static const routeName = '/profile';
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? _image;
  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)!.settings;
    late String retriveString;
    if (data.arguments == null) {
      retriveString = jsonEncode({"empty": "empty"});
    } else {
      retriveString = (data.arguments.toString());
    }

    var user = json.decode(utf8.decode(retriveString.codeUnits));
    // _image = user['imageUrl'];

    Future takePicture() async {
      var image = await ImagePicker().pickImage(source: ImageSource.gallery);
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
      var data = jsonDecode(responseImage.body);

      setState(() {
        _image = data['imageUrl'];
      });
    }

    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.pinkAccent,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              BackButton(
                color: Colors.white,
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  final response = await http.post(Uri.parse(urlSignin),
                      body: prefs.getString('body'),
                      headers: {
                        "Content-Type": "application/json",
                      });
                  Navigator.of(context)
                      .pushNamed(Home.routeName, arguments: response.body);
                },
              ),
            ],
          ),
        ),
        body: Column(
          children: <Widget>[
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Stack(
                    // clipBehavior: Clip.none,
                    // fit: StackFit.expand,
                    children: [
                      if (user["imageUrl"].contains("https"))
                        CircleAvatar(
                          radius: 45,
                          backgroundImage: _image == null
                              ? NetworkImage('${user['imageUrl']}')
                              : NetworkImage('$_image'),
                        )
                      else
                        CircleAvatar(
                            radius: 45,
                            backgroundImage: _image == null
                                ? NetworkImage(
                                    "http://localhost:8080/api/auth/getImage/${user['imageUrl']}")
                                : NetworkImage(
                                    'http://localhost:8080/api/auth/getImage/$_image')),
                      Positioned(
                        right: -10,
                        bottom: -10,
                        child: SizedBox(
                            height: 46,
                            width: 46,
                            child: FlatButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                                side: BorderSide(color: Colors.white),
                              ),
                              color: Color(0xFFF5F6F9),
                              child: SvgPicture.asset("images/Camera Icon.svg"),
                              onPressed: () {
                                takePicture();
                              },
                            )),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 150,
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: RichText(
                          text: TextSpan(children: [
                            TextSpan(
                                text: 'Name:   ',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.pinkAccent[100])),
                            TextSpan(
                                text:
                                    '${user['firstName']} ${user['lastName']}\n',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey[800])),
                            TextSpan(
                                text: 'Email:    ',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.pinkAccent[100])),
                            TextSpan(
                                text: '${user["email"]}\n',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey[800])),
                            TextSpan(
                                text: 'Phone:   ',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.pinkAccent[100])),
                            TextSpan(
                                text: '${user["phone"]}',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey[800])),
                          ]),
                        ),
                      )),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                ProfileMenu(
                    icon: "images/User Icon.svg",
                    text: "Edit information",
                    press: () {
                      Navigator.pushNamed(context, EditInfo.routeName,
                          arguments: retriveString);
                    }),
                ProfileMenu(
                    icon: "images/User Icon.svg",
                    text: "Change password",
                    press: () {
                      Navigator.pushNamed(context, ChangePassword.routeName,
                          arguments: retriveString);
                    })
              ],
            )
          ],
        ),
      ),
    );
  }
}
