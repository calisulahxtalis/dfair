
import 'package:flutter/foundation.dart';

class UserRegister {
  String firstName;
  String lastName;
  String username;
  String email;
  String password;
  String password2;

  UserRegister({
    @required this.email,
    @required this.firstName,
    @required this.lastName,
    @required this.password,
    @required this.password2,
    @required this.username,
  });

  Map<String, dynamic> toJson() {
    return {
      "first_name": firstName,
      "last_name": lastName,
      "username": username,
      "email": email,
      "password": password,
      "password2": password2,
    };
  }
}

class UserLogin {
  String username;
  String password;

  UserLogin({
    @required this.username,
    @required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "password": password,
    };
  }

  factory UserLogin.fromJson(Map<String, dynamic> json) {
    return UserLogin(username: json['username'], password: json['password']);
  }
}