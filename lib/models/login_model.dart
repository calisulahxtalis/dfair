// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
    LoginModel({
        this.username,
        this.password,
        this.nonFieldErrors,
        this.token,
        this.expiry,
    });

    String username;
    String password;
    List<dynamic> nonFieldErrors;
    String token;
    String expiry;

    factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        username: json["username"],
        password: json["password"],
        nonFieldErrors: List<dynamic>.from(json["non_field_errors"].map((x) => x)),
        token: json["token"],
        expiry: json["expiry"],
    );

    Map<String, dynamic> toJson() => {
        "username": username,
        "password": password,
        "non_field_errors": List<dynamic>.from(nonFieldErrors.map((x) => x)),
        "token": token,
        "expiry": expiry,
    };
}
