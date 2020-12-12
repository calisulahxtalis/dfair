import 'dart:convert';
import 'package:dsg/pages/password_reset_confirm.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PasswordReset extends StatefulWidget {
  @override
  _PasswordResetState createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {
  bool isLoading = false;
  reset(String email) async {
    Map data = {
      'email': email,
    };
    var jsonData = {};
    var response = await http.post(
      "https://dfair.herokuapp.com/api/accounts/password/reset/",
      body: data,
    );
    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      setState(() {
        isLoading = false;
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => PasswordResetConfirm()),
            (route) => false);
      });
    } else {
      showDialog(
          context: context,
          builder: (_) => new AlertDialog(
                title: new Text("Email not  Found"),
                content: new Text(
                    "The Email you submitted is not registered on our servers. Try again with different email or contact us."),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Try Again!'),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PasswordReset()),
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
    TextEditingController _controller = TextEditingController();
    String _email;
    return Scaffold(
      appBar: new AppBar(
        title: Center(child: Text("D-Fair Shop")),
        backgroundColor: Colors.purple,
      ),
      body: Container(
        height: 500,
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                  children: [
                    Text(
                        "Please enter your email to reset your password, an email containing the token which is required in the next step will be sent to you automatically",
                        style: TextStyle(
                          fontSize: 16.5,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                        ),
                    TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        labelText: 'EMAIL ADDRESS',
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.purple)),
                      ),
                    ),
                    new RaisedButton(
                      child: Text("Request Token"),
                      onPressed: () {
                        setState(() {
                          isLoading = true;
                        });
                        _email = _controller.text;
                        reset(_email);
                      },
                    )
                  ],
                ),
            ),
      ),
    );
  }
}
