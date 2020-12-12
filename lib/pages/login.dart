import 'dart:convert';
import 'package:dsg/main.dart';
import 'package:dsg/pages/password_reset.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dsg/globals/login_status.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginForm extends StatefulWidget {
  final String success;
  final String usernamer;
  final String passworder;
  LoginForm({this.success, this.usernamer, this.passworder});
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool isLoading = false;
  String _username;
  String _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildUsername() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'USERNAME',
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
        _username = value;
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
        return null;
      },
      onSaved: (String value) {
        _password = value;
      },
      obscureText: true,
    );
  }

  login(String username, String password) async {
    Map data = {
      'username': username,
      'password': password,
    };
    var jsonData = {};
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var response = await http.post(
      "https://dfair.herokuapp.com/api/accounts/login/",
      body: data,
    );
    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      setState(() {
        isLoading = false;
        sharedPreferences.setString('token', jsonData['token']);
        print(sharedPreferences.getString('token'));
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => HomePage(
                      userToken: jsonData['token'],
                    )),
            (route) => false);
      });
    } else {
      showDialog(
          context: context,
          builder: (_) => new AlertDialog(
                title: new Text("Login Failed"),
                content: new Text("Password or username is incorrect"),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Try Again!'),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => LoginForm()),
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
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLoginStatus(context);
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
                            "Login",
                            style: TextStyle(
                              fontSize: 80.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        (widget.success == null)
                            ? SizedBox(height: 12.0)
                            : new SnackBar(
                                content: Text(
                                  widget.success,
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.purple,
                              ),
                        _buildUsername(),
                        _buildPassword(),
                        SizedBox(height: 20.0),
                        InkWell(
                          onTap: () {},
                          child: Container(
                            height: 40.0,
                            child: new Material(
                              borderRadius: BorderRadius.circular(20.0),
                              shadowColor: Colors.purpleAccent,
                              color: Colors.purple,
                              elevation: 7.0,
                              child: GestureDetector(
                                onTap: () async {
                                  if (!_formKey.currentState.validate()) {
                                    return;
                                  }
                                  _formKey.currentState.save();
                                  setState(() {
                                    isLoading = true;
                                  });
                                  login(_username, _password);
                                },
                                child: Center(
                                  child: Text(
                                    'LOGIN',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => PasswordReset()));
                          },
                          child: Container(
                            height: 40.0,
                            color: Colors.transparent,
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.black,
                                      style: BorderStyle.solid,
                                      width: 1.0),
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(20.0)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                    child: Text(
                                      "Forgot Password ?",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed('/register');
                          },
                          child: Container(
                            height: 40.0,
                            child: new Material(
                              borderRadius: BorderRadius.circular(20.0),
                              shadowColor: Colors.purpleAccent,
                              color: Colors.teal,
                              elevation: 7.0,
                              child: GestureDetector(
                                onTap: () {},
                                child: Center(
                                  child: Text(
                                    'Not a member? Register',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )),
    );
  }
}
