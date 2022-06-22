import 'package:app/controller/apiController.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;

import 'login.dart';

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final _emailController = TextEditingController();

    Future forgetPass() async {
      String email = _emailController.text;
      final response = await http
          .post(Uri.parse(base_url + '/forgotPassword/$email'), headers: {
        'Content-Type': 'application/json',
      });
      if (response.body.contains('User not found')) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.red,
          content: const Text("Your email is not registered"),
        ));
        _emailController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.green,
          content: const Text("Your account password is sent to your email"),
        ));
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Login(),
        ));
      }
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
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
                            "Please enter to Your Email",
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
                                  return 'Please enter your email';
                                }
                                if (EmailValidator.validate(val) == false) {
                                  return "Please enter a valid email";
                                }
                              },
                              controller: _emailController,
                              decoration: const InputDecoration(
                                  suffix: const Icon(
                                    FontAwesomeIcons.envelope,
                                    color: Colors.red,
                                  ),
                                  labelText: "Your email",
                                  border: const OutlineInputBorder(
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
                                    if (_formKey.currentState!.validate()) {
                                      forgetPass();
                                    }
                                  },
                                  child: const Text(
                                    'Send Email',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ),
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
