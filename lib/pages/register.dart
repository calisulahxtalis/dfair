import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dsg/pages/login.dart';
import 'package:http/http.dart' as http;

Future<UserRegister> registerUser(String firstName, String lastName,
    String username, String email, String password, String password2) async {
  var result;
  final http.Response response = await http.post(
      'https://dfair.herokuapp.com/api/accounts/registration/',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'first_name': firstName,
        'last_name': lastName,
        'username': username,
        'email': email,
        'password': password,
        'password2': password2,
      }));

  if (response.statusCode == 200) {
    result = UserRegister.fromJson(json.decode(response.body));
    print(result);
    return result;
  } else {
    throw Exception('Error: ' + response.statusCode.toString());
  }
}

class UserRegister {
  String username;
  String password;
  String firstName;
  String lastName;
  String password2;
  String email;

  UserRegister(
      {this.username,
      this.password,
      this.email,
      this.firstName,
      this.lastName,
      this.password2});

  factory UserRegister.fromJson(Map<String, dynamic> json) {
    return UserRegister();
  }
}

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  String _firstName;
  String _lastName;
  String _email;
  String _userName;
  String _password;
  String _password2;

  Future<UserRegister> _futureUserRegister;
  String success;
  String usernamer;
  String passworder;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildFirstName() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'FIRST NAME'),
      validator: (String value) {
        if (value.isEmpty) {
          return 'First Name is required';
        }
        return null;
      },
      onSaved: (String value) {
        _firstName = value;
      },
    );
  }

  Widget _buildLastName() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'LAST NAME'),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Last Name is required';
        }
        return null;
      },
      onSaved: (String value) {
        _lastName = value;
      },
    );
  }

  Widget _buildUserName() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'USERNAME'),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Username is required';
        }
        return null;
      },
      onSaved: (String value) {
        _userName = value;
      },
    );
  }

  Widget _buildEmail() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'EMAIL ADDRESS'),
      keyboardType: TextInputType.emailAddress,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Email is required';
        }

        if (!RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(value)) {
          return 'Please enter a valid email address';
        }
        return null;
      },
      onSaved: (String value) {
        _email = value;
      },
    );
  }

  Widget _buildPassword() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'PASSWORD'),
      obscureText: true,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Password is required';
        }

        if (!RegExp(
                r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
            .hasMatch(value)) {
          return 'Password must contain the following\n (Uppercase, lowercase, number, !, @, #, &, *, ~,\n and atleast 8 characters)';
        }
        return null;
      },
      onSaved: (String value) {
        _password = value;
      },
    );
  }

  Widget _buildPassword2() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'CONFIRM PASSWORD'),
      obscureText: true,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Confirm Password is required';
        }

        if (!RegExp(
                r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
            .hasMatch(value)) {
          return 'Password must contain the following\n (Uppercase, lowercase, number, !, @, #, &, *, ~, and atleast 8 characters)';
        }
        return null;
        // if (value != _password) {
        //   return 'Passwords donot match';
        // }
      },
      onSaved: (String value) {
        _password2 = value;
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("D-Fair Shop")),
        backgroundColor: Colors.purple,
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 0.0),
        child: (_futureUserRegister == null)
            ? Form(
                key: _formKey,
                child: ListView(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                          child: new Text(
                            "SignUp",
                            style: TextStyle(
                              fontSize: 65.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        _buildFirstName(),
                        _buildLastName(),
                        _buildUserName(),
                        _buildEmail(),
                        _buildPassword(),
                        _buildPassword2(),
                        SizedBox(height: 20.0),
                        Container(
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
                                  _futureUserRegister = registerUser(
                                      _firstName,
                                      _lastName,
                                      _userName,
                                      _email,
                                      _password,
                                      _password2);
                                });
                              },
                              child: Center(
                                child: Text(
                                  'REGISTER',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
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
                            Navigator.of(context).pushNamed('/register');
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
                                    child: Icon(Icons.add_to_home_screen),
                                  ),
                                  SizedBox(
                                    width: 20.0,
                                  ),
                                  Center(
                                    child: Text(
                                      "Already registered?, Login Instead!",
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
                        SizedBox(height: 20.0)
                      ],
                    ),
                  ],
                ),
              )
            : FutureBuilder<UserRegister>(
                future: _futureUserRegister,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginForm(
                      usernamer: _userName,
                      passworder: _password,
                      
                    )));
                  } else if (snapshot.hasError) {
                    return Center(child: Text("${snapshot.error}"));
                  }

                  return Center(child: CircularProgressIndicator());
                },
              ),
      ),
    );
  }

}
