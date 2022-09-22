import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../model/user.dart';

void storeUserData(String data) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //store the user entered data in user object
  User user1 = User.fromJson(jsonDecode(data));
  // encode / convert object into json string
  String user = jsonEncode(user1);
  // print(user);
  //save the data into sharedPreferences using key-value pairs
  prefs.setString('userdata', user);
}

void readUserData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Map<String, dynamic> jsondatais = jsonDecode(prefs.getString('userdata')!);
  var user = User.fromJson(jsondatais);
  print(user.toJson());
}
