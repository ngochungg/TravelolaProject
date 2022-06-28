import 'dart:convert';

import 'package:app/model/loginModel.dart';
import 'package:app/screens/forgetPassword.dart';
import 'package:app/screens/home.dart';
import 'package:app/widgets/bottomNav/bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controller/apiController.dart';
import '../controller/dataController.dart';

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

  Future googleLogin() async {
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
      var username = "Google" + result.id;
      var body = jsonEncode({"username": username, "password": result.id});
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var response = await http.post(Uri.parse(googleUrl),
          body: json, headers: {"Content-Type": "application/json"});
      var array = jsonDecode(response.body);
      prefs.setString("body", body);
      prefs.setInt('userId', array['id']);
      prefs.setString('username', array['username']);
      prefs.setString('phone', array['phone']);
      storeUserData(response.body);
      Navigator.pushNamed(context, Home.routeName, arguments: response.body);
    } else {
      return print("Cancalled");
    }
  }

  Future fbLogin() async {
    final result = await FacebookAuth.i.login();
    final requestData = await FacebookAuth.i.getUserData();
    if (result != null) {
      var string = requestData["name"];
      final first = string!.split(' ').first;
      final last = string.split(' ').last;
      var json = jsonEncode({
        "id": requestData["id"],
        "firstName": first,
        "lastName": last,
        "email": requestData["email"],
        "photoUrl": requestData["picture"]["data"]["url"],
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      var response = await http.post(Uri.parse(fbUrl),
          body: json, headers: {"Content-Type": "application/json"});

      var username = "Facebook" + requestData["id"];
      var body =
          jsonEncode({"username": username, "password": requestData["id"]});
      var array = jsonDecode(response.body);
      prefs.setString("body", body);
      prefs.setInt('userId', array['id']);
      prefs.setString('username', array['username']);
      prefs.setString('phone', array['phone']);
      storeUserData(response.body);
      Navigator.pushNamed(context, Home.routeName, arguments: response.body);
    } else {
      return print("Cancalled");
    }
  }

  Future login() async {
    String username = _usernameController.text;
    String password = _passwordController.text;
    var body = jsonEncode({
      "username": username,
      "password": password,
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('body', body);
    final response =
        await http.post(Uri.parse(urlSignin), body: body, headers: {
      "Content-Type": "application/json",
    });
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.green,
        content: Text("Login succescfull"),
      ));
      final String user = response.body;
      var array = jsonDecode(user);
      prefs.setInt('userId', array['id']);
      prefs.setString('username', array['username']);
      prefs.setString('phone', array['phone']);
      prefs.setBool("isLoggedIn", true);
      storeUserData(user);
      Navigator.pushNamed(context, Home.routeName, arguments: user);
    }
    if (response.statusCode == 401) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.red,
        content: Text("Incorrect username or password"),
      ));
      _passwordController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 1.2,
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
                          Navigator.of(context).pop();
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
                      height: 470,
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
                            "Please Login to Your Account",
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
                              controller: _usernameController,
                              decoration: const InputDecoration(
                                  suffix: const Icon(
                                    FontAwesomeIcons.envelope,
                                    color: Colors.red,
                                  ),
                                  labelText: "Username",
                                  border: const OutlineInputBorder(
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
                              controller: _passwordController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                  suffix: Icon(
                                    FontAwesomeIcons.eyeSlash,
                                    color: Colors.red,
                                  ),
                                  labelText: "Password",
                                  border: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8)),
                                  )),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 30, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ForgetPassword()));
                                  },
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
                                  ],
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(1),
                                child: TextButton(
                                  onPressed: () {
                                    if (_usernameController.text.isEmpty &&
                                        _passwordController.text.isEmpty) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        backgroundColor: Colors.red,
                                        content: const Text(
                                            "Please enter username and password"),
                                      ));
                                      return;
                                    }
                                    if (_usernameController.text.isEmpty) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        backgroundColor: Colors.red,
                                        content:
                                            const Text("Please enter username"),
                                      ));
                                      return;
                                    }
                                    if (_passwordController.text.isEmpty) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        backgroundColor: Colors.red,
                                        content:
                                            const Text("Please enter password"),
                                      ));
                                      return;
                                    } else {
                                      login();
                                    }
                                  },
                                  child: const Text(
                                    'Login',
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
                            "Or Login using Social Media Account",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    fbLogin();
                                  },
                                  icon: const Icon(FontAwesomeIcons.facebook,
                                      color: Colors.blue)),
                              IconButton(
                                  onPressed: () {
                                    googleLogin();
                                  },
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
