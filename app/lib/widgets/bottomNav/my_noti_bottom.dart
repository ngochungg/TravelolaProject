// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:app/screens/Post/my_post.dart';
import 'package:app/screens/login.dart';
import 'package:app/screens/register.dart';
import 'package:app/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MyPost extends StatefulWidget {
  @override
  State<MyPost> createState() => _MyPost();
}

class _MyPost extends State<MyPost> {
  var _id;
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
    return Scaffold(
      appBar: buildAppbar(context, 'travelola'),
      body: SingleChildScrollView(
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
                        children: [
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
                ),
              SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: 'Your Post History',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.pinkAccent)),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          primary: Colors.grey[100],
                          elevation: 0,
                        ),
                        onPressed: () async {
                          if (_id != null) {
                            final response = await http.get(Uri.parse(
                                "http://localhost:8080/api/posts/all"));
                            var alo = jsonDecode(response.body);
                            var nlist = [
                              for (int i = 0; i < alo.length; i++)
                                if (alo[i]['user']['id'] == _id) alo[i]
                            ];
                            var data = jsonEncode(nlist);
                            Navigator.of(context).pushNamed(MyPosting.routeName,
                                arguments: data);
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              backgroundColor: Colors.red,
                              content: Text("You need to login first"),
                            ));
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (_) => Login()));
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.history_outlined,
                                color: Colors.pinkAccent),
                            Text(
                              'View your postings history',
                              style: TextStyle(color: Colors.grey),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.pinkAccent,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
