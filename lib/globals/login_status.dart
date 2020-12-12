import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dsg/pages/login.dart';
import 'package:dsg/main.dart';


SharedPreferences sharedPreferences;
void checkLoginStatus(BuildContext context) async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString('token') == null) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginForm()),
          (route) => false);
    } else {
      Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => HomePage(
                      userToken: sharedPreferences.getString('token'),
                    )),
            (route) => false);
    }
  }