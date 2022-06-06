import 'dart:convert';
import 'dart:io';

import 'package:app/login.dart';
import 'package:app/model/registerModel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:email_validator/email_validator.dart';
import 'package:image_picker/image_picker.dart';

class Register extends StatefulWidget {
  Register({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();

  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final String url = "http://localhost:8080/api/auth/signup";

  var image;

  /// Get from gallery
  void _uploadImage() async {
    final _picker = ImagePicker();

    var _pickedImage = await _picker.getImage(source: ImageSource.gallery);

    setState(() {
      image = _pickedImage?.path;
    });
  }

  Future save() async {
    var res = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'firstName': _firstnameController.text,
          'lastName': _lastnameController.text,
          'username': _usernameController.text,
          'password': _passwordController.text,
          'email': _emailController.text,
          'phone': _phoneController.text
        }));
    if (res.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green,
        content: Text("Login succescfull"),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Container(
              height: 1020,
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
                    "Register",
                    style: GoogleFonts.pacifico(
                        fontWeight: FontWeight.bold,
                        fontSize: 50,
                        color: Colors.white),
                  ),
                  SizedBox(
                    height: 30,
                  ),

                  //image
                  Container(
                    child: Center(
                      child: image != null ? Image.file(File(image)) : null
                    ),
                    floatingActionButton: FloatingActionButton(
        onPressed: _uploadImage,
        tooltip: 'Upload image',
        child: Icon(Icons.image),
      ),
                  )

                  //firstname
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "First name",
                      style: GoogleFonts.roboto(
                        // fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Color.fromRGBO(255, 255, 255, 0.8),
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: _firstnameController,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Please enter firstname';
                      }
                    },
                    style: TextStyle(fontSize: 20, color: Colors.white),
                    decoration: InputDecoration(
                        errorStyle:
                            TextStyle(color: Colors.white, fontSize: 15),
                        border:
                            OutlineInputBorder(borderSide: BorderSide.none)),
                  ),
                  Container(
                    height: 8,
                    color: Color.fromRGBO(255, 255, 255, 0.4),
                  ),
                  SizedBox(height: 10),

                  //lastname
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Last name",
                      style: GoogleFonts.roboto(
                        // fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Color.fromRGBO(255, 255, 255, 0.8),
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: _lastnameController,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Please enter lastname';
                      }
                    },
                    style: TextStyle(fontSize: 20, color: Colors.white),
                    decoration: InputDecoration(
                        errorStyle:
                            TextStyle(color: Colors.white, fontSize: 15),
                        border:
                            OutlineInputBorder(borderSide: BorderSide.none)),
                  ),
                  Container(
                    height: 8,
                    color: Color.fromRGBO(255, 255, 255, 0.4),
                  ),
                  SizedBox(height: 10),

                  //username
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
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Please enter username';
                      }
                    },
                    style: TextStyle(fontSize: 20, color: Colors.white),
                    decoration: InputDecoration(
                        errorStyle:
                            TextStyle(color: Colors.white, fontSize: 15),
                        border:
                            OutlineInputBorder(borderSide: BorderSide.none)),
                  ),
                  Container(
                    height: 8,
                    color: Color.fromRGBO(255, 255, 255, 0.4),
                  ),
                  SizedBox(height: 10),

                  //password
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
                    obscureText: true,
                    controller: _passwordController,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Please enter password';
                      }
                      if (val.length < 8) {
                        return 'Password must be at least 8 characters';
                      }
                    },
                    style: TextStyle(fontSize: 20, color: Colors.white),
                    decoration: InputDecoration(
                        errorStyle:
                            TextStyle(color: Colors.white, fontSize: 15),
                        border:
                            OutlineInputBorder(borderSide: BorderSide.none)),
                  ),
                  Container(
                    height: 8,
                    color: Color.fromRGBO(255, 255, 255, 0.4),
                  ),
                  SizedBox(height: 10),

                  //confirm password
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Confirm password",
                      style: GoogleFonts.roboto(
                        // fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Color.fromRGBO(255, 255, 255, 0.8),
                      ),
                    ),
                  ),
                  TextFormField(
                    obscureText: true,
                    controller: _confirmPasswordController,
                    validator: (val) {
                      if (val != _passwordController.text) {
                        return "Password doesn't match";
                      }
                    },
                    style: TextStyle(fontSize: 20, color: Colors.white),
                    decoration: InputDecoration(
                        errorStyle:
                            TextStyle(color: Colors.white, fontSize: 15),
                        border:
                            OutlineInputBorder(borderSide: BorderSide.none)),
                  ),
                  Container(
                    height: 8,
                    color: Color.fromRGBO(255, 255, 255, 0.4),
                  ),
                  SizedBox(height: 10),

                  //email
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Email",
                      style: GoogleFonts.roboto(
                        // fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Color.fromRGBO(255, 255, 255, 0.8),
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: _emailController,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Please enter email';
                      }
                      if (EmailValidator.validate(val) == false) {
                        return 'Please enter valid email';
                      }
                    },
                    style: TextStyle(fontSize: 20, color: Colors.white),
                    decoration: InputDecoration(
                        errorStyle:
                            TextStyle(color: Colors.white, fontSize: 15),
                        border:
                            OutlineInputBorder(borderSide: BorderSide.none)),
                  ),
                  Container(
                    height: 8,
                    color: Color.fromRGBO(255, 255, 255, 0.4),
                  ),
                  SizedBox(height: 10),

                  //phone
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Phone number",
                      style: GoogleFonts.roboto(
                        // fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Color.fromRGBO(255, 255, 255, 0.8),
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: _phoneController,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Please enter your phone number";
                      }
                    },
                    style: TextStyle(fontSize: 20, color: Colors.white),
                    decoration: InputDecoration(
                        errorStyle:
                            TextStyle(color: Colors.white, fontSize: 15),
                        border:
                            OutlineInputBorder(borderSide: BorderSide.none)),
                  ),
                  Container(
                    height: 8,
                    color: Color.fromRGBO(255, 255, 255, 0.4),
                  ),
                  SizedBox(height: 10),

                  //button
                  Center(
                      child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Login()));
                          },
                          child: Text(
                            "Already have Account ?",
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
            Container(
              height: 70,
              width: 70,
              child: FlatButton(
                color: Color.fromRGBO(233, 65, 82, 1),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    save();
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
            )
          ],
        ),
      ),
    ));
  }
}
