import 'package:app/screens/dashboard.dart';
import 'package:app/screens/home.dart';
import 'package:app/screens/login.dart';
import 'package:app/screens/profile.dart';
import 'package:app/widgets/bottomNav/my_account_bottom.dart';
import 'package:app/widgets/bottomNav/my_home_bottom.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: 'Named Routes Demo',
    debugShowCheckedModeBanner: false,
    initialRoute: Dashboard.routeName,
    routes: {
      Login.routeName: (context) => const Login(),
      Dashboard.routeName: (context) => Dashboard(),
      MyAccount.routeName: (context) => MyAccount(),
      MyHome.routeName: (context) => MyHome(),
      Profile.routeName: (context) => Profile(),
      Home.routeName: (context) => Home(),
    },
  ));
}
