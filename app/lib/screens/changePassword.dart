// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:app/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../controller/apiController.dart';
import '../controller/dataController.dart';

class ChangePassword extends StatelessWidget {
  static const routeName = '/changePassword';
  const ChangePassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final data = ModalRoute.of(context)!.settings;
    late String retriveString;
    if (data.arguments == null) {
      retriveString = jsonEncode({"empty": "empty"});
    } else {
      retriveString = (data.arguments.toString());
    }

    var user = jsonDecode(retriveString);
    final _oldPassword = TextEditingController();
    final _newPassword = TextEditingController();
    final _comfirmNewPassword = TextEditingController();

    Future changePassword() async {
      var data = jsonEncode({
        "oldPassword": _oldPassword.text,
        "newPassword": _newPassword.text,
      });
      final changePasswordResponse = await http.post(
          Uri.parse(urlChangePassword + "/${user['id']}"),
          body: data,
          headers: {
            "Content-Type": "application/json",
          });
      if (changePasswordResponse.body
          .contains("Old password is not correct!")) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.red,
          content: Text("Old password is not correct!"),
        ));
        _oldPassword.clear();
        _newPassword.clear();
        _comfirmNewPassword.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.green,
          content: Text("Password changed successfully"),
        ));
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) => Home()));
      }
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
            const Text('Change Your Password',
                style: TextStyle(color: Colors.white, fontSize: 18)),
            const SizedBox(
              width: 40,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Column(
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
                          'Your password will be change and you will need to login again.',
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
                          controller: _oldPassword,
                          obscureText: true,
                          decoration: InputDecoration(
                              suffix: Icon(
                                FontAwesomeIcons.userAlt,
                                color: Colors.red,
                              ),
                              labelText: "Old Password",
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
                          controller: _newPassword,
                          obscureText: true,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "Please enter your password";
                            }
                            if (val.length < 8) {
                              return "Password must be at least 8 characters";
                            }
                          },
                          decoration: InputDecoration(
                              suffix: Icon(
                                FontAwesomeIcons.user,
                                color: Colors.red,
                              ),
                              labelText: "New Password",
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
                          controller: _comfirmNewPassword,
                          obscureText: true,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "Please confirm your password";
                            }
                            if (val != _newPassword.text) {
                              return "Password does not match";
                            }
                          },
                          decoration: InputDecoration(
                              suffix: Icon(
                                FontAwesomeIcons.user,
                                color: Colors.red,
                              ),
                              labelText: "Confirm New Password",
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
                      GestureDetector(
                        child: Container(
                          alignment: Alignment.center,
                          width: 250,
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
                                if (_formKey.currentState!.validate()) {
                                  changePassword();
                                }
                              },
                              child: const Text(
                                'Change Password',
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
            ],
          ),
        ),
      ),
    );
  }
}
