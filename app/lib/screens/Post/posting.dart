// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:app/widgets/bottomNav/bottom_navigation.dart';
import 'package:app/widgets/nofitication.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Posting extends StatelessWidget {
  static const routeName = '/posting';
  const Posting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _firstNameController = TextEditingController();
    final _lastNameController = TextEditingController();
    final _emailController = TextEditingController();
    final _phoneController = TextEditingController();

    Future takePicture() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var id = prefs.getInt('userId');
      var image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      var stream = http.ByteStream(image.openRead());
      var length = await image.length();
      var uri = Uri.parse("http://localhost:8080/api/posts/add");
      var request = http.MultipartRequest("POST", uri);
      var multipartFile =
          http.MultipartFile('imageUrl', stream, length, filename: 'image.jpg');

      request.fields['title'] = _firstNameController.text;
      request.fields['description'] = _lastNameController.text;
      request.fields['content'] = _emailController.text;
      request.files.add(multipartFile);
      request.fields['userId'] = id.toString();
      await request.send();
      notification(
          title: "Posted!!",
          body: "Your post has been posted, please check your post");
      Navigator.of(context).pushNamed(BottomNav.routeName);
    }

    return Scaffold(
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
                Navigator.of(context).pop();
              },
            ),
            const Text('Posting',
                style: TextStyle(color: Colors.white, fontSize: 18)),
            const SizedBox(
              width: 40,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Align(),
                  const SizedBox(
                    height: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: 260,
                        height: 60,
                        child: TextFormField(
                          controller: _firstNameController,
                          decoration: InputDecoration(
                              suffix: Icon(
                                FontAwesomeIcons.userAlt,
                                color: Colors.red,
                              ),
                              labelText: "Your title",
                              // hintText: "${user['firstName']}",
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                              )),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      SizedBox(
                        width: 260,
                        height: 60,
                        child: TextFormField(
                          controller: _lastNameController,
                          decoration: InputDecoration(
                              suffix: Icon(
                                FontAwesomeIcons.user,
                                color: Colors.red,
                              ),
                              labelText: "Description",
                              // hintText: "${user['lastName']}",
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                              )),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      SizedBox(
                        width: 260,
                        height: 180,
                        child: TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 100.0, horizontal: 10.0),
                              suffix: Icon(
                                FontAwesomeIcons.mailBulk,
                                color: Colors.red,
                              ),
                              labelText: "Content",
                              // hintText: "${user['email']}",
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                              )),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      GestureDetector(
                        child: Container(
                          alignment: Alignment.center,
                          width: 300,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Color(0xFF8A2387),
                                Color(0xFFE94057),
                                Color(0xFFF27121),
                              ],
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(1),
                            child: TextButton(
                              onPressed: () {
                                takePicture();
                              },
                              child: const Text(
                                'Select image and post',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 17,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
