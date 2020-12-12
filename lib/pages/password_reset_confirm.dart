import 'dart:convert';
import 'package:dsg/pages/login.dart';
import 'package:dsg/pages/password_reset.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PasswordResetConfirm extends StatefulWidget {
  @override
  _PasswordResetConfirmState createState() => _PasswordResetConfirmState();
}

class _PasswordResetConfirmState extends State<PasswordResetConfirm> {
  bool isLoading = false;
  String _resetToken;
  String _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildResetToken() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'TOKEN',
        labelStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
        focusedBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.purple)),
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Username is required';
        }
        return null;
      },
      onSaved: (String value) {
        _resetToken = value;
      },
    );
  }

  Widget _buildPassword() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'PASSWORD',
        labelStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
        focusedBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.purple)),
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Password is required';
        }

        if (!RegExp(
                r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
            .hasMatch(value)) {
          return 'Password must contain the following\n (Uppercase, lowercase, number, !, @, #, &, *, ~, and atleast 8 characters)';
        }
        return null;
      },
      onSaved: (String value) {
        _password = value;
      },
      obscureText: true,
    );
  }

  confirmReset(String password, String token) async {
    Map data = {
      'password': password,
      'token': token,
    };
    var jsonData = {};
    var response = await http.post(
      "https://dfair.herokuapp.com/api/accounts/password/reset/confirm/",
      body: data,
    );
    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      setState(() {
        isLoading = false;
        showDialog(
            context: context,
            builder: (_) => new AlertDialog(
                  title: new Text("Congratulations"),
                  content: new Text(
                      "Password is reset Successfully, You can now login"),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Reset'),
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginForm()),
                            (route) => false);
                      },
                    )
                  ],
                ));
      });
    } else {
      showDialog(
          context: context,
          builder: (_) => new AlertDialog(
                title: new Text("Invalid token"),
                content: new Text("Please copy the token and try again"),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Try Again!'),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PasswordResetConfirm()),
                          (route) => false);
                    },
                  )
                ],
              ));
      print(response.statusCode);
      print(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("D-Fair Shop")),
        backgroundColor: Colors.purple,
      ),
      body: isLoading
          ? Center(child: new CircularProgressIndicator())
          : Container(
              padding: EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 0.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(15.0, 85.0, 0.0, 0.0),
                          child: new Text(
                            "Reset Password",
                            style: TextStyle(
                              fontSize: 80.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        _buildResetToken(),
                        _buildPassword(),
                        SizedBox(height: 20.0),
                        RaisedButton(
                          onPressed: () async {
                            if (!_formKey.currentState.validate()) {
                              return;
                            }
                            _formKey.currentState.save();
                            setState(() {
                              isLoading = true;
                            });
                            confirmReset(
                              _password,
                              _resetToken,
                            );
                          },
                        )
                      ],
                    ),
                  ],
                ),
              )),
    );
  }
}
