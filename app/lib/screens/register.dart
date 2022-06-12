import 'dart:convert';

import 'package:app/model/registerModel.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:email_validator/email_validator.dart';
import 'package:lottie/lottie.dart';

import 'login.dart';

class Register extends StatefulWidget {
  Register({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginState();
}

class _LoginState extends State<Register> {
  final _formKey = GlobalKey<FormState>();

  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  String image = "default.png";
  final String url = "http://localhost:8080/api/auth/signup";

  Future save() async {
    var res = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'firstName': _firstnameController.text,
          'lastName': _lastnameController.text,
          'username': _usernameController.text,
          'password': _passwordController.text,
          'email': _emailController.text,
          'phone': _phoneController.text,
          'imageUrl': image
        }));
    if (res.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green,
        content: Text("Sign Up succescfull"),
      ));
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    } else if (res.statusCode == 400) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(res.body),
      ));
      _passwordController.clear();
      _confirmPasswordController.clear();
    }
  }

  void click() {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 1.8,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                      Colors.purpleAccent,
                      Colors.amber,
                      Colors.blue,
                    ])),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(
                      height: 40,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: BackButton(
                        color: Colors.white,
                        onPressed: () {
                          Navigator.of(context).popAndPushNamed('/home');
                        },
                      ),
                    ),
                    SizedBox(
                      height: 200,
                      width: 300,
                      child: LottieBuilder.asset("assets/lottie/login2.json"),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: 325,
                      height: 820,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          const Text(
                            "Hello",
                            style: TextStyle(
                                fontSize: 28, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            "Please Sign Up to Your Account",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Container(
                            width: 260,
                            height: 60,
                            child: TextFormField(
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return "Please enter your first name";
                                }
                              },
                              controller: _firstnameController,
                              decoration: InputDecoration(
                                  suffix: Icon(
                                    Icons.person,
                                    color: Colors.red,
                                  ),
                                  labelText: "First Name",
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                  )),
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Container(
                            width: 260,
                            height: 60,
                            child: TextFormField(
                              controller: _lastnameController,
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return "Please enter your last name";
                                }
                              },
                              decoration: InputDecoration(
                                  suffix: Icon(
                                    Icons.person,
                                    color: Colors.red,
                                  ),
                                  labelText: "Last Name",
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                  )),
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Container(
                            width: 260,
                            height: 60,
                            child: TextFormField(
                              controller: _usernameController,
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return "Please enter your username";
                                }
                              },
                              decoration: InputDecoration(
                                  suffix: Icon(
                                    Icons.person_outline,
                                    color: Colors.red,
                                  ),
                                  labelText: "Username",
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                  )),
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Container(
                            width: 260,
                            height: 60,
                            child: TextFormField(
                              obscureText: true,
                              controller: _passwordController,
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
                                    FontAwesomeIcons.eyeSlash,
                                    color: Colors.red,
                                  ),
                                  labelText: "Password",
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                  )),
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Container(
                            width: 260,
                            height: 60,
                            child: TextFormField(
                              obscureText: true,
                              controller: _confirmPasswordController,
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return "Please confirm your password";
                                }
                                if (val != _passwordController.text) {
                                  return "Password does not match";
                                }
                              },
                              decoration: InputDecoration(
                                  suffix: Icon(
                                    FontAwesomeIcons.eyeSlash,
                                    color: Colors.red,
                                  ),
                                  labelText: "Confirm Password",
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                  )),
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Container(
                            width: 260,
                            height: 60,
                            child: TextFormField(
                              controller: _phoneController,
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return "Please enter your phone number";
                                }
                              },
                              decoration: InputDecoration(
                                  suffix: Icon(
                                    FontAwesomeIcons.phone,
                                    color: Colors.red,
                                  ),
                                  labelText: "Phone Number",
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                  )),
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Container(
                            width: 260,
                            height: 60,
                            child: TextFormField(
                              controller: _emailController,
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return "Please enter your email";
                                }
                                if (EmailValidator.validate(val) == false) {
                                  return "Please enter a valid email";
                                }
                              },
                              decoration: InputDecoration(
                                  suffix: Icon(
                                    FontAwesomeIcons.envelope,
                                    color: Colors.red,
                                  ),
                                  labelText: "Email",
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                  )),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 30, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: click,
                                  child: const Text(
                                    "Forget Password",
                                    style: TextStyle(color: Colors.deepOrange),
                                  ),
                                )
                              ],
                            ),
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
                                      ])),
                              child: Padding(
                                padding: EdgeInsets.all(1),
                                child: TextButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      save();
                                    }
                                  },
                                  child: Text(
                                    'Sign Up',
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
                          const Text(
                            "Or Sign Up using Social Media Account",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                  onPressed: () {},
                                  icon: const Icon(FontAwesomeIcons.facebook,
                                      color: Colors.blue)),
                              IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    FontAwesomeIcons.google,
                                    color: Colors.redAccent,
                                  )),
                            ],
                          )
                        ],
                      ),
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
