// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:app/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../controller/apiController.dart';
import '../controller/dataController.dart';

class EditInfo extends StatelessWidget {
  static const routeName = '/editInfo';
  const EditInfo({Key? key}) : super(key: key);

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
    final _firstNameController = TextEditingController();
    final _lastNameController = TextEditingController();
    final _emailController = TextEditingController();
    final _phoneController = TextEditingController();
    Future saveChanges() async {
      var data = jsonEncode({
        "firstName": _firstNameController.text,
        "lastName": _lastNameController.text,
        "email": _emailController.text,
        "phone": _phoneController.text,
      });
      final editResponse = await http.post(
          Uri.parse(urlEditInfo + "/${user['id']}"),
          body: data,
          headers: {
            "Content-Type": "application/json",
          });
      print(editResponse.body);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final responseProfile = await http
          .post(Uri.parse(urlSignin), body: prefs.getString('body'), headers: {
        "Content-Type": "application/json",
      });
      storeUserData(responseProfile.body);
      Navigator.of(context).pushReplacementNamed(Profile.routeName,
          arguments: responseProfile.body);
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
                  Navigator.of(context).pop();
                },
              ),
              const Text('Edit My Profile',
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
                        const Text(
                            'Your first name and last name will also appear as your profile name.',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center),
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
                                labelText: "First Name",
                                hintText: "${user['firstName']}",
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
                                labelText: "Last Name",
                                hintText: "${user['lastName']}",
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
                            controller: _emailController,
                            decoration: InputDecoration(
                                suffix: Icon(
                                  FontAwesomeIcons.mailBulk,
                                  color: Colors.red,
                                ),
                                labelText: "Email",
                                hintText: "${user['email']}",
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
                            controller: _phoneController,
                            decoration: InputDecoration(
                                suffix: Icon(
                                  FontAwesomeIcons.phoneSquare,
                                  color: Colors.red,
                                ),
                                labelText: "Phone",
                                hintText: "${user['phone']}",
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                )),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        GestureDetector(
                          child: Container(
                            alignment: Alignment.center,
                            width: 250,
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
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
                                  saveChanges();
                                },
                                child: const Text(
                                  'Save',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
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
      ),
    );
  }
}
