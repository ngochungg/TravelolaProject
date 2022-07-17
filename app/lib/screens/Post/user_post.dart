// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:app/screens/Post/post_detail.dart';
import 'package:app/screens/Post/posting.dart';
import 'package:app/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserPost extends StatefulWidget {
  static const routeName = '/user-post';
  UserPost({Key? key}) : super(key: key);

  @override
  State<UserPost> createState() => _UserPostState();
}

class _UserPostState extends State<UserPost> {
  dynamic isLoggedIn;
  late SharedPreferences prefs;
  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  void checkLogin() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // print(isLoggedIn);
    final data = ModalRoute.of(context)!.settings;
    late String retriveString;
    if (data.arguments == null) {
      retriveString = jsonEncode({"empty": "empty"});
    } else {
      retriveString = (data.arguments.toString());
    }

    var post = jsonDecode(retriveString);
    int number = 70;
    var nlist = [for (int i = 0; i < post.length; i++) post[i]];
    nlist.sort((b, a) => a['id'].compareTo(b['id']));
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
            SizedBox(
              width: 45,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (isLoggedIn == true) {
                        Navigator.of(context).pushNamed(Posting.routeName);
                      } else {
                        Navigator.of(context).pushNamed(Login.routeName);
                      }
                    },
                    child: Container(
                      height: 50,
                      width: 300,
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(34),
                        border: Border.all(
                          color: Colors.grey,
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        "what's on your mind ?",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            for (int i = 0; i < post.length; i++)
              if (nlist[i]['user']['roles'][0]['id'] == 1)
                SizedBox(
                    width: MediaQuery.of(context).size.width * 2,
                    height: 370,
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            primary: Colors.white,
                            elevation: 0,
                          ),
                          onPressed: () async {
                            final reponse = await http.get(Uri.parse(
                                'http://localhost:8080/api/posts/${nlist[i]['id']}'));
                            Navigator.of(context).pushNamed(
                                PostDetails.routeName,
                                arguments: reponse.body);
                          },
                          child: Column(
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Text(
                                      "${nlist[i]['title']}",
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    if (nlist[i]['content'].length > number)
                                      Flexible(
                                        child: Text(
                                            "${nlist[i]['content'].toString().substring(0, number)}...",
                                            style:
                                                TextStyle(color: Colors.black)),
                                      )
                                    else
                                      Flexible(
                                        child: Text("${nlist[i]['content']}",
                                            style:
                                                TextStyle(color: Colors.black)),
                                      )
                                  ],
                                ),
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  "http://localhost:8080/api/auth/getImage/${nlist[i]['imageUrl']}",
                                  height: 200.0,
                                  width: 300.0,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.remove_red_eye_outlined,
                                    color: Colors.black,
                                    // size: 18,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text('${nlist[i]['viewCount']}',
                                      style: TextStyle(color: Colors.black)),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
          ],
        ),
      ),
    );
  }
}
