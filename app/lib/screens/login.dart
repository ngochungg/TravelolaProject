import 'dart:convert';

import 'package:app/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_signin_button/flutter_signin_button.dart';

import 'register.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  static const routeName = '/login';

  @override
  State<StatefulWidget> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String url = "http://localhost:8080/api/auth/signin";

  Future googleLogin() async {
    var errorMessage;
    final GoogleSignIn _googleSignin = GoogleSignIn();
    var result = await _googleSignin.signIn();
    if (result != null) {
      var string = result.displayName;
      final first = string!.split(' ').first;
      final last = string.split(' ').last;
      var json = jsonEncode({
        "id": result.id,
        "firstName": first,
        "lastName": last,
        "email": result.email,
        "photoUrl": result.photoUrl,
      });

      String googleUrl = "http://localhost:8080/api/auth/loginGoogle";
      var response = await http.post(Uri.parse(googleUrl),
          body: json, headers: {"Content-Type": "application/json"});
      Navigator.pushNamed(context, Home.routeName, arguments: response.body);
    } else {
      errorMessage = "Cancalled";
      return print(errorMessage);
    }
  }

  Future fbLogin() async {}

  Future login() async {
    String username = _usernameController.text;
    String password = _passwordController.text;
    var body = jsonEncode({
      "username": username,
      "password": password,
    });
    final response = await http.post(Uri.parse(url), body: body, headers: {
      "Content-Type": "application/json",
    });
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green,
        content: Text("Login succescfull"),
      ));
      final String user = response.body;
      // print(user);
      Navigator.pushNamed(context, Home.routeName, arguments: user);
    }
    if (response.statusCode == 401) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text("Incorrect username or password"),
      ));
      _passwordController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Container(
              height: 500,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Color.fromRGBO(233, 65, 82, 1),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 10,
                        offset: Offset(1, 5))
                  ],
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(80),
                    bottomRight: Radius.circular(20),
                  )),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(children: [
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Login",
                    style: GoogleFonts.pacifico(
                        fontWeight: FontWeight.bold,
                        fontSize: 50,
                        color: Colors.white),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Username",
                      style: GoogleFonts.roboto(
                        // fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Color.fromRGBO(255, 255, 255, 0.8),
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: _usernameController,
                    // validator: (value) {
                    //   if (value == null || value.isEmpty) {
                    //     return 'Please enter username';
                    //   }
                    //   return null;
                    // },
                    style: TextStyle(fontSize: 20, color: Colors.white),
                    decoration: InputDecoration(
                        border:
                            OutlineInputBorder(borderSide: BorderSide.none)),
                  ),
                  Container(
                    height: 8,
                    color: Color.fromRGBO(255, 255, 255, 0.4),
                  ),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Password",
                      style: GoogleFonts.roboto(
                        // fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Color.fromRGBO(255, 255, 255, 0.8),
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    // validator: (value) {
                    //   if (value == null || value.isEmpty) {
                    //     return 'Please enter password';
                    //   }
                    //   return null;
                    // },
                    style: TextStyle(fontSize: 20, color: Colors.white),
                    decoration: InputDecoration(
                        border:
                            OutlineInputBorder(borderSide: BorderSide.none)),
                  ),
                  Container(
                    height: 8,
                    color: Color.fromRGBO(255, 255, 255, 0.4),
                  ),
                  SizedBox(height: 30),
                  Center(
                      child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Register()));
                          },
                          child: Text(
                            "Don't have Account ?",
                            style: GoogleFonts.roboto(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.white),
                          ))),
                ]),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SignInButton(Buttons.Google, onPressed: () {
              googleLogin();
            }),
            SignInButton(Buttons.Facebook, onPressed: () {
              fbLogin();
            }),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 70,
              width: 70,
              child: FlatButton(
                color: Color.fromRGBO(233, 65, 82, 1),
                onPressed: () {
                  if (_usernameController.text.isEmpty &&
                      _passwordController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: Colors.red,
                      content: Text("Please enter username and password"),
                    ));
                    return;
                  }
                  if (_usernameController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: Colors.red,
                      content: Text("Please enter username"),
                    ));
                    return;
                  }
                  if (_passwordController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: Colors.red,
                      content: Text("Please enter password"),
                    ));
                    return;
                  } else {
                    login();
                  }
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40)),
                child: Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
