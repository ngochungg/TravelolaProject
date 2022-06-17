// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unused_local_variable, unnecessary_new

import 'dart:convert';

import 'package:flutter/material.dart';

import '../widgets/bottomNav/bottom_navigation.dart';

class Home extends StatefulWidget {
  static const routeName = '/home';

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: BottomNav(),
      ),
    );
  }
}
